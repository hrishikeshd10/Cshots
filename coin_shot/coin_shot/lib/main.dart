import 'dart:convert';
import 'dart:io';

import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/appscreen/dash_main/FAQs.dart';
import 'package:coin_shot/appscreen/dash_main/changePwd.dart';
import 'package:coin_shot/appscreen/dash_main/compare.dart';
import 'package:coin_shot/appscreen/dash_main/explore.dart';
import 'package:coin_shot/appscreen/dash_main/getInTouch.dart';
import 'package:coin_shot/appscreen/dash_main/main_dash.dart';
import 'package:coin_shot/appscreen/dash_main/news_detail.dart';
import 'package:coin_shot/appscreen/dash_main/notifications.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/appscreen/dash_main/search_crypto.dart';
import 'package:coin_shot/appscreen/dash_main/terms_condition.dart';
import 'package:coin_shot/appscreen/dash_main/user_profile.dart';
import 'package:coin_shot/main_entry/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'appscreen/dash_main/home.dart';
import 'main_entry/SplashScreen.dart';
import 'widget/custom_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });

  // runApp(MyApp());
}

void showNotification(Map<String, dynamic> message) async {
  print('showNotification  $message');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'default_notification_channel_id', 'Notification Channel', 'JCGSurveyor',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(message['data']['body']));
  var title = message['data']['title'];
  var body = message['data']['body'];

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(
      0, title.toString(), body.toString(), platformChannelSpecifics,
      payload: jsonEncode(message));
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("IN BG");
  if (message.containsKey('data')) {
    showNotification(message);
    print('in bg');
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcm_token;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initState() {
    configLocalNotification();
    _firebaseMessaging.getToken().then((token) {
      print("firebase notification token $token");
      fcm_token = token;
      SPManager().setNotificationToken(fcm_token);
    });
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onmessage ${message}");
        showNotification(message);
      },
      onResume: (message) async {
        setState(() {
          print("onmessage ${message}");
          showNotification(message);
        });
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
    super.initState();
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> _createNotificationChannel(
      String id, String name, String description) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(
        id, name, description,
        importance: Importance.high);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future selectNotification(String payload) async {
    print('selectNotification $payload');
  }

  void showNotification(message) async {
    print('showNotification  $message');

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notification Channel',
        'JCGSurveyor',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(message['data']['body']));
    var title = message['data']['title'];
    var body = message['data']['body'];

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, title.toString(), body.toString(), platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Coinshots',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            highlightColor: CustomColor.colBlue),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new LoginScreen(),
          '/splash': (BuildContext context) => new SplashScreen(),
          '/dashboard': (BuildContext context) => new Dashboard(),
          '/explore': (BuildContext context) => new ExploreScreen(),
          '/home': (BuildContext context) => new MainDashboard(),
          '/profile': (BuildContext context) => new ProfileScreen(),
          '/userprofile': (BuildContext context) => new MyProfileScreen(),
          '/userFAQs': (BuildContext context) => new FAQsScreen(),
          '/termsCondition': (BuildContext context) => new TermsScreen(),
          '/getInTouch': (BuildContext context) => new GetInTouchScreen(),
          '/notification': (BuildContext context) => new NotificationScreen(),
          '/searchCrypto': (BuildContext context) => new SearchCryptoScreen(),
          '/compare': (BuildContext context) => new CompareScreen(),
          '/newsDetails': (BuildContext context) => new NewsDetailsScreen(),
          '/changePwd': (BuildContext context) => new ChangePwdScreen(),
        });
  }
}
