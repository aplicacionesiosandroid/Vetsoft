import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/calendar_day_card.dart';

Widget calendarCard(
  BuildContext context,
  String eventTitle,
  String eventReason,
  String eventDate,
  Color color,
) {
  if (eventDate.contains(" ")) {
    eventDate = eventDate.split(" ")[0];
  }
  DateTime newDate = DateTime.parse(eventDate);

  String dayNumber = newDate.day.toString();
  List<String> days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];
  String day = days[newDate.weekday - 1];

  String eventDateFormat = "${newDate.day}/${newDate.month}/${newDate.year}";

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width - 50, // 352.0, according to figma
      child: Card(
        color: ColorPalet.grisesGray5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              calendarDayCard(color, day, dayNumber),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(eventTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ColorPalet.grisesGray0)),
                  Text(eventReason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray0)),
                  const SizedBox(height: 5),
                  Text(eventDateFormat, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray0)),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
