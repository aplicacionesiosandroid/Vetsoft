//CODIGO PARA EL CALENDARIO, EN ESTE CASO ESTA DENTRO DE UN BOTTOMSHEET PERO LE FALTA EL BOTON DE SELECCIONAR FECHA, SE ESTA TRABAJANDO CON UN PROVIDER
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime todayInicio = DateTime.now();

void openBottomSheetFechaInicio(BuildContext context) {
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      DateTime nowDate = DateTime.now();
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(15),
            height: 500,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    width: 30,
                    height: 2, // Altura de la línea
                    color: const Color.fromARGB(255, 161, 158, 158), // Color de la línea
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccionar fecha de inicio',
                      style: TextStyle(color: Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TableCalendar(
                  //onDaySelected: _onDaySelectedFInicio,
                  onDaySelected: (day, focusedDay) {
                    setState(() {
                      todayInicio = day;
                    });
                    // _onDaySelectedFInicio(day, focusedDay, context);
                  },

                  selectedDayPredicate: (day) => isSameDay(day, todayInicio),
                  locale: 'es_ES',
                  rowHeight: 43,

                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: false,
                    leftChevronIcon: const Icon(Icons.chevron_left),
                    rightChevronIcon: const Icon(Icons.chevron_right),
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    titleTextFormatter: (DateTime focusedDay, dynamic format) {
                      final monthFormat = DateFormat('MMMM', 'es_ES');
                      final monthText = monthFormat.format(focusedDay);
                      final capitalizedMonth = '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                      return '$capitalizedMonth ${focusedDay.year}';
                    },
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: todayInicio,
                  firstDay: DateTime.utc(2023, 02, 10),
                  lastDay: DateTime(nowDate.year + 1, nowDate.month, nowDate.day, nowDate.hour, nowDate.minute, nowDate.second),

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      //shape: BoxShape.rectangle,
                      color: const Color.fromARGB(255, 65, 0, 152),
                      borderRadius: BorderRadius.circular(5), // Ajusta el radio según tus preferencias
                    ),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 65, 0, 152),
                        width: 2,
                      ),
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 65, 0, 152),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
  


  // void _onDaySelectedFInicio(
  //     DateTime day, DateTime focusedDay, BuildContext context) {
  //   TareasProvider dataTarea =
  //       Provider.of<TareasProvider>(context, listen: false);
  //   setState(() {
  //     todayInicio = day;
  //     String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayInicio);
  //     print(formattedDateEnviar);
  //     dataTarea.setFechaInicioSelected(formattedDateEnviar);
  //   });
  // }






