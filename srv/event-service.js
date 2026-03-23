const cds = require('@sap/cds');

module.exports = cds.service.impl((srv) => {
    srv.after('READ', 'Event', (data) => {
        const today = new Date();

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