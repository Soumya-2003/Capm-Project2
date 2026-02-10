namespace comp.employee;
using { managed } from '@sap/cds/common';

aspect Auditable : managed {
  status : EmploymentStatus default 'INACTIVE';
}

type EmploymentStatus : String enum {
    ACTIVE;
    INACTIVE;
    TERMINATED;
};

@assert.unique : {
  test : [ firstName, lastName ]
}

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

entity Employee : Auditable {
  key employeeId : UUID;
  name : Name;
  dob: Date;
  isPermanent : Boolean;
  salary : Decimal(15,2) @assert.range: { 
      $value : [(1000),_],
      message: 'Salary must be greater than 1000' 
    };
  joiningDate : Date;
  // status : EmploymentStatus default 'INACTIVE';
  profilePhoto : Binary;
  address : Address;
  profileDetail : Composition of EmployeeProfile
                  on profileDetail.employee = $self;
  department : Association to Department;
  type : String = case
    when isPermanent = true then '🟢'
    else '🔴'
    end;
  projects : Composition of many EmployeeProject
             on projects.employee = $self;
  skills : Association to many EmployeeSkill
           on skills.employee = $self;
}

entity EmployeeProfile {
  key employee : Association to Employee;
  bio          : String(200);
  linkedinUrl  : String(100);
}


entity Department {
  key deptId : UUID;
  name       : String(50) @mandatory;
  location   : String(50);
  employees  : Association to many Employee
               on employees.department = $self;
}

entity EmployeeProject {
  key ID        : UUID;
  employee      : Association to Employee;
  projectName   : String(50);
  startDate     : Date;
  endDate       : Date;
}

entity Skill {
  key skillId : UUID;
  name        : String(40) @mandatory;
  employees : Association to many EmployeeSkill
              on employees.skill = $self;
}

entity EmployeeSkill {
  key employee : Association to Employee;
  key skill    : Association to Skill;
}

