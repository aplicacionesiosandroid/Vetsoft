import 'package:flutter/material.dart';

import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget botomRow(String text, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: isSelected ? ColorPalet.acentDefault : ColorPalet.complementViolet2,
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? ColorPalet.grisesGray5 : ColorPalet.secondaryDefault,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
    ),
  );
}
