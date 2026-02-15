namespace comp.value;

context Company{
    entity Valuation{
        key companyId : UUID;
        companyName : String (50);
        numberOfClients : Int16;
        markeyRevenue : Decimal(15,2);
    }
}