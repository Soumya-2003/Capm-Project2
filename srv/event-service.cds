using event.management as em from '../db/event-schema';

service EventService {
    entity Event as projection on em.Events;
}
