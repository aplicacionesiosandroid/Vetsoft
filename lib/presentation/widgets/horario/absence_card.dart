import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/calendar_day_card.dart';

Widget absenceCard(
  BuildContext context,
  String dateFrom,
  String dateTo,
  String title,
  String subtitle,
  Color color,
  Color colorText,
  Color colorSubText,
  Color calendarColor,
) {
  // Literal months
  List<String> months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

  return SizedBox(
    width: MediaQuery.of(context).size.width, // 352.0, according to figma
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            calendarDayCard(
              calendarColor,
              months[int.parse(dateFrom.split('-')[1]) - 1],
              dateFrom.split('-')[2],
              width: 60,
              height: 60,
              borderRadius: 18,
            ),
            Icon(
              Iconsax.arrow_right_1,
              color: colorText,
              size: 24,
            ),
            calendarDayCard(
              calendarColor,
              months[int.parse(dateTo.split('-')[1]) - 1],
              dateTo.split('-')[2],
              width: 60,
              height: 60,
              borderRadius: 18,
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colorText),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    'Motivo: $subtitle',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colorSubText),
                  ),
                Text(
                  '${dateFrom.split('-')[2]}/${dateFrom.split('-')[1]}/${dateFrom.split('-')[0]} - ${dateTo.split('-')[2]}/${dateTo.split('-')[1]}/${dateTo.split('-')[0]}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colorSubText),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
