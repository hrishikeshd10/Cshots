import 'dart:convert';
import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/models/GetNewsResp.dart';
import 'package:coin_shot/models/top_news.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
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
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';
import 'main_dash.dart';
import 'notifications.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailsScreen({Key key, this.newsId}) : super(key: key);

  @override
  _NewsDetailsScreen createState() => _NewsDetailsScreen();
}

class _NewsDetailsScreen extends State<NewsDetailsScreen> {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isLike = [true, true, false, false, false];
  List<bool> isBookMark = [true, true, false, false, false];
  List<bool> isShare = [false, false, false, false, false];
  int roleId;

  String locCurrent;
  bool isTopNewSelected = true, isMyNewSelected = false;
  List<String> dummyList = ['', '', '', '', ''];
  List<TopNews> myNews = [
    TopNews(
        title: 'Polygon(Matic) on spotlight',
        imageUrl: 'assets/icons/top_news1.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Best Cryptocurrency Trading Tips in 2021',
        imageUrl: 'assets/icons/top_news2.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
  ];

  var searchController = new TextEditingController();
  FocusNode focusSearch = new FocusNode();
  bool isSearchSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsDetails();
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
                      EdgeInsets.only(top: 25, right: 20, left: 10, bottom: 0),
                  child: getTopMenuIconRow(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'TOP NEWS',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.2),
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.colWhite,
                                    ),
                                  ),
                                ),
                                /*InkWell(
                                  onTap: () {
                                    setState(() {
                                      // isLike[0] = !isLike[0];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(isLike[0]
                                            ? 'assets/icons/thumb_up_green.png'
                                            : 'assets/icons/thumb_up.png'),
                                      ),
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      // isBookMark[0] = !isBookMark[0];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(GlobalLists
                                                    .getNewsListDetail[0]
                                                    .bookmark ==
                                                true
                                            ? 'assets/icons/bookmark_green.png'
                                            : 'assets/icons/bookmark.png'),
                                      ),
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      // isShare[0] = !isShare[0];
                                      // bottomsheet();
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/share.png'),
                                      ),
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),*/
                              ]),
                        ),
                        Text(
                          GlobalLists.getNewsListDetail[0].name,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.8),
                            fontWeight: FontWeight.w600,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          GlobalLists.getNewsListDetail[0].description,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.splash_version,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          GlobalLists.getNewsListDetail[0].createdAt +
                              ' | Source: abcde.com',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.splash_version,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        /*Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Jerry Hoffman',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.colWhite,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    // isShare[0] = !isShare[0];
                                    // bottomsheet();
                                  });
                                },
                                child: Text(
                                  // 'Follow',
                                  '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.0),
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.forgot_pwd,
                                  ),
                                ),
                              ),
                            ]),*/
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColor.blackgrey,
                              width: 1,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  'assets/icons/top_news_details.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          GlobalLists.getNewsListDetail[0].description,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeight: FontWeight.w400,
                            color: CustomColor.colWhite,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, bottom: 5),
                            child: Text(
                              'RELATED',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        getNewsList(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //to get news list.
  Widget getNewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, i) => Card(
        color: CustomColor.card_back,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 2,
                      left: SizeConfig.blockSizeHorizontal * 3,
                      bottom: SizeConfig.blockSizeVertical * 2,
                      right: SizeConfig.blockSizeVertical * 1),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(
                                GlobalLists.getNewsList[i].thumbnail),
                            fit: BoxFit.cover)),
                    width: 70,
                    height: 70,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        GlobalLists.getNewsList[i].name,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            color: CustomColor.colWhite,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 6,
                      ),
                      Text(
                        GlobalLists.getNewsList[i].createdAt,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.5),
                            color: CustomColor.text_line,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
            // GlobalLists.currentPage = 2;
            Navigator.pop(context);
            // Navigator.pushNamed(context, "/home");
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
        GestureDetector(
          onTap: () {
            // _scaffoldKey.currentState.openDrawer();
          },
          child: Image.asset(
            'assets/icons/splash_coinshot.png',
            width: SizeConfig.blockSizeHorizontal * 35,
            height: SizeConfig.blockSizeHorizontal * 18,
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 27,
        ),
        GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, "/notification");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: NotificationScreen(),
                //duration: Duration(seconds: 1),
              ),
            );
          },
          child: Stack(
            children: <Widget>[
              new Image.asset(
                'assets/icons/notify.png',
                width: SizeConfig.blockSizeHorizontal * 8,
                height: SizeConfig.blockSizeHorizontal * 8,
              ),
              new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '0',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ProfileScreen(),
                //duration: Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: GlobalLists.profileDetails.profilephoto != null
                        ? NetworkImage(APIManager.baseURLComm +
                            GlobalLists.profileDetails.profilephoto)
                        : AssetImage('assets/icons/profile.png'),
                    fit: BoxFit.cover)),
            width: SizeConfig.blockSizeHorizontal * 9,
            height: SizeConfig.blockSizeHorizontal * 9,
          ),
        ),
      ],
    );
  }

  //search icon Row.
  Widget getTopSearchIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSearchSelected = false;
            });
          },
          child: Image.asset(
            'assets/icons/collapsebutton.png',
            color: CustomColor.green_news,
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: searchController,
            focusNode: focusSearch,
            cursorColor: CustomColor.colExpenseHeadingCol,
            style: TextStyle(
              fontFamily: 'Roboto',
              color: CustomColor.colWhite,
              // fontSize: ResponsiveFlutter.of(context)
              //     .fontSize(1.8),
            ),
            decoration: new InputDecoration(
              hintText: "Search",
              hintStyle: new TextStyle(
                color: CustomColor.splash_version,
                // fontSize: ResponsiveFlutter.of(context)
                //     .fontSize(1.8),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.outline,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.outline,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: CustomColor.green_news,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    setState(() {
                      isSearchSelected = false;
                    });
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  getNewsDetails() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/news/api/v1/getNewsbyId';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['newsId'] = widget.newsId;

      GlobalLists.getNewsListDetail.clear();
      http.Response response = await http.post(
        uri,
        body: map,
      );

      GetNewsResp resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        // ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = GetNewsResp.fromJson(json.decode(response.body));
        // ShowDialogs.showToast(resp.message);
        // Navigator.pop(context);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.getNewsListDetail = resp.data;
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
