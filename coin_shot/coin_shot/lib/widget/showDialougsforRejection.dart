import 'package:coin_shot/widget/custom_colors.dart';
import 'package:flutter/material.dart';

class ShowDialouge {
  void showPopup(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          //  title: new Text(dialogTitle),

          content: Builder(builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "Add Reason for Rejecting",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter Reason',
                    style: TextStyle(
                      color: CustomColor.colExpenseHeadingCol,
                      fontFamily: 'Roboto',
                      fontSize: 13,
                    ),
                  ),
                  TextFormField(
                    cursorColor: CustomColor.colExpenseHeadingCol,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                    ),
                    decoration: new InputDecoration(
                      hintText: "Select",
                      hintStyle: new TextStyle(
                        color: CustomColor.colLastUpdatedDate,
                        fontSize: 13,
                      ),
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.colExpenseHeadingCol,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColor.colExpenseHeadingCol,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 40,
                          width: 150,
                          padding: EdgeInsets.only(right: 0),
                          child: RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: const BoxDecoration(
                                color: CustomColor.colBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 18.0,
                                    minHeight:
                                        36.0), // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[],
        );
      },
    );
  }
}
