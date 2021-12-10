import 'dart:convert';
import 'dart:core';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/appscreen/dash_main/search/CryptoSearch.dart';
import 'package:coin_shot/models/AddBookmark.dart';
import 'package:coin_shot/models/GetNewsResp.dart';
import 'package:coin_shot/models/top_news.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
import 'package:coin_shot/widget/globalClasses.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';
import 'main_dash.dart';
import 'news_detail.dart';
import 'notifications.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreen createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen> with TickerProviderStateMixin {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isLike = [true, true, false, false, false];
  List<bool> isBookMark = [true, true, false, false, false];
  List<bool> isShare = [false, false, false, false, false];
  int roleId;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "1 to 30 Days"),
    new Tab(text: "31 to 60 Days"),
    new Tab(text: "90 Days")
  ];
  String locCurrent;
  bool isTopNewSelected = true, isMyNewSelected = false;
  List<String> dummyList = ['', '', '', '', ''];
  List<TopNews> topNews = [
    TopNews(
        title: 'Polygon(Matic) on spotlight',
        imageUrl: 'assets/icons/top_news1.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Best Cryptocurrency Trading Tips in 2021',
        imageUrl: 'assets/icons/top_news2.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Polygon(Matic) on spotlight',
        imageUrl: 'assets/icons/top_news1.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Best Cryptocurrency Trading Tips in 2021',
        imageUrl: 'assets/icons/top_news2.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
    TopNews(
        title: 'Polygon(Matic) on spotlight',
        imageUrl: 'assets/icons/top_news1.png',
        dateTime: 'Sep 09, 2021 | 11.00AM'),
  ];

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
    getData();
  }

  Future<void> getData() async {
    ShowDialogs.showLoadingDialog(context, _keyLoader);
    await getNewsRequest();
    await getMyNewsRequest();
    Navigator.of(_keyLoader.currentContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        GlobalLists.currentPage = 2;
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
        // Navigator.pushReplacement(
        //   context,
        //   PageTransition(
        //     type: PageTransitionType.fade,
        //     child: MainDashboard(),
        //     //duration: Duration(seconds: 1),
        //   ),
        // );
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
                  child: /*isSearchSelected
                      ? getTopSearchIconRow()
                      :*/ getTopMenuIconRow(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 0),
                          child: Text(
                            'NEWS',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              fontWeight: FontWeight.w600,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ),
                        getNewsCard(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget bottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Colors.black,
              child: Container(
                  decoration: new BoxDecoration(
                      color: CustomColor.card_back,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5),
                          topRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: new Center(
                          child: Text(
                            'Share News',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: CustomColor.outline,
                        height: 1,
                      ),
                      Container(
                        height: 20,
                      ),
                      ListTile(
                        title: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/whatsapp.png'),
                                        ),
                                      ),
                                      // width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Whatsapp',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.text_line,
                                      ),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/twitter.png'),
                                        ),
                                      ),
                                      // width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Twitter',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.text_line,
                                      ),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/insta.png'),
                                        ),
                                      ),
                                      // width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Instagram',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.text_line,
                                      ),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/telegram.png'),
                                        ),
                                      ),
                                      // width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Telegram',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.text_line,
                                      ),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/links.png'),
                                        ),
                                      ),
                                      // width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Copy Link',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5),
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.text_line,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        height: 20,
                      ),
                    ],
                  )));
        });
  }

  //Get Survey List Card to have my & new claims.
  Widget getNewsCard() {
    return Card(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: SizeConfig.blockSizeVertical * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                    topRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 3)),
                color: CustomColor.card_back,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isTopNewSelected = true;
                                isMyNewSelected = false;
                              });
                            },
                            child: Text(
                              'Top News',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColor.colWhite,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isTopNewSelected = false;
                                isMyNewSelected = true;
                              });
                            },
                            child: Text(
                              'My News',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColor.colWhite,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(1.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: isTopNewSelected
                              ? CustomColor.green_news
                              : CustomColor.card_back,
                        ),
                        // width: 98,
                        height: 3,
                      )),
                      Expanded(
                          child: Container(
                        // width: 105,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isMyNewSelected
                              ? CustomColor.green_news
                              : CustomColor.card_back,
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
            ),
            Expanded(
                child: isTopNewSelected
                    ? GlobalLists.getNewsList.length == 0
                        ? Container(
                            child: Center(
                              child: Text("No Records",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColor.text_line,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          )
                        : getNewsList(GlobalLists.getNewsList)
                    : GlobalLists.getBookmarkList.length == 0
                        ? Container(
                            child: Center(
                              child: Text("No Records",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColor.text_line,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          )
                        : getNewsList(GlobalLists.getBookmarkList)
                // : newClaims())
                )
          ],
        ),
      ),
    );
  }

  //to get news list.
  Widget getNewsList(List<Datum> topNews) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: topNews.length,
      itemBuilder: (context, i) => InkWell(
        onTap: () {
          // Navigator.pop(context);
          // Navigator.pushNamed(context, "/newsDetails");
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: NewsDetailsScreen(
                newsId: GlobalLists.getNewsList[i].id.toString(),
              ),
              //duration: Duration(seconds: 1),
            ),
          );
        },
        child: Card(
          color: CustomColor.card_back,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        right: SizeConfig.blockSizeVertical * 2),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          topNews[i].name,
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
                          height: SizeConfig.safeBlockVertical * 4,
                        ),
                        Text(
                          topNews[i].createdAt,
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
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      // isBookMark[i] = !isBookMark[i];
                                      isMyNewSelected
                                          ? removeBookmarkRequest(topNews[i].id)
                                          : GlobalLists.getNewsList[i]
                                                      .bookmark ==
                                                  true
                                              ? removeBookmarkRequest(
                                                  topNews[i].id)
                                              : addBookmarkRequest(
                                                  topNews[i].id);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(isMyNewSelected
                                            ? 'assets/icons/bookmark_green.png'
                                            : GlobalLists.getNewsList[i]
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
                                Builder(
                                  builder: (BuildContext context) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          print('clicked share');
                                          // bottomsheet();
                                          _onShareData(
                                              context,
                                              topNews[i].thumbnail,
                                              topNews[i].name,
                                              topNews[i].description);
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
                                    );
                                  },
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 5,
                        ),
                        /*Container(
                        child: Text(
                          'Follow',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              color: CustomColor.forgot_pwd,
                              fontWeight: FontWeight.w400),
                        ),
                      ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
            GlobalLists.currentPage = 2;
            Navigator.pop(context);
            Navigator.pushNamed(context, "/home");
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
          width: SizeConfig.blockSizeHorizontal * 15,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              // isSearchSelected = !isSearchSelected;
              showSearch(
                  context: context,
                  delegate: CryptoSearch(GlobalLists.searchCryptoDataList));
            });
          },
          child: Image.asset(
            'assets/icons/search.png',
            width: SizeConfig.blockSizeHorizontal * 8,
            height: SizeConfig.blockSizeHorizontal * 8,
          ),
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

  //TODO:GET NEWS LIST API GO HERE:
  getNewsRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/news/api/v1/getNews';

      GlobalLists.getNewsList.clear();
      http.Response response = await http.get(
        uri,
        // headers: map,
      );

      print("myyy list length is   ${response.body}");
      GetNewsResp resp = GetNewsResp.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getNewsList = resp.data;
          print("news list length is   ${GlobalLists.getNewsList.length}");
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getNewsList = [];
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET NEWS LIST API GO HERE:
  getMyNewsRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/bookmark/api/v1/getBookmarkNews';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;

      print("myyy list length is   ${map}");
      GlobalLists.getBookmarkList.clear();
      http.Response response = await http.post(
        uri,
        body: map,
      );

      GetNewsResp resp = GetNewsResp.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        setState(() {
          GlobalLists.getBookmarkList = resp.data;
          print(
              "getBookmarkList list length is   ${GlobalLists.getBookmarkList.length}");
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      } else if (resp.n == 0) {
        setState(() {
          GlobalLists.getBookmarkList = [];
        });
        // ShowDialogs.showToast(resp.message);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  addBookmarkRequest(var newsId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/bookmark/api/v1/addBookmark';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['newsId'] = newsId.toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      AddBookmark resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = AddBookmark.fromJson(json.decode(response.body));
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 3;
          Navigator.pushNamed(context, "/home");
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET REMOVE BOOKMARK API GO HERE:
  removeBookmarkRequest(var newsId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/bookmark/api/v1/removeBookmark';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['newsId'] = newsId.toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      AddBookmark resp = AddBookmark.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 3;
          Navigator.pushNamed(context, "/home");
        });
      } else if (resp.n == 0) {
        ShowDialogs.showToast(resp.status);
        Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  _onShareData(
      BuildContext mcontext, var imageLink, var subject, var desc) async {
    final RenderBox box = context.findRenderObject();
    {
      await Share.share('${subject}\n\n ${desc}\n ${imageLink}',
          subject: "Share",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

}
