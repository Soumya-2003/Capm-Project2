namespace event.management;

type Organizer {
    name : String;
    contact : Integer;
    bio : String;
}

entity Events {
  key eventId : UUID;
      eventName       : String(150) @Common.FieldControl: #Mandatory;
      description     : String(500) @Common.FieldControl: #Optional;
      eventDate       : Date @Common.FieldControl: #Mandatory;
      startTime       : Time @Common.FieldControl: #Mandatory;
      endTime         : Time @Common.FieldControl: #Mandatory;
      free : Boolean @Common.FieldControl: #ReadOnly;
      organizer : Organizer @Common.FieldControl: #ReadOnly;

      venue           : String @Common.FieldControl: #Mandatory;
      maxParticipants : Integer @Common.FieldControl: #Optional;
      registrations   : String @Common.FieldControl: #ReadOnly;
      budget          : Decimal(15,2) @Measures.ISOCurrency: currency_code;
      currency_code : String(3) @Common.FieldControl: #Optional;
      currency : Association to Currencies on currency.code=currency_code;
      rating : Integer @Common.FieldControl: #Optional;
      tags            : Composition of many EventTags
                    on tags.event = $self;

      brochure        : LargeBinary @Common.FieldControl: #Optional;
      brochureName    : String @Common.FieldControl: #Optional;
      mimeType : String @Common.FieldControl: #Optional;

      status : String @Core.Computed;
      criticality : Integer @Core.Computed;
}

entity EventTags {
  key ID   : UUID;
  tag      : String;
  event    : Association to Events;
}

entity Currencies{
    key code : String(3);
    name : String(50);
    symbol : String(5);
}
