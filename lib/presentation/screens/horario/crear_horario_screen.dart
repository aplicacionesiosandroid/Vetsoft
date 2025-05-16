import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/crear_horario_form.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class CrearHorarioScreen extends StatelessWidget {
  const CrearHorarioScreen({super.key});

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
                          'Crear Horario',
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
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CrearHorarioForm(),
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
