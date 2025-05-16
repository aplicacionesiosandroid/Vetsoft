import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget cardView(
  BuildContext context,
  String title,
  String description,
  Color lineColor,
) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 3, color: lineColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorPalet.grisesGray0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalet.grisesGray2,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
