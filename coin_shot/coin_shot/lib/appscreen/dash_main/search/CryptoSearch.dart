import 'dart:math';

import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/models/SearchCurrency.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/widget/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:coin_shot/models/GetCryptoList.dart' as crypto;
import 'package:responsive_flutter/responsive_flutter.dart';

class CryptoSearch extends SearchDelegate<crypto.Datum> {
  final List<SearchCurrency> visitorList;
  List<SearchCurrency> myList = [];
  List<CryptoModel> topNews = [
    CryptoModel(
        imageUrl: 'assets/icons/Bitcoin.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Bitcoin',
        msg: 'BTC',
        mainAmount: '₹35,00,00,000.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/USDTT.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Tether',
        msg: 'USDT',
        mainAmount: '₹79.63',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/SOLL.png',
        subImg: 'assets/icons/graphred.png',
        title: 'Solana',
        msg: 'Sol',
        mainAmount: '₹8,586.59',
        basicAmount: '₹9,17,22,216.23',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/USDTT.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'USD Coin',
        msg: 'USDC',
        mainAmount: '₹79.63',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%')
  ];

  CryptoSearch(this.visitorList)
      : super(
            searchFieldLabel: "Enter Currency..",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            searchFieldStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ));

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        textTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.white, fontFamily: 'Montserrat')));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          query = "";
          Navigator.pop(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // Navigator.pop(context);
    return myList.isEmpty
        ? Center(
            child: Text(
              "No currencies found here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                fontWeight: FontWeight.w600,
                color: CustomColor.colWhite,
              ),
            ),
          )
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, i) {
              SearchCurrency cryptoVisitor = myList[i];
              return InkWell(
                onTap: () {
                  GlobalLists.currentPage = 1;
                  // GlobalLists.getLastCryptoViewed = myList[i];
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/home");
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption:
                          i == 0 || i == 1 ? '  Add to\nWatchlist' : 'Remove',
                      color: Colors.black45,
                      icon: i == 0 || i == 1 ? Icons.star_border : Icons.star,
                      foregroundColor: Colors.yellow,
                      onTap: () => {
                        i == 0 || i == 1
                            ? print('add clicked')
                            : print('remove clicked')
                      },
                    ),
                  ],
                  actionExtentRatio: 0.25,
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 5, top: 5, left: 10, right: 10),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    decoration: new BoxDecoration(
                      color: CustomColor.card_back,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 1, bottom: 5, top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: SvgPicture.network(
                                        cryptoVisitor.thumbnail,
                                        placeholderBuilder: (context) =>
                                            Icon(Icons.error),
                                        height: 25,
                                        width: 25,
                                        // color: Colors.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cryptoVisitor.symName,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w600,
                                                color: CustomColor.colWhite,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              cryptoVisitor.symbol.substring(
                                                  0,
                                                  cryptoVisitor.symbol
                                                      .indexOf('INR')),
                                              // cryptoVisitor.symbol,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.5),
                                                fontWeight: FontWeight.w600,
                                                color: CustomColor.text_line,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(i == 0
                                          ? topNews[0].subImg
                                          : topNews[2].subImg),
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, bottom: 1),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor.buy, 2)
                                                    .toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w600,
                                              color: CustomColor.colWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: CustomColor.outline,
                          height: 1.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 1, bottom: 5, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Volume (24 hrs)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "₹" +
                                            roundUpValue(
                                                    cryptoVisitor.volume, 2)
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.colWhite,
                                        ),
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Change (24 hrs)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 1),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(checkNegative(
                                                            roundUpValue(
                                                                (cryptoVisitor
                                                                        .dayChange) *
                                                                    100,
                                                                2)) ==
                                                        false
                                                    ? 'assets/icons/PathRev.png'
                                                    : 'assets/icons/PathRevRed.png'),
                                              ),
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor
                                                                .dayChange *
                                                            100,
                                                        2)
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w400,
                                              color: checkNegative(roundUpValue(
                                                          (cryptoVisitor
                                                                  .dayChange) *
                                                              100,
                                                          2)) ==
                                                      false
                                                  ? CustomColor.green_news
                                                  : CustomColor.red_text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Change (7D)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(checkNegative(
                                                            roundUpValue(
                                                                (cryptoVisitor
                                                                        .weekChange) *
                                                                    100,
                                                                2)) ==
                                                        false
                                                    ? 'assets/icons/PathRev.png'
                                                    : 'assets/icons/PathRevRed.png'),
                                              ),
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor
                                                                .weekChange *
                                                            100,
                                                        2)
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w400,
                                              color: checkNegative(roundUpValue(
                                                          (cryptoVisitor
                                                                  .weekChange) *
                                                              100,
                                                          2)) ==
                                                      false
                                                  ? CustomColor.green_news
                                                  : CustomColor.red_text,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  double roundUpValue(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    myList = query.isEmpty
        ? this.visitorList
        : visitorList
            .where((mg) =>
                mg.symbol.toLowerCase().contains(query.trim().toLowerCase()) ||
                mg.symName.toLowerCase().contains(query.trim().toLowerCase())
    )
            .toList();
    return myList.isEmpty
        ? Center(
            child: Text(
              "No currencies found here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                fontWeight: FontWeight.w600,
                color: CustomColor.colWhite,
              ),
            ),
          )
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, i) {
              // String startDateString;
              // String endDateString;
              SearchCurrency cryptoVisitor = myList[i];
              // if (visitor.startDate != null) {
              //   DateTime entryDateTime =
              //   DateFormat('dd-MM-yyyy').parse(visitor.startDate);
              //   startDateString =
              //       DateFormat('dd-MMM-yyyy').format(entryDateTime);
              // }
              // if (visitor.endDate != null) {
              //   DateTime exitDateTime =
              //   DateFormat('dd-MM-yyyy').parse(visitor.endDate);
              //   endDateString = DateFormat('dd MMM yyyy').format(exitDateTime);
              // }
              return InkWell(
                onTap: () {
                  GlobalLists.currentPage = 1;
                  // GlobalLists.getLastCryptoViewed = myList[i];
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/home");
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption:
                          i == 0 || i == 1 ? '  Add to\nWatchlist' : 'Remove',
                      color: Colors.black45,
                      icon: i == 0 || i == 1 ? Icons.star_border : Icons.star,
                      foregroundColor: Colors.yellow,
                      onTap: () => {
                        i == 0 || i == 1
                            ? print('add clicked')
                            : print('remove clicked')
                      },
                    ),
                  ],
                  actionExtentRatio: 0.25,
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 5, top: 5, left: 10, right: 10),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    decoration: new BoxDecoration(
                      color: CustomColor.card_back,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 1, bottom: 5, top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    /*Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage(topNews[0].imageUrl),
                                        ),
                                      ),
                                      width: 25,
                                      height: 25,
                                    ),*/
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: SvgPicture.network(
                                        cryptoVisitor.thumbnail,
                                        placeholderBuilder: (context) =>
                                            Icon(Icons.error),
                                        height: 25,
                                        width: 25,
                                        // color: Colors.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cryptoVisitor.symName,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w600,
                                                color: CustomColor.colWhite,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              cryptoVisitor.symbol.substring(
                                                  0,
                                                  cryptoVisitor.symbol
                                                      .indexOf('INR')),
                                              // cryptoVisitor.symbol,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.5),
                                                fontWeight: FontWeight.w600,
                                                color: CustomColor.text_line,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(i == 0
                                          ? topNews[0].subImg
                                          : topNews[2].subImg),
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, bottom: 1),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor.buy, 2)
                                                    .toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w600,
                                              color: CustomColor.colWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: CustomColor.outline,
                          height: 1.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 1, bottom: 5, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Volume (24 hrs)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "₹" +
                                            roundUpValue(
                                                    cryptoVisitor.volume, 2)
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.colWhite,
                                        ),
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Change (24 hrs)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 1),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(checkNegative(
                                                            roundUpValue(
                                                                (cryptoVisitor
                                                                        .dayChange) *
                                                                    100,
                                                                2)) ==
                                                        false
                                                    ? 'assets/icons/PathRev.png'
                                                    : 'assets/icons/PathRevRed.png'),
                                              ),
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor
                                                                .dayChange *
                                                            100,
                                                        2)
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w400,
                                              color: checkNegative(roundUpValue(
                                                          (GlobalLists
                                                                  .getCryptoDataList[
                                                                      i]
                                                                  .dayChange) *
                                                              100,
                                                          2)) ==
                                                      false
                                                  ? CustomColor.green_news
                                                  : CustomColor.red_text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Change (7D)',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.5),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.text_line,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(checkNegative(
                                                            roundUpValue(
                                                                (cryptoVisitor
                                                                        .weekChange) *
                                                                    100,
                                                                2)) ==
                                                        false
                                                    ? 'assets/icons/PathRev.png'
                                                    : 'assets/icons/PathRevRed.png'),
                                              ),
                                            ),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "₹" +
                                                roundUpValue(
                                                        cryptoVisitor
                                                                .weekChange *
                                                            100,
                                                        2)
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(1.8),
                                              fontWeight: FontWeight.w400,
                                              color: checkNegative(roundUpValue(
                                                          (cryptoVisitor
                                                                  .weekChange) *
                                                              100,
                                                          2)) ==
                                                      false
                                                  ? CustomColor.green_news
                                                  : CustomColor.red_text,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  bool checkNegative(double val) {
    if (val < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
