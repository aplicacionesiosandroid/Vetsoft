import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/card_view.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'crear_jornada_screen.dart';

class JornadaHorarioScreen extends StatelessWidget {
  const JornadaHorarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Asignar horario",
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
                                MaterialPageRoute(builder: (context) => const CrearJornadaScreen()),
                              );
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
                    ],
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
