// To parse this JSON data, do
//
//     final getLoginResp = getLoginRespFromJson(jsonString);

import 'dart:convert';

GetLoginResp getLoginRespFromJson(String str) => GetLoginResp.fromJson(json.decode(str));

String getLoginRespToJson(GetLoginResp data) => json.encode(data.toJson());

class GetLoginResp {
  GetLoginResp({
    this.n,
    this.message,
    this.data,
  });

  int n;
  String message;
  Data data;

  factory GetLoginResp.fromJson(Map<String, dynamic> json) => GetLoginResp(
    n: json["n"],
    message: json["message "],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "message ": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.email,
    this.token,
  });

  String id;
  String email;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "token": token,
  };
}
