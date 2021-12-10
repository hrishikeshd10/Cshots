import 'dart:convert';
import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/models/notification_data.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
import 'package:coin_shot/widget/circular_btn.dart';
import 'package:coin_shot/widget/globalClasses.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geocoder/geocoder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<NotificationData> notifyData = [
    NotificationData(
        title: 'BTC Price Alert',
        message: 'BTC +2% in the last hour',
        imageUrl: 'assets/icons/top_news1.png',
        lastSession: 'Now'),
    NotificationData(
        title: 'Tether USDT',
        message: 'Market volume(24h) ₹3,00,74,52,821.58',
        imageUrl: 'assets/icons/top_news2.png',
        lastSession: '15 mins ago'),
    NotificationData(
        title: 'USD Coin',
        message: '(Watchlist) USD Coin hits ₹79.56',
        imageUrl: 'assets/icons/top_news1.png',
        lastSession: '1 hr ago'),
    NotificationData(
        title: 'Binance Coin BNB',
        message: '(Watchlist) Binance Coin hits ₹29,542.04',
        imageUrl: 'assets/icons/top_news2.png',
        lastSession: '5 hrs ago'),
    NotificationData(
        title: 'Solana SOL',
        message: 'Market volume(24h) ₹9,17,22,216.23',
        imageUrl: 'assets/icons/top_news1.png',
        lastSession: '2 days ago'),
    NotificationData(
        title: 'USD Coin Price Alert',
        message: 'USD Coin +1.6% in the last 30 mins',
        imageUrl: 'assets/icons/top_news2.png',
        lastSession: '3 days ago'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  Future<void> getData() async {
    ShowDialogs.showLoadingDialog(context, _keyLoader);
    Navigator.of(_keyLoader.currentContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: () async {
          // GlobalLists.currentPage = 2;
          Navigator.pop(context);
          // Navigator.pushNamed(context, "/home");
        },
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25, right: 20, left: 20, bottom: 5),
            child: getTopMenuIconRow(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeHorizontal * 8,
                    ),
                    getNotificationList(),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    ));
  }

  //to get notification list.
  Widget getNotificationList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifyData.length,
      itemBuilder: (context, i) => Card(
        color: CustomColor.card_back,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 20),
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.circle,
                    color: CustomColor.signin_clr,
                    size: 10,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(notifyData[i].imageUrl),
                          fit: BoxFit.cover)),
                  width: 30,
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          notifyData[i].title,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              color: CustomColor.colWhite,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          notifyData[i].message,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              color: CustomColor.text_line,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          notifyData[i].lastSession,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              color: CustomColor.text_line,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/delete_outline.png'),
                                  ),
                                ),
                                width: 20,
                                height: 20,
                              ),
                            ]),
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

  //Menu icon Row.
  Widget getTopMenuIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/home");
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: 30,
            height: 30,
          ),
        ),
        Expanded(
          child: Text(
            ' NOTIFICATIONS',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
              fontWeight: FontWeight.w600,
              color: CustomColor.colWhite,
            ),
          ),
        ),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Clear All',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                    fontWeight: FontWeight.w400,
                    color: Colors.blueAccent,
                  ),
                ),))
      ],
    );
  }
}
