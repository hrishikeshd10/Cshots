import 'dart:async';

import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/UtilityFile.dart';
import 'package:coin_shot/appscreen/dash_main/main_dash.dart';
import 'package:coin_shot/widget/custom_colors.dart';
import 'package:coin_shot/widget/formLabel.dart';
import 'package:coin_shot/widget/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../appscreen/dash_main/home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _AddSplashState createState() => _AddSplashState();
}

class _AddSplashState extends State<SplashScreen> {
  String userId = null;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  String fcm_token;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkStatus();
    Utility().loadAPIConfig(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image.asset("assets/icons/splash_coinshot.png"))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FormLabel(
              text: 'Version: ' + '1.1.4',
              labelColor: CustomColor.splash_version,
              fontfamily: 'Roboto',
              fontweight: FontWeight.w400,
              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
            ),
          ),
        ],
      ),
    );
  }

  void checkStatus() async {
    String userIdNew = await SPManager().getToken();
    print(' value is $userIdNew');
    setState(() {
      userId = userIdNew;
      print(' second value is $userId');
      if (userId == null || userId=='') {
        Timer(
            Duration(seconds: 4),
                () =>  Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: LoginScreen(),
              ),
            )
        );
      } else {
        Timer(
            Duration(seconds: 4),
                () =>  Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: MainDashboard(),
              ),
            )
        );
      }
    });
  }

}
