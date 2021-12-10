// To parse this JSON data, do
//
//     final updateUser = updateUserFromJson(jsonString);

import 'dart:convert';

UpdateUser updateUserFromJson(String str) => UpdateUser.fromJson(json.decode(str));

String updateUserToJson(UpdateUser data) => json.encode(data.toJson());

class UpdateUser {
  UpdateUser({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
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
    this.fullname,
    this.password,
    this.profilephoto,
    this.mobile,
    this.otp,
    this.email,
    this.createdBy,
    this.token,
  });

  String fullname;
  String password;
  dynamic profilephoto;
  int mobile;
  int otp;
  String email;
  String createdBy;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fullname: json["fullname"],
    password: json["password"],
    profilephoto: json["profilephoto"],
    mobile: json["mobile"],
    otp: json["otp"],
    email: json["email"],
    createdBy: json["createdBy"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "password": password,
    "profilephoto": profilephoto,
    "mobile": mobile,
    "otp": otp,
    "email": email,
    "createdBy": createdBy,
    "token": token,
  };
}
