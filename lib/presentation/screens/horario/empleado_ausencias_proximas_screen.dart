import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/absence_card.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/empty_absence_card.dart';
import 'package:vet_sotf_app/providers/horario/empleado_lista_ausencias_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class EmpleadoAusenciasProximasScreen extends StatelessWidget {
  const EmpleadoAusenciasProximasScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmpleadoListaAusenciasProvider(),
      child: _EmpleadoAusenciasProximasScreen(),
    );
  }
}

class _EmpleadoAusenciasProximasScreen extends StatelessWidget {
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
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                      const Text(
                        "Ausencias próximas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorPalet.grisesGray0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                            itemCount: listaAusenciasProvider.listaAusencias.proximasAusencias.length,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
