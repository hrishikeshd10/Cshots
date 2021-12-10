// To parse this JSON data, do
//
//     final getMarketData = getMarketDataFromJson(jsonString);

import 'dart:convert';

GetMarketData getMarketDataFromJson(String str) => GetMarketData.fromJson(json.decode(str));

String getMarketDataToJson(GetMarketData data) => json.encode(data.toJson());

class GetMarketData {
  GetMarketData({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  List<Datum> data;

  factory GetMarketData.fromJson(Map<String, dynamic> json) => GetMarketData(
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
    this.globalVolume24Hour,
    this.globalVolume24HourDayChange,
    this.globalMarketCap,
    this.globalMarketCapDayChange,
    this.inrVolume24Hour,
    this.inrVolume24HourDayChange,
    this.timestamp,
    this.createdAt,
  });

  int id;
  double globalVolume24Hour;
  double globalVolume24HourDayChange;
  double globalMarketCap;
  double globalMarketCapDayChange;
  double inrVolume24Hour;
  double inrVolume24HourDayChange;
  DateTime timestamp;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    globalVolume24Hour: json["globalVolume24Hour"].toDouble(),
    globalVolume24HourDayChange: json["globalVolume24HourDayChange"].toDouble(),
    globalMarketCap: json["globalMarketCap"].toDouble(),
    globalMarketCapDayChange: json["globalMarketCapDayChange"].toDouble(),
    inrVolume24Hour: json["inrVolume24Hour"].toDouble(),
    inrVolume24HourDayChange: json["inrVolume24HourDayChange"].toDouble(),
    timestamp: DateTime.parse(json["timestamp"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "globalVolume24Hour": globalVolume24Hour,
    "globalVolume24HourDayChange": globalVolume24HourDayChange,
    "globalMarketCap": globalMarketCap,
    "globalMarketCapDayChange": globalMarketCapDayChange,
    "inrVolume24Hour": inrVolume24Hour,
    "inrVolume24HourDayChange": inrVolume24HourDayChange,
    "timestamp": timestamp.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}
