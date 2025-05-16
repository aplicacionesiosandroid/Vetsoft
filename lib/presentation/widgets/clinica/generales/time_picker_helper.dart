import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bottom_picker/bottom_picker.dart';

/// Clase genérica para manejar el selector de tiempo
class TimePickerHelper<T> {
  final BuildContext context;
  final T provider;
  final String Function() getHoraSelected;  // Función para obtener la hora seleccionada
  final void Function(String) setHoraSelected; // Función para establecer la hora seleccionada

  TimePickerHelper({
    required this.context,
    required this.provider,
    required this.getHoraSelected,
    required this.setHoraSelected,
  });

  void openTimePicker() {
    // Obtenemos la hora seleccionada previamente o usamos una hora predeterminada
    final String horaSeleccionada = getHoraSelected();
    final DateTime initialTime = horaSeleccionada.isNotEmpty
        ? DateFormat.Hm().parse(
        horaSeleccionada) // Convertimos la hora seleccionada a DateTime
        : DateTime
        .now(); // Si no hay hora seleccionada, usamos la hora actual

    BottomPicker.time(
      title: 'Selecciona un horario',
      titleStyle: const TextStyle(
        fontFamily: 'sans',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Color.fromARGB(255, 29, 34, 44),
      ),
      // bottomPickerTheme: BottomPickerTheme.plumPlate,
      dismissable: true,
      initialDateTime: initialTime,
      // Configurar la hora inicial
      onSubmit: (selectedTime) {
        if (selectedTime is DateTime) {
          // Formateamos la hora seleccionada
          String formattedTime = DateFormat.Hm().format(selectedTime);
          setHoraSelected(formattedTime); // Establecer la hora seleccionada
        } else {
          print('Error: el tiempo seleccionado no es válido.');
        }
      },
      onClose: () {
        print('Picker cerrado');
      },
      use24hFormat: false, // Usar formato de 24 horas
    ).show(context);
  }
}
