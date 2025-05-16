import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/absence_card.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/empty_absence_card.dart';
// import 'package:vet_sotf_app/presentation/widgets/horario/file_percentage.dart';
import 'package:vet_sotf_app/providers/horario/empleado_lista_ausencias_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_ausencias_pasadas_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_ausencias_proximas_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_nueva_ausencia_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class EmpleadoAusenciaScreen extends StatelessWidget {
  const EmpleadoAusenciaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmpleadoListaAusenciasProvider(),
      child: const _EmployeeAbsenceScreen(),
    );
  }
}

class _EmployeeAbsenceScreen extends StatelessWidget {
  const _EmployeeAbsenceScreen();
  @override
  Widget build(BuildContext context) {
    final listaAusenciasProvider = Provider.of<EmpleadoListaAusenciasProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF5E6EFF),
        body: Container(
          margin: const EdgeInsets.only(top: 75),
          decoration: const BoxDecoration(
            color: ColorPalet.backGroundColor,
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
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              // filePercentage(
                              //   context,
                              //   '¡Aún te quedan 5 días libres para tomarte vacaciones!',
                              //   0.75,
                              //   ColorPalet.secondaryLight,
                              //   ColorPalet.secondaryDefault,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: ColorPalet.grisesGray2),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const EmpleadoNNuevaAusenciaScreen()),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Añadir ausencia',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalet.estadoNeutral,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Iconsax.add_square,
                                          size: 24.0,
                                          color: ColorPalet.estadoNeutral,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Próximas ausencias',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: ColorPalet.grisesGray2),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EmpleadoAusenciasProximasScreen()));
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
                              if (!listaAusenciasProvider.isLoading)
                                listaAusenciasProvider.listaAusencias.proximasAusencias.isEmpty
                                    ? emptyAbsenceCard(
                                        context,
                                        ColorPalet.grisesGray5,
                                        ColorPalet.grisesGray0,
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return absenceCard(
                                            context,
                                            listaAusenciasProvider.listaAusencias.proximasAusencias[index].fechaInicio,
                                            listaAusenciasProvider.listaAusencias.proximasAusencias[index].fechaFin,
                                            listaAusenciasProvider.listaAusencias.proximasAusencias[index].nombreAusencia,
                                            listaAusenciasProvider.listaAusencias.proximasAusencias[index].estado,
                                            ColorPalet.grisesGray5,
                                            ColorPalet.grisesGray0,
                                            ColorPalet.grisesGray1,
                                            Colors.red,
                                          );
                                        },
                                      )
                              else
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorPalet.primaryDefault,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Ausencias pasadas",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: ColorPalet.grisesGray2),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EmpleadoAusenciasPasadasScreen()));
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
                              if (!listaAusenciasProvider.isLoading)
                                listaAusenciasProvider.listaAusencias.ausenciasPasadas.isEmpty
                                    ? emptyAbsenceCard(
                                        context,
                                        ColorPalet.grisesGray5,
                                        ColorPalet.grisesGray0,
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              absenceCard(
                                                context,
                                                listaAusenciasProvider.listaAusencias.ausenciasPasadas[index].fechaInicio,
                                                listaAusenciasProvider.listaAusencias.ausenciasPasadas[index].fechaFin,
                                                'Ausencia Aprobada',
                                                listaAusenciasProvider.listaAusencias.ausenciasPasadas[index].nombreAusencia,
                                                ColorPalet.grisesGray5,
                                                ColorPalet.grisesGray0,
                                                ColorPalet.grisesGray1,
                                                Colors.pink,
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          );
                                        },
                                      )
                              else
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorPalet.primaryDefault,
                                  ),
                                ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calendario',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _calendarSection(),
                            ],
                          ),
                        ],
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
        const SizedBox(height: 20.0),
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
