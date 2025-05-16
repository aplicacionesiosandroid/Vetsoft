import 'package:flutter/material.dart';

Widget emptyAbsenceCard(
  BuildContext context,
  Color color,
  Color colorText,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width, // 352.0, according to figma
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No solicitaste ninguna asusencia',
                style: TextStyle(
                  color: colorText,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )),
    ),
  );
}
