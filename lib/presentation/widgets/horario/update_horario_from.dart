// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/models/horario/horario_update_model.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/horario_provider.dart';

class UpdateHorarioForm extends StatefulWidget {
  final HorarioUpdateModel horario;
  const UpdateHorarioForm({super.key, required this.horario});

  @override
  UpdateHorarioFormState createState() => UpdateHorarioFormState();
}

class TimeSlot {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController totalHoursController = TextEditingController();
  TimeSlot({required String startTime, required String endTime}) {
    startTimeController.text = startTime;
    endTimeController.text = endTime;
    totalHoursController.text = "0";
  }
}

class UpdateHorarioFormState extends State<UpdateHorarioForm> {
  String formatDateString(String date) {
    List<String> parts = date.split('/');
    if (parts.length != 3) {
      mostrarSnackBar(context, 'Error: Formato de fecha inválido.');
    }
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  int calculateHours(String startTime, String endTime) {
    final format = DateFormat("HH:mm");
    final start = format.parse(startTime);
    final end = format.parse(endTime);
    return end.difference(start).inHours;
  }

  late HorarioUpdateModel horario = widget.horario;
  late String? dropdownValue = horario.tipoHorario == 'horario fijo' ? 'Horario Fijo' : 'Horario Flexible';
  late TextEditingController dateControllerDesde = TextEditingController(text: DateFormat('dd/MM/yyyy').format(horario.fechaInicio));
  late TextEditingController dateControllerHasta = TextEditingController(text: DateFormat('dd/MM/yyyy').format(horario.fechaFin));
  late TextEditingController nameController = TextEditingController(text: horario.tipoHorario);

  late List<String> selectedDays = horario.tipoHorario == 'horario fijo'
      ? []
      : () {
          List<String> days = [];
          horario.lunesHoras! > 0 ? days.add('Lunes') : null;
          horario.martesHoras! > 0 ? days.add('Martes') : null;
          horario.miercolesHoras! > 0 ? days.add('Miercoles') : null;
          horario.juevesHoras! > 0 ? days.add('Jueves') : null;
          horario.viernesHoras! > 0 ? days.add('Viernes') : null;
          horario.sabadoHoras! > 0 ? days.add('Sabado') : null;
          horario.domingoHoras! > 0 ? days.add('Domingo') : null;
          return days;
        }();

  late Map<String, List<TimeSlot>> timeSlots = (horario.tipoHorario == 'horario fijo')
      ? () {
          Map<String, List<TimeSlot>> timeSlots = {
            'Lunes': [],
            'Martes': [],
            'Miercoles': [],
            'Jueves': [],
            'Viernes': [],
            'Sabado': [],
            'Domingo': [],
          };
          if (horario.lunesInicio != null) {
            timeSlots['Lunes']!.add(TimeSlot(startTime: horario.lunesInicio!.substring(0, 5), endTime: horario.lunesFin!.substring(0, 5)));
          }
          if (horario.martesInicio != null) {
            timeSlots['Martes']!.add(TimeSlot(startTime: horario.martesInicio!.substring(0, 5), endTime: horario.martesFin!.substring(0, 5)));
          }
          if (horario.miercolesInicio != null) {
            timeSlots['Miercoles']!
                .add(TimeSlot(startTime: horario.miercolesInicio!.substring(0, 5), endTime: horario.miercolesFin!.substring(0, 5)));
          }
          if (horario.juevesInicio != null) {
            timeSlots['Jueves']!.add(TimeSlot(startTime: horario.juevesInicio!.substring(0, 5), endTime: horario.juevesFin!.substring(0, 5)));
          }
          if (horario.viernesInicio != null) {
            timeSlots['Viernes']!.add(TimeSlot(startTime: horario.viernesInicio!.substring(0, 5), endTime: horario.viernesFin!.substring(0, 5)));
          }
          if (horario.sabadoInicio != null) {
            timeSlots['Sabado']!.add(TimeSlot(startTime: horario.sabadoInicio!.substring(0, 5), endTime: horario.sabadoFin!.substring(0, 5)));
          }
          if (horario.domingoInicio != null) {
            timeSlots['Domingo']!.add(TimeSlot(startTime: horario.domingoInicio!.substring(0, 5), endTime: horario.domingoFin!.substring(0, 5)));
          }
          return timeSlots;
        }()
      : () {
          Map<String, List<TimeSlot>> timeSlots = {
            'Lunes': [],
            'Martes': [],
            'Miercoles': [],
            'Jueves': [],
            'Viernes': [],
            'Sabado': [],
            'Domingo': [],
          };
          String baseTime = '08:00';
          int baseHour = int.parse(baseTime.split(':')[0]);
          int baseMinute = int.parse(baseTime.split(':')[1]);

          if (horario.lunesHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.lunesHoras!));
            timeSlots['Lunes']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Lunes']![0].totalHoursController.text = horario.lunesHoras.toString();
          }
          if (horario.martesHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.martesHoras!));
            timeSlots['Martes']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Martes']![0].totalHoursController.text = horario.martesHoras.toString();
          }
          if (horario.miercolesHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.miercolesHoras!));
            timeSlots['Miercoles']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Miercoles']![0].totalHoursController.text = horario.miercolesHoras.toString();
          }
          if (horario.juevesHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.juevesHoras!));
            timeSlots['Jueves']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Jueves']![0].totalHoursController.text = horario.juevesHoras.toString();
          }
          if (horario.viernesHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.viernesHoras!));
            timeSlots['Viernes']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Viernes']![0].totalHoursController.text = horario.viernesHoras.toString();
          }
          if (horario.sabadoHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.sabadoHoras!));
            timeSlots['Sabado']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Sabado']![0].totalHoursController.text = horario.sabadoHoras.toString();
          }
          if (horario.domingoHoras! >= 0) {
            DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, baseHour, baseMinute);
            DateTime endTime = startTime.add(Duration(hours: horario.domingoHoras!));
            timeSlots['Domingo']!.add(TimeSlot(startTime: DateFormat('HH:mm').format(startTime), endTime: DateFormat('HH:mm').format(endTime)));
            timeSlots['Domingo']![0].totalHoursController.text = horario.domingoHoras.toString();
          }

          return timeSlots;
        }();

  @override
  Widget build(BuildContext context) {
    final horarioProvider = Provider.of<HorarioProvider>(context, listen: false);

    return ListView(
      children: [
        const Text(
          "Escribe aquí el nombre del nuevo horario laboral",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorPalet.grisesGray2,
          ),
        ),
        const SizedBox(height: 16),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildDropdownField(),
        const SizedBox(height: 16),
        _buildDateTimeRow("Fecha de inicio", dateControllerDesde, "Fecha de finalización", dateControllerHasta),
        const SizedBox(height: 16),
        const Text(
          'Horas de trabajo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalet.grisesGray1,
          ),
        ),
        dropdownValue == 'Horario Fijo' ? _buildWeeklySchedule() : _buildFlexibleSchedule(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              try {
                // print("Fecha de inicio ingresada: ${dateControllerDesde.text}"); // Imprime para diagnóstico
                // print("Fecha de finalización ingresada: ${dateControllerHasta.text}"); // Imprime para diagnóstico
                String formattedStartDate = formatDateString(dateControllerDesde.text);
                String formattedEndDate = formatDateString(dateControllerHasta.text);
                // print("Fecha de inicio formateada: $formattedStartDate"); // Imprime para diagnóstico
                // print("Fecha de finalización formateada: $formattedEndDate"); // Imprime para diagnóstico

                if (dropdownValue == 'Horario Fijo') {
                  Map<String, TimeRange> dias = {};
                  timeSlots.forEach((day, slots) {
                    if (slots.isNotEmpty) {
                      dias[day] = TimeRange(startTime: slots[0].startTimeController.text, endTime: slots[0].endTimeController.text);
                    }
                  });

                  var horarioFijo = HorarioFijo(
                    nombreHorario: nameController.text,
                    fechaInicio: DateTime.parse(formattedStartDate),
                    fechaFin: DateTime.parse(formattedEndDate),
                    dias: dias,
                  );
                  // Validaciones de campos vacíos
                  if (horarioFijo.nombreHorario.isEmpty) {
                    mostrarSnackBar(context, 'Error: El nombre del horario no puede estar vacío.');
                    return;
                  }
                  if (horarioFijo.fechaInicio.isAfter(horarioFijo.fechaFin)) {
                    mostrarSnackBar(context, 'Error: La fecha de inicio no puede ser posterior a la fecha de finalización.');
                    return;
                  }
                  if (horarioFijo.dias.isEmpty) {
                    mostrarSnackBar(context, 'Error: Debe ingresar al menos un día de trabajo.');
                    return;
                  }
                  if (horarioFijo.dias.values.any((element) => element.startTime.isEmpty || element.endTime.isEmpty)) {
                    mostrarSnackBar(context, 'Error: Debe ingresar una hora de inicio y una hora de finalización para cada día de trabajo.');
                    return;
                  }
                  if (horarioFijo.dias.values.any((element) => element.startTime == element.endTime)) {
                    mostrarSnackBar(context, 'Error: La hora de inicio y la hora de finalización no pueden ser iguales.');
                    return;
                  }
                  if (horarioFijo.dias.values.any((element) => calculateHours(element.startTime, element.endTime) < 0)) {
                    mostrarSnackBar(context, 'Error: La hora de inicio no puede ser posterior a la hora de finalización.');
                    return;
                  }
                  await horarioProvider.updateHorarioFijo(horarioFijo, horario.horarioId);
                  // print('Horario fijo creado con éxito.');
                  mostrarSnackBar(context, 'Horario fijo actualizado. Imagen en galería.');
                  Navigator.pop(context);
                } else {
                  Map<String, int> horas = {};
                  timeSlots.forEach((day, slots) {
                    if (slots.isNotEmpty && selectedDays.contains(day)) {
                      final hoursWorked = slots[0].totalHoursController.text.isNotEmpty ? int.parse(slots[0].totalHoursController.text) : 0;
                      horas['${day.toLowerCase()}_horas'] = hoursWorked;
                    } else {
                      horas['${day.toLowerCase()}_horas'] = 0;
                    }
                  });
                  var horarioFlexible = HorarioFlexible(
                    nombreHorario: nameController.text,
                    fechaInicio: DateTime.parse(formattedStartDate),
                    fechaFin: DateTime.parse(formattedEndDate),
                    horas: horas,
                    dias: {},
                  );
                  // Validaciones de campos vacíos
                  if (horarioFlexible.nombreHorario.isEmpty) {
                    mostrarSnackBar(context, 'Error: El nombre del horario no puede estar vacío.');
                    return;
                  }
                  if (horarioFlexible.fechaInicio.isAfter(horarioFlexible.fechaFin)) {
                    mostrarSnackBar(context, 'Error: La fecha de inicio no puede ser posterior a la fecha de finalización.');
                    return;
                  }
                  if (horarioFlexible.horas.values.any((element) => element < 0)) {
                    mostrarSnackBar(context, 'Error: Las horas de trabajo no pueden ser negativas.');
                    return;
                  }
                  if (horarioFlexible.horas.values.every((element) => element == 0)) {
                    mostrarSnackBar(context, 'Error: Debe ingresar al menos un día de trabajo.');
                    return;
                  }
                  if (selectedDays.isEmpty) {
                    mostrarSnackBar(context, 'Error: Debe ingresar al menos un día de trabajo.');
                    return;
                  }

                  await horarioProvider.updateHorarioFlexible(horarioFlexible, horario.horarioId);
                  // print('Horario flexible creado con éxito.');
                  mostrarSnackBar(context, 'Horario flexible actualizado. Imagen en galería.');
                  Navigator.pop(context);
                }
              } on Exception catch (e) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Error: ${e.toString()}'),
                    );
                  },
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ColorPalet.secondaryDefault,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              children: [
                if (horarioProvider.isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: ColorPalet.grisesGray5,
                      strokeWidth: 2,
                    ),
                  )
                else
                  const Text(
                    "Guardar Cambios",
                    style: TextStyle(
                      color: ColorPalet.grisesGray5,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => alertModal(
                context,
                '¿Estás seguro/a de querer volver atrás?',
                'No se guardarán los cambios que hayas realizado.',
                'Volver',
                'Quedarme aquí',
                ColorPalet.grisesGray5,
                () => {Navigator.pop(context), Navigator.pop(context)},
                () => {Navigator.pop(context)},
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: ColorPalet.secondaryDefault, width: 2),
                ),
              ),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: ColorPalet.secondaryDefault,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nombre del horario",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalet.grisesGray1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: ColorPalet.backGroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Ejemplo: Horario de oficina',
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorPalet.grisesGray2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklySchedule() {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        _buildDayRow("Lunes"),
        _buildDayRow("Martes"),
        _buildDayRow("Miercoles"),
        _buildDayRow("Jueves"),
        _buildDayRow("Viernes"),
        _buildDayRow("Sabado"),
        _buildDayRow("Domingo"),
      ],
    );
  }

  Widget _buildFlexibleSchedule() {
    return Column(
      children: [
        ..._buildFlexibleDays(),
      ],
    );
  }

  List<Widget> _buildFlexibleDays() {
    List<String> days = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"];
    return days.map((day) {
      TimeSlot slot = timeSlots[day]![0];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (selectedDays.contains(day)) {
                  selectedDays.remove(day);
                } else {
                  selectedDays.add(day);
                }
              });
            },
            child: Row(
              children: [
                Radio(
                  toggleable: true,
                  value: day,
                  groupValue: selectedDays.contains(day) ? day : null,
                  onChanged: (val) {
                    // print selected days
                    setState(() {
                      if (selectedDays.contains(day)) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }
                    });
                  },
                ),
                Text(day.substring(0, 3), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorPalet.grisesGray1)),
                const SizedBox(width: 50),
                const SizedBox(width: 50),
                Container(
                  decoration: BoxDecoration(
                    color: ColorPalet.backGroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: 100,
                  child: TextFormField(
                    controller: slot.totalHoursController,
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDateTimeRow(String labelDesde, TextEditingController controllerDesde, String labelHasta, TextEditingController controllerHasta) {
    return Row(
      children: [
        Expanded(
          child: _buildDateTimeField(labelDesde, controllerDesde, context),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateTimeField(labelHasta, controllerHasta, context),
        ),
      ],
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalet.grisesGray1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: ColorPalet.backGroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextFormField(
            onTap: () async {
              // Asegúrate de que el DatePicker esté configurado con el formato de fecha correcto
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                String formattedDate = DateFormat('dd/MM/yyyy').format(picked); // Formato de fecha como "01/02/2023"
                controller.text = formattedDate; // Actualiza el controlador de texto con la fecha formateada
              }
            },
            readOnly: true, // Evita que el usuario escriba manualmente en el campo de texto
            controller: controller, // Asegúrate de que el controlador esté vinculado
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Iconsax.calendar_1,
                color: ColorPalet.grisesGray2,
                size: 24,
              ),
              border: InputBorder.none,
              hintText: 'dd/mm/aaaa',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorPalet.grisesGray2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    Map<int, String> scheduleTypes = {
      1: 'Horario Fijo',
      2: 'Horario Flexible',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de la jornada',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalet.grisesGray1,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: ColorPalet.backGroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: dropdownValue,
                items: scheduleTypes.entries.map<DropdownMenuItem<String>>((MapEntry<int, String> e) {
                  return DropdownMenuItem<String>(
                    value: e.value,
                    child: Text(e.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray1,
                        )),
                  );
                }).toList(),
                onChanged: (value) => setState(() => dropdownValue = value),
                icon: const Icon(Iconsax.arrow_down_1, color: ColorPalet.grisesGray1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayRow(String day) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Botón de radio eliminado
              Text(day.substring(0, 3), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorPalet.grisesGray1)),
              IconButton(
                icon: const Icon(
                  Iconsax.add_square,
                  color: Color.fromARGB(255, 25, 134, 230),
                ),
                onPressed: () {
                  setState(() {
                    timeSlots[day]?.add(TimeSlot(startTime: "", endTime: ""));
                  });
                },
              ),
            ],
          ),
          for (var slot in timeSlots[day]!) _buildTimeSlot(day, slot),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String day, TimeSlot slot) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Iconsax.minus_square5,
            color: Colors.red,
          ),
          onPressed: () {
            _deleteTimeSlot(day, slot);
          },
        ),
        const SizedBox(width: 16), // Para alinear con las horas de los otros días
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inicio'),
              TextFormField(
                controller: slot.startTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: '08:00',
                  suffixIcon: Icon(Iconsax.clock),
                  border: InputBorder.none,
                ),
                onTap: () async {
                  // Asegúrate de que el TimePicker esté configurado con el formato de hora correcto
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                  );
                  if (picked != null) {
                    String formattedTime = picked.format(context); // Formato de hora como "08:00 AM"
                    slot.startTimeController.text = formattedTime; // Actualiza el controlador de texto con la hora formateada
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Fin'),
              TextFormField(
                controller: slot.endTimeController,
                decoration: const InputDecoration(
                  hintText: '14:00',
                  suffixIcon: Icon(Iconsax.clock),
                  border: InputBorder.none,
                ),
                onTap: () async {
                  // Asegúrate de que el TimePicker esté configurado con el formato de hora correcto
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 14, minute: 0),
                  );
                  if (picked != null) {
                    String formattedTime = picked.format(context); // Formato de hora como "08:00 AM"
                    slot.endTimeController.text = formattedTime; // Actualiza el controlador de texto con la hora formateada
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _deleteTimeSlot(String day, TimeSlot slot) {
    setState(() {
      timeSlots[day]?.remove(slot);
    });
  }
}
