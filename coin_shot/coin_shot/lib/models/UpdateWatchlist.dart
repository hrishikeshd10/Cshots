// To parse this JSON data, do
//
//     final updateWatchlist = updateWatchlistFromJson(jsonString);

import 'dart:convert';

UpdateWatchlist updateWatchlistFromJson(String str) => UpdateWatchlist.fromJson(json.decode(str));

String updateWatchlistToJson(UpdateWatchlist data) => json.encode(data.toJson());

class UpdateWatchlist {
  UpdateWatchlist({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  List<Datum> data;

  factory UpdateWatchlist.fromJson(Map<String, dynamic> json) => UpdateWatchlist(
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
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.isDeleted,
    this.name,
    this.customer,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  dynamic updatedBy;
  bool isActive;
  bool isDeleted;
  String name;
  String customer;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    name: json["name"],
    customer: json["customer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "name": name,
    "customer": customer,
  };
}
