using comp.value as com from '../db/company-model';

service CompanyService {

    entity Valuations as projection on com.Company.Valuation;    

}