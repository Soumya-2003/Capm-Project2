namespace event.management;

entity Events {
  key eventId : UUID;
      eventName       : String(150);
      description     : String(500);
      eventDate       : Date;
      startTime       : Time;
      endTime         : Time;

      venue           : String;
      maxParticipants : Integer;
      registrations   : String;

      virtual status : String;
}
