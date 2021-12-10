// To parse this JSON data, do
//
//     final addDataToWatchlist = addDataToWatchlistFromJson(jsonString);

import 'dart:convert';

AddDataToWatchlist addDataToWatchlistFromJson(String str) => AddDataToWatchlist.fromJson(json.decode(str));

String addDataToWatchlistToJson(AddDataToWatchlist data) => json.encode(data.toJson());

class AddDataToWatchlist {
  AddDataToWatchlist({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory AddDataToWatchlist.fromJson(Map<String, dynamic> json) => AddDataToWatchlist(
    n: json["n"],
    status: json["status"],
    data: json["data"]==[]? [] : Data.fromJson(json["data"]),
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
    this.currency,
    this.watchlist,
    this.customerWatchlist,
    this.customer,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  dynamic updatedBy;
  bool isActive;
  bool isDeleted;
  String currency;
  bool watchlist;
  int customerWatchlist;
  String customer;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    currency: json["currency"],
    watchlist: json["watchlist"],
    customerWatchlist: json["customerWatchlist"],
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
    "currency": currency,
    "watchlist": watchlist,
    "customerWatchlist": customerWatchlist,
    "customer": customer,
  };
}
