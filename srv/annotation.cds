using { EventService } from './event-service';

annotate EventService.Event with {
    eventName  @Common.Label: 'Event Name';
    eventDate  @Common.Label: 'Event Date';
    venue @Common.Label: 'Venue';
    maxParticipants @Common.Label: 'Total Registrations';
    status @Common.Label: 'Status';
};

annotate EventService.Event with @UI.LineItem: [
    { Value: eventName },
    { Value: venue },
    { Value: maxParticipants },
    { Value: status }
];

annotate EventService.Event with @UI.SelectionFields: [
    eventName, eventDate
];

annotate EventService.Event with @UI.HeaderInfo: {
    TypeName: 'Event',
    TypeNamePlural: 'Events',
    TypeImageUrl  : 'https://woocommerce.com/wp-content/uploads/2025/09/host-meetup.jpg',
    Title: {$Type: 'UI.DataField', Value: eventName },
    Description: { $Type: 'UI.DataField', Value: venue }
};

annotate EventService.Event with @UI.HeaderFacets: [
    {
        $Type: 'UI.ReferenceFacet',
        Label: 'Event Info',
        Target: '@UI.FieldGroup#HeaderInfo'
    },
    {
        $Type: 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#RegistrationStatus'
    }
];

annotate EventService.Event with @UI.FieldGroup #HeaderInfo: {
    $Type: 'UI.FieldGroupType',
    Data: [
        { Value: eventDate, Label: 'Event Date' },
        { Value: startTime, Label: 'Start Time' },
        { Value: endTime, Label: 'End Time' },
    ]
};

annotate EventService.Event with @UI.DataPoint #RegistrationStatus: {
        Value: registrations,
        Title: 'Registration',
        Criticality: {
        $edmJson: {
            $If: [
                { $Eq: [ { $Path: 'registrations' }, 'Closed' ] }, 1,
                3
            ]
        }
    }
};

annotate EventService.Event with @UI.Facets: [
    {
        $Type: 'UI.ReferenceFacet',
        Label: 'General Information',
        Target: '@UI.FieldGroup#General'
    },
    {
        $Type: 'UI.ReferenceFacet',
        Label: 'Schedule',
        Target: '@UI.FieldGroup#Schedule'
    }
];

annotate EventService.Event with @UI.FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
        { Value: eventName, Label: 'Event Name' },
        { Value: description, Label: 'Description' },
        { Value: venue, Label: 'Venue' },
        { Value: maxParticipants, Label: 'Max Participants' }
    ]
};

annotate EventService.Event with @UI.FieldGroup #Schedule: {
    $Type: 'UI.FieldGroupType',
    Data: [
        { Value: eventDate, Label: 'Event Date' },
        { Value: startTime, Label: 'Start Time' },
        { Value: endTime, Label: 'End Time' }
    ]
};
