import 'dart:convert';

class SearchCurrency {
  SearchCurrency({
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
    this.symName,
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
  String symName;

  factory SearchCurrency.fromJson(Map<String, dynamic> json) => SearchCurrency(
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
    symName: json["name"],
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
    "name": symName,
  };

}
