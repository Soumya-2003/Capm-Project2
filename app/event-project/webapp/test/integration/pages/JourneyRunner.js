sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"eventproject/test/integration/pages/EventList",
	"eventproject/test/integration/pages/EventObjectPage",
	"eventproject/test/integration/pages/EventTagsObjectPage"
], function (JourneyRunner, EventList, EventObjectPage, EventTagsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('eventproject') + '/test/flp.html#app-preview',
        pages: {
			onTheEventList: EventList,
			onTheEventObjectPage: EventObjectPage,
			onTheEventTagsObjectPage: EventTagsObjectPage
        },
        async: true
    });

    return runner;
});

