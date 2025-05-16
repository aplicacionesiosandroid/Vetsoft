// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/horario/empleado_tipo_ausencia_model.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/empleado_ausencias_nuevo_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class EmpleadoNNuevaAusenciaScreen extends StatelessWidget {
  const EmpleadoNNuevaAusenciaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmpleadoAusenciasNuevoProvider(),
      child: _EmployeeNewAbsenceScreen(),
    );
  }
}

class _EmployeeNewAbsenceScreen extends StatelessWidget {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final empleadoAusenciasNuevoProvider = Provider.of<EmpleadoAusenciasNuevoProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            padding: const EdgeInsets.all(24.0),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
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
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                      const Text(
                        "Añadir ausencia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorPalet.grisesGray0,
                        ),
                      ),
                      IconButton(
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
                        icon: const Icon(
                          Icons.close,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tipo de ausencia',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalet.grisesGray1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (!empleadoAusenciasNuevoProvider.isLoading)
                    Container(
                      decoration: BoxDecoration(
                        color: ColorPalet.backGroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: empleadoAusenciasNuevoProvider.selectedTipoAusencia,
                            items: empleadoAusenciasNuevoProvider.listaTipoAusencias.map<DropdownMenuItem<int>>((EmpleadoTipoAusenciaModel e) {
                              return DropdownMenuItem<int>(
                                value: e.tipoAusenciaId,
                                child: Text(
                                  e.nombreAusencia,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ColorPalet.grisesGray1,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => {
                              empleadoAusenciasNuevoProvider.setSelectedTipoAusencia(value as int),
                            },
                            icon: const Icon(Iconsax.arrow_down_1, color: ColorPalet.grisesGray1),
                          ),
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalet.primaryDefault,
                      ),
                    ),
                  if (empleadoAusenciasNuevoProvider.selectedTipoAusencia != 0 &&
                      // find by id
                      empleadoAusenciasNuevoProvider.listaTipoAusencias
                              .firstWhere((element) => element.tipoAusenciaId == empleadoAusenciasNuevoProvider.selectedTipoAusencia)
                              .documento ==
                          true)
                    Container(
                      decoration: BoxDecoration(
                        color: ColorPalet.backGroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                    ),
                  if (empleadoAusenciasNuevoProvider.isDocumentUploading) const SizedBox(height: 20),
                  if (empleadoAusenciasNuevoProvider.isDocumentUploading)
                    const Text(
                      'Certificación Médica',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorPalet.grisesGray1,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  if (empleadoAusenciasNuevoProvider.isDocumentUploading)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorPalet.backGroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorPalet.backGroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              empleadoAusenciasNuevoProvider.setDocumento(file);
                              documentoController.text = file.path.split('/').last;
                            }
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            prefix: Icon(
                              null,
                              color: ColorPalet.grisesGray2,
                              size: 24,
                            ),
                            suffixIcon: Icon(
                              Icons.file_upload,
                              color: ColorPalet.grisesGray2,
                              size: 24,
                            ),
                            border: InputBorder.none,
                            hintText: 'Seleccionar archivo',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorPalet.grisesGray2,
                            ),
                          ),
                          controller: documentoController,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalet.grisesGray1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorPalet.backGroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _textFieldController,
                        maxLines: 5,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Describe los detalles de tu ausencia aquí.',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalet.grisesGray2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        activeColor: ColorPalet.grisesGray1,
                        value: 1,
                        groupValue: empleadoAusenciasNuevoProvider.selectedDaysHalfDays,
                        onChanged: (value) {
                          empleadoAusenciasNuevoProvider.setSelectedDaysHalfDays(1);
                        },
                      ),
                      GestureDetector(
                        child: const Text(
                          'Días',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorPalet.grisesGray1,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        onTap: () {
                          empleadoAusenciasNuevoProvider.setSelectedDaysHalfDays(1);
                        },
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        activeColor: ColorPalet.grisesGray1,
                        value: 1,
                        groupValue: (1 - empleadoAusenciasNuevoProvider.selectedDaysHalfDays),
                        onChanged: (value) {
                          empleadoAusenciasNuevoProvider.setSelectedDaysHalfDays(0);
                        },
                      ),
                      GestureDetector(
                        child: const Text(
                          'Medio día',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorPalet.grisesGray1,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        onTap: () {
                          empleadoAusenciasNuevoProvider.setSelectedDaysHalfDays(0);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Desde',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorPalet.grisesGray1,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorPalet.backGroundColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
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
                                  dateFromController.text = formattedDate; // Actualiza el controlador de texto con la fecha formateada
                                }
                              },
                              readOnly: true,
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
                              controller: dateFromController,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Desde',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorPalet.grisesGray1,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorPalet.backGroundColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
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
                                  dateToController.text = formattedDate; // Actualiza el controlador de texto con la fecha formateada
                                }
                              },
                              readOnly: true,
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
                              controller: dateToController,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 42,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorPalet.secondaryDark.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (empleadoAusenciasNuevoProvider.selectedTipoAusencia == 0) {
                          mostrarSnackBar(context, 'Error: Debes seleccionar un tipo de ausencia.');
                          return;
                        }
                        if (_textFieldController.text.isEmpty) {
                          mostrarSnackBar(context, 'Error: El campo de descripción no puede estar vacío.');
                          return;
                        }
                        if (dateFromController.text.isEmpty) {
                          mostrarSnackBar(context, 'Error: Debes seleccionar una fecha de inicio.');
                          return;
                        }
                        if (dateToController.text.isEmpty) {
                          mostrarSnackBar(context, 'Error: Debes seleccionar una fecha de fin.');
                          return;
                        }
                        if (dateFromController.text.compareTo(dateToController.text) > 0) {
                          mostrarSnackBar(context, 'Error: La fecha de inicio no puede ser mayor a la fecha de fin.');
                          return;
                        }
                        if (empleadoAusenciasNuevoProvider.isDocumentUploading && empleadoAusenciasNuevoProvider.documento == null) {
                          mostrarSnackBar(context, 'Error: Debes seleccionar un archivo.');
                          return;
                        }
                        await empleadoAusenciasNuevoProvider.postAgregarAusenciaEmpleado(
                            _textFieldController.text, dateFromController.text, dateToController.text);
                        empleadoAusenciasNuevoProvider.reset();
                        _textFieldController.clear();
                        dateFromController.clear();
                        dateToController.clear();
                        mostrarSnackBar(context, 'Ausencia añadida correctamente.');
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Añadir ausencia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorPalet.grisesGray5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
