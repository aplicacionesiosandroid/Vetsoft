import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/card_jornadas.dart';
import 'package:vet_sotf_app/providers/horario/admin_horario_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/crear_jornada_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/loading_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class JornadasScreen extends StatelessWidget {
  const JornadasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHorarioProvider(),
      child: _JornadasScreen(),
    );
  }
}

class _JornadasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminHorarioProvider = Provider.of<AdminHorarioProvider>(context);
    if (adminHorarioProvider.isLoading) return const LoadingScreen();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Jornadas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Iconsax.search_normal),
                              onPressed: () {},
                              iconSize: 24,
                              color: ColorPalet.grisesGray0,
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.notification),
                              onPressed: () {},
                              iconSize: 24,
                              color: ColorPalet.grisesGray0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Seleccionar empleado",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalet.grisesGray0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CrearJornadaScreen(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "Asignar Jornada",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ColorPalet.estadoNeutral,
                                      ),
                                    ),
                                    Icon(
                                      Iconsax.add_square,
                                      color: ColorPalet.estadoNeutral,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (adminHorarioProvider.listaEmpleados.isEmpty)
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
                                    child: Text("No hay jornadas asignadas"),
                                  ),
                                ),
                              );
                            },
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: adminHorarioProvider.listaEmpleados.length,
                          itemBuilder: (context, index) {
                            return cardJornadas(
                              name: adminHorarioProvider.listaEmpleados[index].nombreApellidos,
                              role: adminHorarioProvider.listaEmpleados[index].rol,
                              scheduleType: adminHorarioProvider.listaEmpleados[index].tipoHorario,
                              dateRange: adminHorarioProvider.listaEmpleados[index].fechas,
                              imageUrl: adminHorarioProvider.listaEmpleados[index].imagenUser,
                            );
                          },
                        )
                      ],
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
