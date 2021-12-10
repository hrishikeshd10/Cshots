// To parse this JSON data, do
//
//     final getUserDetail = getUserDetailFromJson(jsonString);

import 'dart:convert';

GetUserDetail getUserDetailFromJson(String str) => GetUserDetail.fromJson(json.decode(str));

String getUserDetailToJson(GetUserDetail data) => json.encode(data.toJson());

class GetUserDetail {
  GetUserDetail({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  Data data;

  factory GetUserDetail.fromJson(Map<String, dynamic> json) => GetUserDetail(
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
    this.profilephoto,
    this.mobile,
    this.email,
  });

  String fullname;
  dynamic profilephoto;
  int mobile;
  String email;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fullname: json["fullname"],
    profilephoto: json["profilephoto"],
    mobile: json["mobile"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "profilephoto": profilephoto,
    "mobile": mobile,
    "email": email,
  };
}
