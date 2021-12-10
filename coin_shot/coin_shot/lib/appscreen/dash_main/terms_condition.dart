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

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreen createState() => _TermsScreen();
}

class _TermsScreen extends State<TermsScreen> with TickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                    Container(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: Text(
                        'Terms and Conditions',
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: Text(
                        'In at iaculis lorem. Praesent tempor dictum tellus ut molestie. Sed sed ullamcorper lorem, id faucibus odio. Duis eu nisl ut ligula cursus molestie at at dolor. Nulla est justo, pellentesque vel lectus eget, fermentum varius dui. Morbi faucibus quam sed efficitur interdum. Suspendisse in pretium magna. Vivamus nec orci purus. Quisque accumsan dictum urna semper laoreet. Sed id rutrum tellus. In nisi sapien, sagittis faucibus tincidunt et, lacinia id felis. Ut tempor lectus porta, tempus orci ac, feugiat tellus. Suspendisse sagittis libero vitae metus sodales, id semper justo congue. Donec quam lorem, efficitur sit amet ex dapibus, venenatis sodales justo. Nulla arcu tellus, lacinia ac feugiat ac, cursus eget felis. Pellentesque fringilla quam ac ex convallis, vel imperdiet magna laoreet.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize:
                          ResponsiveFlutter.of(context).fontSize(2.0),
                          fontWeight: FontWeight.w300,
                          color: CustomColor.colWhite,
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: Text(
                        'Privacy Policy',
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Text(
                        'In at iaculis lorem. Praesent tempor dictum tellus ut molestie. Sed sed ullamcorper lorem, id faucibus odio. Duis eu nisl ut ligula cursus molestie at at dolor. Nulla est justo, pellentesque vel lectus eget, fermentum varius dui. Morbi faucibus quam sed efficitur interdum. Suspendisse in pretium magna. Vivamus nec orci purus. Quisque accumsan dictum urna semper laoreet. Sed id rutrum tellus. In nisi sapien, sagittis faucibus tincidunt et, lacinia id felis. Ut tempor lectus porta, tempus orci ac, feugiat tellus. Suspendisse sagittis libero vitae metus sodales, id semper justo congue. Donec quam lorem, efficitur sit amet ex dapibus, venenatis sodales justo. Nulla arcu tellus, lacinia ac feugiat ac, cursus eget felis. Pellentesque fringilla quam ac ex convallis, vel imperdiet magna laoreet.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize:
                          ResponsiveFlutter.of(context).fontSize(2.0),
                          fontWeight: FontWeight.w300,
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
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: 30,
            height: 30,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/splash_coinshot.png',
              alignment: Alignment.centerLeft,
              width: 50,
              height: 25,
            ),
          ),
        ),
      ],
    );
  }
}
