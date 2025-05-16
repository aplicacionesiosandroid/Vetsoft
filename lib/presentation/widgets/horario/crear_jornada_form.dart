// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/horario/empleado_model.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/horario_provider.dart';

class CreateJornadaForm extends StatefulWidget {
  final List<EmpleadoModel> listaEmpleados;
  const CreateJornadaForm({super.key, required this.listaEmpleados});

  @override
  CreateJornadaFormState createState() => CreateJornadaFormState();
}

class TimeSlot {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TimeSlot({required String startTime, required String endTime}) {
    startTimeController.text = startTime;
    endTimeController.text = endTime;
  }
}

class CreateJornadaFormState extends State<CreateJornadaForm> {
  final TextEditingController dateControllerDesde = TextEditingController();
  final TextEditingController dateControllerHasta = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<String> selectedDays = [];
  List<String> selectedUsers = [];
  Map<String, List<TimeSlot>> timeSlots = {
    'lunes': [TimeSlot(startTime: "08:00", endTime: "14:00")],
    'martes': [TimeSlot(startTime: "08:00", endTime: "14:00")],
    'miercoles': [TimeSlot(startTime: "08:00", endTime: "14:00")],
    'jueves': [TimeSlot(startTime: "08:00", endTime: "14:00")],
    'viernes': [TimeSlot(startTime: "08:00", endTime: "14:00")],
    'sabado': [],
    'domingo': [],
  };
  late List<Map<String, dynamic>> users = widget.listaEmpleados
      .map((e) => {'id': e.empleadoId, 'name': e.nombreApellidos, 'role': e.rol, 'profilePic': e.imagenUser, 'selected': false})
      .toList();

  int get selectedUsersCount => users.where((user) => user['selected']).length;

