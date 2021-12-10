import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/appscreen/dash_main/search/CryptoSearch.dart';
import 'package:coin_shot/models/AddDataToWatchlist.dart';
import 'package:coin_shot/models/AddWatchList.dart';
import 'package:coin_shot/models/GetCryptoList.dart';
import 'package:coin_shot/models/GetMainWatchlist.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';
import 'notifications.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreen createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var searchController = new TextEditingController();
  FocusNode focusSearch = new FocusNode();
  bool isSearchSelected = false;
  int noOfRecords = 0, splitValue = 0, pageCount = 0;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalLists.getCryptoDataListRefresh.clear();
    getCryptoDataRequest();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        GlobalLists.currentPage = 2;
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      },
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
                      :*/
                      getTopMenuIconRow(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Container(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                                          fontSize:
                                              ResponsiveFlutter.of(context)
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
                                padding:
                                    const EdgeInsets.only(top: 1, bottom: 1),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.pushNamed(
                                          context, "/searchCrypto");
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/search.png'),
                                          ),
                                        ),
                                        width: 25,
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, bottom: 1),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      bottomsheet();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
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
                              ),
                            ],
                          ),
                        ),
                        Container(color: CustomColor.card_back, height: 1.5),
                        getWatchListCard(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //Get Survey List Card to have my & new claims.
  Widget getWatchListCard() {
    return Card(
      color: Colors.transparent,
      child: Container(
        // margin: const EdgeInsets.only(top: 20),
        height: SizeConfig.blockSizeVertical * 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: 15),
            Expanded(
                child: LazyLoadScrollView(
                    onEndOfPage: () => getCryptoDataRequest(),
                    scrollOffset: noOfRecords,
                    isLoading: noOfRecords == splitValue ? true : false,
                    child: getWatchListData()) /*getWatchListData()*/),
            Container(height: 15),
          ],
        ),
      ),
    );
  }

  //Menu icon Row.
  Widget getWatchListData() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: GlobalLists.getCryptoDataListRefresh.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              GlobalLists.currentPage = 1;
              GlobalLists.getLastCryptoViewed =
                  GlobalLists.getCryptoDataListRefresh[i];
              Navigator.pop(context);
              Navigator.pushNamed(context, "/home");
            },
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: i == 0 || i == 1 ? '  Add to\nWatchlist' : 'Remove',
                  color: Colors.black45,
                  icon: i == 0 || i == 1 ? Icons.star_border : Icons.star,
                  foregroundColor: Colors.yellow,
                  onTap: () => {
                    i == 0 || i == 1
                        ? watchlistSheet()
                        : print('remove clicked')
                  },
                ),
              ],
              actionExtentRatio: 0.25,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
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
                                      image: AssetImage(topNews[0].imageUrl),
                                    ),
                                  ),
                                  width: 25,
                                  height: 25,
                                ),*/
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.network(
                                    GlobalLists
                                        .getCryptoDataListRefresh[i].thumbnail,
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
                                          GlobalLists.getValues
                                                      .where((list) => GlobalLists
                                                          .getCryptoDataListRefresh[
                                                              i]
                                                          .symbol
                                                          .substring(
                                                              0,
                                                              GlobalLists
                                                                  .getCryptoDataListRefresh[
                                                                      i]
                                                                  .symbol
                                                                  .indexOf(
                                                                      'INR'))
                                                          .contains(list.value))
                                                      .toList()
                                                      .length ==
                                                  0
                                              ? 'NA'
                                              : GlobalLists.getValues
                                                  .where((list) => GlobalLists
                                                      .getCryptoDataListRefresh[i]
                                                      .symbol
                                                      .substring(0, GlobalLists.getCryptoDataListRefresh[i].symbol.indexOf('INR'))
                                                      .contains(list.value))
                                                  .toList()[0]
                                                  .name,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2.0),
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.colWhite,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          GlobalLists
                                              .getCryptoDataListRefresh[i]
                                              .symbol
                                              .substring(
                                                  0,
                                                  GlobalLists
                                                      .getCryptoDataListRefresh[
                                                          i]
                                                      .symbol
                                                      .indexOf('INR')),
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ResponsiveFlutter.of(context)
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
                                                        .getCryptoDataListRefresh[
                                                            i]
                                                        .buy,
                                                    2)
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
                      padding:
                          const EdgeInsets.only(left: 1, bottom: 5, top: 10),
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
                                      fontSize: ResponsiveFlutter.of(context)
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
                                                GlobalLists
                                                    .getCryptoDataListRefresh[i]
                                                    .volume,
                                                2)
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.5),
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
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.5),
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.text_line,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 1),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(checkNegative(
                                                        roundUpValue(
                                                            (GlobalLists
                                                                    .getCryptoDataListRefresh[
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
                                            (roundUpValue(
                                                    (GlobalLists
                                                            .getCryptoDataListRefresh[
                                                                i]
                                                            .dayChange) *
                                                        100,
                                                    2))
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
                                                              .getCryptoDataListRefresh[
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
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.5),
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.text_line,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(checkNegative(
                                                        roundUpValue(
                                                            (GlobalLists
                                                                    .getCryptoDataListRefresh[
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
                                                    (GlobalLists
                                                            .getCryptoDataListRefresh[
                                                                i]
                                                            .weekChange) *
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
                                                              .getCryptoDataListRefresh[
                                                                  i]
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

  bool checkNegative(double val) {
    if (val < 0.0) {
      return true;
    } else {
      return false;
    }
  }

  //Menu icon Row.
  Widget getTopMenuIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            GlobalLists.currentPage = 2;
            Navigator.pop(context);
            Navigator.pushNamed(context, "/home");
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
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
          width: SizeConfig.blockSizeHorizontal * 15,
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
                //duration: Duration(seconds: 1),
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
                    // isSearchSelected = false;
                    showSearch(
                        context: context,
                        delegate:
                            CryptoSearch(GlobalLists.searchCryptoDataList));
                  });
                },
              ),
            ),
          ),
        ),
      ],
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => a.buy.compareTo(b.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => a.buy.compareTo(b.buy));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => b.volume.compareTo(a.volume));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => a.volume.compareTo(b.volume));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => b.buy.compareTo(a.buy));
                            print(
                                'High to low in price: ${GlobalLists.getCryptoDataListRefresh}');
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
                            GlobalLists.getCryptoDataListRefresh
                                .sort((a, b) => a.buy.compareTo(a.buy));
                            print(
                                'Low to hight in price: ${GlobalLists.getCryptoDataListRefresh}');
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))));
        });
  }

  Widget watchlistSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Colors.black,
              child: Container(
                  decoration: new BoxDecoration(
                      color: CustomColor.card_back,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5),
                          topRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: new Center(
                          child: Text(
                            'Select Watchlist',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                              ResponsiveFlutter.of(context).fontSize(2.0),
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
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: GlobalLists.getMainWatchList.length,
                          itemBuilder: (context, i) => InkWell(
                              onTap: () {
                                setState(() {
                                  GlobalLists.selectWatchlist =
                                      GlobalLists.getMainWatchList[i].name;
                                  GlobalLists.watchlistId = GlobalLists
                                      .getMainWatchList[i].id
                                      .toString();
                                });

                                Navigator.pop(context);
                              },
                              child: new Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          GlobalLists.getMainWatchList[i].name,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                            ResponsiveFlutter.of(context)
                                                .fontSize(2.0),
                                            fontWeight: FontWeight.w400,
                                            color: CustomColor.colWhite,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    color: CustomColor.outline,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ))),
                      Container(
                        height: 20,
                      ),
                    ],
                  )));
        });
  }

  //TODO:GET NEWS LIST API GO HERE:
  getCryptoDataRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);

      final uri = APIManager.baseURLComm +
          '/pocketbits/api/v1/getaveragetickerdataforsymbol';

      var map = new Map<String, dynamic>();
      map['offset'] = pageCount.toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print("aaj tak map is   ${map}");
      print("aaj tak response is   ${response.body}");
      GetCryptoList resp = GetCryptoList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          int value = int.parse(GlobalLists.noOfLine.toString().split(".")[0]);
          GlobalLists.getCryptoDataListRefresh = resp.data;
          print(
              "aaj tak list length is   ${GlobalLists.getCryptoDataListRefresh.length}");

          String s = GlobalLists.getCryptoDataListRefresh[0].symbol;
          String result = s.substring(0, s.indexOf('INR'));
          print('hiii.. $result');

          splitValue = (value * 5) + 5;
          noOfRecords = noOfRecords + 5;
          if ((value) == pageCount) {
            pageCount = pageCount;
          } else {
            pageCount = pageCount + 1;
          }
        });
      } else if (resp.n == 0) {
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.getNewsList = [];
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  getWatchlistById() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/getWatchlist';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetMainWatchlist resp =
      GetMainWatchlist.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getMainWatchList = resp.data;
        });
      } else if (resp.n == 0) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  addDataToWatchlist(var currencyId, var watchListId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/addWatchlistData';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['currencyId'] = currencyId;
      map['watchlistId'] = watchListId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      AddDataToWatchlist resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = AddDataToWatchlist.fromJson(json.decode(response.body));
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 4;
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  removeWatchlistData(var name, var id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri =
          APIManager.baseURLComm + '/watchlist/api/v1/removeWatchlistData';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['currencyId'] = name;
      map['watchlistdataId'] = id.toString();
      map['watchlistId'] = GlobalLists.watchlistId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print('heyyy $map');
      print('heyyy ${response.body}');
      AddWatchList resp = AddWatchList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 4;
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

}
