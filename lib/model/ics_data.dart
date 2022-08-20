// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:icalendar_parser/icalendar_parser.dart';

class IcsData {
  String version;
  String prodid;
  String calscale;
  String method;
  String type;
  String dtStart;
  String dtEnd;
  IcsData({
    required this.version,
    required this.prodid,
    required this.calscale,
    required this.method,
    required this.type,
    required this.dtStart,
    required this.dtEnd,
  });

  IcsData copyWith({
    String? version,
    String? prodid,
    String? calscale,
    String? method,
    String? type,
    String? dtStart,
    String? dtEnd,
  }) {
    return IcsData(
      version: version ?? this.version,
      prodid: prodid ?? this.prodid,
      calscale: calscale ?? this.calscale,
      method: method ?? this.method,
      type: type ?? this.type,
      dtStart: dtStart ?? this.dtStart,
      dtEnd: dtEnd ?? this.dtEnd,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'prodid': prodid,
      'calscale': calscale,
      'method': method,
      'type': type,
      'dtStart': dtStart,
      'dtEnd': dtEnd,
    };
  }

  factory IcsData.fromMap(Map<String, dynamic> map) {
    return IcsData(
      version: map['version'] as String,
      prodid: map['prodid'] as String,
      calscale: map['calscale'] as String,
      method: map['method'] as String,
      type: map['type'] as String,
      dtStart: map['dtStart'] as String,
      dtEnd: map['dtEnd'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IcsData.fromJson(String source) => IcsData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IcsData(version: $version, prodid: $prodid, calscale: $calscale, method: $method, type: $type, dtStart: $dtStart, dtEnd: $dtEnd)';
  }

  @override
  bool operator ==(covariant IcsData other) {
    if (identical(this, other)) return true;
  
    return 
      other.version == version &&
      other.prodid == prodid &&
      other.calscale == calscale &&
      other.method == method &&
      other.type == type &&
      other.dtStart == dtStart &&
      other.dtEnd == dtEnd;
  }

  @override
  int get hashCode {
    return version.hashCode ^
      prodid.hashCode ^
      calscale.hashCode ^
      method.hashCode ^
      type.hashCode ^
      dtStart.hashCode ^
      dtEnd.hashCode;
  }
}
