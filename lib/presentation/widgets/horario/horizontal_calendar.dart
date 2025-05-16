//ESTE ULTIMO ES PARA EL CALENDARIO QUE SE SCROLEA HORIZONTALMENTE
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

Widget horizontalCalendar({required Function(DateTime) onDateSelected}) {
  return SizedBox(
    height: 180,
    child: EasyDateTimeLine(
      headerProps: const EasyHeaderProps(
          showSelectedDate: true, selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY, monthPickerType: MonthPickerType.switcher),
      dayProps: EasyDayProps(
        inactiveBorderRadius: 35,
        dayStructure: DayStructure.dayStrDayNum,
        height: 90,
        width: 45,
        activeDayDecoration: BoxDecoration(color: const Color.fromARGB(255, 65, 0, 152), borderRadius: BorderRadius.circular(35)),
      ),
      activeColor: const Color.fromARGB(255, 65, 0, 152),
      locale: 'es_ES',
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        onDateSelected(selectedDate);
        // final fechaSeleccionada = DateFormat("yyyy-MM-dd").format(selectedDate);
        // ataTareas.getTareasFecha(fechaSeleccionada);
      },
    ),
  );
}
