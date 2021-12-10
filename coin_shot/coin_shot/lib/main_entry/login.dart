import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/models/GetLoginResp.dart';
import 'package:coin_shot/models/GetOTPResponse.dart';
import 'package:coin_shot/models/GetUserDetail.dart';
import 'package:coin_shot/widget/circular_blank_btn.dart';
import 'package:coin_shot/widget/circular_btn.dart';
import 'package:coin_shot/widget/custom_colors.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:coin_shot/widget/sizeconfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 16.0);
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  FocusNode focusemail = new FocusNode();
  FocusNode focuspassward = new FocusNode();
  FocusNode focuspasswardSignUp = new FocusNode();
  FocusNode refocuspasswardSignUp = new FocusNode();
  bool _obscureText = true;
  bool _passwordVisible, signUpPwdVisible, signUpConfPwdVisible, signUpPwdSetVisible, signUpConfPwdSetVisible;
  double curLat, curLong;
  String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
  Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp, regexEmail;
  Color accentPurpleColor = Color(0xFFFFFFFF);
  Color primaryColor = Color(0xFFFFFFFF);
  Color accentPinkColor = Color(0xFFFFFFFF);
  Color accentDarkGreenColor = Color(0xFFFFFFFF);
  Color accentYellowColor = Color(0xFFFFFFFF);
  Color accentOrangeColor = Color(0xFFFFFFFF);

  //Controllers for sign in.
  var userMobile = new TextEditingController();
  var userPassword = new TextEditingController();

  //Controllers for sign up.
  var otpController = new TextEditingController();
  var nameController = new TextEditingController();
  var emailIdController = new TextEditingController();
  var mobileController = new TextEditingController();
  var OTPController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confPwdController = new TextEditingController();

  //Controllers for Registration.
  var passwordSetController = new TextEditingController();
  var confPwdSetController = new TextEditingController();
  FocusNode focuspwdSetSignUp = new FocusNode();
  FocusNode refocuspwdSetSignUp = new FocusNode();

  var /* sentOtp = 0,*/ sentOtpForgot = 0;
  String verifyOTPValue = "0";
  String sendOTP = "Send OTP";

  Timer _timer;
  int _start = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    signUpPwdVisible = false;
    signUpConfPwdVisible = false;
    signUpPwdSetVisible = false;
    signUpConfPwdSetVisible = false;
    // userMobile.text = '8097933045';
    // userPassword.text = 'ashu@123';
    regExp = new RegExp(patttern);
    regexEmail = new RegExp(patternEmail);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            sendOTP = "Send OTP";
            // timer.cancel();
          });
        } else {
          setState(() {
            sendOTP = "";
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  TextStyle createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3?.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          if (GlobalLists.signUp == true || GlobalLists.verifyPwd == true || GlobalLists.forgetPwd == true || GlobalLists.sendOTPFor == true || GlobalLists.signOtp==true) {
            GlobalLists.signOtp = false;
            GlobalLists.signPwd = true;
            GlobalLists.signUp = false;
            GlobalLists.forgetPwd = false;
            GlobalLists.verifyPwd = false;
            GlobalLists.sendOTPFor = false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          } else {
            ShowDialogs.showExitDialog(
                1, context, "Exit App", "Are you sure you want to Exit?", () {
              setState(() {
                SystemNavigator.pop();
              });
            });
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/maskgroup_login.png'),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/icons/splash_coinshot.png',
                        width: 100.0, height: 100.0)),
              ),
            ),
            GlobalLists.signUp == true
                ? Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 14),
                    decoration: new BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 5),
                            topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 5))),
                    child: SingleChildScrollView(
                      // controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(3.0),
                                fontWeight: FontWeight.w800,
                                color: CustomColor.colWhite,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 1,
                            ),
                            Text(
                              'Setting up an account takes less than 1 minute',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                fontWeight: FontWeight.w400,
                                color: CustomColor.splash_version,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            Text(
                              'Full Name',
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                    ],
                                    controller: nameController,
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            Text(
                              'Email ID',
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
                                    controller: emailIdController,
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            Text(
                              'Mobile No',
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
                                    keyboardType: TextInputType.number,
                                    controller: mobileController,
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
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
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            Text(
                              'OTP',
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
                                    keyboardType: TextInputType.number,
                                    controller: OTPController,
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.8),
                                    ),
                                    decoration: new InputDecoration(
                                      hintText: "Enter OTP",
                                      hintStyle: new TextStyle(
                                        color: CustomColor.splash_version,
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.8),
                                      ),
                                    ),
                                  ),
                                ),
                                GlobalLists.signUp == true
                                    ? InkWell(
                                        onTap: () {
                                          if (_start != 0) {
                                            ShowDialogs.showToast(
                                                'Please wait');
                                          } else {
                                            if (mobileController.text.length ==
                                                0) {
                                              ShowDialogs.showToast(
                                                  'Please enter mobile number');
                                            } else if (!regExp.hasMatch(
                                                mobileController.text)) {
                                              ShowDialogs.showToast(
                                                  'Please enter valid mobile number');
                                            } else {
                                              sendOTPRequest(1);
                                            }
                                          }
                                        },
                                        child: Text(
                                          sendOTP,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2.0),
                                            fontWeight: FontWeight.w400,
                                            color: CustomColor.forgot_pwd,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        ' ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2.0),
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.splash_version,
                                        ),
                                      )
                              ],
                            ),
                            Container(
                              color: CustomColor.underline,
                              height: 1,
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            Text(
                              'Password',
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
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
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
                                            signUpPwdVisible =
                                                !signUpPwdVisible;
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
                              'Confirm Password',
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
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
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
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (nameController.text.length == 0) {
                                    ShowDialogs.showToast('Please enter name');
                                  } else if (emailIdController.text.length ==
                                      0) {
                                    ShowDialogs.showToast('Please enter email');
                                  } else if (!regexEmail
                                      .hasMatch(emailIdController.text)) {
                                    ShowDialogs.showToast(
                                        'Please enter valid Email Id');
                                  } else if (mobileController.text.length ==
                                      0) {
                                    ShowDialogs.showToast(
                                        'Please enter mobile number');
                                  } else if (!regExp
                                      .hasMatch(mobileController.text)) {
                                    ShowDialogs.showToast(
                                        'Please enter valid mobile number');
                                  } else if (OTPController.text.length == 0) {
                                    ShowDialogs.showToast('Please enter OTP');
                                  } else if (OTPController.text.length > 7 &&
                                      OTPController.text.length < 7) {
                                    ShowDialogs.showToast('Invalid OTP');
                                  } else if (passwordController.text.length ==
                                      0) {
                                    ShowDialogs.showToast(
                                        'Please enter password');
                                  } else if (passwordController.text.length >
                                          8 &&
                                      passwordController.text.length < 4) {
                                    ShowDialogs.showToast(
                                        'Please enter valid password');
                                  } else if (confPwdController.text.length ==
                                      0) {
                                    ShowDialogs.showToast(
                                        'Please Re-enter password');
                                  } else if (confPwdController.text.trim() !=
                                      passwordController.text.trim()) {
                                    ShowDialogs.showToast('Password mismatch');
                                  } else {
                                    doRegRequest();
                                  }
                                });
                              },
                              child: CircleButton(getTitle: 'Register'),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 3,
                            ),
                            InkWell(
                                onTap: () {
                                  // setState(() {
                                  GlobalLists.signOtp = false;
                                  GlobalLists.signPwd = true;
                                  GlobalLists.signUp = false;
                                  GlobalLists.forgetPwd = false;
                                  GlobalLists.verifyPwd = false;
                                  GlobalLists.sendOTPFor = false;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget));
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2.0),
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.splash_version,
                                        ),
                                      ),
                                      Text(
                                        'Sign In',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2.0),
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.forgot_pwd,
                                        ),
                                      ),
                                    ])),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : GlobalLists.verifyPwd == true
                    ? Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 38),
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    SizeConfig.blockSizeHorizontal * 5),
                                topRight: Radius.circular(
                                    SizeConfig.blockSizeHorizontal * 5))),
                        child: SingleChildScrollView(
                          // controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 2,
                                ),
                                Text(
                                  'Create new password',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(3.0),
                                    fontWeight: FontWeight.w800,
                                    color: CustomColor.colWhite,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 2,
                                ),
                                Text(
                                  'Enter the verification code we just sent',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.splash_version,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 5,
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 5,
                                ),
                                Text(
                                  'New Password',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.splash_version,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: passwordSetController,
                                        focusNode: focuspwdSetSignUp,
                                        obscureText: !signUpPwdSetVisible,
                                        cursorColor:
                                            CustomColor.colExpenseHeadingCol,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: CustomColor.colWhite,
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.8),
                                        ),
                                        decoration: new InputDecoration(
                                          hintText: "Enter password",
                                          hintStyle: new TextStyle(
                                            color: CustomColor.splash_version,
                                            fontSize:
                                                ResponsiveFlutter.of(context)
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
                                              signUpPwdSetVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: CustomColor.text_line,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                signUpPwdSetVisible =
                                                    !signUpPwdSetVisible;
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
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.splash_version,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: confPwdSetController,
                                        focusNode: refocuspwdSetSignUp,
                                        obscureText: !signUpConfPwdSetVisible,
                                        cursorColor:
                                            CustomColor.colExpenseHeadingCol,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: CustomColor.colWhite,
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.8),
                                        ),
                                        decoration: new InputDecoration(
                                          hintText: "Re-Enter password",
                                          hintStyle: new TextStyle(
                                            color: CustomColor.splash_version,
                                            fontSize:
                                                ResponsiveFlutter.of(context)
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
                                              signUpConfPwdSetVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: CustomColor.text_line,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                signUpConfPwdSetVisible =
                                                    !signUpConfPwdSetVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 25,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (passwordSetController.text.length == 0) {
                                        ShowDialogs.showToast(
                                            'Please enter password');
                                      } else if (passwordSetController
                                                  .text.length >
                                              8 &&
                                          passwordSetController.text.length < 4) {
                                        ShowDialogs.showToast(
                                            'Please enter valid password');
                                      } else if (confPwdSetController
                                              .text.length ==
                                          0) {
                                        ShowDialogs.showToast(
                                            'Please Re-enter password');
                                      } else if (confPwdSetController.text
                                              .trim() !=
                                          passwordSetController.text.trim()) {
                                        ShowDialogs.showToast(
                                            'Password mismatch');
                                      } else {
                                        setPassword();
                                      }
                                    });
                                  },
                                  child: CircleButton(getTitle: 'Save'),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeHorizontal * 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GlobalLists.forgetPwd == true
                        ? Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 38),
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5),
                                    topRight: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5))),
                            child: SingleChildScrollView(
                              // controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      'Forget password',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(3.0),
                                        fontWeight: FontWeight.w800,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      'Enter your registered phone number to receive a verification code',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    Text(
                                      'Mobile No',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: userMobile,
                                            keyboardType: TextInputType.number,
                                            cursorColor: CustomColor
                                                .colExpenseHeadingCol,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: CustomColor.colWhite,
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2.0),
                                            ),
                                            decoration: new InputDecoration(
                                              hintText: "Enter mobile number",
                                              hintStyle: new TextStyle(
                                                color:
                                                    CustomColor.splash_version,
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.5),
                                              ),
                                              // enabledBorder:
                                              //     UnderlineInputBorder(
                                              //   borderSide: BorderSide(
                                              //     color: CustomColor
                                              //         .colBorderColor,
                                              //   ),
                                              // ),
                                              // focusedBorder:
                                              //     UnderlineInputBorder(
                                              //   borderSide: BorderSide(
                                              //     color: CustomColor
                                              //         .splash_version,
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (_start != 0) {
                                                  ShowDialogs.showToast(
                                                      'Please wait');
                                                } else {
                                                  if (userMobile.text.length ==
                                                      0) {
                                                    ShowDialogs.showToast(
                                                        'Please enter mobile number');
                                                  } else if (!regExp.hasMatch(
                                                      userMobile.text)) {
                                                    ShowDialogs.showToast(
                                                        'Please enter valid mobile number');
                                                  } else {
                                                    sendOTPRequest(2);
                                                  }
                                                }
                                              });
                                            },
                                            child: Text(
                                              sendOTP,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color: CustomColor.forgot_pwd,
                                              ),
                                            ))
                                      ],
                                    ),
                                    Container(
                                      color: CustomColor.underline,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    GlobalLists.sendOTPFor == true
                                        ? _getInputField
                                        : Container(),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    /*GlobalLists.sendOTPFor == true
                                        ? Text(
                                              _start == 0
                                                  ? 'Resend OTP in ' +
                                                      "$_start" +
                                                      "s"
                                                  : '',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.8),
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    CustomColor.splash_version,
                                              ),
                                            )
                                        : Container(),*/
                                    Text(
                                      _start != 0
                                          ? 'Resend OTP in ' + "$_start" + "s"
                                          : '',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.8),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 20,
                                    ),
                                    GlobalLists.sendOTPFor == true
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (userMobile.text.length ==
                                                    0) {
                                                  ShowDialogs.showToast(
                                                      'Please enter mobile number');
                                                } else if (verifyOTPValue ==
                                                    "0") {
                                                  ShowDialogs.showToast(
                                                      'Please enter OTP');
                                                } else {
                                                  verifyOTPRequest(1);
                                                }
                                              });
                                            },
                                            child: CircleButton(
                                                getTitle: 'Verify'),
                                          )
                                        : SizedBox(
                                            height:
                                                SizeConfig.blockSizeHorizontal *
                                                    25,
                                          ),
                                    GlobalLists.sendOTPFor != true
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            color: CustomColor.green_news,
                                            height: 0.3,
                                          )
                                        : Container(),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          GlobalLists.signOtp = false;
                                          GlobalLists.signPwd = true;
                                          GlobalLists.signUp = false;
                                          GlobalLists.sendOTPFor = false;
                                          GlobalLists.forgetPwd = false;
                                          GlobalLists.verifyPwd = false;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                        });
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Try ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    CustomColor.splash_version,
                                              ),
                                            ),
                                            Text(
                                              'Sign In',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color: CustomColor.forgot_pwd,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 33),
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5),
                                    topRight: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5))),
                            child: SingleChildScrollView(
                              // controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(3.0),
                                        fontWeight: FontWeight.w800,
                                        color: CustomColor.colWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      'Sign In to your account',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    Text(
                                      'Mobile No',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: userMobile,
                                            keyboardType: TextInputType.number,
                                            cursorColor: CustomColor
                                                .colExpenseHeadingCol,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: CustomColor.colWhite,
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2.0),
                                            ),
                                            decoration: new InputDecoration(
                                              hintText: "Enter mobile number",
                                              hintStyle: new TextStyle(
                                                color:
                                                    CustomColor.splash_version,
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GlobalLists.signOtp == true
                                            ? InkWell(
                                                onTap: () {
                                                  if (_start != 0) {
                                                    ShowDialogs.showToast(
                                                        'Please wait');
                                                  } else {
                                                    if (userMobile
                                                            .text.length ==
                                                        0) {
                                                      ShowDialogs.showToast(
                                                          'Please enter mobile number');
                                                    } else if (!regExp.hasMatch(
                                                        userMobile.text)) {
                                                      ShowDialogs.showToast(
                                                          'Please enter valid mobile number');
                                                    } else {
                                                      sendOTPRequest(0);
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  sendOTP,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(1.8),
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        CustomColor.forgot_pwd,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                ' ',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(2.0),
                                                  fontWeight: FontWeight.w400,
                                                  color: CustomColor
                                                      .splash_version,
                                                ),
                                              )
                                      ],
                                    ),
                                    Container(
                                      color: CustomColor.underline,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    GlobalLists.signPwd == true
                                        ? Text(
                                            'Password',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2.0),
                                              fontWeight: FontWeight.w400,
                                              color: CustomColor.splash_version,
                                            ),
                                          )
                                        : Container(),
                                    GlobalLists.signPwd == true
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: userPassword,
                                                  focusNode: focuspassward,
                                                  obscureText:
                                                      !_passwordVisible,
                                                  cursorColor: CustomColor
                                                      .colExpenseHeadingCol,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: CustomColor.colWhite,
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(2.0),
                                                  ),
                                                  decoration:
                                                      new InputDecoration(
                                                    hintText: "Enter password",
                                                    hintStyle: new TextStyle(
                                                      color: CustomColor
                                                          .splash_version,
                                                      fontSize:
                                                          ResponsiveFlutter.of(
                                                                  context)
                                                              .fontSize(1.5),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: CustomColor
                                                            .colBorderColor,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: CustomColor
                                                            .splash_version,
                                                      ),
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _passwordVisible
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: CustomColor
                                                            .text_line,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _passwordVisible =
                                                              !_passwordVisible;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : _getInputField,
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    GlobalLists.signPwd == true
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                GlobalLists.signOtp = false;
                                                GlobalLists.signPwd = false;
                                                GlobalLists.signUp = false;
                                                GlobalLists.sendOTPFor = false;
                                                GlobalLists.forgetPwd = true;
                                                GlobalLists.verifyPwd = false;
                                              });
                                            },
                                            child: Text(
                                              'Forget Password?',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color: CustomColor.forgot_pwd,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _start != 0
                                                ? 'Resend OTP in ' +
                                                    "$_start" +
                                                    "s"
                                                : '',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize:
                                                  ResponsiveFlutter.of(context)
                                                      .fontSize(2.0),
                                              fontWeight: FontWeight.w400,
                                              color: CustomColor.splash_version,
                                            ),
                                          ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (userMobile.text.length == 0) {
                                            ShowDialogs.showToast(
                                                'Please enter mobile number');
                                          } else if (!regExp
                                              .hasMatch(userMobile.text)) {
                                            ShowDialogs.showToast(
                                                'Please enter valid mobile number');
                                          } else if (userPassword.text.length ==
                                                  0 ||
                                              userPassword.text.length > 8 ||
                                              userPassword.text.length < 4) {
                                            ShowDialogs.showToast(
                                                'Please enter password');
                                          } else {
                                            doLoginRequest();
                                          }
                                        });
                                      },
                                      child: CircleButton(getTitle: 'Sign In'),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 3,
                                    ),
                                    Text(
                                      'OR',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.splash_version,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            GlobalLists.signOtp = true;
                                            GlobalLists.signPwd = false;
                                            GlobalLists.signUp = false;
                                            GlobalLists.sendOTPFor = false;
                                            GlobalLists.forgetPwd = false;
                                            GlobalLists.verifyPwd = false;
                                          });
                                        });
                                      },
                                      child: CircleBlankButton(),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // setState(() {
                                        GlobalLists.signOtp = false;
                                        GlobalLists.signPwd = false;
                                        GlobalLists.signUp = true;
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'New User? ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    CustomColor.splash_version,
                                              ),
                                            ),
                                            Text(
                                              'Create an account',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2.0),
                                                fontWeight: FontWeight.w400,
                                                color: CustomColor.forgot_pwd,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    // Text(
                                    //   'Version: 1.0.3',
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //     fontFamily: 'Roboto',
                                    //     fontSize:
                                    //     ResponsiveFlutter.of(context)
                                    //         .fontSize(1.5),
                                    //     fontWeight: FontWeight.w400,
                                    //     color: CustomColor.splash_version,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
          ],
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  // Return "OTP" input field
  get _getInputField {
    return OtpTextField(
      numberOfFields: 6,
      borderColor: accentPurpleColor,
      fieldWidth: 43.0,
      focusedBorderColor: CustomColor.signin_clr,
      styles: [
        createStyle(accentPurpleColor),
        createStyle(accentYellowColor),
        createStyle(accentDarkGreenColor),
        createStyle(accentOrangeColor),
        createStyle(accentPinkColor),
        createStyle(accentPurpleColor),
      ],
      showFieldAsBox: false,
      borderWidth: 2.0,
      //runs when a code is typed in
      onCodeChanged: (String code) {
        print('code is $code');
      },
      //runs when every textfield is filled
      onSubmit: (String verificationCode) {
        setState(() {
          verifyOTPValue = verificationCode;
        });
        print('verificationCode is $verificationCode');
      },
    );
  }

  // Return "OTP" input field
  get _getInputField1 {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _otpTextField(1),
        _otpTextField(2),
        _otpTextField(3),
        _otpTextField(4),
        _otpTextField(5),
      ],
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
        controller: otpController,
        cursorColor: CustomColor.colExpenseHeadingCol,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: CustomColor.colWhite,
          fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
        ),
        decoration: new InputDecoration(
          hintText: "",
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
      /*   new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
          color: CustomColor.text_line,
        ),
      ),*/
      decoration: BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: CustomColor.signin_clr,
      ))),
    );
  }

  //TODO:GET LOGIN API GO HERE:
  doLoginRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/coinshots/api/v1/Login';
      var user = userMobile.text;
      var pass = userPassword.text;
      var map = new Map<String, dynamic>();
      map['mobile'] = user;
      map['password'] = pass;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      GetLoginResp resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = GetLoginResp.fromJson(json.decode(response.body));
        setState(() {
          SPManager().setUserId(resp.data.id);
          SPManager().setEmailId(resp.data.email);
          SPManager().setToken(resp.data.token);
          ShowDialogs.showToast('Login successfully');
          Navigator.of(_keyLoader.currentContext).pop();
          Navigator.pushNamed(context, "/home");
          GlobalLists.signOtp = false;
          GlobalLists.signPwd = true;
          GlobalLists.signUp = false;

        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET REGISTRATION API GO HERE:
  doRegRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/coinshots/api/v1/SignUp';
      var name = nameController.text;
      var email = emailIdController.text;
      var pass = passwordController.text;
      var number = mobileController.text;
      var confPwd = confPwdController.text;
      var OTP = OTPController.text;

      var map = new Map<String, dynamic>();
      map['fullname'] = name;
      map['email'] = email;
      map['mobile'] = number;
      map['password'] = pass;
      map['confirmpassword'] = confPwd;
      map['otp'] = OTP;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetLoginResp resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = GetLoginResp.fromJson(json.decode(response.body));
        setState(() {
          // ShowDialogs.showToast("Success");
          ShowDialogs.showToast('User registered successfully');
          Navigator.of(_keyLoader.currentContext).pop();
          setState(() {
            GlobalLists.signOtp = false;
            GlobalLists.signPwd = true;
            GlobalLists.signUp = false;
            GlobalLists.forgetPwd = false;
            GlobalLists.verifyPwd = false;
            GlobalLists.sendOTPFor = false;
            // Navigator.pushNamed(context, "/home");
          });
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET SEND OTP API GO HERE:
  sendOTPRequest(var comeFrom) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      var url = APIManager.baseURLComm + '/coinshots/api/v1/OtpSend';
      var mobileNumber =
          comeFrom == 1 ? mobileController.text : userMobile.text;
      var map = new Map<String, dynamic>();
      map['mobile'] = mobileNumber;
      map['type'] = comeFrom == 1 ? 'reg' : 'log';

      final params = {
        'mobile': mobileNumber,
        'type': comeFrom == 1 ? 'reg' : 'log'
      };

      print("map value is   ${map}");
      http.Response response = await http.post(
        url,
        body: map,
      );

      print(response.body);
      var jsonResponse = jsonDecode(response.body);
      GetOtpResponse resp;

      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          // sentOtp = 0;
          sentOtpForgot = 0;
        });
      } else {
        resp = GetOtpResponse.fromJson(json.decode(response.body));
        //0: login, 1: Registration, 2: Change password.
        ShowDialogs.showToast('OTP sent successfully');
        startTimer();
        if (comeFrom == 0) {
          setState(() {
            _start = 60;
            // sentOtp = 0;
            GlobalLists.signOtp = true;
            GlobalLists.signPwd = false;
            GlobalLists.signUp = false;
          });
        } else if (comeFrom == 1) {
          setState(() {
            // sentOtp = 1;
          });
        } else {
          setState(() {
            sentOtpForgot = 1;
            GlobalLists.signOtp = false;
            GlobalLists.signPwd = false;
            GlobalLists.signUp = false;
            GlobalLists.sendOTPFor = true;
            GlobalLists.forgetPwd = true;
            GlobalLists.verifyPwd = false;
          });
        }
        Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET VERIFY OTP API GO HERE:
  verifyOTPRequest(var navId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/coinshots/api/v1/VerifyOtp';
      var user = userMobile.text;
      var pass = userPassword.text;
      var map = new Map<String, dynamic>();
      map['mobile'] = user;
      map['otp'] = pass;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      GetLoginResp resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        if(navId==1){
          setState(() {
            ShowDialogs.showToast('Verified successfully');
            Navigator.of(_keyLoader.currentContext).pop();
            GlobalLists.signOtp = false;
            GlobalLists.signPwd = false;
            GlobalLists.signUp = false;
            GlobalLists.forgetPwd = false;
            GlobalLists.verifyPwd = true;
            GlobalLists.sendOTPFor = false;
          });
          }
        else{
          resp = GetLoginResp.fromJson(json.decode(response.body));
          setState(() {
            SPManager().setUserId(resp.data.id);
            SPManager().setEmailId(resp.data.email);
            SPManager().setToken(resp.data.token);
            ShowDialogs.showToast('Login successfully');
            // Navigator.pop(context);
            Navigator.of(_keyLoader.currentContext).pop();
            GlobalLists.signOtp = false;
            GlobalLists.signPwd = true;
            GlobalLists.signUp = false;
            GlobalLists.verifyPwd = false;
            Navigator.pushNamed(context, "/home");
          });
        }

      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET VERIFY OTP API GO HERE:
  setPassword() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/coinshots/api/v1/forgetPassword';
      var user = userMobile.text;
      var map = new Map<String, dynamic>();
      map['mobile'] = user;
      map['newpassword'] = passwordSetController.text.trim().toString();
      map['confirmpassword'] = confPwdSetController.text.trim().toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        ShowDialogs.showToast('SignIn with new credentials');
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          // GlobalLists.signOtp = false;
          // GlobalLists.signPwd = true;
          // GlobalLists.signUp = false;
          // GlobalLists.forgetPwd = false;
          // GlobalLists.verifyPwd = false;
          // GlobalLists.sendOTPFor = false;

          GlobalLists.signOtp = false;
          GlobalLists.signPwd = true;
          GlobalLists.signUp = false;
          GlobalLists.forgetPwd = false;
          GlobalLists.verifyPwd = false;
          GlobalLists.sendOTPFor = false;
          Navigator.pushNamed(context, "/login");
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

}
