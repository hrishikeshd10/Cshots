import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/add_watchlist.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/appscreen/dash_main/search/CryptoSearch.dart';
import 'package:coin_shot/models/AddWatchList.dart';
import 'package:coin_shot/models/GetMainWatchlist.dart';
import 'package:coin_shot/models/GetWatchlistData.dart';
import 'package:coin_shot/models/UpdateWatchlist.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
import 'package:coin_shot/widget/globalClasses.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geocoder/geocoder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';
import 'main_dash.dart';
import 'notifications.dart';

class WatchListScreen extends StatefulWidget {
  @override
  _WatchListScreen createState() => _WatchListScreen();
}

class _WatchListScreen extends State<WatchListScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyLoaderAdd = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _textFieldController = new TextEditingController();
  var searchController = new TextEditingController();
  FocusNode focusSearch = new FocusNode();
  bool isSearchSelected = false;
  String valueText = "", codeDialog = "";
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
    getData();
  }

  Future<void> getData() async {
    ShowDialogs.showLoadingDialog(context, _keyLoader);
    await getMainWatchlist();
    if (GlobalLists.watchlistId != "") {
      await getWatchlistData(GlobalLists.watchlistId);
    }

    Navigator.of(_keyLoader.currentContext).pop();
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
                      : */
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
                                    setState(() {
                                      bottomsheet(0);
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        GlobalLists.selectWatchlist == ""
                                            ? 'Select Watchlist'
                                            : GlobalLists.selectWatchlist,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2.2),
                                          fontWeight: FontWeight.w600,
                                          color: CustomColor.colWhite,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: CustomColor.colWhite,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, bottom: 1),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (GlobalLists.watchlistId == "") {
                                            ShowDialogs.showToast(
                                                "Please select watchlist");
                                          } else {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child: AddWatchScreen(
                                                  watchListId:
                                                      GlobalLists.watchlistId,
                                                ),
                                                //duration: Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/add_circle.png'),
                                          ),
                                        ),
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          bottomsheetNew();
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/sort_black.png'),
                                          ),
                                        ),
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: CustomColor.card_back, height: 1.5),
                        GlobalLists.getWatchListData.length == 0
                            ? Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text("No Records",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: CustomColor.text_line,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                              )
                            : getWatchListCard(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget bottomsheet(int value) {
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
                            value == 1
                                ? "Add to Watchlist"
                                : 'Select Watchlist',
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
                                  getWatchlistData(
                                      GlobalLists.getMainWatchList[i].id);
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 1, bottom: 1),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  removeMainWatchlist(
                                                      GlobalLists
                                                          .getMainWatchList[i]
                                                          .id
                                                          .toString());
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: CustomColor.text_line,
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _textFieldController.text ==
                                                        GlobalLists
                                                            .getMainWatchList[i]
                                                            .name;
                                                    _displayTextInputDialog(
                                                        context,
                                                        "1",
                                                        GlobalLists
                                                            .getMainWatchList[i]
                                                            .name,
                                                        GlobalLists
                                                            .getMainWatchList[i]
                                                            .id
                                                            .toString());
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.edit_outlined,
                                                  color: CustomColor.text_line,
                                                ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
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
                        height: 10,
                      ),
                      ListTile(
                        title: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1, bottom: 1),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _displayTextInputDialog(
                                        context, "0", "", "");
                                    // _showDialog();
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: CustomColor.text_line,
                                ),
                              ),
                            ),
                            Text(
                              'CREATE NEW WATCHLIST',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.8),
                                fontWeight: FontWeight.w400,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _displayTextInputDialog(context, "0", "", "");
                          // Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      Container(
                        height: 20,
                      ),
                    ],
                  )));
        });
  }

  Widget bottomsheetNew() {
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                b.currency[0].buy.compareTo(a.currency[0].buy));
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                a.currency[0].buy.compareTo(b.currency[0].buy));
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                b.currency[0].buy.compareTo(a.currency[0].buy));
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                a.currency[0].buy.compareTo(b.currency[0].buy));
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
                            GlobalLists.getWatchListData.sort((a, b) => b
                                .currency[0].volume
                                .compareTo(a.currency[0].volume));
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
                            GlobalLists.getWatchListData.sort((a, b) => a
                                .currency[0].volume
                                .compareTo(b.currency[0].volume));
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                b.currency[0].buy.compareTo(a.currency[0].buy));
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
                            GlobalLists.getWatchListData.sort((a, b) =>
                                a.currency[0].buy.compareTo(b.currency[0].buy));
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

  //Get Survey List Card to have my & new claims.
  Widget getWatchListCard() {
    return Card(
      color: Colors.transparent,
      child: Container(
        // margin: const EdgeInsets.only(bottom: 10),
        height: SizeConfig.blockSizeVertical * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: 15),
            Expanded(child: getWatchListData()),
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
      itemCount: GlobalLists.getWatchListData.length,
      itemBuilder: (context, i) => InkWell(
        onTap: () {
          GlobalLists.currentPage = 1;
          Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
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
                                  image: AssetImage(topNews[0].imageUrl),
                                ),
                              ),
                              width: 25,
                              height: 25,
                            ),
                            http://admin.coinshots.io/  */
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: SvgPicture.network(
                                'http://admin.coinshots.io'+GlobalLists.getWatchListData[i]
                                    .currency[0].thumbnail,
                                placeholderBuilder: (context) => Icon(Icons.error),
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
                                                      .getWatchListData[i]
                                                      .currency[0]
                                                      .symbol
                                                      .substring(
                                                          0,
                                                          GlobalLists
                                                              .getWatchListData[
                                                                  i]
                                                              .currency[0]
                                                              .symbol
                                                              .indexOf('INR'))
                                                      .contains(list.value))
                                                  .toList()
                                                  .length ==
                                              0
                                          ? 'NA'
                                          : GlobalLists.getValues
                                              .where((list) => GlobalLists
                                                  .getWatchListData[i]
                                                  .currency[0]
                                                  .symbol
                                                  .substring(
                                                      0,
                                                      GlobalLists.getWatchListData[i].currency[0].symbol
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
                                      GlobalLists.getWatchListData[i]
                                          .currency[0].symbol
                                          .substring(
                                              0,
                                              GlobalLists.getWatchListData[i]
                                                  .currency[0].symbol
                                                  .indexOf('INR')),
                                      // GlobalLists.getWatchListData[i].currency[0].symbol,
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
                              image: AssetImage(i == 0 || i == 2 || i == 5
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
                                    // GlobalLists.getWatchListData[i].currency[0].buy,
                                    GlobalLists.getWatchListData[i].currency[0]
                                                .buy !=
                                            null
                                        ? "₹" +
                                            roundUpValue(
                                                    double.parse(GlobalLists
                                                        .getWatchListData[i]
                                                        .currency[0]
                                                        .buy),
                                                    2)
                                                .toString()
                                        : "₹" + "0.0",
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
                                // topNews[i].basicAmount,
                                "₹" +
                                    roundUpValue(
                                            double.parse(GlobalLists
                                                .getWatchListData[i]
                                                .currency[0]
                                                .volume),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 1),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(checkNegative(
                                                    roundUpValue(
                                                        double.parse(GlobalLists
                                                                .getWatchListData[
                                                                    i]
                                                                .currency[0]
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
                                                double.parse(GlobalLists
                                                        .getWatchListData[i]
                                                        .currency[0]
                                                        .dayChange) *
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
                                                  double.parse(GlobalLists
                                                          .getWatchListData[i]
                                                          .currency[0]
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(checkNegative(
                                                    roundUpValue(
                                                        (double.parse(GlobalLists
                                                                .getWatchListData[
                                                                    i]
                                                                .currency[0]
                                                                .weekChange) *
                                                            100),
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
                                                double.parse(GlobalLists
                                                        .getWatchListData[i]
                                                        .currency[0]
                                                        .weekChange) *
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
                                                  (double.parse(GlobalLists
                                                          .getWatchListData[i]
                                                          .currency[0]
                                                          .weekChange) *
                                                      100),
                                                  2)) ==
                                              false
                                          ? CustomColor.green_news
                                          : CustomColor.red_text,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
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
          // actions: <Widget>[
          //   IconSlideAction(
          //     caption: /*'Edit'*/ '',
          //     color: Colors.black45,
          //     icon: Icons.edit,
          //     onTap: () => {print('more clicked')},
          //   ),
          // ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Remove',
              color: Colors.black45,
              icon: Icons.star,
              foregroundColor: Colors.yellow,
              onTap: () => {
                removeWatchlistData(
                    GlobalLists.getWatchListData[i].currency[0].symbol,
                    GlobalLists.getWatchListData[i].id.toString())
              },
            ),
          ],
        ),
      ),
    );
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

  //TODO:GET ADD BOOKMARK API GO HERE:
  getMainWatchlist() async {
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
        // ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        // Navigator.of(_keyLoader.currentContext).pop();
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

  //TODO:GET ADD BOOKMARK API GO HERE:
  getWatchlistData(var id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri =
          APIManager.baseURLComm + '/watchlist/api/v1/getWatchlistdDataById';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['customerWatchlistId'] = id.toString();

      GlobalLists.getWatchListData.clear();
      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetWatchlistData resp =
          GetWatchlistData.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        // Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.getWatchListData = resp.data;
        });
      } else if (resp.n == 0) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  double roundUpValue(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, dynamic fromId, var name, var Id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            content: Container(
              height: 180,
              decoration: BoxDecoration(
                color: CustomColor.card_back,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: Text(
                      'Watchlist',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CustomColor.colWhite),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                    ],
                    controller: _textFieldController,
                    cursorColor: CustomColor.colExpenseHeadingCol,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: CustomColor.colWhite,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                    decoration: new InputDecoration(
                      hintText: name == "" ? "Enter" : name,
                      hintStyle: new TextStyle(
                        color: CustomColor.splash_version,
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.colBorderColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.splash_version,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0)),
                        color: Colors.black,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: CustomColor.text_line,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      RaisedButton(
                        //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
                        padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0)),
                        color: Colors.black,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: CustomColor.signin_clr,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: () {
                          if (_textFieldController.text.length == 0) {
                            ShowDialogs.showToast('Please enter name');
                          } else {
                            if (fromId == "1") {
                              updateMainWatchlist(Id);
                            } else {
                              addMainWatchlist();
                            }
                          }
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // actions: <Widget>[
            // usually buttons at the bottom of the dialog
          );
        });
  }

  //TODO:GET addMainWatchlist API GO HERE:
  addMainWatchlist() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoaderAdd);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/addWatchlist';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['name'] = _textFieldController.text.trim().toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      AddWatchList resp = AddWatchList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoaderAdd.currentContext).pop();

        setState(() {
          GlobalLists.currentPage = 4;
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoaderAdd.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET updateMainWatchlist API GO HERE:
  updateMainWatchlist(var id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoaderAdd);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/editWatchlist';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['watchlistId'] = id.toString();
      map['name'] = _textFieldController.text.trim().toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      UpdateWatchlist resp =
          UpdateWatchlist.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoaderAdd.currentContext).pop();

        setState(() {
          GlobalLists.currentPage = 4;
          GlobalLists.selectWatchlist = _textFieldController.text;
          GlobalLists.watchlistId = id.toString();

          print('global name is ${GlobalLists.selectWatchlist}');
          print('text name is ${_textFieldController.text}');
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoaderAdd.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  removeMainWatchlist(var id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoaderAdd);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/removeWatchlist';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['watchlistId'] = id;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      AddWatchList resp = AddWatchList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoaderAdd.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 4;
          //remove....
          GlobalLists.selectWatchlist = "";
          GlobalLists.watchlistId = "";
          GlobalLists.getWatchListData.clear();
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoaderAdd.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  removeWatchlistData(var name, var id) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoaderAdd);
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
        Navigator.of(_keyLoaderAdd.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 4;
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoaderAdd.currentContext).pop();
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
