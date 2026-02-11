using comp.employee as emp from '../db/schema';

service EmployeeService {
    
    // entity Employee as projection on emp.Employee excluding{profilePhoto};

    entity Departments as projection on emp.Department;

    entity Skills as projection on emp.Skill;

    @cds.redirection.target
    entity Projects as projection on emp.EmployeeProject;

    // View1
    // view PermanentEmployees as SELECT from emp.Employee{
    //     key employeeId,
    //     name.firstName as firstName,
    //     name.lastName as lastName,
    //     salary,
    //     status,
    //     joiningDate
    // } where isPermanent = true;

    // View2
    // @cds.redirection.target
    // @readonly
    // view PermanentEmployeesBySalary(minSalary : Decimal(15,2)) as
    // SELECT from emp.Employee {
    //     key employeeId,
    //     name.firstName as firstName,
    //     name.lastName as lastName,
    //     salary,
    //     joiningDate
    // } where isPermanent = true and salary >= :minSalary;


    // entity ActiveProjects as projection on ActiveEmployeeProjects;

    // entity EmployeesByDept as projection on EmployeesByDepartment;
    // Unbounded Function
    function getPermanentEmployees() returns array of String;

    // Bounded Function
    entity Employee as projection on emp.Employee actions {
        function getTotalProjects() returns Integer;
    }

    // Unbounded Action
    action deactivateEmployees();

    // Bounded Action
    entity EmployeeProjects as projection on emp.EmployeeProject actions {
        action endProject() returns Boolean;
    }
}