import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget alertModal(
  BuildContext context,
  String title,
  String subtitle,
  String leftButtonText,
  String rightButtonText,
  Color color,
  Function leftButtonAction,
  Function rightButtonAction, {
  Color leftButtonColor = ColorPalet.estadoNegative,
  Color rightButtonColor = ColorPalet.secondaryDefault,
  Color titleColor = ColorPalet.grisesGray0,
  Color subtitleColor = ColorPalet.grisesGray1,
  Color buttonTextColor = ColorPalet.grisesGray5,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    content: SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: titleColor),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: subtitleColor),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 42,
                width: MediaQuery.of(context).size.width * 0.33,
                child: TextButton(
                  onPressed: () => leftButtonAction(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(leftButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Text(
                    leftButtonText,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: buttonTextColor),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.33,
                child: TextButton(
                  onPressed: () => rightButtonAction(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(rightButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    rightButtonText,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: buttonTextColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
