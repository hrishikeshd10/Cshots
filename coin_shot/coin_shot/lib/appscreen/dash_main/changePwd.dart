import 'dart:convert';
import 'dart:core';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/models/UpdatePassword.dart';
import 'package:coin_shot/widget/circular_btn.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';

class ChangePwdScreen extends StatefulWidget {
  @override
  _ChangePwdScreen createState() => _ChangePwdScreen();
}

class _ChangePwdScreen extends State<ChangePwdScreen>
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
  Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp, regexEmail;

  bool _passwordVisible, signUpPwdVisible, signUpConfPwdVisible;

  FocusNode oldFocuspasswardSignUp = new FocusNode();
  FocusNode focuspasswardSignUp = new FocusNode();
  FocusNode refocuspasswardSignUp = new FocusNode();

  var oldPwdController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confPwdController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regExp = new RegExp(patttern);
    regexEmail = new RegExp(patternEmail);
    _passwordVisible = false;
    signUpPwdVisible = false;
    signUpConfPwdVisible = false;
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
                    EdgeInsets.only(top: 25, right: 20, left: 15, bottom: 5),
                child: getTopMenuIconRow(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 8,
                        ),
                        Text(
                          'Old Password',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.splash_version,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: oldPwdController,
                                focusNode: oldFocuspasswardSignUp,
                                obscureText: !_passwordVisible,
                                cursorColor: CustomColor.colExpenseHeadingCol,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: CustomColor.colWhite,
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                ),
                                decoration: new InputDecoration(
                                  hintText: "Enter password",
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: CustomColor.text_line,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 5,
                        ),
                        Text(
                          'New Password',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.splash_version,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                focusNode: focuspasswardSignUp,
                                obscureText: !signUpPwdVisible,
                                cursorColor: CustomColor.colExpenseHeadingCol,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: CustomColor.colWhite,
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                ),
                                decoration: new InputDecoration(
                                  hintText: "Enter password",
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      signUpPwdVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: CustomColor.text_line,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        signUpPwdVisible = !signUpPwdVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 5,
                        ),
                        Text(
                          'Confirm New Password',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.splash_version,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: confPwdController,
                                focusNode: refocuspasswardSignUp,
                                obscureText: !signUpConfPwdVisible,
                                cursorColor: CustomColor.colExpenseHeadingCol,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: CustomColor.colWhite,
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                ),
                                decoration: new InputDecoration(
                                  hintText: "Re-Enter password",
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      signUpConfPwdVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: CustomColor.text_line,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        signUpConfPwdVisible =
                                            !signUpConfPwdVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          child: InkWell(
                            onTap: () {
                              if (oldPwdController.text.length == 0) {
                                ShowDialogs.showToast('Please enter password');
                              } else if (oldPwdController.text.length > 8 &&
                                  oldPwdController.text.length < 4) {
                                ShowDialogs.showToast(
                                    'Please enter valid password');
                              } else if (passwordController.text.length == 0) {
                                ShowDialogs.showToast('Please enter password');
                              } else if (passwordController.text.length > 8 &&
                                  passwordController.text.length < 4) {
                                ShowDialogs.showToast(
                                    'Please enter valid password');
                              } else if (confPwdController.text.length == 0) {
                                ShowDialogs.showToast(
                                    'Please Re-enter password');
                              } else if (confPwdController.text.trim() !=
                                  passwordController.text.trim()) {
                                ShowDialogs.showToast('Password mismatch');
                              } else {
                                setPassword();
                              }
                            },
                            child: CircleButton(getTitle: 'Send'),
                          ),
                        ),
                        Container(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              border: Border.all(
                                  width: 1.0,
                                  color: CustomColor.splash_version),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.0),
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.splash_version,
                                ),
                              ),
                            ),
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
            ' CHANGE PASSWORD',
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

  //TODO:GET REMOVE BOOKMARK API GO HERE:
  setPassword() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/coinshots/api/v1/updatePassword';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['customerpassword'] = oldPwdController.text.trim().toString();
      map['newpassword'] = passwordController.text.trim().toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        setState(() {
          ShowDialogs.showToast('Password changed successfully');
          Navigator.of(_keyLoader.currentContext).pop();
          Navigator.pop(context);
          SPManager().setToken(null);
          Navigator.pop(context);
          GlobalLists.currentPage=2;
          Navigator.pushNamed(context, "/login");
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
