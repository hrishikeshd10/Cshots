import 'package:coin_shot/widget/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class ShowDialogs {
  var _causeoflossController = TextEditingController();


  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {String message = "Loading, please wait...",
      bool setForLightScreen = false}) async {
    Future.delayed(
      Duration(microseconds: 300),
      () {
        showLoadingDialogWithDelay(context, key, message, setForLightScreen);
      },
    );
  }

  static Future<bool> showConfirmDialog(BuildContext context,
      String dialogTitle, String dialogMessage, Function ontap) async {
    bool yesNo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 20,
              //       color: Colors.white.withOpacity(0.4),
              //       offset: Offset(15, 15),
              //       spreadRadius: 1)
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Icon(Icons.logout),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    '$dialogTitle',
                    style: TextStyle(color: CustomColor.colBlue, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          content: Container(
            height: 140,
            //width: double.infinity-10.0,
            //  color: customcolor.greybackground1,
            decoration: BoxDecoration(
              color: CustomColor.lightGrey,
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
                  height: 5,
                ),
                Container(
                  child: Text(
                    '$dialogMessage',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColor.colBlue),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0)),
                      color: Colors.white,
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: CustomColor.colBlue,
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
                      color: CustomColor.colBlue,
                      child: Text(
                        'Yes, Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: ontap,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          // usually buttons at the bottom of the dialog
        );
      },
    );
    return yesNo;
  }

  static Future<bool> showExitDialog(int check, BuildContext context,
      String dialogTitle, String dialogMessage, Function ontap) async {
    bool yesNo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Container(
            height: 140,
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
                    '$dialogMessage',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColor.colWhite),
                  ),
                ),
                SizedBox(
                  height: 25.0,
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
                        check == 1 ? 'Yes, Exit' : 'Logout',
                        style: TextStyle(
                          color: CustomColor.signin_clr,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: ontap,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          // usually buttons at the bottom of the dialog
        );
      },
    );
    return yesNo;
  }

  static Future<void> showLoadingDialogWithDelay(BuildContext context,
      GlobalKey key, String message, bool setForLightScreen) async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            key: key,
            type: MaterialType.transparency,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitCircle(
                    color: setForLightScreen ? Colors.black : Colors.white),
                SizedBox(height: 15),
                Text(message,
                    style: TextStyle(
                        color: setForLightScreen ? Colors.black : Colors.white))
              ],
            )),
          );
        });
  }

  static void showSimpleDialog(
      BuildContext context, String dialogTitle, String dialogMessage) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(dialogTitle),
          content: new Text(dialogMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: CustomColor.blackgrey,
        backgroundColor: CustomColor.lightGrey,
        fontSize: 16.0);
  }
}
