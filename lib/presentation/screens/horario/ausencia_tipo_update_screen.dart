// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/ausencias_tipo_update_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/loading_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class AusenciasTipoUpdateScreen extends StatelessWidget {
  final int id;
  const AusenciasTipoUpdateScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AusenciasTipoUpdateProvider(id),
      child: _AusenciasTipoUpdateScreen(),
    );
  }
}

class _AusenciasTipoUpdateScreen extends StatelessWidget {
  final TextEditingController nombreTipoAusenciaController = TextEditingController();
  final TextEditingController solicitudMinimaController = TextEditingController();
  final TextEditingController maximoSolicitudesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ausenciasEditarTipoProvider = Provider.of<AusenciasTipoUpdateProvider>(context);
    nombreTipoAusenciaController.text = ausenciasEditarTipoProvider.nombreAusencia;
    solicitudMinimaController.text = ausenciasEditarTipoProvider.solicitudMinima;
    maximoSolicitudesController.text = ausenciasEditarTipoProvider.maximoSolicitudes;

    if (ausenciasEditarTipoProvider.isLoading) return const LoadingScreen();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF5E6EFF),
        body: Container(
          margin: const EdgeInsets.only(top: 75),
          decoration: const BoxDecoration(
            color: ColorPalet.grisesGray5,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Actualizar tipo de ausencia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorPalet.grisesGray0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
                            _buildLabeledTextField('Nombre del tipo de ausencia', nombreTipoAusenciaController),
                            const SizedBox(height: 25),
                            const Text('Selecciona un color para este tipo de ausencia',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorPalet.grisesGray2)),
                            const SizedBox(height: 10),
                            _buildColorOptions(),
                            const SizedBox(height: 25),
                            _buildLabeledDropdown('¿Descuenta tiempo de mi contador de ausencias?', context, 1),
                            const SizedBox(height: 20),
                            _buildLabeledDropdown('¿Necesita ser aprobado?', context, 2),
                            const SizedBox(height: 20),
                            _buildLabeledDropdown('¿Permite un documento adjunto?', context, 3),
                            const SizedBox(height: 20),
                            _buildLabeledDropdown('¿El nombre de la ausencia es visible para el resto de los empleados/as?', context, 4),
                            const SizedBox(height: 20),
                            _buildLabeledDropdown('¿El tipo de ausencia es un día laborable?', context, 5),
                            const SizedBox(height: 25),
                            _buildLabeledTextField('Solicitud mínima cada vez', solicitudMinimaController, hintText: 'Días ilimitados'),
                            const SizedBox(height: 25),
                            _buildLabeledTextField('Máximo de solicitudes a la vez', maximoSolicitudesController, hintText: 'Días ilimitados'),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _crearTipoAusencia(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5E6EFF),
                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                child: const Text(
                                  'Actualizar tipo de ausencia',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorPalet.grisesGray5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
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

  void _crearTipoAusencia(BuildContext context) async {
    final provider = Provider.of<AusenciasTipoUpdateProvider>(context, listen: false);

    // print('Nombre Tipo Ausencia: ${nombreTipoAusenciaController.text}');
    // print('Color Seleccionado: ${provider.getSelectedColor}');
    // print('Opción 1 Seleccionada: ${provider.getSelectedOption1}');
    // print('Opción 2 Seleccionada: ${provider.getSelectedOption2}');
    // print('Opción 3 Seleccionada: ${provider.getSelectedOption3}');
    // print('Opción 4 Seleccionada: ${provider.getSelectedOption4}');
    // print('Opción 5 Seleccionada: ${provider.getSelectedOption5}');
    // print('Solicitud Mínima: ${solicitudMinimaController.text}');
    // print('Máximo de Solicitudes: ${maximoSolicitudesController.text}');

    if (nombreTipoAusenciaController.text.isEmpty ||
        provider.getSelectedColor == null ||
        provider.getSelectedOption1 == 'Seleccionar...' ||
        provider.getSelectedOption2 == 'Seleccionar...' ||
        provider.getSelectedOption3 == 'Seleccionar...' ||
        provider.getSelectedOption4 == 'Seleccionar...' ||
        provider.getSelectedOption5 == 'Seleccionar...' ||
        solicitudMinimaController.text.isEmpty ||
        maximoSolicitudesController.text.isEmpty) {
      mostrarSnackBar(context, 'Por favor complete todos los campos requeridos');

      return;
    }

    final String colorHex = '#${provider.getSelectedColor!.value.toRadixString(16).padLeft(8, '0').substring(2)}';

    try {
      await provider.updateAusencia(nombreTipoAusenciaController.text, solicitudMinimaController.text, maximoSolicitudesController.text, colorHex);
      mostrarSnackBar(context, 'Tipo de ausencia actualizado correctamente');
    } catch (e) {
      mostrarSnackBar(context, 'Error al actualizar el tipo de ausencia');
    }
    Navigator.pop(context, true);
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller, {String hintText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray2)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorPalet.backGroundColor,
          ),
          child: TextField(
            controller: controller, // Asignar el TextEditingController aquí
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdown(String label, BuildContext context, int index) {
    final provider = Provider.of<AusenciasTipoUpdateProvider>(context, listen: false);
    List<String> opciones = [];

    if (label == '¿Descuenta tiempo de mi contador de ausencias?') {
      opciones = ['Seleccionar...', 'Si, descuenta tiempo.', 'No, no descuenta tiempo.'];
    } else if (label == '¿Necesita ser aprobado?') {
      opciones = ['Seleccionar...', 'Si, requiere ser aprobado.', 'No, se aprobará automáticamente.'];
    } else if (label == '¿Permite un documento adjunto?') {
      opciones = ['Seleccionar...', 'Si, lo permite.', 'No, no lo permite.'];
    } else if (label == '¿El nombre de la ausencia es visible para el resto de los empleados/as?') {
      opciones = ['Seleccionar...', 'Si, es visible.', 'No, no es visible.'];
    } else if (label == '¿El tipo de ausencia es un día laborable?') {
      opciones = [
        'Seleccionar...',
        'Si, durante la ausencia se cuenta que el empleado está trabajando.',
        'No, durante la ausencia no se cuenta que el empleado está trabajando.'
      ];
    }

    String? currentValue;
    switch (index) {
      case 1:
        currentValue = provider.getSelectedOption1;
        break;
      case 2:
        currentValue = provider.getSelectedOption2;
        break;
      case 3:
        currentValue = provider.getSelectedOption3;
        break;
      case 4:
        currentValue = provider.getSelectedOption4;
        break;
      case 5:
        currentValue = provider.getSelectedOption5;
        break;
    }

    if (!opciones.contains(currentValue)) {
      switch (index) {
        case 1:
          provider.setSelectedOption1('Seleccionar...');
          break;
        case 2:
          provider.setSelectedOption2('Seleccionar...');
          break;
        case 3:
          provider.setSelectedOption3('Seleccionar...');
          break;
        case 4:
          provider.setSelectedOption4('Seleccionar...');
          break;
        case 5:
          provider.setSelectedOption5('Seleccionar...');
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorPalet.grisesGray1)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: ColorPalet.backGroundColor,
          ),
          child: DropdownButtonHideUnderline(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      iconSize: 0.0,
                      value: currentValue,
                      items: opciones.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPalet.grisesGray1,
                              )),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        switch (index) {
                          case 1:
                            provider.setSelectedOption1(newValue!);
                            break;
                          case 2:
                            provider.setSelectedOption2(newValue!);
                            break;
                          case 3:
                            provider.setSelectedOption3(newValue!);
                            break;
                          case 4:
                            provider.setSelectedOption4(newValue!);
                            break;
                          case 5:
                            provider.setSelectedOption5(newValue!);
                            break;
                        }
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.arrow_drop_down, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorOptions() {
    return Consumer<AusenciasTipoUpdateProvider>(
      builder: (context, provider, child) {
        List<Color> colors = [
          const Color.fromARGB(255, 252, 10, 187),
          const Color.fromARGB(255, 231, 13, 93),
          const Color.fromARGB(255, 239, 67, 5),
          const Color.fromARGB(255, 255, 170, 59),
          const Color.fromARGB(255, 255, 236, 60),
          const Color.fromARGB(255, 4, 191, 216),
          const Color.fromARGB(255, 3, 131, 92),
          const Color.fromARGB(255, 9, 172, 242),
          const Color.fromARGB(255, 0, 98, 218),
          const Color.fromARGB(255, 102, 5, 247),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors.map((color) => _colorOption(context, color, provider)).toList(),
        );
      },
    );
  }

  Widget _colorOption(BuildContext context, Color color, AusenciasTipoUpdateProvider provider) {
    bool isSelected = provider.getSelectedColor == color;
    return GestureDetector(
      onTap: () {
        provider.setSelectedColor(color);
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: isSelected ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
