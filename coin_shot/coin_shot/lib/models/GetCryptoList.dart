// To parse this JSON data, do
//
//     final getCryptoList = getCryptoListFromJson(jsonString);

import 'dart:convert';

GetCryptoList getCryptoListFromJson(String str) => GetCryptoList.fromJson(json.decode(str));

String getCryptoListToJson(GetCryptoList data) => json.encode(data.toJson());

class GetCryptoList {
  GetCryptoList({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  List<Datum> data;

  factory GetCryptoList.fromJson(Map<String, dynamic> json) => GetCryptoList(
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
    this.symbol,
    this.buy,
    this.sell,
    this.high,
    this.low,
    this.volume,
    this.marketCapUsd,
    this.dayChange,
    this.weekChange,
    this.thumbnail,
  });

  int id;
  String symbol;
  double buy;
  double sell;
  double high;
  double low;
  double volume;
  double marketCapUsd;
  double dayChange;
  double weekChange;
  String thumbnail;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    symbol: json["symbol"],
    buy: json["buy"].toDouble(),
    sell: json["sell"].toDouble(),
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    volume: json["volume"].toDouble(),
    marketCapUsd: json["marketCapUsd"].toDouble(),
    dayChange: json["dayChange"].toDouble(),
    weekChange: json["weekChange"].toDouble(),
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "buy": buy,
    "sell": sell,
    "high": high,
    "low": low,
    "volume": volume,
    "marketCapUsd": marketCapUsd,
    "dayChange": dayChange,
    "weekChange": weekChange,
    "thumbnail": thumbnail,
  };
}
