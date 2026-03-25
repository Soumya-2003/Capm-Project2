using event.management as em from '../db/event-schema';

service EventService {
    @odata.draft.enabled
    @Analytics.query: true
    entity Event as projection on em.Events;

    entity EventTags as projection on em.EventTags;

    entity Currencies as projection on em.Currencies;
    
}
