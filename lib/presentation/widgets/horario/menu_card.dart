import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget menuCard(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 32.0, color: ColorPalet.grisesGray5),
              const SizedBox(height: 10.0),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ColorPalet.grisesGray5)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray5)),
                  const Icon(Iconsax.arrow_right_1, size: 24.0, color: ColorPalet.grisesGray5),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
