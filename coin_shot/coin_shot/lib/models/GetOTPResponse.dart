// To parse this JSON data, do
//
//     final getOtpResponse = getOtpResponseFromJson(jsonString);

import 'dart:convert';

GetOtpResponse getOtpResponseFromJson(String str) => GetOtpResponse.fromJson(json.decode(str));

String getOtpResponseToJson(GetOtpResponse data) => json.encode(data.toJson());

class GetOtpResponse {
  GetOtpResponse({
    this.n,
    this.message,
    this.data,
  });

  int n;
  String message;
  Data data;

  factory GetOtpResponse.fromJson(Map<String, dynamic> json) => GetOtpResponse(
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
    this.requestId,
    this.type,
  });

  String requestId;
  String type;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    requestId: json["request_id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "type": type,
  };
}
