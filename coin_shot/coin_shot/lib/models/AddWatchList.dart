// To parse this JSON data, do
//
//     final addWatchList = addWatchListFromJson(jsonString);

import 'dart:convert';

AddWatchList addWatchListFromJson(String str) => AddWatchList.fromJson(json.decode(str));

String addWatchListToJson(AddWatchList data) => json.encode(data.toJson());

class AddWatchList {
  AddWatchList({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory AddWatchList.fromJson(Map<String, dynamic> json) => AddWatchList(
    n: json["n"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
