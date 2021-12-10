import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/models/GetUserDetail.dart';
import 'package:coin_shot/models/UpdateUser.dart';
import 'package:coin_shot/widget/circular_btn.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';
import 'profile.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreen createState() => _MyProfileScreen();
}

class _MyProfileScreen extends State<MyProfileScreen>
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
  String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
  Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp, regexEmail;
  final ImagePicker _picker = ImagePicker();
  File _imageFile, _image;
  dynamic _pickImageError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regExp = new RegExp(patttern);
    regexEmail = new RegExp(patternEmail);
    getUserDetail();
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
          Navigator.pop(context);
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          body: SafeArea(
              child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 25, right: 20, left: 20, bottom: 5),
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
                            onTap: () {
                              _onImageButtonPressed(ImageSource.gallery,
                                  context: context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: (_image != null)
                                          ? FileImage(_image)
                                          : GlobalLists.profileDetails
                                                      .profilephoto !=
                                                  null
                                              ? NetworkImage(
                                                  APIManager.baseURLComm +
                                                      GlobalLists.profileDetails
                                                          .profilephoto)
                                              : AssetImage(
                                                  'assets/icons/profile.png'),
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
                            // 'Patrick Jones',
                            GlobalLists.profileDetails.fullname,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
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
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.text_line,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
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
                            'Full Name',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
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
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
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
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
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
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
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
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
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
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
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
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     left: 15,
                        //     right: 15,
                        //   ),
                        //   child: Text(
                        //     'Password',
                        //     style: TextStyle(
                        //       fontFamily: 'Roboto',
                        //       fontSize:
                        //           ResponsiveFlutter.of(context).fontSize(2.0),
                        //       fontWeight: FontWeight.w400,
                        //       color: CustomColor.splash_version,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/changePwd");
                                },
                                child: Text(
                                  'Change password',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.3),
                                    fontWeight: FontWeight.w600,
                                    color: CustomColor.forgot_pwd,
                                  ),
                                ))),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //     left: 15,
                        //     right: 15,
                        //   ),
                        //   color: CustomColor.underline,
                        //   height: 1,
                        // ),
                        Container(
                          height: 50,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (nameController.text.trim().length == 0) {
                                  ShowDialogs.showToast('Please enter name');
                                } else if (emailIdController.text
                                        .trim()
                                        .length ==
                                    0) {
                                  ShowDialogs.showToast('Please enter email');
                                } else if (!regexEmail
                                    .hasMatch(emailIdController.text)) {
                                  ShowDialogs.showToast(
                                      'Please enter valid Email Id');
                                } else if (mobileController.text.length == 0) {
                                  ShowDialogs.showToast(
                                      'Please enter mobile number');
                                } else if (!regExp
                                    .hasMatch(mobileController.text)) {
                                  ShowDialogs.showToast(
                                      'Please enter valid mobile number');
                                } else {
                                  updateUserDetail();
                                }
                              });
                            },
                            child: CircleButton(getTitle: 'Save'),
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
            ' MY PROFILE',
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

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      // final pickedFile = await ImagePicker.pickImage(
      //   imageQuality: 80,
      //   source: source,
      // );

      final pickedFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      await _displayPickImageDialog(
          context, (double maxWidth, double maxHeight, int quality) async {});
      setState(() {
        _imageFile = pickedFile;
        _image = File(pickedFile.path);
        // uploadMediaApi();
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    onPick(null, null, null);
  }

  //TODO:GET REMOVE BOOKMARK API GO HERE:
  getUserDetail() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
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
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.profileDetails = resp.data;
          nameController.text = resp.data.fullname;
          emailIdController.text = resp.data.email;
          mobileController.text = resp.data.mobile.toString();
        });
      } else if (resp.n == 0) {
        // ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  Future updateUserDetail() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      var requestUrl =
          APIManager.baseURLComm + '/coinshots/api/v1/updateCustomer';

      if (_imageFile == null) {
        var userId = await SPManager().getUserId();
        var map = new Map<String, dynamic>();
        map['customerId'] = userId;
        map['fullname'] = nameController.text.trim().toString();
        map['mobile'] = mobileController.text.trim().toString();
        map['email'] = emailIdController.text.trim().toString();


        http.Response response = await http.post(
          requestUrl,
          body: map,
        );
        var jsonResponse = jsonDecode(response.body);
        UpdateUser resp;
        if (jsonResponse['n'] == 0) {
          ShowDialogs.showToast(jsonResponse['message']);
          Navigator.of(_keyLoader.currentContext).pop();
        } else {
          resp = UpdateUser.fromJson(json.decode(response.body));
          ShowDialogs.showToast(resp.status);
          Navigator.of(_keyLoader.currentContext).pop();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
          setState(() {
            nameController.text = resp.data.fullname;
            emailIdController.text = resp.data.email;
            mobileController.text = resp.data.mobile.toString();
          });
        }

      } else {
        var path = _imageFile.path;
        File first = File(path);


        var userId = await SPManager().getUserId();

        Uri uri = Uri.parse(requestUrl);
        http.MultipartRequest request = new http.MultipartRequest('POST', uri);
        request.files
            .add(await http.MultipartFile.fromPath('profilephoto', first.path));
        request.fields['customerId'] = userId;
        request.fields['fullname'] = nameController.text.trim().toString();
        request.fields['mobile'] = mobileController.text.trim().toString();
        request.fields['email'] = emailIdController.text.trim().toString();

        try {
          http.StreamedResponse response =
              await request.send().catchError((error) {
            setState(() {
              print("error ${error}");
              ShowDialogs.showToast("Something went wrong!");
            });
          });

          final respStr = await response.stream.bytesToString();
          print(response.statusCode);
          if (response.statusCode == 401) {
            Navigator.of(_keyLoader.currentContext).pop();
          } else if (response.statusCode == 200) {
            UpdateUser resp = UpdateUser.fromJson(json.decode(respStr));

            if (resp.n == 1) {
              ShowDialogs.showToast(resp.status);
              Navigator.of(_keyLoader.currentContext).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
              setState(() {
                nameController.text = resp.data.fullname;
                emailIdController.text = resp.data.email;
                mobileController.text = resp.data.mobile.toString();
              });
            } else if (resp.n == 0) {
              ShowDialogs.showToast(resp.status);
              Navigator.of(_keyLoader.currentContext).pop();
            }
          } else {}
        } on HttpException {
          setState(() {
            print('login service error.');
            Navigator.of(_keyLoader.currentContext).pop();
            ShowDialogs.showToast("Something went wrong!");
          });
        } on TimeoutException catch (e) {
          print('Timeout Error: $e');
          setState(() {
            Navigator.of(_keyLoader.currentContext).pop();
            ShowDialogs.showToast("Something went wrong!");
          });
        } on SocketException catch (e) {
          print('Socket Error: $e');
          setState(() {
            Navigator.of(_keyLoader.currentContext).pop();
            ShowDialogs.showToast("Something went wrong!");
          });
        } on Error catch (e) {
          print('General Error: $e');
          setState(() {
            Navigator.of(_keyLoader.currentContext).pop();
            ShowDialogs.showToast("Something went wrong!");
          });
        }
      }
    } else {
      setState(() {
        Navigator.of(_keyLoader.currentContext).pop();
        ShowDialogs.showToast("Please check Internet Connection.");
      });
    }
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
