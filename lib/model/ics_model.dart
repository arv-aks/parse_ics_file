// To parse this JSON data, do
//
//     final icsData = icsDataFromJson(jsonString);

import 'dart:convert';

IcsData icsDataFromJson(String str) => IcsData.fromJson(json.decode(str));

String icsDataToJson(IcsData data) => json.encode(data.toJson());

class IcsData {
  IcsData({
    required this.type,
    required this.dtstart,
    this.dtend,
    this.dtstamp,
    this.organizer,
    this.uid,
    this.attendee,
    this.description,
    this.lastModified,
    this.location,
    this.sequence,
    this.status,
    required this.summary,
    this.transp,
  });

  String type;
  Dtend dtstart;
  Dtend? dtend;
  Dtend? dtstamp;
  Organizer? organizer;
  String? uid;
  List<Attendee>? attendee;
  String? description;
  Dtend? lastModified;
  String? location;
  String? sequence;
  String? status;
  String summary;
  String? transp;

  factory IcsData.fromJson(Map<String, dynamic> json) => IcsData(
        type: json["type"],
        dtstart: Dtend.fromJson(json["dtstart"]),
        dtend: json["dtend"] == null ? null : Dtend.fromJson(json["dtend"]),
        dtstamp:
            json["dtstamp"] == null ? null : Dtend.fromJson(json["dtstamp"]),
        organizer: json["organizer"] == null
            ? null
            : Organizer.fromJson(json["organizer"]),
        uid: json["uid"],
        attendee: json["attendee"] == null
            ? null
            : List<Attendee>.from(
                json["attendee"].map((x) => Attendee.fromJson(x))),
        description: json["description"],
        lastModified: json["lastModified"] == null
            ? null
            : Dtend.fromJson(json["lastModified"]),
        location: json["location"],
        sequence: json["sequence"],
        status: json["status"],
        summary: json["summary"],
        transp: json["transp"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "dtstart": dtstart.toJson(),
        "dtend": dtend!.toJson(),
        "dtstamp": dtstamp!.toJson(),
        "organizer": organizer!.toJson(),
        "uid": uid,
        "attendee": List<dynamic>.from(attendee!.map((x) => x.toJson())),
        "description": description,
        "lastModified": lastModified!.toJson(),
        "location": location,
        "sequence": sequence,
        "status": status,
        "summary": summary,
        "transp": transp,
      };
}

class Attendee {
  Attendee({
    this.name,
    this.cutype,
    this.role,
    this.partstat,
    this.rsvp,
    this.xNumGuests,
    required this.mail,
  });

  String? name;
  String? cutype;
  String? role;
  String? partstat;
  String? rsvp;
  String? xNumGuests;
  String mail;

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        name: json["name"],
        cutype: json["cutype"],
        role: json["role"],
        partstat: json["partstat"],
        rsvp: json["rsvp"],
        xNumGuests: json["x-num-guests"],
        mail: json["mail"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cutype": cutype,
        "role": role,
        "partstat": partstat,
        "rsvp": rsvp,
        "x-num-guests": xNumGuests,
        "mail": mail,
      };
}

class Dtend {
  Dtend({
    this.dt,
  });

  String? dt;

  factory Dtend.fromJson(Map<String, dynamic> json) => Dtend(
        dt: json["dt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
      };
}

class Organizer {
  Organizer({
    this.name,
    this.mail,
  });

  String? name;
  String? mail;

  factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        name: json["name"] ?? "",
        mail: json["mail"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mail": mail,
      };
}
