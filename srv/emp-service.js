const cds = require('@sap/cds');
const { UPDATE, INSERT, SELECT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl((srv) => {

    const { Employee, EmployeeProjects } = srv.entities;

    // Before Create
	  srv.before('CREATE', 'Employee', async(req)=>{
        console.log('Checking Request Validation...Please Wait!'); 
        const { joiningDate, department_deptId } = req.data;

        if(joiningDate && new Date(joiningDate) > new Date()){
          req.error(400, 'Joining date cannot be in future');
        }

        if (!department_deptId){
          req.error(400, 'Employee must belong to a department');
        }
    })

    // After Create
    srv.after('CREATE', 'Employee', async(data, req) => {
        console.log(`Employee Created: ${data.employeeId}`);       
    });

    // Before Update
    srv.before('UPDATE', 'Employee', async(req) => {
        const empId = req.data.employeeId;
        const changedFields = [];
        for(let field in req.data){
          if(field === 'employeeId') continue;
          changedFields.push(field);
        }
        if(changedFields.length > 0){
            const updatedFields = changedFields.join(', ');
            console.log(`Updating ${updatedFields} for employee ${empId}`);
        }   
    });

    // After Update
    srv.after('UPDATE', 'Employee', async(data, req) => {
      console.log(`Employee ${data.employeeId} updated`);
      await console.log("Changed Field:", req.data);      
    });


    // Before Delete
    srv.before('DELETE', 'Employee', async(req) => {
      const empId = req.data.employeeId;
      const activeProjects = await SELECT.from('comp.employee.EmployeeProject')
                                   .where({
                                      employee_employeeId: empId,
                                      endDate: null
                                   });

      if(activeProjects.length > 0){
        return req.reject(400, 'Deletion blocked: Employee has ongoing projects.');
      }
    })

    // After Delete
    srv.after('DELETE', 'Employee', async(data, req) => {
      const {employeeId} = req.data;
      console.log(`Successfully deleted all records for Employee ID: ${employeeId}`);
    })


    // on Searching an employee
    srv.on('searchEmployees', async (req) => {
      const { query } = req.data;

      const rows = await SELECT.from(Employee)
                  .columns(
                    'employeeId',
                    'name_firstName',
                    'name_lastName',
                    'salary'
                  ).search(query);

      return rows.map(e => ({
        employeeId: e.employeeId,
        name: `${e.name_firstName} ${e.name_lastName}`,
        salary: e.salary
      }));
    });


    // Implementation of Unbounded Function
    srv.on('getPermanentEmployees', async () => {
        const rows = await SELECT.from(Employee)
                     .columns('name_firstName', 'name_lastName')
                     .where({ isPermanent : true });
        return rows.map(e => `${e.name_firstName} ${e.name_lastName}`);
    });

    // Implementation of Bounded Function
    srv.on('getTotalProjects', async(req) => {
      const empId = req.params[0].employeeId;
      const result = await SELECT.one.from('comp.employee.EmployeeProject')
                            .columns('count(*) as Total')
                            .where({ employee_employeeId : empId });

      return result.Total;
    })

    // Implementation of Unbounded Action
    srv.on('deactivateEmployees', async () => {
        const affected = await UPDATE(Employee)
        .set({ status: 'INACTIVE' })
        .where({ status: 'ACTIVE' });

      return `${affected} employees deactivated`;
   });

    // Implementation  of Bounded Action
    srv.on('endProject', EmployeeProjects, async(req) => {
      const { ID } = req.params[0];
      const todayDate = new Date().toISOString().split('T')[0];
      const updated = await UPDATE(EmployeeProjects)
                            .set({ endDate: todayDate })
                            .where({ ID, endDate: null });

      return updated > 0;
    })



    // Get salary in descending order using orderBy
    srv.on('getEmployeesBySalary', async(req) => {
      const rows = await SELECT.from(Employee).columns(
        'employeeId',
        'name_firstName',
        'name_lastName',
        'salary'
      ).orderBy({salary: 'desc'});

      return rows.map(result => ({
          employeeId : result.employeeId,
          name : `${result.name_firstName} ${result.name_lastName}`,
          salary : result.salary
      }));
    });


    // Get Departments having more than one employee using GROUP BY
    srv.on('employeesPerDepartment', async(req) => {
      return SELECT.from('comp.employee.Employee')
             .columns(
                'department.name as department',
                'count(employeeId) as totalEmployees'
             ).groupBy('department.name').having('count(employeeId) > 1');
    })


    // INNER JOIN - Employees with Department
    srv.on('employeeWithDepartment', async(req) => {
      const rows = await SELECT.from('comp.employee.Employee as E')
                        .join('comp.employee.Department as D')
                        .on('E.department_deptId = D.deptId')
                        .columns(
                          'E.employeeId',
                          'E.name_firstName',
                          'E.name_lastName',
                          'D.name as departmentName'
                        );
      return rows.map(row => ({
        empId : row.employeeId,
        name : `${row.name_firstName} ${row.name_lastName}`,
        department : row.departmentName
      }))
    })


    // LEFT JOIN - GET Emplpoyees with project
    srv.on('employeesWithProjects', async (req) => {
      const rows = await SELECT.from('comp.employee.Employee as E')
                        .leftJoin('comp.employee.EmployeeProject as P')
                        .on('E.employeeId = P.employee_employeeId')
                        .columns(
                            'E.employeeId',
                            'E.name_firstName',
                            'E.name_lastName',
                            'P.projectName',
                            'P.endDate'
                        );

        return rows.map(row => {
          let projectStatus = null;
          if (row.projectName) {
              projectStatus = row.endDate === null ? 'ONGOING' : 'COMPLETED';
          }

          return {
              employeeId : row.employeeId,
              name : `${row.name_firstName} ${row.name_lastName}`,
              projectName : row.projectName || 'No Project Assigned',
              status : projectStatus
          };
      });
    });


    // RIGHT JOIN - GET ongoing projects with employee name sorted by start date
    srv.on('activeProjects', async (req) => {
        const rows = await SELECT.from('comp.employee.EmployeeProject as Project')
            .rightJoin('comp.employee.Employee as Emp')
            .on('Project.employee_employeeId = Emp.employeeId')
            .columns(
                'Project.projectName',
                'Project.startDate',
                'Project.endDate',
                'Emp.name_firstName',
                'Emp.name_lastName'
            ).where('Project.endDate is null') 
             .orderBy('Project.startDate asc');

        return rows.map(row => ({
            projectName : row.projectName || 'No Active Project',
            startDate : row.startDate,
            employeeName : `${row.name_firstName} ${row.name_lastName}`
        }));
    });
});