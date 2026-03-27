using EventService as service from '../../srv/event-service';
using from '../../srv/annotation';

annotate service.Event with {
    currency @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Currencies',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : currency_code,
                ValueListProperty : 'code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'symbol',
            },
        ],
    }
};

annotate service.Event with @(
    UI.DataPoint #Rating : {
        Value : rating,
        TargetValue : 10,
        Visualization : #Rating,
    },
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : eventName,
        },
        {
            $Type : 'UI.DataField',
            Value : venue,
        },
        {
            $Type : 'UI.DataField',
            Value : maxParticipants,
        },
        {
            $Type : 'UI.DataField',
            Value : status,
        },
        {
            $Type : 'UI.DataField',
            Value : free,
        },
        {
            $Type : 'UI.DataField',
            Value : budget,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : 'Rating',
            Target : '@UI.DataPoint#Rating',
            @UI.Importance : #High,
        },
    ],
    UI.LineItem.@UI.Criticality : criticality,
);

