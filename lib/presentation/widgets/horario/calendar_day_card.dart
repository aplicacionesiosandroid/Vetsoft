import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget calendarDayCard(
  Color color,
  String text,
  String dayNumber, {
  Color textColor = ColorPalet.grisesGray5,
  double height = 65,
  double width = 65,
  double borderRadius = 24,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(text.substring(0, 3), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor)),
        Text(dayNumber, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
      ],
    ),
  );
}
