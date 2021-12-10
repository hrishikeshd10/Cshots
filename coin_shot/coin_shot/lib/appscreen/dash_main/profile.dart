import 'dart:convert';
import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/widget/circular_btn.dart';
import 'package:coin_shot/widget/globalClasses.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isreasonexpanded = false;
  bool isCHListexpanded = false;
  int roleId;
  String locCurrent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: GlobalLists.profileDetails.profilephoto != null
                                      ? NetworkImage(APIManager.baseURLComm +
                                      GlobalLists.profileDetails.profilephoto)
                                      : AssetImage('assets/icons/profile.png'),
                                  fit: BoxFit.cover)),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        GlobalLists.profileDetails.fullname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                          fontWeight: FontWeight.w400,
                          color: CustomColor.colWhite,
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        GlobalLists.profileDetails.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                          fontWeight: FontWeight.w400,
                          color: CustomColor.text_line,
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/userprofile");
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     type: PageTransitionType.fade,
                                //     child: MyProfileScreen(),
                                //     //duration: Duration(seconds: 1),
                                //   ),
                                // );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Basic Profile Details",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
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
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Notifications",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 4,
                                      ),
                                      child: ToggleSwitch(
                                        minHeight: 18.0,
                                        minWidth: 18.0,
                                        cornerRadius: 15.0,
                                        activeBgColors: [
                                          [Colors.white],
                                          [Colors.green[800]],
                                        ],
                                        activeFgColor: Colors.grey,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.grey,
                                        initialLabelIndex: 1,
                                        totalSwitches: 2,
                                        labels: ['', ''],
                                        radiusStyle: true,
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },

                                      ),
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
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/userFAQs");
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     type: PageTransitionType.fade,
                                //     child: FAQsScreen(),
                                //     //duration: Duration(seconds: 1),
                                //   ),
                                // );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "FAQs",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
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
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "About Us",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
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
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     type: PageTransitionType.fade,
                                //     child: TermsScreen(),
                                //     //duration: Duration(seconds: 1),
                                //   ),
                                // );
                                Navigator.pushNamed(context, "/termsCondition");
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Terms of Services",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
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
                    Card(
                      color: CustomColor.card_back,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     type: PageTransitionType.fade,
                                //     child: GetInTouchScreen(),
                                //     //duration: Duration(seconds: 1),
                                //   ),
                                // );
                                Navigator.pushNamed(context, "/getInTouch");
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Get In Touch",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
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
                    Container(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            logoutDialog();
                          });
                        },
                        child: CircleButton(getTitle: 'Log Out'),
                      ),
                    ),
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

  Widget logoutDialog() {
    ShowDialogs.showExitDialog(
        2, context, "Logout App", "Are you sure you want to Logout?", () {
      setState(() {
        SPManager().setToken(null);
        Navigator.pop(context);
        GlobalLists.currentPage=2;
        Navigator.pushNamed(context, "/login");
      });
    });
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
            ' PROFILE & MORE',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
              fontWeight: FontWeight.w600,
              color: CustomColor.colWhite,
            ),
          ),
        )
      ],
    );
  }
}
