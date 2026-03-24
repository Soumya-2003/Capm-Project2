const cds = require('@sap/cds');

module.exports = cds.service.impl((srv) => {
    srv.after('READ', 'Event', (data) => {
        const events = Array.isArray(data) ? data : [data];
        const today = new Date();

        events.forEach(e => {
            if (e.budget > 500) {
                e.criticality = 3; 
            } else if (e.budget > 250) {
                e.criticality = 2; 
            } else {
                e.criticality = 1; 
            }
        });

        data.forEach(e => {
            if (e.eventDate) {
                const eventDate = new Date(e.eventDate);

                if (eventDate >= today) {
                    e.status = 'Upcoming';
                } else {
                    e.status = 'Completed';
                }
            }
        });
    });
})