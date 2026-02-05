using comp.employee as emp from '../db/schema';

service EmployeeService {
    entity Employee as projection on emp.Employee;
}
