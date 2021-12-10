import 'dart:convert';
import 'dart:core';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/appscreen/dash_main/compare.dart';
import 'package:coin_shot/appscreen/dash_main/news.dart';
import 'package:coin_shot/appscreen/dash_main/watchlist.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_flutter/responsive_flutter.dart';
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';
import 'explore.dart';
import 'home.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboard createState() => _MainDashboard();
}

class _MainDashboard extends State<MainDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [
    ExploreScreen(),
    CompareScreen(),
    Dashboard(),
    NewsScreen(),
    WatchListScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getData() async {
    ShowDialogs.showLoadingDialog(context, _keyLoader);
    // await getMainClaimsSurveyList();
    Navigator.of(_keyLoader.currentContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: _pages[GlobalLists.currentPage],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
          decoration: new BoxDecoration(
            color: CustomColor.outline,
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(0.5),
                topRight: Radius.circular(0.5),
                bottomLeft: Radius.circular(0.5),
                bottomRight: Radius.circular(0.5)),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.green_news,
            elevation: 5,
            mouseCursor: SystemMouseCursors.grab,
            currentIndex: GlobalLists.currentPage,
            //New
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/explore.png',
                  height: 25,
                  width: 25,
                  color: GlobalLists.currentPage == 0
                      ? CustomColor.green_news
                      : CustomColor.text_line,
                ),
                title: Padding(
                  padding:
                      EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                      fontWeight: FontWeight.w400,
                      color: GlobalLists.currentPage == 0
                          ? CustomColor.green_news
                          : CustomColor.text_line,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/compare.png',
                  height: 25,
                  width: 25,
                  color: GlobalLists.currentPage == 1
                      ? CustomColor.green_news
                      : CustomColor.text_line,
                ),
                title: Padding(
                  padding:
                      EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                  child: Text(
                    'Compare',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                      fontWeight: FontWeight.w400,
                      color:  GlobalLists.currentPage == 1
                          ? CustomColor.green_news
                          : CustomColor.text_line,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  GlobalLists.currentPage == 2
                      ? 'assets/icons/home.png'
                      : 'assets/icons/home_grey.png',
                  height: 25,
                  width: 25,
                ),
                title: Padding(
                  padding:
                      EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                      fontWeight: FontWeight.w400,
                      color: GlobalLists.currentPage == 2
                          ? CustomColor.green_news
                          : CustomColor.text_line,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/news.png',
                  height: 25,
                  width: 25,
                  color: GlobalLists.currentPage == 3
                      ? CustomColor.green_news
                      : CustomColor.text_line,
                ),
                title: Padding(
                  padding:
                      EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                  child: Text(
                    'News',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                      fontWeight: FontWeight.w400,
                      color:  GlobalLists.currentPage == 3
                          ? CustomColor.green_news
                          : CustomColor.text_line,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/watchlist.png',
                  height: 25,
                  width: 25,
                  color: GlobalLists.currentPage == 4
                      ? CustomColor.green_news
                      : CustomColor.text_line,
                ),
                title: Padding(
                  padding:
                      EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                  child: Text(
                    'Watchlist',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                      fontWeight: FontWeight.w400,
                      color:  GlobalLists.currentPage == 4
                          ? CustomColor.green_news
                          : CustomColor.text_line,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      /*FancyBottomNavigationNew(
            initialSelection: GlobalLists.currentPage,
            circleColor: Colors.transparent,
            barBackgroundColor: Colors.black,
            activeIconColor: CustomColor.signin_clr,
            inactiveIconColor: CustomColor.text_line,
            textColor: CustomColor.signin_clr,
            tabs: [
              TabDataNew(iconData: Icons.monetization_on, title: "Explore"),
              TabDataNew(iconData: Icons.swap_horiz_rounded, title: "Compare"),
              TabDataNew(iconData: Icons.home, title: "Home"),
              TabDataNew(iconData: Icons.insert_drive_file_rounded, title: "News"),
              TabDataNew(iconData: Icons.add_comment_rounded, title: "Watchlist"),
            ],
            onTabChangedListener: (position) {
              setState(() {
                GlobalLists.currentPage = position;
                print(GlobalLists.currentPage);
              });
            },
          ),*/
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      GlobalLists.currentPage = index;
    });
  }
}
