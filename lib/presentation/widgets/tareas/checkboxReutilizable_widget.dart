import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/tareas/objetivos_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';

import '../../../config/global/palet_colors.dart';


class ReusableCheckboxFechaIniFin extends StatelessWidget {
  final String desc;
  final bool value;
  final Function(bool?) onChanged;

  const ReusableCheckboxFechaIniFin(
      {super.key,
      required this.desc,
      required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Consumer<TareasProvider>(
      builder: (context, checkboxModel, child) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.5),
              ),
              side: BorderSide(
                  color: Color.fromARGB(255, 160, 128, 203), width: 2),
              activeColor: Color.fromARGB(255, 65, 0, 152),
              value: value,
              onChanged: onChanged,

            ),
            Text(
              desc,
              style: const TextStyle(
                  fontFamily: 'inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 29, 39, 44)),
            )
          ],
        );
      },
    );
  }
}


//agregar recompensa para el formulario de crear oobjetivo
class ReusableCheckboxAddRecompensa extends StatelessWidget {
  final String desc;
  final bool value;
  final Function(bool?) onChanged;

  const ReusableCheckboxAddRecompensa(
      {super.key,
      required this.desc,
      required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Consumer<ObjetivosProvider>(
      builder: (context, checkboxModel, child) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.5),
              ),
              side: BorderSide(
                  color: ColorPalet.primaryLight, width: 2),
              activeColor: ColorPalet.primaryDefault,
              value: value,
              onChanged: onChanged,

            ),
            Text(
              desc,
              style: const TextStyle(
                  fontFamily: 'inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 29, 39, 44)),
            )
          ],
        );
      },
    );
  }
}
