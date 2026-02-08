namespace comp.employee;

type EmploymentStatus : String enum {
    ACTIVE;
    INACTIVE;
    TERMINATED;
};

type Name : {
  firstName : String(20) @mandatory @assert : (case
           when trim(firstName) = '' then 'First Name must not be empty'
           end);
  lastName : String(20) default 'NA';
}

type Address : {
    City : String(30) @assert : (case
           when trim(City) = '' then 'City must not be empty'
           end);
    State : String(30) @assert:(
           case when State is null then
           'State should be mentioned in the address' end);
    ZipCode : Int64 @assert.range: {
      $value : [100000,999999],
      message : 'Zip Code must be 6 digits'
    };
};

entity Employee{
  key employeeId : UUID;
  name : Name;
  dob: Date;
  isPermanent : Boolean;
  salary : Decimal(15,2) @assert.range: { 
      $value : [(1000),_], 
      message: 'Salary must be greater than 1000' 
    };
  joiningDate : Date;
  status : EmploymentStatus default 'INACTIVE';
  profilePhoto : Binary;
  address : Address;
  department : Association to Department;
  profile : String = employeeId || ' is ' || status;
  type : String = case
    when isPermanent = true then '🟢'
    else '🔴'
    end;
  // projects : array of String;
  projects : Composition of many EmployeeProject
              on projects.employee = $self;
}

entity Department {
  key deptId : UUID;
  name       : String(50) @mandatory;
  location   : String(50);
}

entity EmployeeProject {
  key ID        : UUID;
  employee      : Association to Employee;
  projectName   : String(50);
  startDate     : Date;
  endDate       : Date;
}


