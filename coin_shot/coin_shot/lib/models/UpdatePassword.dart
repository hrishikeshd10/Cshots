// To parse this JSON data, do
//
//     final updatePassword = updatePasswordFromJson(jsonString);

import 'dart:convert';

UpdatePassword updatePasswordFromJson(String str) => UpdatePassword.fromJson(json.decode(str));

String updatePasswordToJson(UpdatePassword data) => json.encode(data.toJson());

class UpdatePassword {
  UpdatePassword({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory UpdatePassword.fromJson(Map<String, dynamic> json) => UpdatePassword(
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
    this.password,
    this.email,
    this.updatedBy,
    this.isActive,
    this.isDeleted,
  });

  String password;
  String email;
  String updatedBy;
  bool isActive;
  bool isDeleted;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    password: json["password"],
    email: json["email"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
    "email": email,
    "updatedBy": updatedBy,
    "isActive": isActive,
    "isDeleted": isDeleted,
  };
}
