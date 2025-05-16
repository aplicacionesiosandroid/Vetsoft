// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/evento_provider.dart';

class NuevoEventoScreen extends StatelessWidget {
  NuevoEventoScreen({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateControllerDesde = TextEditingController();
  final TextEditingController dateControllerHasta = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final eventoProvider = Provider.of<EventoProvider>(context, listen: false);

    InputDecoration getInputDecoration(String hint, {IconData? prefixIcon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColorPalet.grisesGray2,
        ),
        filled: true,
        fillColor: ColorPalet.backGroundColor,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        //controller
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF5E6EFF),
        body: Container(
          margin: const EdgeInsets.only(top: 75),
          decoration: const BoxDecoration(
            color: ColorPalet.grisesGray5,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.arrow_left),
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
                      iconSize: 24,
                      color: ColorPalet.grisesGray0,
                    ),
                    const Text(
                      'Nuevo Evento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {},
                      iconSize: 24,
                      color: ColorPalet.grisesGray0,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Título',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorPalet.grisesGray1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: getInputDecoration('Título del evento'),
                              controller: titleController,
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha de inicio',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalet.grisesGray1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: dateControllerDesde,
                                        decoration: getInputDecoration('dd/mm/aaaa', prefixIcon: Iconsax.calendar_1),
                                        readOnly: true,
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
                                            dateControllerDesde.text = formattedDate; // Actualiza el controlador de texto
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha de finalización',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalet.grisesGray1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: dateControllerHasta,
                                        decoration: getInputDecoration('13/08/23', prefixIcon: Iconsax.calendar_1),
                                        readOnly: true,
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
                                            dateControllerHasta.text = formattedDate; // Actualiza el controlador de texto
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              'Descripción',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorPalet.grisesGray1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: getInputDecoration('Describe los detalles del evento'),
                              controller: descriptionController,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 20.0),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            //   decoration: BoxDecoration(
                            //     color: ColorPalet.backGroundColor,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<String>(
                            //       isExpanded: true,
                            //       hint: const Text('Alerta',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w400,
                            //             color: ColorPalet.grisesGray1,
                            //           )),
                            //       onChanged: (String? newValue) {
                            //         // Handle change
                            //       },
                            //       items: <String>['Option 1', 'Option 2', 'Option 3'].map<DropdownMenuItem<String>>((String value) {
                            //         return DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Text(
                            //             value,
                            //             style: const TextStyle(
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w400,
                            //               color: ColorPalet.grisesGray1,
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    if (titleController.text.isEmpty) {
                                      mostrarSnackBar(context, 'El título no puede estar vacío');
                                      return;
                                    }
                                    if (dateControllerDesde.text.isEmpty) {
                                      mostrarSnackBar(context, 'La fecha de inicio no puede estar vacía');
                                      return;
                                    }
                                    if (dateControllerHasta.text.isEmpty) {
                                      mostrarSnackBar(context, 'La fecha de finalización no puede estar vacía');
                                      return;
                                    }
                                    if (descriptionController.text.isEmpty) {
                                      mostrarSnackBar(context, 'La descripción no puede estar vacía');
                                      return;
                                    }
                                    // convertimos las fechas a yyyy-mm-dd
                                    String fechaInicio = dateControllerDesde.text.split('/').reversed.join('-');
                                    String fechaFin = dateControllerHasta.text.split('/').reversed.join('-');
                                    await eventoProvider.postCrearEvento(titleController.text, fechaInicio, fechaFin, descriptionController.text);
                                    mostrarSnackBar(context, 'Evento creado correctamente');
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
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: ColorPalet.secondaryDefault,
                                ),
                                child: const Text(
                                  'Añadir evento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorPalet.grisesGray5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
