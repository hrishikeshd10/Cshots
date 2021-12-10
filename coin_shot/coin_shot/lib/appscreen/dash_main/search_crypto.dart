import 'dart:convert';
import 'dart:core';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';

class SearchCryptoScreen extends StatefulWidget {
  @override
  _SearchCryptoScreen createState() => _SearchCryptoScreen();
}

class _SearchCryptoScreen extends State<SearchCryptoScreen> {
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
        Navigator.pop(context);
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
                      EdgeInsets.only(top: 50, right: 20, left: 10, bottom: 5),
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
                          Container(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10,right: 10, bottom: 10),
                            child: Text(
                              'CRYPTOCURRENCIES',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                ResponsiveFlutter.of(context)
                                    .fontSize(2.8),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                    ],
                                    // controller: nameController,
                                    cursorColor: CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize:
                                      ResponsiveFlutter.of(context).fontSize(2.0),
                                    ),
                                    decoration: new InputDecoration(
                                      hintText: "Search",
                                      hintStyle: new TextStyle(
                                        color: CustomColor.outline,
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColor.colBorderColor,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColor.outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: SizeConfig.blockSizeHorizontal * 8,
            height: SizeConfig.blockSizeHorizontal * 8,
          ),
        ),

      ],
    );
  }



}
