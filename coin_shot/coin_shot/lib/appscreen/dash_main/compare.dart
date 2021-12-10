import 'dart:convert';
import 'dart:core';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/Utility/checkInternetconnection.dart';
import 'package:coin_shot/appscreen/dash_main/search/CryptoSearch.dart';
import 'package:coin_shot/appscreen/dash_main/search_crypto.dart';
import 'package:coin_shot/models/AddDataToWatchlist.dart';
import 'package:coin_shot/models/GetCryptoList.dart';
import 'package:coin_shot/models/GetMainWatchlist.dart';
import 'package:coin_shot/models/crypto_data.dart';
import 'package:coin_shot/models/developer_series.dart';
import 'package:coin_shot/models/sales_data.dart';
import 'package:coin_shot/widget/FancyBottomNavigationNew.dart';
import 'package:coin_shot/widget/circular_blank_btn.dart';
import 'package:coin_shot/widget/circular_btn.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../widget/custom_colors.dart';
import '../../widget/drawerLayout.dart';
import '../../widget/formLabel.dart';
import '../../widget/sizeconfig.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:coin_shot/models/GetCryptoList.dart' as crypto;
import 'main_dash.dart';

class CompareScreen extends StatefulWidget {
  final crypto.Datum lastCryptoViewed;

  const CompareScreen({Key key, this.lastCryptoViewed}) : super(key: key);

  @override
  _CompareScreen createState() => _CompareScreen();
}

