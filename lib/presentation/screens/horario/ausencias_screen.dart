import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/card_ausencia.dart';
import 'package:vet_sotf_app/providers/horario/admin_solicitud_ausencias_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/solicitudes_ausencias_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'ausencia_tipo_screen.dart';
import 'evento_nuevo_screen.dart';

class AusenciasScreen extends StatelessWidget {
  final String selectedTab = "Todos";

  const AusenciasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSolicitudAusenciasProvider(),
      child: _AusenciasScreen(),
    );
  }
}

class _AusenciasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminSolicitudAusenciasProvider = Provider.of<AdminSolicitudAusenciasProvider>(context);
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
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 24,
                      color: ColorPalet.grisesGray0,
                    ),
                    const Text(
                      'Ausencias',
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
                        // Añade este widget
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Encabezado con íconos y título
                            // Resto del contenido original
                            _buttonsSection(context),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Solicitudes pendientes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0,
                                        color: ColorPalet.grisesGray0,
                                      ),
                                    ),
                                    Text(
                                      '(${adminSolicitudAusenciasProvider.listaAusenciasSolicitadas.length})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: ColorPalet.secondaryDefault,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(foregroundColor: ColorPalet.grisesGray2),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SolicitudesAusenciasScreen()));
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ver todas",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Iconsax.arrow_circle_right, size: 24.0, color: ColorPalet.grisesGray2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2.0),
                            if (adminSolicitudAusenciasProvider.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (adminSolicitudAusenciasProvider.listaAusenciasSolicitadas.isEmpty)
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: ColorPalet.grisesGray3,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text("No hay solicitudes pendientes"),
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  var fechaInicio = adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].fechaInicio.toString();
                                  var fechaFin = adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].fechaFin.toString();
                                  var fechaInicioFormat = fechaInicio.substring(0, 10).split('-').reversed.join('/');
                                  var fechaFinFormat = fechaFin.substring(0, 10).split('-').reversed.join('/');
                                  return CardAusencia(
                                    id: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].ausenciaId,
                                    name: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].nombre,
                                    reason: 'Motivo: ${adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].motivo}',
                                    date: '$fechaInicioFormat - $fechaFinFormat',
                                    imageUrl: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].imagen,
                                  );
                                },
                              ),
                            const SizedBox(height: 20.0),
                            _calendarSection(),
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

  Widget _buttonsSection(BuildContext context) {
    return Column(
      children: [
        _customButton(
          context,
          Iconsax.document_text,
          'Tipo de ausencia',
          ColorPalet.grisesGray5,
          ColorPalet.secondaryDark,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AusenciasTipoScreen()),
            );
          },
        ),
        const SizedBox(height: 15.0),
        _customButton(
          context,
          Iconsax.calendar_edit,
          'Vista del equipo',
          ColorPalet.secondaryDark,
          ColorPalet.secondaryLight,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NuevoEventoScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _customButton(BuildContext context, IconData icon, String title, Color textColor, Color bgColor, {VoidCallback? onPressed}) {
    return InkWell(
      // <-- Agrega este InkWell aquí
      onTap: onPressed, // <-- y este onTap
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: textColor,
            ),
            const SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarSection() {
    String? selectedOption = 'Mensual';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calendario',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0), // Reduce el padding vertical para ajustar el alto
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: SizedBox(
                  // Agregamos un SizedBox
                  height: 30.0, // Definimos una altura específica
                  child: DropdownButton<String>(
                    value: selectedOption,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        print('Opción seleccionada: $newValue');
                        selectedOption = newValue;
                      }
                    },
                    elevation: 0,
                    style: const TextStyle(color: Colors.black),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    items: ['Mensual', 'Vista del equipo'].map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    underline: Container(),
                    dropdownColor: Colors.white,
                    iconSize: 24,
                    iconEnabledColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 20.0),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       botomRow('Todos', selectedTab == 'Todos'),
        //       botomRow('Ausencias Solicitadas', selectedTab == 'Ausencias Solicitadas'),
        //       botomRow('Ausencias No planificadas', selectedTab == 'Ausencias No planificadas'),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 20.0),
        selectedOption == 'Mensual'
            ? _monthlyCalendar()
            : Container(
                color: Colors.white,
                height: 200.0,
              ),
      ],
    );
  }

  Widget _monthlyCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
    );
  }
}
