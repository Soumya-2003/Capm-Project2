const cds = require('@sap/cds');
const { UPDATE } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl((srv) => {

    const { Employee, EmployeeProjects } = srv.entities;

	  srv.before('CREATE', 'Employee', async(req)=>{
        console.log('Checking Request Validation...Please Wait!'); 
    })

    srv.after('CREATE', 'Employee', async(data) => {
        console.log(`Employee Created: ${data.employeeId}`);        
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
    // const { EmployeeProjects } = srv.entities;
    srv.on('endProject', EmployeeProjects, async(req) => {
      const { ID } = req.params[0];
      const todayDate = new Date().toISOString().split('T')[0];
      const updated = await UPDATE(EmployeeProjects)
                            .set({ endDate: todayDate })
                            .where({ ID, endDate: null });

      return updated > 0;
    })
});