library fancy_bottom_navigation;
import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:fancy_bottom_navigation/paint/half_clipper.dart';
import 'package:fancy_bottom_navigation/paint/half_painter.dart';
import 'package:flutter/material.dart';

import 'custom_colors.dart';

const double CIRCLE_SIZE = 90;
const double ARC_HEIGHT = 60;
const double ARC_WIDTH = 120;
const double CIRCLE_OUTLINE = 1;
const double SHADOW_ALLOWANCE = 10;
const double BAR_HEIGHT = 60;

class FancyBottomNavigationNew extends StatefulWidget {
  FancyBottomNavigationNew(
      { this.tabs,
         this.onTabChangedListener,
        this.key,
        this.initialSelection = 0,
        this.circleColor,
        this.activeIconColor,
        this.inactiveIconColor,
        this.textColor,
        this.barBackgroundColor})
      : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 6);

  final Function(int position) onTabChangedListener;
  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color barBackgroundColor;
  final List<TabDataNew> tabs;
  final int initialSelection;

  final Key key;

  @override
  FancyBottomNavigationStateN createState() => FancyBottomNavigationStateN();
}

class FancyBottomNavigationStateN extends State<FancyBottomNavigationNew>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;

    circleColor = widget.circleColor ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor);

    activeIconColor = widget.activeIconColor ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white);

    barBackgroundColor = widget.barBackgroundColor ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white);
    textColor = widget.textColor ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54);
    inactiveIconColor = (widget.inactiveIconColor) ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor);
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: BAR_HEIGHT,
          decoration: BoxDecoration(color: barBackgroundColor,
              // border: Border.all(width: 1.0, color: CustomColor.splash_version),
              border: Border(
                top: BorderSide(
                  color: CustomColor.outline,
                  width: 0.9,
                ),
              ),
              boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 1)
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.tabs
                .map((t) => TabItem(
                uniqueKey: t.key,
                selected: t.key == widget.tabs[currentSelected].key,
                iconData: t.iconData,
                title: t.title,
                iconColor: inactiveIconColor,
                textColor: textColor,
                callbackFunction: (uniqueKey) {
                  int selected = widget.tabs
                      .indexWhere((tabData) => tabData.key == uniqueKey);
                  widget.onTabChangedListener(selected);
                  _setSelected(uniqueKey);
                  _initAnimationAndStart(_circleAlignX, 1);
                }))
                .toList(),
          ),
        ),
        Positioned.fill(
          top: -(CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE) / 3.0,
          child: Container(
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              curve: Curves.easeOut,
              alignment: Alignment(_circleAlignX, 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: FractionallySizedBox(
                  widthFactor: 1 / widget.tabs.length,
                  child: GestureDetector(
                    onTap: widget.tabs[currentSelected].onclick as void
                    Function(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                          width:
                          CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                          child: ClipRect(
                              clipper: HalfClipper(),
                              child: Container(
                                child: Center(
                                  child: Container(
                                      width: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                      height: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: CustomColor.splash_version,
                                                blurRadius: 1.0)
                                          ])),
                                ),
                              )),
                        ),
                        // SizedBox(
                        //     height: ARC_HEIGHT,
                        //     width: ARC_WIDTH,
                        //     child: CustomPaint(
                        //       painter: HalfPainter(barBackgroundColor),
                        //     )),
                        SizedBox(
                          height: CIRCLE_SIZE,
                          width: CIRCLE_SIZE,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: circleColor),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: AnimatedOpacity(
                                duration:
                                Duration(milliseconds: ANIM_DURATION ~/ 5),
                                opacity: _circleIconAlpha,
                                child: Icon(
                                  activeIcon,
                                  color: activeIconColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(Duration(milliseconds: ANIM_DURATION ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(Duration(milliseconds: (ANIM_DURATION ~/ 5 * 3)), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabDataNew {
  TabDataNew({ this.iconData,  this.title, this.onclick});

  IconData iconData;
  String title;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