class _CompareScreen extends State<CompareScreen>
    with TickerProviderStateMixin {
  int selectedTab = 3;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List mainClaimselementList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isreasonexpanded = false, isBuySelected = true, isSellSelected = false;
  bool isCHListexpanded = false;
  int roleId;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "1 to 30 Days"),
    new Tab(text: "31 to 60 Days"),
    new Tab(text: "90 Days")
  ];
  String locCurrent;
  bool isSelected = false;
  List<CryptoModel> exchangesList = [
    CryptoModel(
        imageUrl: 'assets/icons/pocketBits.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'Bitcoin',
        msg: 'BTC',
        mainAmount: '₹35.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/waz.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'WAZIRX',
        msg: 'USDT',
        mainAmount: '₹79.63',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/zeb.png',
        subImg: 'assets/icons/graphred.png',
        title: 'ZEBPAY',
        msg: 'Sol',
        mainAmount: '₹35.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/maskgroup.png',
        subImg: 'assets/icons/graphgreen.png',
        title: 'COINDCX',
        msg: 'USDC',
        mainAmount: '₹79.63',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
    CryptoModel(
        imageUrl: 'assets/icons/bit.png',
        subImg: 'assets/icons/graphred.png',
        title: 'BITBNS',
        msg: 'BNB',
        mainAmount: '₹35.44',
        basicAmount: '₹15,5233.78',
        mainPer: '0.69%',
        basicPer: '7.33%'),
  ];

  final List<DeveloperSeries> data = [
    DeveloperSeries(
      year: 2016,
      developers: 2000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2018,
      developers: 15000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2019,
      developers: 10000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2020,
      developers: 20000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2021,
      developers: 28000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2022,
      developers: 25000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2023,
      developers: 32000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2024,
      developers: 30000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2025,
      developers: 35000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2026,
      developers: 45000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: 2027,
      developers: 45000,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];
  List<charts.Series<DeveloperSeries, num>> series;

  List<SalesData> chartData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    series = [
      charts.Series(
          id: "developers",
          data: data,
          domainFn: (DeveloperSeries series, _) => series.year,
          measureFn: (DeveloperSeries series, _) => series.developers,
          colorFn: (DeveloperSeries series, _) => series.barColor)
    ];
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
        GlobalLists.currentPage = 2;
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            // top: false,
            child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 10),
              child: getTopMenuIconRow(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 5,
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      padding: EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 10),
                      decoration: new BoxDecoration(
                        color: CustomColor.card_back,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Avg Price',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.0),
                                fontWeight: FontWeight.w400,
                                color: CustomColor.text_line,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '₹35,04,404.44',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.5),
                                fontWeight: FontWeight.w600,
                                color: CustomColor.colWhite,
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: 10,
                    ),
                    compareWidget(),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: SizeConfig.blockSizeHorizontal * 70,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      padding: EdgeInsets.only(
                          top: 10, right: 2, left: 1, bottom: 10),
                      decoration: new BoxDecoration(
                        color: CustomColor.card_back,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SfCartesianChart(
                          // title: ChartTitle(text: 'Test'),
                          legend: Legend(isVisible: false),
                          // tooltipBehavior: true,
                          backgroundColor: Colors.transparent,
                          primaryXAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}L',
                              numberFormat: NumberFormat.simpleCurrency(
                                  decimalDigits: 2)),
                          series: <SplineSeries>[
                            SplineSeries<SalesData, double>(
                                // name: 'sales',
                                enableTooltip: true,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: false),
                                color: CustomColor.green_news,
                                //line color
                                width: 1.5,
                                //line width
                                opacity: 1.0,
                                //line opacity
                                dashArray: <double>[0, 0],
                                //dash line
                                splineType: SplineType.cardinal,
                                dataSource: <SalesData>[
                                  SalesData(15, 5),
                                  SalesData(16, 18),
                                  SalesData(16.5, 12),
                                  SalesData(17, 22),
                                  SalesData(18, 8),
                                  SalesData(19, 18),
                                  SalesData(20, 15),
                                  SalesData(21, 30),
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales)
                          ]),
                    ),
                    // Container(
                    //   height: 20,
                    // ),
                    // bottomButtonWidget(),
                    Container(
                      height: 20,
                    ),
                    bottomWidget(),
                    Container(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'EXCHANGES',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              fontWeight: FontWeight.w600,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 1, bottom: 1, right: 5),
                          child: Text(
                            'Buy',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              fontWeight: FontWeight.w400,
                              color: isBuySelected == true
                                  ? CustomColor.green_news
                                  : CustomColor.text_line,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 2, right: 2, left: 2, bottom: 2),
                          decoration: new BoxDecoration(
                            color:
                                isBuySelected == true && isSellSelected == false
                                    ? CustomColor.green_news
                                    : CustomColor.red_text,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSellSelected = !isSellSelected;
                                    isBuySelected = !isBuySelected;
                                    print(
                                        'buy color is $isBuySelected & sell color is $isSellSelected }');
                                  });
                                },
                                child: Align(
                                  alignment: Alignment(-1, 0),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                      color: isSellSelected == true &&
                                              isBuySelected == false
                                          ? CustomColor.red_text
                                          : CustomColor.colWhite,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSellSelected = !isSellSelected;
                                    isBuySelected = !isBuySelected;
                                    print(
                                        'buy color is $isBuySelected & sell color is $isSellSelected }');
                                  });
                                },
                                child: Align(
                                  alignment: Alignment(1, 0),
                                  child: Container(
                                    // width: 50,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                        color: isBuySelected == true &&
                                                isSellSelected == false
                                            ? CustomColor.green_news
                                            : CustomColor.colWhite,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 1, bottom: 1, left: 5),
                          child: Text(
                            'Sell',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              fontWeight: FontWeight.w400,
                              color: isSellSelected == true
                                  ? CustomColor.red_text
                                  : CustomColor.text_line,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: CustomColor.outline,
                      height: 1.5,
                    ),
                    Container(
                      height: 20,
                    ),
                    getWatchListData(),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  //Get Survey List Card to have my & new claims.
  Widget getWatchListCard() {
    return Container(
      // margin: const EdgeInsets.only(bottom: 10),
      // height: SizeConfig.blockSizeVertical * 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(height: 10),
          Expanded(child: getWatchListData())
        ],
      ),
    );
  }

  //Menu icon Row.
  Widget getWatchListData() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: exchangesList.length,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 1, top: 10),
        decoration: new BoxDecoration(
          color: CustomColor.card_back,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              // padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
              padding: const EdgeInsets.only(left: 1, bottom: 10, top: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(exchangesList[i].imageUrl),
                            ),
                          ),
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          exchangesList[i].title,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.0),
                            fontWeight: FontWeight.w600,
                            color: CustomColor.colWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            exchangesList[i].basicAmount,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w400,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              color: CustomColor.outline,
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 1, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buy + Fees (0.00%):',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.5),
                              fontWeight: FontWeight.w600,
                              color: CustomColor.text_line,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '₹33,83,078.33',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.0),
                              fontWeight: FontWeight.w600,
                              color: CustomColor.colWhite,
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    width: 60,
                    height: 25,
                    child: isBuySelected == true
                        ? CircleButton(getTitle: 'Buy Now')
                        : CircleButton(getTitle: 'Sell Now'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget compareWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Change (24 hrs)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                      fontWeight: FontWeight.w400,
                      color: CustomColor.text_line,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 1),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/PathRev.png'),
                          ),
                        ),
                        width: 20,
                        height: 18,
                      ),
                      Text(
                        '0.69%',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                          fontWeight: FontWeight.w400,
                          color: CustomColor.green_news,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Volume (24 hrs)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                      fontWeight: FontWeight.w400,
                      color: CustomColor.text_line,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₹15,5233.78',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                      fontWeight: FontWeight.w600,
                      color: CustomColor.colWhite,
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Widget bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Text(
                      'Best Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                        fontWeight: FontWeight.w500,
                        color: CustomColor.green_news,
                      ),
                    ),
                  ),
                  Container(
                    color: CustomColor.outline,
                    height: 1.5,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Text(
                      '₹33,30,259.30',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                        fontWeight: FontWeight.w600,
                        color: CustomColor.colWhite,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/best_buy.png'),
                      ),
                    ),
                    width: 60,
                    height: 30,
                  ),
                  SizedBox(height: 10),
                ]),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            decoration: new BoxDecoration(
              color: CustomColor.card_back,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Text(
                      'Best Sell',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                        fontWeight: FontWeight.w500,
                        color: CustomColor.red_text,
                      ),
                    ),
                  ),
                  Container(
                    color: CustomColor.outline,
                    height: 1.5,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 20, left: 10, bottom: 10),
                    child: Text(
                      '₹33,87,499.38',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                        fontWeight: FontWeight.w600,
                        color: CustomColor.colWhite,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/zebpay.png'),
                      ),
                    ),
                    width: 80,
                    height: 30,
                  ),
                  SizedBox(height: 10),
                ]),
          ),
        ),
      ],
    );
  }

  Widget bottomsheet(int value) {
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
                            value == 1
                                ? "Add to Watchlist"
                                : 'Select Watchlist',
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
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: GlobalLists.getMainWatchList.length,
                          itemBuilder: (context, i) => InkWell(
                              onTap: () {
                                setState(() {
                                  // GlobalLists.selectWatchlist=GlobalLists.getMainWatchList[i].name;
                                  // GlobalLists.watchlistId=GlobalLists.getMainWatchList[i].id.toString();
                                  addDataToWatchlist(GlobalLists.getMainWatchList[i].id.toString());
                                });

                                Navigator.pop(context);
                              },
                              child: new Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          GlobalLists.getMainWatchList[i].name,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                            ResponsiveFlutter.of(context)
                                                .fontSize(2.0),
                                            fontWeight: FontWeight.w400,
                                            color: CustomColor.colWhite,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    color: CustomColor.outline,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ))),
                      Container(
                        height: 20,
                      ),
                    ],
                  )));
        });
  }

  Widget bottomButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: SizeConfig.blockSizeVertical * 4.5,
            child: CircleButton(getTitle: 'Buy'),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: SizeConfig.blockSizeVertical * 4.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                border:
                    Border.all(width: 1.0, color: CustomColor.splash_version),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Sell',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                    fontWeight: FontWeight.w400,
                    color: CustomColor.splash_version,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Menu icon Row.
  Widget getTopMenuIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Row(
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
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/Bitcoin.png'),
                ),
              ),
              width: 30,
              height: 30,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Bitcoin',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                  fontWeight: FontWeight.w600,
                  color: CustomColor.colWhite,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'BTC',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                  fontWeight: FontWeight.w600,
                  color: CustomColor.text_line,
                ),
              ),
            ]),
          ],
        )),
        GestureDetector(
          onTap: () {
            // print('print');
            // Navigator.pushNamed(context, "/searchCrypto");
            showSearch(
                context: context,
                delegate: CryptoSearch(GlobalLists.searchCryptoDataList));
          },
          child: Image.asset(
            'assets/icons/search.png',
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              bottomsheet(1);
            });
          },
          child: Image.asset(
            'assets/icons/grade_black.png',
            color: isSelected == true ? Colors.yellow : CustomColor.text_line,
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeHorizontal * 7,
          ),
        ),
      ],
    );
  }

  //TODO:GET WATCHLIST API GO HERE:
  getMainWatchlist() async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      // ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/getWatchlist';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;

      http.Response response = await http.post(
        uri,
        body: map,
      );

      print(response.body);
      GetMainWatchlist resp =
      GetMainWatchlist.fromJson(json.decode(response.body));

      if (resp.n == 1) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.pop(context);
        // Navigator.of(_keyLoader.currentContext).pop();
        setState(() {
          GlobalLists.getMainWatchList = resp.data;
        });
      } else if (resp.n == 0) {
        // ShowDialogs.showToast(resp.status);
        // Navigator.of(_keyLoader.currentContext).pop();
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

  //TODO:ADD WATCHLIST API GO HERE:
  addDataToWatchlist(var watchListId) async {
    var status = await ConnectionDetector.checkInternetConnection();
    if (status) {
      ShowDialogs.showLoadingDialog(context, _keyLoader);
      final uri = APIManager.baseURLComm + '/watchlist/api/v1/addWatchlistData';
      var userId = await SPManager().getUserId();
      var map = new Map<String, dynamic>();
      map['customerId'] = userId;
      map['currencyId'] = GlobalLists.getLastCryptoViewed.symbol;
      map['watchlistId'] = watchListId;

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
          isSelected = true;
        });
      }
    } else {
      ShowDialogs.showToast("Please check internet connection");
    }
  }

}
