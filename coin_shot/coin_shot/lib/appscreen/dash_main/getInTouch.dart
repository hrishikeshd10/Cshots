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

class GetInTouchScreen extends StatefulWidget {
  @override
  _GetInTouchScreen createState() => _GetInTouchScreen();
}

class _GetInTouchScreen extends State<GetInTouchScreen>
    with TickerProviderStateMixin {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isreasonexpanded = false;
  bool isCHListexpanded = false;
  int roleId;
  String locCurrent;
  var nameController = new TextEditingController();
  var emailIdController = new TextEditingController();
  var mobileController = new TextEditingController();
  var msgController = new TextEditingController();
  String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
  Pattern patternEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp, regexEmail;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regExp = new RegExp(patttern);
    regexEmail = new RegExp(patternEmail);
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            'Full Name',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.splash_version,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z ]")),
                                  ],
                                  controller: nameController,
                                  cursorColor: CustomColor.colExpenseHeadingCol,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: CustomColor.colWhite,
                                    fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Enter full name",
                                    hintStyle: new TextStyle(
                                      color: CustomColor.splash_version,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            'Email ID',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.splash_version,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: emailIdController,
                                  cursorColor: CustomColor.colExpenseHeadingCol,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: CustomColor.colWhite,
                                    fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Enter email id",
                                    hintStyle: new TextStyle(
                                      color: CustomColor.splash_version,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            'Mobile No',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.splash_version,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: mobileController,
                                  cursorColor: CustomColor.colExpenseHeadingCol,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: CustomColor.colWhite,
                                    fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Enter mobile number",
                                    hintStyle: new TextStyle(
                                      color: CustomColor.splash_version,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            'Message',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.splash_version,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z ]")),
                                  ],
                                  controller: msgController,
                                  cursorColor: CustomColor.colExpenseHeadingCol,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: CustomColor.colWhite,
                                    fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Write your message here",
                                    hintStyle: new TextStyle(
                                      color: CustomColor.splash_version,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if(nameController.text.trim().length==0){
                                  ShowDialogs.showToast('Please enter name');
                                }
                                else if(emailIdController.text.trim().length==0){
                                  ShowDialogs.showToast('Please enter email');
                                }else if (!regexEmail.hasMatch(emailIdController.text)) {
                                  ShowDialogs.showToast('Please enter valid Email Id');
                                }else if (mobileController.text.length == 0) {
                                  ShowDialogs.showToast('Please enter mobile number');
                                }
                                else if (!regExp.hasMatch(mobileController.text)) {
                                  ShowDialogs.showToast('Please enter valid mobile number');
                                }else if(msgController.text.trim().length==0){
                                  ShowDialogs.showToast('Please enter message');
                                }
                                else{
                                  Navigator.pop(context);
                                }

                              });
                            },
                            child: CircleButton(getTitle: 'Send'),
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
          child: Text(
            ' GET IN TOUCH',
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
