import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

// import 'package:background_fetch/background_fetch.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/appscreen/dash_main/search/CryptoSearch.dart';
import 'package:coin_shot/models/GetCryptoList.dart';
import 'package:coin_shot/models/GetUserDetail.dart';
import 'package:coin_shot/models/GetValues.dart';
import 'package:coin_shot/models/SearchCurrency.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/models/top_news.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';
import 'explore.dart';
import 'news_detail.dart';
import 'notifications.dart';
import 'package:http/http.dart' as http;
import 'package:coin_shot/models/GetMarketData.dart';
import 'package:coin_shot/models/GetNewsResp.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TopNews> topNews = [
    TopNews(
        title: 'Polygon(Matic) on spotlight',
        imageUrl: 'assets/icons/top_news1.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Best Cryptocurrency Trading Tips in 2021',
        imageUrl: 'assets/icons/top_news2.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
  ];

  var searchController = new TextEditingController();
  FocusNode focusSearch = new FocusNode();
  bool isSearchSelected = false;

  List<CryptoModel> viewedList = [
    CryptoModel(
        imageUrl: 'assets/icons/Bitcoin.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Bitcoin',
        msg: 'BTC',
        mainAmount: '₹35,04,404.44',
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
        basicAmount: '₹15,5233.78',
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
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/LayerTwo.png',
        subImg: 'assets/icons/graphred.png',
        title: 'Binance Coin',
        msg: 'BNB',
        mainAmount: '₹35,04,404.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/Bitcoin.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Bitcoin',
        msg: 'BTC',
        mainAmount: '₹35.44',
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
        mainAmount: '₹35.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
  ];
  Timer timer;
  int splitValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalLists.signUp == false;
    GlobalLists.signPwd == false;
    GlobalLists.signOtp == false;
    getData();
    // timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getData());
  }

  /* @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }*/

  Future<void> getData() async {
    ShowDialogs.showLoadingDialog(context, _keyLoader);
    await getNewsRequest();
    await getMarketDataRequest();
    await getValues();
    await getUserDetail();
    await getCryptoDataRequest();
    Navigator.of(_keyLoader.currentContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () => ShowDialogs.showExitDialog(
          1, context, "Exit App", "Are you sure you want to Exit?", () {
        setState(() {
          SystemNavigator.pop();
        });
      }),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 25, right: 20, left: 10, bottom: 0),
                  child:
                      /*isSearchSelected
                      ? getTopSearchIconRow()
                      : */
                      getTopMenuIconRow(),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
                        child: Text(
                          'TOP NEWS',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.2),
                            fontWeight: FontWeight.w600,
                            color: CustomColor.colWhite,
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      GlobalLists.getNewsList == null
                          ? Container()
                          : Container(
                              color: CustomColor.card_back,
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 3,
                              ),
                              height: 102,
                              child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        // left: SizeConfig.blockSizeHorizontal * 3,
                                        top: SizeConfig.blockSizeHorizontal * 1,
                                        bottom:
                                            SizeConfig.blockSizeHorizontal * 1,
                                        // right: SizeConfig.blockSizeHorizontal * 3
                                      ),
                                      child: new ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Container(
                                            width: 240.0,
                                            child: getTopNewsFirst(0),
                                          ),
                                          Center(
                                            child: Container(
                                              height: 60,
                                              color: CustomColor.outline,
                                              width: 1.5,
                                            ),
                                          ),
                                          Container(
                                            width: 240.0,
                                            child: getTopNewsFirst(1),
                                          ),
                                        ],
                                      )))),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 3,
                            right: SizeConfig.blockSizeHorizontal * 3),
                        child: Container(
                          // height: 130.0,
                          child: GlobalLists.getMarketDataList.length == 0
                              ? Container()
                              : compareWidget(),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 3,
                            right: SizeConfig.blockSizeHorizontal * 3),
                        child: Container(
                          // height: 170.0,
                          child: allTopWidget(),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
                        child: Text(
                          'LAST VIEWED',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.2),
                            fontWeight: FontWeight.w600,
                            color: CustomColor.colWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Container(
                          color: CustomColor.border_line,
                          height: 1,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: GlobalLists.getLastCryptoViewed == null
                            ? Container()
                            : getLastViewed(),
                      ),
                      Container(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'CRYPTOCURRENCIES',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.2),
                                        fontWeight: FontWeight.w600,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            /* Padding(
                              padding: const EdgeInsets.only(top: 1, bottom: 1),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bottomsheet();
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/sort_black.png'),
                                        ),
                                      ),
                                      width: 25,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Container(
                          color: CustomColor.border_line,
                          height: 1,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: GlobalLists.getCryptoDataList.length == 0
                            ? Container()
                            : getCryptoList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.8),
                                        fontWeight: FontWeight.w600,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1, bottom: 1),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                    GlobalLists.currentPage = 0;
                                    Navigator.pushNamed(context, "/home");
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'View more',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w600,
                                        color: CustomColor.forgot_pwd,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/arrow_downward.png'),
                                        ),
                                      ),
                                      width: 25,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget getTopNewsFirst(int i) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: NewsDetailsScreen(
                newsId: GlobalLists.getNewsList[i].id.toString(),
              ),
              //duration: Duration(seconds: 1),
            ),
          );
          // Navigator.pushNamed(context, "/newsDetails");
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 2,
                      left: SizeConfig.blockSizeHorizontal * 3,
                      bottom: SizeConfig.blockSizeVertical * 2,
                      right: SizeConfig.blockSizeVertical * 2),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(
                                GlobalLists.getNewsList[i].thumbnail),
                            fit: BoxFit.cover)),
                    width: 60,
                    height: 60,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        GlobalLists.getNewsList[i].name,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            color: CustomColor.colWhite,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 4,
                      ),
                      Text(
                        GlobalLists.getNewsList[i].createdAt,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            color: CustomColor.text_line,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  //Menu icon Row.
  Widget getLastViewed() {
    print(
        'ata mde ${APIManager.baseURLComm + GlobalLists.getLastCryptoViewed.thumbnail}');
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, i) => InkWell(
        onTap: () {
          GlobalLists.currentPage = 1;
          Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          decoration: new BoxDecoration(
            color: CustomColor.card_back,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 5, top: 1),
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
                              GlobalLists.getLastCryptoViewed.thumbnail,
                              placeholderBuilder: (context) =>
                                  Icon(Icons.error),
                              height: 25,
                              width: 25,
                              // color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobalLists.getValues
                                                .where((list) => GlobalLists
                                                    .getLastCryptoViewed.symbol
                                                    .substring(
                                                        0,
                                                        GlobalLists
                                                            .getLastCryptoViewed
                                                            .symbol
                                                            .indexOf('INR'))
                                                    .contains(list.value))
                                                .toList()
                                                .length ==
                                            0
                                        ? 'NA'
                                        : GlobalLists.getValues
                                            .where((list) => GlobalLists
                                                .getLastCryptoViewed.symbol
                                                .substring(
                                                    0,
                                                    GlobalLists
                                                        .getLastCryptoViewed
                                                        .symbol
                                                        .indexOf('INR'))
                                                .contains(list.value))
                                            .toList()[0]
                                            .name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    GlobalLists.getLastCryptoViewed.symbol
                                        .substring(
                                            0,
                                            GlobalLists
                                                .getLastCryptoViewed.symbol
                                                .indexOf('INR')),
                                    // GlobalLists.getLastCryptoViewed.symbol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
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
                            image: AssetImage(viewedList[3].subImg),
                          ),
                        ),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, bottom: 1),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "₹" +
                                      roundUpValue(
                                              GlobalLists
                                                  .getLastCryptoViewed.buy,
                                              2)
                                          .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
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
                padding: const EdgeInsets.only(left: 1, bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Volume (24 hrs)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
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
                                          GlobalLists
                                              .getLastCryptoViewed.volume,
                                          2)
                                      .toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Change (24 hrs)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.text_line,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(checkNegative(
                                                  roundUpValue(
                                                      (GlobalLists
                                                              .getLastCryptoViewed
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
                                              GlobalLists.getLastCryptoViewed
                                                      .dayChange *
                                                  100,
                                              2)
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
                                    fontWeight: FontWeight.w400,
                                    color: checkNegative(roundUpValue(
                                                (GlobalLists.getLastCryptoViewed
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
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.text_line,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(checkNegative(
                                                  roundUpValue(
                                                      (GlobalLists
                                                              .getLastCryptoViewed
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
                                              GlobalLists.getLastCryptoViewed
                                                      .weekChange *
                                                  100,
                                              2)
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
                                    fontWeight: FontWeight.w400,
                                    color: checkNegative(roundUpValue(
                                                GlobalLists.getLastCryptoViewed
                                                        .weekChange *
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
  }

  //Menu icon Row.
  Widget getCryptoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, i) => InkWell(
        onTap: () {
          GlobalLists.currentPage = 1;
          Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          decoration: new BoxDecoration(
            color: CustomColor.card_back,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 5, top: 1),
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
                              image: AssetImage(viewedList[i].imageUrl),
                            ),
                          ),
                          width: 25,
                          height: 25,
                        ),*/
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: SvgPicture.network(
                              GlobalLists.getCryptoDataList[i].thumbnail,
                              placeholderBuilder: (context) =>
                                  Icon(Icons.error),
                              height: 25,
                              width: 25,
                              // color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobalLists.getValues
                                                .where((list) => GlobalLists
                                                    .getCryptoDataList[i].symbol
                                                    .substring(
                                                        0,
                                                        GlobalLists
                                                            .getCryptoDataList[
                                                                i]
                                                            .symbol
                                                            .indexOf('INR'))
                                                    .contains(list.value))
                                                .toList()
                                                .length ==
                                            0
                                        ? 'NA'
                                        : GlobalLists.getValues
                                            .where((list) => GlobalLists
                                                .getCryptoDataList[i].symbol
                                                .substring(
                                                    0,
                                                    GlobalLists
                                                        .getCryptoDataList[i]
                                                        .symbol
                                                        .indexOf('INR'))
                                                .contains(list.value))
                                            .toList()[0]
                                            .name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    GlobalLists.getCryptoDataList[i].symbol
                                        .substring(
                                            0,
                                            GlobalLists
                                                .getCryptoDataList[i].symbol
                                                .indexOf('INR')),
                                    // GlobalLists.getCryptoDataList[i].symbol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
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
                                ? viewedList[0].subImg
                                : viewedList[2].subImg),
                          ),
                        ),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, bottom: 1),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "₹" +
                                      roundUpValue(
                                              GlobalLists
                                                  .getCryptoDataList[i].buy,
                                              2)
                                          .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
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
                padding: const EdgeInsets.only(left: 1, bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Volume (24 hrs)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
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
                                          GlobalLists
                                              .getCryptoDataList[i].volume,
                                          2)
                                      .toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Change (24 hrs)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.text_line,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(checkNegative(
                                                  roundUpValue(
                                                      (GlobalLists
                                                              .getCryptoDataList[
                                                                  i]
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
                                              GlobalLists.getCryptoDataList[i]
                                                      .dayChange *
                                                  100,
                                              2)
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
                                    fontWeight: FontWeight.w400,
                                    color: checkNegative(roundUpValue(
                                                (GlobalLists
                                                        .getCryptoDataList[i]
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
                                    ResponsiveFlutter.of(context).fontSize(1.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.text_line,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(checkNegative(
                                                  roundUpValue(
                                                      (GlobalLists
                                                              .getCryptoDataList[
                                                                  i]
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
                                              GlobalLists.getCryptoDataList[i]
                                                      .weekChange *
                                                  100,
                                              2)
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.8),
                                    fontWeight: FontWeight.w400,
                                    color: checkNegative(roundUpValue(
                                                (GlobalLists
                                                        .getCryptoDataList[i]
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
  }

  Widget allTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'TOP GAINERS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.text_line,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/PathRev.png'),
                            ),
                          ),
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomColor.outline,
                    height: 1.5,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/USDCC.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "USD Coin",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '4.72%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.green_news,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/USDTT.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "Tether (USD)",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '1.55%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.green_news,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/Bitcoin.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "Bitcoin SV",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '1.52%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.green_news,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ]),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'TOP LOSERS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.text_line,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/PathRevRed.png'),
                            ),
                          ),
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomColor.outline,
                    height: 1.5,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/ALGOO.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "Algorand",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '-15.55%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.red_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/ETHH.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "Ethereum",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '-9.49%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.red_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/LayerTwo.png'),
                                  ),
                                ),
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                "Binance Coin",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '-8.84%',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.red_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ]),
          ),
        ),
      ],
    );
  }

  Widget getVolumeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: new EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
          child: Container(
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )),
        Expanded(
            child: Padding(
          padding: new EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
          child: Container(
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )),
        Expanded(
            child: Padding(
          padding: new EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
          child: Container(
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )),
      ],
    );
  }

  Widget compareWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "₹" +
                        roundUpValue(
                                GlobalLists.getMarketDataList[0]
                                    .inrVolume24HourDayChange,
                                2)
                            .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                      fontWeight: FontWeight.w600,
                      color: CustomColor.colWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        EdgeInsets.only(top: 3, right: 5, left: 5, bottom: 3),
                    decoration: new BoxDecoration(
                      color: CustomColor.light_green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/PathRev.png'),
                            ),
                          ),
                          width: 10,
                          height: 10,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '0.69%',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.green_news,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'INR \n Volume \n (24hrs)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                      fontWeight: FontWeight.w400,
                      color: CustomColor.text_line,
                    ),
                  ),
                ]),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    //added today...
                    "\$" +
                        roundUpValue(
                                GlobalLists.getMarketDataList[0]
                                    .globalMarketCapDayChange,
                                2)
                            .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                      fontWeight: FontWeight.w600,
                      color: CustomColor.colWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        EdgeInsets.only(top: 3, right: 5, left: 5, bottom: 3),
                    decoration: new BoxDecoration(
                      color: CustomColor.light_red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/PathRevRed.png'),
                            ),
                          ),
                          width: 10,
                          height: 10,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '10.09%',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.red_text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Global \n MarketCap \n (24hrs)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                      fontWeight: FontWeight.w400,
                      color: CustomColor.text_line,
                    ),
                  ),
                ]),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\$" +
                        roundUpValue(
                                GlobalLists.getMarketDataList[0]
                                    .globalVolume24HourDayChange,
                                2)
                            .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                      fontWeight: FontWeight.w600,
                      color: CustomColor.colWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        EdgeInsets.only(top: 3, right: 5, left: 5, bottom: 3),
                    decoration: new BoxDecoration(
                      color: CustomColor.light_green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/PathRev.png'),
                            ),
                          ),
                          width: 10,
                          height: 10,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '0.69%',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.green_news,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Global \n Volume \n (24hrs)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                      fontWeight: FontWeight.w400,
                      color: CustomColor.text_line,
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  double roundUpValue(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  //to get top news list.
  Widget getTopNewsList() {
    return ListView.builder(
      // shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: topNews.length,
      itemBuilder: (context, i) => Card(
        color: CustomColor.card_back,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 2,
                      left: SizeConfig.blockSizeHorizontal * 3,
                      bottom: SizeConfig.blockSizeVertical * 2,
                      right: SizeConfig.blockSizeVertical * 2),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage(topNews[i].imageUrl),
                            fit: BoxFit.cover)),
                    width: 70,
                    height: 70,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        topNews[i].title,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            color: CustomColor.colWhite,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 4,
                      ),
                      Text(
                        topNews[i].dateTime,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            color: CustomColor.text_line,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: SizeConfig.blockSizeVertical * 100,
              color: Colors.black,
              child: Container(
                  decoration: new BoxDecoration(
                      color: CustomColor.card_back,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5),
                          topRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5))),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: new Center(
                          child: Text(
                            'Sort by ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Ascending ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from low to high
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Descending',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from high to low
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => a.buy.compareTo(b.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Highest Price',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from high to low
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Lowest Price',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from low to high
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => a.buy.compareTo(b.buy));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Highest Volume',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from high to low
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => b.volume.compareTo(a.volume));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Lowest Volume',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from low to high
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => a.volume.compareTo(b.volume));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Biggest Gainers',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from high to low
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      ListTile(
                        title: new Text(
                          'Biggest Losers',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // Selling price from low to high
                            GlobalLists.getCryptoDataList
                                .sort((a, b) => a.volume.compareTo(b.volume));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataList}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))));
        });
  }

  //Menu icon Row.
  Widget getTopMenuIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // _scaffoldKey.currentState.openDrawer();
          },
          child: Image.asset(
            'assets/icons/splash_coinshot.png',
            width: SizeConfig.blockSizeHorizontal * 35,
            height: SizeConfig.blockSizeHorizontal * 18,
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              // isSearchSelected = !isSearchSelected;
              showSearch(
                  context: context,
                  delegate: CryptoSearch(GlobalLists.searchCryptoDataList));
            });
          },
          child: Image.asset(
            'assets/icons/search.png',
            width: SizeConfig.blockSizeHorizontal * 8,
            height: SizeConfig.blockSizeHorizontal * 8,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, "/notification");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: NotificationScreen(),
                //duration: Duration(seconds: 1),
              ),
            );
          },
          child: Stack(
            children: <Widget>[
              new Image.asset(
                'assets/icons/notify.png',
                width: SizeConfig.blockSizeHorizontal * 8,
                height: SizeConfig.blockSizeHorizontal * 8,
              ),
              new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '0',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ProfileScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: GlobalLists.profileDetails.profilephoto != null
                        ? NetworkImage(APIManager.baseURLComm +
                            GlobalLists.profileDetails.profilephoto)
                        : AssetImage('assets/icons/profile.png'),
                    fit: BoxFit.cover)),
            width: SizeConfig.blockSizeHorizontal * 9,
            height: SizeConfig.blockSizeHorizontal * 9,
          ),
        ),
      ],
    );
  }

  //search icon Row.
  Widget getTopSearchIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSearchSelected = false;
            });
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: searchController,
            focusNode: focusSearch,
            cursorColor: CustomColor.colExpenseHeadingCol,
            style: TextStyle(
              fontFamily: 'Roboto',
              color: CustomColor.colWhite,
              // fontSize: ResponsiveFlutter.of(context)
              //     .fontSize(1.8),
            ),
            decoration: new InputDecoration(
              hintText: "Search",
              hintStyle: new TextStyle(
                color: CustomColor.splash_version,
                // fontSize: ResponsiveFlutter.of(context)
                //     .fontSize(1.8),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.outline,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.outline,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: CustomColor.green_news,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    setState(() {
                      isSearchSelected = false;
                    });
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //TODO:GET NEWS LIST API GO HERE:
  getNewsRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/news/api/v1/getNews';

      GlobalLists.getNewsList.clear();
      http.Response response = await http.get(
        uri,
        // headers: map,
      );

      print(response.body);
      GetNewsResp resp = GetNewsResp.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getNewsList = resp.data;
          print("news list length is   ${GlobalLists.getNewsList.length}");
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getNewsList = [];
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET NEWS LIST API GO HERE:
  getMarketDataRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/pocketbits/api/v1/getmarketdata';

      GlobalLists.getMarketDataList.clear();
      http.Response response = await http.get(
        uri,
      );

      print(response.body);
      GetMarketData resp = GetMarketData.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getMarketDataList = resp.data;
          print(
              "market list length is   ${GlobalLists.getMarketDataList.length}");
        });
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getNewsList = [];
        });
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET NEWS LIST API GO HERE:
  getCryptoDataRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      final uri = APIManager.baseURLComm +
          '/pocketbits/api/v1/getaveragetickerdataforsymbol';

      var map = new Map<String, dynamic>();
      map['offset'] = "";

      GlobalLists.getCryptoDataList.clear();
      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetCryptoList resp = GetCryptoList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getCryptoDataList = resp.data;
          GlobalLists.noOfLine = (GlobalLists.getCryptoDataList.length / 5);
          if (GlobalLists.getLastCryptoViewed == null) {
            GlobalLists.getLastCryptoViewed = GlobalLists.getCryptoDataList[0];
          }
          print("diwani   ${GlobalLists.getCryptoDataList.length}");

          if (GlobalLists.getValues.length > 0 && GlobalLists.getCryptoDataList.length>0) {
            for (var i = 0; i < GlobalLists.getCryptoDataList.length; i++) {
              // String currencyName =

              SearchCurrency searchCrypto;


              String currencyName = GlobalLists.getValues
                          .where((list) => GlobalLists
                              .getCryptoDataList[i].symbol
                              .substring(
                                  0,
                                  GlobalLists.getCryptoDataList[i].symbol
                                      .indexOf('INR'))
                              .contains(list.value))
                          .toList()
                          .length ==
                      0
                  ? 'NA'
                  : GlobalLists.getValues
                      .where((list) => GlobalLists.getCryptoDataList[i].symbol
                          .substring(
                              0,
                              GlobalLists.getCryptoDataList[i].symbol
                                  .indexOf('INR'))
                          .contains(list.value))
                      .toList()[0]
                      .name;
              /*searchCrypto.id = GlobalLists.getCryptoDataList[i].id;
              searchCrypto.symbol = GlobalLists.getCryptoDataList[i].symbol;
              searchCrypto.buy = GlobalLists.getCryptoDataList[i].buy;
              searchCrypto.sell = GlobalLists.getCryptoDataList[i].sell;
              searchCrypto.high = GlobalLists.getCryptoDataList[i].high;
              searchCrypto.low = GlobalLists.getCryptoDataList[i].low;
              searchCrypto.volume = GlobalLists.getCryptoDataList[i].volume;
              searchCrypto.marketCapUsd =
                  GlobalLists.getCryptoDataList[i].marketCapUsd;
              searchCrypto.dayChange =
                  GlobalLists.getCryptoDataList[i].dayChange;
              searchCrypto.weekChange =
                  GlobalLists.getCryptoDataList[i].weekChange;
              searchCrypto.thumbnail =
                  GlobalLists.getCryptoDataList[i].thumbnail;
              searchCrypto.weekChange =
                  GlobalLists.getCryptoDataList[i].weekChange;*/

              GlobalLists.searchCryptoDataList.add(SearchCurrency(
                id: GlobalLists.getCryptoDataList[i].id,
                symbol: GlobalLists.getCryptoDataList[i].symbol,
                buy:  GlobalLists.getCryptoDataList[i].buy,
                sell: GlobalLists.getCryptoDataList[i].sell,
                high: GlobalLists.getCryptoDataList[i].high,
                low: GlobalLists.getCryptoDataList[i].low,
                volume: GlobalLists.getCryptoDataList[i].volume,
                marketCapUsd: GlobalLists.getCryptoDataList[i].marketCapUsd,
                dayChange: GlobalLists.getCryptoDataList[i].dayChange,
                weekChange: GlobalLists.getCryptoDataList[i].weekChange,
                thumbnail: GlobalLists.getCryptoDataList[i].thumbnail,
                symName: currencyName,
              ));
            }

            print("diwani   ${GlobalLists.searchCryptoDataList.length}");
          }
        });
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getNewsList = [];
        });
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET NEWS LIST API GO HERE:
  getValues() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/pocketbits/api/v1/getvalues';

      GlobalLists.getValues.clear();
      http.Response response = await http.get(
        uri,
      );

      print(response.body);
      GetValues resp = GetValues.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getValues = resp.data;
          print("getValues list length is   ${GlobalLists.getValues.length}");
        });
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getValues = [];
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET REMOVE BOOKMARK API GO HERE:
  getUserDetail() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri =
          APIManager.baseURLComm + '/coinshots/api/v1/getCustomerDetails';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetUserDetail resp = GetUserDetail.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.profileDetails = resp.data;
        });
      } else if (resp.n == 0) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  bool checkNegative(double val) {
    if (val < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
