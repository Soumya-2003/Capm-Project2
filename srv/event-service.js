const cds = require('@sap/cds');

module.exports = cds.service.impl(function (srv) {

    const { Event } = srv.entities;

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

    srv.on('closeEvent', async (req) => {

        const { eventId } = req.params[0];

        await UPDATE(Event)
            .set({
                registrations: 'Closed',
                status: 'Closed'
            })
            .where({ eventId });

        return SELECT.one.from(Event).where({ eventId });
    });

    srv.on('openEvent', async (req) => {

        const { eventId } = req.params[0];

        await UPDATE(Event)
            .set({
                registrations: 'Open',
                status: 'Upcoming'
            })
            .where({ eventId });

        return SELECT.one.from(Event).where({ eventId });
    });

    srv.on('rateEvent', async (req) => {

        const { eventId } = req.params[0];
        const { rating } = req.data;

        if (rating < 1 || rating > 10) {
            req.error(400, 'Rating must be between 1 and 10');
        }

        await UPDATE(Event)
            .set({ rating })
            .where({ eventId });

        return SELECT.one.from(Event).where({ eventId });
    });


});