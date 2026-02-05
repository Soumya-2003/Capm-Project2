namespace comp.employee;

type EmploymentStatus : String enum {
    ACTIVE;
    INACTIVE;
    TERMINATED;
};

type Name : {
  firstName : String(20) @mandatory @assert : (case
           when trim(firstName) = '' then 'City must not be empty'
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
  status : EmploymentStatus;
  profilePhoto : Binary;
  address : Address;
  profile : String = employeeId || ' is ' || status;
  type : String = case
  when isPermanent = true then '🟢'
  else '🔴'
  end;
  projects : Integer @assert.range:[0,100];

}