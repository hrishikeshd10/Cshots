import 'package:coin_shot/widget/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import 'custom_colors.dart';

class CircleBlankButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          border: Border.all(width: 1.0, color: CustomColor.splash_version),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Sign in via OTP',
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
    );
  }
}
