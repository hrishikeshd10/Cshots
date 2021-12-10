import 'package:coin_shot/Utility/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import 'custom_colors.dart';
import 'sizeconfig.dart';

class CircleButton extends StatelessWidget {
  final String getTitle;

  //requiring the list of todos
  CircleButton({
    @required this.getTitle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 5,
      child: Container(
        decoration: BoxDecoration(
          color: getTitle == 'Sell Now'
              ? CustomColor.red_text
              : getTitle == 'Buy Now'
                  ? CustomColor.green_news
                  : CustomColor.signin_clr,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            getTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: getTitle == 'Buy Now' || getTitle == 'Sell Now'
                  ? ResponsiveFlutter.of(context).fontSize(1.5)
                  : ResponsiveFlutter.of(context).fontSize(2.0),
              fontWeight: FontWeight.w400,
              color: CustomColor.colWhite,
            ),
          ),
        ),
      ),
    );
  }
}
