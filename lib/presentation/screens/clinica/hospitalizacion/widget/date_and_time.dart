import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';

Future<void> dataTimeInicioHospitalizacion(BuildContext context,
    HospitalizacionProvider dataHospitalizacion, sizeScreenWidth) async {
  // Restablecer el valor del controlador
  DateTime today = DateTime.now(); // Define la fecha actual

  Widget _separacionCampos(double height) {
    return SizedBox(height: height);
  }

  Widget _NombreCampos(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _onDaySelected(DateTime day, DateTime focusedDay) {
            setState(() {
              today = day;
              String formattedDateEnviar =
                  DateFormat("yyyy-MM-dd").format(today);
              dataHospitalizacion.setFechaInicioSlected(formattedDateEnviar);
            });
          }

          ///Obteniendo hora
          void _openTimePicker(BuildContext context,
              HospitalizacionProvider dataHospitalizacion) {
            BottomPicker.time(
              title: 'Selecciona un horario',
              titleStyle: const TextStyle(
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color.fromARGB(255, 29, 34, 44),
              ),
              initialDateTime: dataHospitalizacion.horaInicioSelected.isNotEmpty
                  ? DateFormat.Hm()
                      .parse(dataHospitalizacion.horaInicioSelected)
                  : DateTime.now(),
              dismissable: true,
              onSubmit: (index) {
                DateTime dateTime = DateTime.parse(index.toString());
                String formattedTime = DateFormat.Hm().format(dateTime);
                setState(() {
                  dataHospitalizacion.setHoraInicioSelected(formattedTime);
                });
              },
              bottomPickerTheme: BottomPickerTheme.temptingAzure,
              use24hFormat: false,
            ).show(context);
          }

          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Inicio de hospitalización',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Container(
                width: sizeScreenWidth,
                child: Column(
                  children: [
                    CalendarioFormulario(
                      focusedDay: today,
                      firstDay: DateTime.utc(2023, 02, 10),
                      lastDay: DateTime.utc(2030, 02, 10),
                      onDaySelected: _onDaySelected,
                      selectedDayPredicate: (day) => isSameDay(day, today),
                    ),
                    _separacionCampos(20),
                    _NombreCampos('Hora'),
                    _separacionCampos(15),
                    InkWell(
                      onTap: () {
                        _openTimePicker(context, dataHospitalizacion);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 249, 249, 249),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 7),
                            Icon(
                              Icons.access_time,
                              color: Color.fromARGB(255, 139, 149, 166),
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            dataHospitalizacion.horaInicioSelected.isEmpty
                                ? Text(
                                    'Seleccionar hora',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          139, 149, 166, 1),
                                      fontSize: 14,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    dataHospitalizacion.horaInicioSelected,
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          139, 149, 166, 1),
                                      fontSize: 14,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  dataHospitalizacion.fechaInicioSelected == ''
                      ? dataHospitalizacion.setFechaInicioSlected(
                          DateFormat("yyyy-MM-dd").format(today))
                      : dataHospitalizacion.fechaInicioSelected;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 26, 202, 212),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aceptar',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 26, 202, 212), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 26, 202, 212),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> dataTimeFinHospitalizacion(BuildContext context,
    HospitalizacionProvider dataHospitalizacion, sizeScreenWidth) async {
  // Restablecer el valor del controlador
  DateTime today = DateTime.now(); // Define la fecha actual

  Widget _separacionCampos(double height) {
    return SizedBox(height: height);
  }

  Widget _NombreCampos(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _onDaySelected(DateTime day, DateTime focusedDay) {
            setState(() {
              today = day;
              String formattedDateEnviar =
                  DateFormat("yyyy-MM-dd").format(today);
              dataHospitalizacion.setFechaFinSlected(formattedDateEnviar);
            });
          }

          ///Obteniendo hora
          void _openTimePicker(BuildContext context,
              HospitalizacionProvider dataHospitalizacion) {
            BottomPicker.time(
              title: 'Selecciona un horario',
              titleStyle: const TextStyle(
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color.fromARGB(255, 29, 34, 44),
              ),
              dismissable: true,
              initialDateTime: dataHospitalizacion.horaFinSelected.isNotEmpty
                  ? DateFormat.Hm().parse(dataHospitalizacion.horaFinSelected)
                  : DateTime.now(),
              onSubmit: (index) {
                DateTime dateTime = DateTime.parse(index.toString());
                String formattedTime = DateFormat.Hm().format(dateTime);
                setState(() {
                  dataHospitalizacion.setHoraFinSelected(formattedTime);
                });
              },
              bottomPickerTheme: BottomPickerTheme.temptingAzure,
              use24hFormat: false,
            ).show(context);
          }

          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Fin de hospitalización',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Container(
                width: sizeScreenWidth,
                child: Column(
                  children: [
                    CalendarioFormulario(
                      focusedDay: today,
                      firstDay: DateTime.utc(2023, 02, 10),
                      lastDay: DateTime.utc(2030, 02, 10),
                      onDaySelected: _onDaySelected,
                      selectedDayPredicate: (day) => isSameDay(day, today),
                    ),
                    _separacionCampos(20),
                    _NombreCampos('Hora'),
                    _separacionCampos(15),
                    InkWell(
                      onTap: () {
                        _openTimePicker(context, dataHospitalizacion);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 249, 249, 249),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 7),
                            const Icon(
                              Icons.access_time,
                              color: Color.fromARGB(255, 139, 149, 166),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            dataHospitalizacion.horaFinSelected.isEmpty
                                ? const Text(
                                    'Seleccionar hora',
                                    style: TextStyle(
                                      color: Color.fromRGBO(139, 149, 166, 1),
                                      fontSize: 14,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    dataHospitalizacion.horaFinSelected,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(139, 149, 166, 1),
                                      fontSize: 14,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  dataHospitalizacion.fechaFinSelected == ''
                      ? dataHospitalizacion.setFechaFinSlected(
                          DateFormat("yyyy-MM-dd").format(today))
                      : dataHospitalizacion.fechaFinSelected;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 26, 202, 212),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aceptar',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromARGB(255, 26, 202, 212), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 26, 202, 212),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
