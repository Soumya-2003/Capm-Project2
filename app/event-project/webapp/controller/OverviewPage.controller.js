sap.ui.define([
    "sap/fe/core/PageController",
    "sap/m/MessageToast"
], function (PageController, MessageToast) {
    "use strict";

    return PageController.extend("eventproject.controller.OverviewPage", {

        onInit: function () {
            PageController.prototype.onInit.apply(this, arguments);
        },

        clickMeButtonPress: function () {
            MessageToast.show("Button Clicked");
        }

    });
});