  @override
  Widget build(BuildContext context) {
    final horarioProvider = Provider.of<HorarioProvider>(context, listen: false);
    return ListView(
      children: [
        _buildDateTimeRow("Desde", dateControllerDesde, "Hasta", dateControllerHasta),
        const SizedBox(height: 16),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildWeeklySchedule(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            try {
              String formattedStartDate = formatDateString(dateControllerDesde.text);
              String formattedEndDate = formatDateString(dateControllerHasta.text);

              Map<String, List<TimeRange>> dias = {};
              timeSlots.forEach((day, slots) {
                if (slots.isNotEmpty) {
                  for (var slot in slots) {
                    if (dias.containsKey(day)) {
                      dias[day] = [...dias[day]!, TimeRange(startTime: slot.startTimeController.text, endTime: slot.endTimeController.text)];
                    } else {
                      dias[day] = [TimeRange(startTime: slot.startTimeController.text, endTime: slot.endTimeController.text)];
                    }
                  }
                }
              });

              dias.removeWhere((key, value) => !selectedDays.contains(key));
              var jornada = Jornada(
                nombreHorario: selectedUsers.join(', '),
                fechaInicio: DateTime.parse(formattedStartDate),
                fechaFin: DateTime.parse(formattedEndDate),
                dias: dias,
              );
              jornada.tipoHorario = nameController.text;
              // Validaciones de campos vacíos
              if (jornada.nombreHorario.isEmpty) {
                mostrarSnackBar(context, 'Error: El nombre del horario no puede estar vacío.');
                return;
              }
              if (jornada.fechaInicio.isAfter(jornada.fechaFin)) {
                mostrarSnackBar(context, 'Error: La fecha de inicio no puede ser posterior a la fecha de finalización.');
                return;
              }
              if (jornada.dias.isEmpty) {
                mostrarSnackBar(context, 'Error: Debe ingresar al menos un día de trabajo.');
                return;
              }
              if (jornada.dias.values.any((element) => element.any((element) => element.startTime.isEmpty || element.endTime.isEmpty))) {
                mostrarSnackBar(context, 'Error: Debe ingresar una hora de inicio y una hora de finalización para cada día de trabajo.');
                return;
              }
              if (jornada.dias.values.any((element) => element.any((element) => element.startTime == element.endTime))) {
                mostrarSnackBar(context, 'Error: La hora de inicio y la hora de finalización no pueden ser iguales.');
                return;
              }
              if (selectedUsers.isEmpty) {
                mostrarSnackBar(context, 'Error: Debe seleccionar al menos un empleado.');
                return;
              }
              await horarioProvider.postEmpleadoAsignarHorario(jornada);
              mostrarSnackBar(context, 'Jornada creada exitosamente.');
              Navigator.pop(context);
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
              ColorPalet.acentLigth,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: const Text("Asignar horario"),
        ),
      ],
    );
  }

  Widget _buildWeeklySchedule() {
    return Column(
      children: [
        _buildUserAssignmentField(),
        _buildDayRow("lunes"),
        _buildDayRow("martes"),
        _buildDayRow("miercoles"),
        _buildDayRow("jueves"),
        _buildDayRow("viernes"),
        _buildDayRow("sabado"),
        _buildDayRow("domingo"),
      ],
    );
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

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tipo de la jornada",
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

  Widget _buildSelectedUsersAvatars() {
    List<Map<String, dynamic>> selectedUsers = users.where((user) => user['selected']).toList();
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedUsers.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(selectedUsers[index]['profilePic']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserAssignmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Asignar a:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorPalet.grisesGray1,
            )),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Iconsax.profile_2user,
              size: 24,
              color: ColorPalet.grisesGray2,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(
                Iconsax.add_circle4,
                size: 32,
                color: ColorPalet.grisesGray2,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setNewState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 10,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        "Participantes (${selectedUsersCount.toString()})",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalet.grisesGray1,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      _buildSelectedUsersAvatars(),
                                      SizedBox(height: 18),
                                      TextField(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: ColorPalet.grisesGray2,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Prueba con un nombre o apellido',
                                          filled: true,
                                          fillColor: ColorPalet.backGroundColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon: const Icon(Icons.search),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 20,
                                          child: ClipOval(
                                            child: Image.network(
                                              users[index]['profilePic']!,
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                return const Center(
                                                  child: Icon(Icons.image, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          users[index]['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: users[index]['selected'] ? FontWeight.w500 : FontWeight.w400,
                                            color: users[index]['selected'] ? ColorPalet.secondaryDefault : ColorPalet.grisesGray0,
                                          ),
                                        ),
                                        subtitle: Text(users[index]['role']!),
                                        trailing: users[index]['selected'] ? const Icon(Icons.check, color: ColorPalet.secondaryDefault) : null,
                                        onTap: () {
                                          setNewState(() {
                                            users[index]['selected'] = !users[index]['selected'];
                                            if (users[index]['selected']) {
                                              selectedUsers.add(users[index]['id'].toString());
                                            } else {
                                              selectedUsers.remove(users[index]['id'].toString());
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
              },
            ),
          ],
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
              Radio(
                toggleable: true,
                value: day,
                groupValue: selectedDays.contains(day) ? day : null,
                onChanged: (val) {
                  setState(() {
                    if (selectedDays.contains(day)) {
                      selectedDays.remove(day);
                    } else {
                      selectedDays.add(day);
                    }
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  if (selectedDays.contains(day)) {
                    selectedDays.remove(day);
                  } else {
                    selectedDays.add(day);
                  }
                },
                child: Text(
                  day[0].toUpperCase() + day.substring(1, 3),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalet.grisesGray1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.add_square4,
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
          Row(children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Copia los tiempos de inicio y fin del primer día seleccionado a todos los demás días seleccionados
                    for (var day in selectedDays) {
                      for (var slot in timeSlots[day]!) {
                        slot.startTimeController.text = timeSlots[selectedDays[0]]![0].startTimeController.text;
                        slot.endTimeController.text = timeSlots[selectedDays[0]]![0].endTimeController.text;
                      }
                    }
                  });
                },
                child: const Text(
                  "+ Aplicar a todos",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalet.estadoNeutral,
                  ),
                ),
              ),
            ),
          ]),
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

  String formatDateString(String date) {
    List<String> parts = date.split('/');
    if (parts.length != 3) {
      mostrarSnackBar(context, 'Error: Formato de fecha inválido.');
    }
    // Reordena las partes en el formato aaaa-mm-dd
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }
}
