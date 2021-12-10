import 'package:coin_shot/Utility/APIManager.dart';
import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:coin_shot/Utility/SPManager.dart';
import 'package:coin_shot/appscreen/dash_main/main_dash.dart';
import 'package:coin_shot/widget/custom_colors.dart';
import 'package:coin_shot/widget/formLabel.dart';
import 'package:coin_shot/widget/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../main_entry/login.dart';
import 'showDialog.dart';

Map<String, bool> expansionState = Map();

class AppDrawer extends StatefulWidget {
  final String userName;
  final int roleId;

  const AppDrawer({Key key, this.userName, this.roleId}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var expansionList = [];
  int selectedIndex;

  void closeOpenExpansionList(expansionName) {
    expansionList.forEach((name) {
      if (name != expansionName) expansionState[name] = false;
    });
    setState(() {
      if (!expansionState[expansionName]) expansionState[expansionName] = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() async {
    expansionList.forEach((name) {
      expansionState.putIfAbsent(name, () => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var text_style = TextStyle(
        fontFamily: "Roboto",
        fontSize: ResponsiveFlutter.of(context).fontSize(2),
        fontWeight: FontWeight.w300,
        color: CustomColor.colBlue);
    var version_textStyle = TextStyle(
        fontFamily: "Roboto",
        fontSize: ResponsiveFlutter.of(context).fontSize(2),
        fontWeight: FontWeight.w300,
        color: CustomColor.colBlue);
    return Drawer(
      //  ScaffoldState().openDrawer() ,
      child: Container(
        color: CustomColor.colWhite,
        //  color: Colors.white60,
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(left: 5),
              children: [
                Container(
                  height: 180,
                  //color: CustomColor.colgrey,
                  padding: EdgeInsets.only(left: 20, bottom: 30),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              FormLabel(
                                text: GlobalLists.userName == null
                                    ? "Hi, Loading..."
                                    : "Hi, ${GlobalLists.userName}",
                                labelColor: CustomColor.colBlue,
                                fontweight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(
                                "assets/icons/arrowDown.png",
                                height: 15,
                                width: 15,
                              )
                            ],
                          ),
                          GlobalLists.roleId == 4
                              ? FormLabel(
                                  text: "C. Handler",
                                  labelColor: CustomColor.colBlue,
                                  fontSize: 14,
                                )
                              : GlobalLists.roleId == 3
                                  ? FormLabel(
                                      text: "P. Handler",
                                      labelColor: CustomColor.colBlue,
                                      fontSize: 14,
                                    )
                                  : GlobalLists.roleId == 5
                                      ? FormLabel(
                                          text: "Field Surveyor",
                                          labelColor: CustomColor.colBlue,
                                          fontSize: 14,
                                        )
                                      : FormLabel(
                                          text: "Loading...",
                                          labelColor: CustomColor.colBlue,
                                          fontSize: 14,
                                        ),
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image.network(
                                APIManager.baseURLComm+GlobalLists.profileDetails.profilephoto,
                                height: 55,
                                width: 55,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 35),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                      "assets/icons/edit.png",
                                      height: 25,
                                      width: 25,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  // color: selectedIndex == 0
                  //     ? Color(0xffE3EAFF)
                  //     : Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/dashboard.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      "Dashboard",
                      style: text_style,
                    ),
                    onTap: () {
                      // Navigator.pushNamed(context, "/home");
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: MainDashboard(),
                          //duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/totalSurvey.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text(
                    "Total Surveys",
                    style: text_style,
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, "/listofSurvey");
                    Navigator.pushNamed(context, "/surveyList");
                    selectedIndex = 2;
                  },
                ),
                GlobalLists.roleId == 3 || GlobalLists.roleId == 4
                    ? ListTile(
                        leading: Image.asset(
                          'assets/icons/report.png',
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "CAT's surveys",
                          style: text_style,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/catastropic");
                          selectedIndex = 5;
                        },
                      )
                    : Container(),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/Test Icon.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text(
                    "Today's Surveys",
                    style: text_style,
                  ),
                  onTap: () {
                    selectedIndex = 3;
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             TodaysSurveyList()));
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/expenses.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text(
                    "Expenses",
                    style: text_style,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/listexpenses");
                    selectedIndex = 3;
                  },
                ),
                GlobalLists.roleId == 4 || GlobalLists.roleId == 3
                    ? ListTile(
                        leading: Image.asset(
                          'assets/icons/requests_survey_unselected.png',
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "Requests",
                          style: text_style,
                        ),
                        onTap: () {
                          selectedIndex = 4;
                        },
                      )
                    : Container(),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/gallery.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text(
                    "Gallery",
                    style: text_style,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/gallery");
                  },
                ),
                GlobalLists.roleId == 4 || GlobalLists.roleId == 3
                    ? ListTile(
                        leading: Image.asset(
                          'assets/icons/report.png',
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "Reports",
                          style: text_style,
                        ),
                        onTap: () {},
                      )
                    : Container(),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         color: CustomColor.colgrey,
            //         padding: EdgeInsets.only(bottom: 10),
            //         height: 60,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Image.asset(
            //               'assets/icons/logout.png',
            //               width: 25,
            //               height: 25,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 logoutDialog();
            //               },
            //               child: Text(
            //                 "LOGOUT",
            //                 style: TextStyle(
            //                     color: CustomColor.colBlue,
            //                     fontFamily: "Roboto",
            //                     fontWeight: FontWeight.w600),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       FormLabel(
            //         text: 'Version: ' + '1.1.0',
            //         labelColor: CustomColor.blackgrey,
            //         fontfamily: 'Roboto',
            //         fontweight: FontWeight.w400,
            //         fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
            //       ),
            //     ],
            //   ),
            // ),
            InkWell(
                onTap: () {
                  logoutDialog();
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: CustomColor.colgrey,
                    padding: EdgeInsets.only(bottom: 15),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/logout.png',
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "LOGOUT",
                          style: TextStyle(
                              color: CustomColor.colBlue,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: double.infinity,
                color: CustomColor.colWhite,
                child: FormLabel(
                  text: '       Version: ' + '1.1.4',
                  labelColor: CustomColor.blackgrey,
                  fontfamily: 'Roboto',
                  fontweight: FontWeight.w400,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "assets/icons/collapsebutton.png",
                      height: 30,
                      width: 30,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutDialog() {
    ShowDialogs.showExitDialog(
        2, context, "Logout App", "Are you sure you want to Logout?", () {
      setState(() {
        // SPManager().clear();
        SPManager().setEmpId(null);
        SPManager().setUserId(null);
        SPManager().setNotificationToken(null);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        // Navigator.of(context).popUntil(ModalRoute.withName('/login'));
      });
    });
  }
}
