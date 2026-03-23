namespace event.management;

type Organizer {
    name : String;
    contact : Integer;
    bio : String;
}

entity Events {
  key eventId : UUID;
      eventName       : String(150);
      description     : String(500);
      eventDate       : Date;
      startTime       : Time;
      endTime         : Time;
      free : Boolean;
      organizer : Organizer;

      venue           : String;
      maxParticipants : Integer;
      registrations   : String;
      rating : Integer;

      // brochure        : LargeBinary @Core.MediaType: 'text/plain';
      // brochureName    : String;

      virtual status : String;
}
