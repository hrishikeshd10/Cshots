// To parse this JSON data, do
//
//     final getValues = getValuesFromJson(jsonString);

import 'dart:convert';

GetValues getValuesFromJson(String str) => GetValues.fromJson(json.decode(str));

String getValuesToJson(GetValues data) => json.encode(data.toJson());

class GetValues {
  GetValues({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  List<Datum> data;

  factory GetValues.fromJson(Map<String, dynamic> json) => GetValues(
    n: json["n"],
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.type,
    this.value,
    this.name,
  });

  int id;
  Type type;
  String value;
  String name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: typeValues.map[json["type"]],
    value: json["value"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": typeValues.reverse[type],
    "value": value,
    "name": name,
  };
}

enum Type { COIN, EXCHANGE }

final typeValues = EnumValues({
  "COIN": Type.COIN,
  "EXCHANGE": Type.EXCHANGE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
