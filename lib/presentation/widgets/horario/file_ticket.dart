import 'package:flutter/material.dart';

WidgetfileTicket(
  BuildContext context,
  IconData icon,
  String title,
  Color color,
  Color colorText,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width, // 352.0, according to figma
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: colorText,
            ),
            const SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorText,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
