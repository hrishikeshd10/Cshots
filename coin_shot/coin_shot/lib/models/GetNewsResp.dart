// To parse this JSON data, do
//
//     final getNewsResp = getNewsRespFromJson(jsonString);

import 'dart:convert';

GetNewsResp getNewsRespFromJson(String str) => GetNewsResp.fromJson(json.decode(str));

String getNewsRespToJson(GetNewsResp data) => json.encode(data.toJson());

class GetNewsResp {
  GetNewsResp({
    this.n,
    this.message,
    this.data,
  });

  int n;
  String message;
  List<Datum> data;

  factory GetNewsResp.fromJson(Map<String, dynamic> json) => GetNewsResp(
    n: json["n"],
    message: json["message "],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "message ": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.isDeleted,
    this.name,
    this.thumbnail,
    this.description,
    this.fromDate,
    this.toDate,
    this.bookmark,
    this.customer,
  });

  int id;
  String createdAt;
  DateTime updatedAt;
  String createdBy;
  String updatedBy;
  bool isActive;
  bool isDeleted;
  String name;
  String thumbnail;
  String description;
  DateTime fromDate;
  DateTime toDate;
  bool bookmark;
  String customer;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    description: json["description"],
    fromDate: DateTime.parse(json["from_date"]),
    toDate: DateTime.parse(json["to_date"]),
    bookmark: json["bookmark"],
    customer: json["customer"] == null ? null : json["customer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt.toIso8601String(),
    "createdBy": createdBy,
    "updatedBy": updatedBy == null ? null : updatedBy,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "name": name,
    "thumbnail": thumbnail,
    "description": description,
    "from_date": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
    "bookmark": bookmark,
    "customer": customer == null ? null : customer,
  };
}
