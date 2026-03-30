using {EventService} from './event-service';

annotate EventService.Event with {
    eventName       @Common.Label       : 'Event Name';
    eventDate       @Common.Label       : 'Event Date';
    startTime       @Common.Label       : 'Start Time';
    endTime         @Common.Label       : 'End Time';
    venue           @Common.Label       : 'Venue';
    free            @Common.Label       : 'Free';
    description     @Common.Label       : 'Description';
    maxParticipants @Common.Label       : 'Total Registrations';
    status          @Common.Label       : 'Status';
    rating          @Common.Label       : 'Rating';
    budget          @Common.Label: 'Budget';
    // budget          @Aggregation.default: #SUM;
    organizer       @(
        Common.SemanticObject: 'Organizer',
        Common.Label         : 'Organizer Details'
    );
};

annotate EventService.Event with @UI.Chart #EventChart: {
    ChartType : #Column,
    Measures  : [budget],
    Dimensions: [eventName],

    MeasureAttributes: [{
        Measure: budget,
        Role   : #Axis1
    }],

    DimensionAttributes: [{
        Dimension: eventName,
        Role     : #Category
    }]
};

annotate EventService.Event with @Aggregation.ApplySupported: {
    Transformations: ['aggregate', 'groupby'],
    GroupableProperties: [eventName],
    AggregatableProperties: [{
        Property: budget
    }]
};


annotate EventService.Event with @(UI: {
    LineItem           : {
        // ![@UI.Criticality]: criticality,
        $value            : [
            {Value: eventName},
            {Value: venue},
            {Value: maxParticipants},
            // {Value: status},
            {Value: free},
            {Value: budget}
        ]
    },

    PresentationVariant: {
        $Type         : 'UI.PresentationVariantType',
        Visualizations: ['@UI.LineItem'],
        RequestAtLeast: [criticality],
        Total         : [{
            $Type   : 'UI.AggregationType',
            Property: budget
        }]
    }
});


// annotate EventService.Event with @odata.draft.bypass;


annotate EventService.Event with {
    brochure     @Core.MediaType                  : mimeType;
    brochureName @Core.ContentDisposition.Filename: brochureName;
};


annotate EventService.Event with {
    tags @(UI.MultiValue: true);
};


annotate EventService.Event with @UI.SelectionFields: [
    eventName,
    eventDate
];

// --------------Object page header------------------

annotate EventService.Event with @UI.HeaderInfo: {
    TypeName      : 'Event',
    TypeNamePlural: 'Events',
    TypeImageUrl  : 'https://woocommerce.com/wp-content/uploads/2025/09/host-meetup.jpg',
    Title         : {
        $Type: 'UI.DataField',
        Value: eventName
    },
    Description   : {
        $Type: 'UI.DataField',
        Value: venue
    }
};

annotate EventService.Event with @UI.HeaderFacets: [
    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Event Info',
        Target: '@UI.FieldGroup#HeaderInfo'
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#RegistrationStatus'
    },
    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Organizer',
        Target: '@UI.FieldGroup#HeaderOrganizer'
    }

];

annotate EventService.Event with @UI.FieldGroup #HeaderInfo: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            Value: eventDate,
            Label: 'Event Date'
        },
        {
            Value: startTime,
            Label: 'Start Time'
        },
        {
            Value: endTime,
            Label: 'End Time'
        },
    ]
};

annotate EventService.Event with @UI.DataPoint #RegistrationStatus: {
    Value      : registrations,
    Title      : 'Registration',
    Criticality: {$edmJson: {$If: [
        {$Eq: [
            {$Path: 'registrations'},
            'Closed'
        ]},
        1,
        3
    ]}}
};

annotate EventService.Event with @UI.FieldGroup #HeaderOrganizer: {
    $Type: 'UI.FieldGroupType',
    Data : [{
        $Type : 'UI.DataFieldForAnnotation',
        Target: '@Communication.Contact#OrganizerContact',
        Label : 'Organizer'
    }]
};

annotate EventService.Event with @(Communication.Contact #OrganizerContact: {
    $Type: 'Communication.ContactType',
    fn   : organizer_name,
    tel  : [{
        $Type: 'Communication.PhoneNumberType',
        type : #work,
        uri  : organizer_contact
    }],

    adr  : [{
        $Type   : 'Communication.AddressType',
        type    : #work,
        locality: venue,
        country : 'IN'
    }]

}

);

// -------------------Object page sections-------------------

annotate EventService.Event with @UI.Facets: [
    {
        $Type : 'UI.ReferenceFacet',
        Label : 'General Information',
        Target: '@UI.FieldGroup#General'
        // ![@UI.PartOfPreview]: false
    },
    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Schedule',
        Target: '@UI.FieldGroup#Schedule'
        // ![@UI.PartOfPreview]: false
    }
];

annotate EventService.Event with @UI.DataPoint #Progress: {
    Value        : rating,
    Title        : 'Rating',

    TargetValue  : 10,
    Visualization: #Progress,

    Criticality  : {$edmJson: {$If: [
        {$Lt: [
            {$Path: 'rating'},
            5
        ]},
        1,
        {$If: [
            {$Lt: [
                {$Path: 'rating'},
                8
            ]},
            2,
            3
        ]}
    ]}}
};

annotate EventService.Event with @UI.FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {Value: eventName},
        {Value: description},
        {Value: venue},
        {
            Value: maxParticipants,
            Label: 'Max Participants'
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#Progress',
            Label : 'Rating'
        },
        // {Value: organizer_name},
        {
            $Type : 'UI.DataFieldWithNavigationPath',
            Value : organizer_name,
            Label : 'Organizer',
            Target: '@UI.QuickViewFacets'
        },
        {
            $Type: 'UI.DataField',
            Value: tags.tag,
            Label: 'Tags'
        },
        {Value: budget, ![@UI.PartOfPreview]: false}
    ]
};

annotate EventService.Event with @UI.FieldGroup #Schedule: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {Value: eventDate},
        {Value: startTime},
        {Value: endTime},
        {Value: brochure},
        {Value: brochureName}
    ]
};


annotate EventService.Event with @UI.QuickViewFacets: [{
    $Type : 'UI.ReferenceFacet',
    Label : 'Organizer Info',
    Target: '@UI.FieldGroup#QuickViewOrganizer'
}];

annotate EventService.Event with @UI.FieldGroup #QuickViewOrganizer: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            Value: organizer_name,
            Label: 'Name'
        },
        {
            Value: organizer_contact,
            Label: 'Phone'
        },
        {
            Value: organizer_bio,
            Label: 'About'
        }
    ]
};


// Valuehelp in multi-input
annotate EventService.EventTags with {
    tag @(Common.ValueList: {
        CollectionPath: 'EventTags',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: tag,
                ValueListProperty: 'tag'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'tag'
            }
        ]
    });
};

annotate EventService.Event with {
    currency_code @Common: {
        Label                   : 'Currency',
        Text                    : currency.name,
        TextArrangement         : #TextFirst,
        ValueListWithFixedValues: true,
        ValueList               : {
            CollectionPath: 'Currencies',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: currency_code,
                    ValueListProperty: 'code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'symbol'
                }
            ]
        }
    }
};
