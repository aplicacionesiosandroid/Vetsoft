import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget filePercentage(
  BuildContext context,
  String message,
  double percentage,
  Color color,
  Color colorText,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width, // 352.0, according to figma
    child: Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorText,
                ),
                maxLines: 4,
              ),
            ),
            CircularPercentIndicator(
                radius: 42,
                lineWidth: 8.0,
                startAngle: 180,
                percent: percentage,
                center: Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorText,
                  ),
                ),
                progressColor: colorText,
                backgroundColor: color),
          ],
        ),
      ),
    ),
  );
}
