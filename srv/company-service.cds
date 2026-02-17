using comp.value as com from '../db/company-model';

service CompanyService {

    entity Valuations as projection on com.Company.Valuation;    

}

// service CompanyService {

//     entity Valuation as projection on com.Company.Valuation;    

// }