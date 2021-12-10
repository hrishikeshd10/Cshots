// To parse this JSON data, do
//
//     final addBookmark = addBookmarkFromJson(jsonString);

import 'dart:convert';

AddBookmark addBookmarkFromJson(String str) => AddBookmark.fromJson(json.decode(str));

String addBookmarkToJson(AddBookmark data) => json.encode(data.toJson());

class AddBookmark {
  AddBookmark({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory AddBookmark.fromJson(Map<String, dynamic> json) => AddBookmark(
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
    this.thumbnail,
    this.description,
    this.fromDate,
    this.toDate,
    this.bookmark,
    this.customer,
  });

  int id;
  DateTime createdAt;
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    description: json["description"],
    fromDate: DateTime.parse(json["from_date"]),
    toDate: DateTime.parse(json["to_date"]),
    bookmark: json["bookmark"],
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
    "thumbnail": thumbnail,
    "description": description,
    "from_date": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
    "bookmark": bookmark,
    "customer": customer,
  };
}
