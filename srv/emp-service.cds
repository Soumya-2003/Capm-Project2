using comp.employee as emp from '../db/schema';

service EmployeeService {
    entity Employee as projection on emp.Employee excluding{profilePhoto};
}

service DepartmentService {
    entity Departments as projection on emp.Department
}
