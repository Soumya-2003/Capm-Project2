namespace comp.value;

context Company{
    entity Valuation{
        key companyId : UUID;
        companyName : String (50);
        numberOfClients : Int16;
        markeyRevenue : Decimal(15,2);
    }
}


// context Company{
//     entity Valuation {
//         key companyId : UUID;
//         ![Company Name] : String (50);
//         ![Number Of Clients] : Int16;
//         ![Market Revenue]: Decimal(15,2);
//     }
// }