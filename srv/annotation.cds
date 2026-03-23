using { EventService } from './event-service';

annotate EventService.Event with {
    eventName       @Common.Label: 'Event Name';
    eventDate       @Common.Label: 'Event Date';
    startTime       @Common.Label: 'Start Time';
    endTime         @Common.Label: 'End Time';
    venue           @Common.Label: 'Venue';
    free            @Common.Label: 'Free';
    description     @Common.Label: 'Description';
    maxParticipants @Common.Label: 'Total Registrations';
    status          @Common.Label: 'Status';
    rating          @Common.Label: 'Rating';
    organizer  @Common.SemanticObject: 'Organizer' @Common.Label: 'Organizer';
};

annotate EventService.Event with @UI.LineItem: [
    { Value: eventName },
    { Value: venue },
    { Value: maxParticipants },
    // { Value: status },
    { Value : free }
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
                { $Eq: [ { $Path: 'registrations' }, 'Closed' ] }, 1, 3
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

annotate EventService.Event with @UI.DataPoint #Progress: {
    Value: rating,
    Title: 'Rating',

    TargetValue: 10,
    Visualization: #Progress,

    Criticality: {
        $edmJson: {
            $If: [
                { $Lt: [ { $Path: 'rating' }, 5 ] }, 1,
                { $If: [
                    { $Lt: [ { $Path: 'rating' }, 8 ] }, 2,
                    3
                ]}
            ]
        }
    }
};

annotate EventService.Event with @UI.FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
        { Value: eventName },
        { Value: description },
        { Value: venue },
        { Value: maxParticipants, Label: 'Max Participants' },
        {
            $Type: 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#Progress',
            Label: 'Rating'
        },
        { Value: organizer_name }
    ]
};

annotate EventService.Event with @UI.FieldGroup #Schedule: {
    $Type: 'UI.FieldGroupType',
    Data: [
        { Value: eventDate },
        { Value: startTime },
        { Value: endTime }
    ]
};

annotate EventService.Event with @UI.QuickViewFacets: [
    {
        $Type: 'UI.ReferenceFacet',
        Label: 'Organizer Info',
        Target: '@UI.FieldGroup#QuickViewOrganizer'
    }
];

annotate EventService.Event with @UI.FieldGroup #QuickViewOrganizer: {
    Data: [
        { Value: organizer_name, Label: 'Name' },
        { Value: organizer_contact, Label: 'Phone' },
        { Value: organizer_bio, Label: 'About' }
    ]
};

// ------Organizer----------------

// annotate EventService.Organizer with @UI.SelectionFields: [
//     name,
//     bio
// ];

// annotate EventService.Event with {
//     venue @Common.ValueList: {
//         $Type: 'Common.ValueListType',
//         CollectionPath: 'Organizer',

//         Parameters: [
//             {
//                 $Type: 'Common.ValueListParameterInOut',
//                 LocalDataProperty: venue,
//                 ValueListProperty: 'name'
//             },
//             {
//                 $Type: 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty: 'contact'
//             }
//         ]
//     };
// };