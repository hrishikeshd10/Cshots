import 'dart:convert';
import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
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

class FAQsScreen extends StatefulWidget {
  @override
  _FAQsScreen createState() => _FAQsScreen();
}

class _FAQsScreen extends State<FAQsScreen> {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isExpandAll = false,
      isCoinSel = false,
      isChooseCoin = false,
      isInvestCoin = false,
      isAvgCoin = false;
  int roleId;
  String locCurrent, setTitleAll="Expand All";

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
                padding:
                    EdgeInsets.only(top: 25, right: 20, left: 8, bottom: 5),
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
                        Container(
                          height: 30,
                        ),
                        Card(
                          color: CustomColor.card_back,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCoinSel = !isCoinSel;
                                      if (isExpandAll != true) {
                                        isExpandAll = false;
                                        isChooseCoin = false;
                                        isInvestCoin = false;
                                        isAvgCoin = false;
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "What is Coinshots?",
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
                                      Center(
                                        child: Icon(
                                          isCoinSel == true
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        isCoinSel == true
                            ? Card(
                                color: CustomColor.card_back,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    "Phasellus risus turpis, pretium sit amet magna non, molestie ultricies enim. Nullam pulvinar felis at metus malesuada, nec convallis lacus commodo. Duis blandit neque purus, nec auctor mi sollicitudin nec. Duis urna ipsum, tincidunt at euismod ut, placerat eget urna. Curabitur nec faucibus leo, et laoreet nibh. Pellentesque euismod quam at eros efficitur, vitae venenatis sem consectetur. Donec ut risus ultricies, dictum neque at, bibendum purus. In hac habitasse platea dictumst.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w400,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Card(
                          color: CustomColor.card_back,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isChooseCoin = !isChooseCoin;
                                      if (isExpandAll != true) {
                                        isExpandAll = false;
                                        isCoinSel = false;
                                        isInvestCoin = false;
                                        isAvgCoin = false;
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Why choose Coinshots",
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
                                      Center(
                                        child: Icon(
                                          isChooseCoin == true
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        isChooseCoin == true
                            ? Card(
                                color: CustomColor.card_back,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    "Phasellus risus turpis, pretium sit amet magna non, molestie ultricies enim. In hac habitasse platea dictumst.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w400,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Card(
                          color: CustomColor.card_back,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isInvestCoin = !isInvestCoin;
                                      if (isExpandAll != true) {
                                        isExpandAll = false;
                                        isCoinSel = false;
                                        isChooseCoin = false;
                                        isAvgCoin = false;
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "How to invest in Bitcoins",
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
                                      Center(
                                        child: Icon(
                                          isInvestCoin == true
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        isInvestCoin == true
                            ? Card(
                                color: CustomColor.card_back,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    "Nullam pulvinar felis at metus malesuada, nec convallis lacus commodo. Duis urna ipsum, tincidunt at euismod ut, placerat eget urna. Curabitur nec faucibus leo, et laoreet nibh. Pellentesque euismod quam at eros efficitur, vitae venenatis sem consectetur. Donec ut risus ultricies, dictum neque at, bibendum purus. In hac habitasse platea dictumst.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w400,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Card(
                          color: CustomColor.card_back,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAvgCoin = !isAvgCoin;
                                      if (isExpandAll != true) {
                                        isExpandAll = false;
                                        isCoinSel = false;
                                        isChooseCoin = false;
                                        isInvestCoin = false;
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "What is average price",
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
                                      Center(
                                        child: Icon(
                                          isAvgCoin == true
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        isAvgCoin == true
                            ? Card(
                                color: CustomColor.card_back,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    "Phasellus risus turpis, pretium sit amet magna non, molestie ultricies enim. Nullam pulvinar felis at metus malesuada, nec convallis lacus commodo. Duis blandit neque purus, nec auctor mi sollicitudin nec. Duis urna ipsum, tincidunt at euismod ut, placerat eget urna. Curabitur nec faucibus leo, et laoreet nibh. Pellentesque euismod quam at eros efficitur, vitae venenatis sem consectetur. Donec ut risus ultricies, dictum neque at, bibendum purus. In hac habitasse platea dictumst.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
                                      fontWeight: FontWeight.w400,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
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
            ' FAQS',
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
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isExpandAll == true) {
                        setTitleAll='Expand All';
                        isExpandAll = false;
                        isCoinSel = false;
                        isChooseCoin = false;
                        isInvestCoin = false;
                        isAvgCoin = false;
                      } else {

                        setTitleAll='Collapse All';
                        isExpandAll = true;
                        isCoinSel = true;
                        isChooseCoin = true;
                        isInvestCoin = true;
                        isAvgCoin = true;
                      }
                    });
                  },
                  child: Text(
                    setTitleAll,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                      fontWeight: FontWeight.w400,
                      color: Colors.blueAccent,
                    ),
                  ),
                )))
      ],
    );
  }
}
