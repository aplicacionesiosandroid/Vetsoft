import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/alert_modal.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/admin_horario_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/horario_update_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget horarioCardOption(
  BuildContext context,
  String title,
  String description,
  int horarioId,
  Color lineColor,
) {
  final adminHorarioProvider = Provider.of<AdminHorarioProvider>(context);

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 3, color: lineColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorPalet.grisesGray0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorPalet.grisesGray2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -15,
            right: 0,
            child: Theme(
              data: ThemeData(
                popupMenuTheme: PopupMenuThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  adminHorarioProvider.setSelectHorario(horarioId);
                  if (value == "Editar") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HorarioUpdateScreen(horarioId: horarioId)));
                  } else if (value == "Archivar") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => alertModal(
                        context,
                        '¿Estás seguro/a de que quieres archivar este horario?',
                        'Si archivas esta horario, podrás recuperarla más tarde.',
                        'No, cancelar',
                        'Sí, archivar',
                        ColorPalet.grisesGray5,
                        () {
                          Navigator.pop(context);
                        },
                        () {
                          Navigator.pop(context);
                          adminHorarioProvider.getArchivoHorarios();
                          mostrarSnackBar(context, 'Horario archivado');
                        },
                      ),
                    );
                  } else if (value == "Eliminar") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => alertModal(
                        context,
                        '¿Estás seguro/a de que quieres eliminar este horario?',
                        'Si eliminas esta horario, no podrás recuperarla más tarde.',
                        'No, cancelar',
                        'Sí, eliminar',
                        ColorPalet.grisesGray5,
                        () {
                          Navigator.pop(context);
                        },
                        () {
                          Navigator.pop(context);
                          adminHorarioProvider.deleteEliminarHorarios();
                          mostrarSnackBar(context, 'Horario eliminado');
                        },
                        leftButtonColor: ColorPalet.secondaryDefault,
                        rightButtonColor: ColorPalet.estadoNegative,
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: title,
                    enabled: false,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 3, color: lineColor),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ), // Para que el título no sea seleccionable
                  ),
                  const PopupMenuItem(
                    value: 'Editar',
                    child: Row(
                      children: [
                        Icon(Iconsax.edit),
                        SizedBox(width: 8.0),
                        Text('Editar horario'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Archivar',
                    child: Row(
                      children: [
                        Icon(Iconsax.archive),
                        SizedBox(width: 8.0),
                        Text('Archivar horario'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Eliminar',
                    child: Row(
                      children: [
                        Icon(Iconsax.trash),
                        SizedBox(width: 8.0),
                        Text('Eliminar horario'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
