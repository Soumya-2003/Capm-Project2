sap.ui.define([
    "sap/ui/test/opaQunit",
    "./pages/JourneyRunner"
], function (opaTest, runner) {
    "use strict";

    function journey() {
        QUnit.module("First journey");

        opaTest("Start application", function (Given, When, Then) {
            Given.iStartMyApp();

            Then.onTheEventList.iSeeThisPage();
            Then.onTheEventList.onFilterBar().iCheckFilterField("Event Name");
            Then.onTheEventList.onFilterBar().iCheckFilterField("Event Date");
            Then.onTheEventList.onTable().iCheckColumns(5, {"eventName":{"header":"Event Name"},"venue":{"header":"Venue"},"maxParticipants":{"header":"Total Registrations"},"free":{"header":"Free"},"budget":{"header":"Budget"}});

        });


        opaTest("Navigate to ObjectPage", function (Given, When, Then) {
            // Note: this test will fail if the ListReport page doesn't show any data
            
            When.onTheEventList.onFilterBar().iExecuteSearch();
            
            Then.onTheEventList.onTable().iCheckRows();

            When.onTheEventList.onTable().iPressRow(0);
            Then.onTheEventObjectPage.iSeeThisPage();

        });

        opaTest("Teardown", function (Given, When, Then) { 
            // Cleanup
            Given.iTearDownMyApp();
        });
    }

    runner.run([journey]);
});