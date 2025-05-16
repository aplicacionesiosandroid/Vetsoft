import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget CalendarioFormulario({
  required DateTime focusedDay,
  required DateTime firstDay,
  required DateTime lastDay,
  required Function(DateTime, DateTime) onDaySelected,
  required bool Function(DateTime) selectedDayPredicate,
}) {
  return TableCalendar(
    onDaySelected: onDaySelected,
    selectedDayPredicate: selectedDayPredicate,
    locale: 'es_ES',
    rowHeight: 45,
    headerStyle: HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        final formattedDate = DateFormat('MMMM  yyyy', locale).format(date);
        return formattedDate[0].toUpperCase() + formattedDate.substring(1);
      },
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    availableGestures: AvailableGestures.horizontalSwipe,
    focusedDay: focusedDay,
    firstDay: firstDay,
    lastDay: lastDay,
    calendarStyle: CalendarStyle(
      todayDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF635CFF),
      ),
      selectedDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
            10), // Se asegura de que el borderRadius se aplique
        color: Colors.transparent,
        border: Border.all(
          color: Color(0xFF8840FF),
          width: 2,
        ),
      ),
      selectedTextStyle: const TextStyle(
        color: Color(0xFF8840FF),
      ),
      weekendDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      defaultDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      outsideDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
