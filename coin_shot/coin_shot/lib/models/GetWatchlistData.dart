// To parse this JSON data, do
//
//     final getWatchlistData = getWatchlistDataFromJson(jsonString);

import 'dart:convert';

GetWatchlistData getWatchlistDataFromJson(String str) => GetWatchlistData.fromJson(json.decode(str));

String getWatchlistDataToJson(GetWatchlistData data) => json.encode(data.toJson());

class GetWatchlistData {
  GetWatchlistData({
    this.n,
    this.status,
    this.data,
  });

  int n;
  String status;
  List<Datum> data;

  factory GetWatchlistData.fromJson(Map<String, dynamic> json) => GetWatchlistData(
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
  List<Currency> currency;
  bool watchlist;
  int customerWatchlist;
  String customer;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    currency: List<Currency>.from(json["currency"].map((x) => Currency.fromJson(x))),
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
    "currency": List<dynamic>.from(currency.map((x) => x.toJson())),
    "watchlist": watchlist,
    "customerWatchlist": customerWatchlist,
    "customer": customer,
  };
}

class Currency {
  Currency({
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
  String buy;
  String sell;
  String high;
  String low;
  String volume;
  String marketCapUsd;
  String dayChange;
  String weekChange;
  String thumbnail;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    symbol: json["symbol"],
    buy: json["buy"],
    sell: json["sell"],
    high: json["high"],
    low: json["low"],
    volume: json["volume"],
    marketCapUsd: json["marketCapUsd"],
    dayChange: json["dayChange"],
    weekChange: json["weekChange"],
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
