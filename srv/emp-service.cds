using comp.employee as emp from '../db/schema';

service EmployeeService {
    
    // entity Employee as projection on emp.Employee excluding{profilePhoto};

    entity Departments as projection on emp.Department;

    entity Skills as projection on emp.Skill;

    entity EmployeeSkills as projection on emp.EmployeeSkill;

    entity Profile as projection on emp.EmployeeProfile;

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



    type EmployeeSearchResult {
        employeeId : UUID;
        name : String;
        salary : Decimal;
    }
    function searchEmployees(query : String) returns array of EmployeeSearchResult;
    // entity ActiveProjects as projection on ActiveEmployeeProjects;

    // entity EmployeesByDept as projection on EmployeesByDepartment;
    // Unbound Function
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

    // Get salary in descending order using orderBy
    function getEmployeesBySalary() returns array of EmployeeSearchResult;

    type DeptEmployeeCount{
        deptId : UUID;
        totalEmployees : Integer
    }

    // Get Departments having more than two employees using GROUP BY
    function employeesPerDepartment() returns array of DeptEmployeeCount;


    // INNER JOIN - Employees with Department
    type empWithDept{
        empId : UUID;
        name : String;
        department : String; 
    }

    function employeeWithDepartment() returns array of empWithDept;


    // LEFT JOIN - GET Emplpoyees with project
    type Status : String enum{
        ONGOING;
        COMPLETED;
    }
    type empProjectInfo {
    employeeId  : UUID;
    name        : String;
    projectName : String;
    status     : Status;
    }
    function employeesWithProjects() returns array of empProjectInfo;


    // RIGHT JOIN - GET ongoing projects with employee name sorted by start date
    type activeProjectInfo {
        projectName : String;
        startDate   : Date;
        employeeName : String;
    }
    function activeProjects() returns array of activeProjectInfo;


    // FULL OUTER JOIN - Employees with or without projects also Projects with or without employees
    type FullJoinResult {
        employeeId  : UUID;
        name : String;
        projectName : String;
    }

    function employeesAndProjectsFullJoin() returns array of FullJoinResult;



}