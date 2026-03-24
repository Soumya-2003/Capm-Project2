using event.management as em from '../db/event-schema';

service EventService {
    @odata.draft.enabled
    entity Event as projection on em.Events;

    entity EventTags as projection on em.EventTags;

    entity Currencies as projection on em.Currencies;
    // @Aggregation.ApplySupported: {
    //     Transformations: [ 'aggregate', 'groupby', 'filter' ],
    //     Rollup: #None,
    //     PropertyRestrictions: true
    // }
    // entity EventAnalytics as projection on em.Events {
    //     key eventId,
    //     eventName,
    //     venue,
    //     eventDate,
        
    //     @Analytics.Measure: true
    //     @Aggregation.default: #SUM
    //     budget,

    //     @Analytics.Dimension: true
    //     case 
    //         when budget > 7000 then 1 
    //         when budget > 4000 then 2 
    //         else 3 
    //     end as budgetCriticality : Integer
    // };
}
