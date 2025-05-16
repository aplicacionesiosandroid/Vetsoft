import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/card_view.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/horario_card_option.dart';
import 'package:vet_sotf_app/providers/horario/admin_horario_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/loading_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'crear_horario_screen.dart';

class HorarioScreen extends StatelessWidget {
  const HorarioScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHorarioProvider(),
      child: _CreateHorarioScreen(),
    );
  }
}

class _CreateHorarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminHorarioProvider = Provider.of<AdminHorarioProvider>(context);
    if (adminHorarioProvider.isLoading) return const LoadingScreen();

    // En caso de que no haya horarios creados, osea que la lista este vacia
    if (adminHorarioProvider.listaHorarios.isEmpty) {
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
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              'Horarios',
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
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Tipo de horario",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ColorPalet.grisesGray0,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var update = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const CrearHorarioScreen()),
                                      );
                                      if (update == true) {
                                        adminHorarioProvider.getVerHorarios();
                                      }
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Crear horario",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: ColorPalet.estadoNeutral,
                                          ),
                                        ),
                                        SizedBox(width: 5),
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
                              const SizedBox(height: 15),
                              cardView(
                                context,
                                "Horario Flexible",
                                "Con los horarios flexibles podrás definir un número de horas para cada jornada laboral de la semana durante un periodo de tiempo determinado.",
                                ColorPalet.secondaryDefault,
                              ),
                              const SizedBox(height: 15),
                              cardView(
                                context,
                                "Horario Fijo",
                                "Con los horarios fijos podrás definir un horario específico y constante para cada jornada laboral de la semana durante un periodo de tiempo determinado.",
                                ColorPalet.complementViolet3,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Horarios creados",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalet.grisesGray0,
                                ),
                              ),
                              const SizedBox(height: 15),
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
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
                                          child: Text("No hay horarios creados"),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
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
                        icon: const Icon(Iconsax.arrow_left),
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: 24,
                        color: ColorPalet.grisesGray0,
                      ),
                      const Text(
                        'Horarios',
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
                  const SizedBox(height: 15),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tipo de horario",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalet.grisesGray0,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var update = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CrearHorarioScreen()),
                                    );
                                    if (update == true) {
                                      adminHorarioProvider.getVerHorarios();
                                    }
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Crear horario",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: ColorPalet.estadoNeutral,
                                        ),
                                      ),
                                      SizedBox(width: 5),
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
                            const SizedBox(height: 15),
                            cardView(
                              context,
                              "Horario Flexible",
                              "Con los horarios flexibles podrás definir un número de horas para cada jornada laboral de la semana durante un periodo de tiempo determinado.",
                              ColorPalet.secondaryDefault,
                            ),
                            const SizedBox(height: 15),
                            cardView(
                              context,
                              "Horario Fijo",
                              "Con los horarios fijos podrás definir un horario específico y constante para cada jornada laboral de la semana durante un periodo de tiempo determinado.",
                              ColorPalet.complementViolet3,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Horarios creados",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: ColorPalet.grisesGray0,
                              ),
                            ),
                            const SizedBox(height: 15),
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: adminHorarioProvider.listaHorarios.length,
                                itemBuilder: (context, index) {
                                  return horarioCardOption(
                                    context,
                                    adminHorarioProvider.listaHorarios[index].tipoHorario,
                                    adminHorarioProvider.listaHorarios[index].nombreHorario,
                                    adminHorarioProvider.listaHorarios[index].horarioId,
                                    ColorPalet.secondaryDefault,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 50),
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
  }
}
