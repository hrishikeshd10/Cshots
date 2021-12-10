import 'dart:convert';
import 'dart:core';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/profile.dart';
import 'package:coin_shot/models/AddDataToWatchlist.dart';
import 'package:coin_shot/models/GetCryptoList.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_colors.dart';
import '../../widget/sizeconfig.dart';
import 'main_dash.dart';
import 'notifications.dart';
import 'package:coin_shot/models/GetCryptoList.dart' as crypto;

class AddWatchScreen extends StatefulWidget {
  final String watchListId;

  const AddWatchScreen({Key key, this.watchListId}) : super(key: key);

  @override
  _AddWatchScreen createState() => _AddWatchScreen();
}

class _AddWatchScreen extends State<AddWatchScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int noOfRecords = 0, splitValue = 0, pageCount = 0;
  var controller = TextEditingController();
  List<CryptoModel> topNews = [
    CryptoModel(
        imageUrl: 'assets/icons/Bitcoin.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Bitcoin',
        msg: 'BTC',
        mainAmount: '₹35,00,00,000.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/LayerTwo.png',
        subImg: 'assets/icons/graphred.png',
        title: 'Binance Coin',
        msg: 'BNB',
        mainAmount: '₹35,04,404.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCryptoDataRequest();
    // getData();
  }

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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(
                              'Add To Watchlist',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.8),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 1),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                    ],
                                    controller: controller,
                                    onChanged: onSearchTextChanged,
                                    cursorColor:
                                        CustomColor.colExpenseHeadingCol,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: CustomColor.colWhite,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.0),
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
                          getWatchListCard(),
                          // getWatchListData(),
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

  //Set data that user searches for.
  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        controller.clear();
        GlobalLists.getCryptoDataListSearch.clear();
      });
      return;
    }
    setState(() {
      GlobalLists.getCryptoDataListSearch.clear();
      GlobalLists.getCryptoDataList.forEach((dataDetail) {
        if (dataDetail.symbol.toString().toLowerCase().contains(text))
          GlobalLists.getCryptoDataListSearch.add(dataDetail);
      });
    });
  }

  //Get Survey List Card to have my & new claims.
  Widget getWatchListCard() {
    return Card(
      color: Colors.transparent,
      child: Container(
        // margin: const EdgeInsets.only(top: 20),
        height: SizeConfig.blockSizeVertical * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: 15),
            Expanded(
                child: LazyLoadScrollView(
                    onEndOfPage: () => getCryptoDataRequest(),
                    scrollOffset: noOfRecords,
                    isLoading: noOfRecords == splitValue ? true : false,
                    child: getExpneseList()) /*getWatchListData()*/),
            Container(height: 15),
          ],
        ),
      ),
    );
  }

  //this Widget to show expense list.
  Widget getExpneseList() {
    return GlobalLists.getCryptoDataListRefresh.length == 0
        ? Container(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'No records',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: ResponsiveFlutter.of(context).fontSize(3),
                  fontWeight: FontWeight.bold,
                  color: CustomColor.colWhite,
                ),
              ),
            ),
          )
        : GlobalLists.getCryptoDataListSearch.length == 0 ||
                controller.text.isEmpty
            ? getWatchListData(GlobalLists.getCryptoDataListRefresh)
            : getWatchListData(GlobalLists.getCryptoDataListSearch);
  }

  //Menu icon Row.
  Widget getWatchListData(List<crypto.Datum> getList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: getList.length,
        itemBuilder: (context, i) => InkWell(
              onTap: () {
                GlobalLists.passSelectedSymbol = getList[i].symbol;
                addDataToWatchlist(getList[i].symbol);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 10),
                decoration: new BoxDecoration(
                  color: CustomColor.card_back,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 1, bottom: 5, top: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                /*Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(topNews[0].imageUrl),
                                    ),
                                  ),
                                  width: 25,
                                  height: 25,
                                ),*/
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.network(
                                    getList[i].thumbnail,
                                    placeholderBuilder: (context) => Icon(Icons.error),
                                    height: 25,
                                    width: 25,
                                    // color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobalLists.getValues
                                                      .where((list) => getList[
                                                              i]
                                                          .symbol
                                                          .substring(
                                                              0,
                                                              getList[i]
                                                                  .symbol
                                                                  .indexOf(
                                                                      'INR'))
                                                          .contains(list.value))
                                                      .toList()
                                                      .length ==
                                                  0
                                              ? 'NA'
                                              : GlobalLists.getValues
                                                  .where((list) => getList[i]
                                                      .symbol
                                                      .substring(
                                                          0,
                                                          getList[i]
                                                              .symbol
                                                              .indexOf('INR'))
                                                      .contains(list.value))
                                                  .toList()[0]
                                                  .name,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2.0),
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.colWhite,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          getList[i].symbol.substring(0,
                                              getList[i].symbol.indexOf('INR')),
                                          // getList[i].symbol,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.5),
                                            fontWeight: FontWeight.w600,
                                            color: CustomColor.text_line,
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 15,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, "/notification");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: NotificationScreen(),
                // //duration: Duration(seconds: 1),
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

  //TODO:GET NEWS LIST API GO HERE:
  getCryptoDataRequest() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);

      final uri = APIManager.baseURLComm +
          '/pocketbits/api/v1/getaveragetickerdataforsymbol';

      var map = new Map<String, dynamic>();
      map['offset'] = pageCount.toString();

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print("aaj tak map is   ${map}");
      print("aaj tak response is   ${response.body}");
      GetCryptoList resp = GetCryptoList.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          int value = int.parse(GlobalLists.noOfLine.toString().split(".")[0]);
          GlobalLists.getCryptoDataListRefresh = resp.data;
          print(
              "aaj tak list length is   ${GlobalLists.getCryptoDataListRefresh.length}");

          splitValue = (value * 5) + 5;
          noOfRecords = noOfRecords + 5;
          if ((value) == pageCount) {
            pageCount = pageCount;
          } else {
            pageCount = pageCount + 1;
          }
        });
      } else if (resp.n == 0) {
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.getNewsList = [];
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:GET ADD BOOKMARK API GO HERE:
  addDataToWatchlist(var currencyId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/addWatchlistData';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['currencyId'] = currencyId;
      map['watchlistId'] = widget.watchListId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      AddDataToWatchlist resp;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['n'] == 0) {
        ShowDialogs.showToast(jsonResponse['message']);
        Navigator.of(_keyLoader.currentContext).pop();
      } else {
        resp = AddDataToWatchlist.fromJson(json.decode(response.body));
        ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.currentPage = 4;
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/home");
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }
}
