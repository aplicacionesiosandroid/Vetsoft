// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/employee_file.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/file_percentage.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/file_ticket.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/empleado_fichaje_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/qr_scan_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class EmpleadoFichajeScreen extends StatelessWidget {
  const EmpleadoFichajeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmpleadoFichajeProvider(),
      child: _EmpleadoFichajeScreen(),
    );
  }
}

class _EmpleadoFichajeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final empleadoFichajeProvider = Provider.of<EmpleadoFichajeProvider>(context);
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
                      'Fichaje',
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
                              if (!empleadoFichajeProvider.isLoading)
                                filePercentage(
                                  context,
                                  (empleadoFichajeProvider.horarioAvanceModel.porcentaje == 0)
                                      ? '¡Aun no comenzaste tu jornada laboral! Ficha tu entrada para comenzar'
                                      : (empleadoFichajeProvider.horarioAvanceModel.porcentaje == 1)
                                          ? '¡Completaste tu jornada laboral!'
                                          : '¡Estas a punto de completar tu jornada laboral!',
                                  empleadoFichajeProvider.horarioAvanceModel.porcentaje / 100,
                                  ColorPalet.secondaryLight,
                                  ColorPalet.secondaryDefault,
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanScreen()));
                                    if (result == null) return;
                                    if (result.toString().isEmpty) return;
                                    if (result.toString().contains('jornada') || result.toString().contains('horario')) {
                                      empleadoFichajeProvider.setCodigo(result.toString());
                                      empleadoFichajeProvider.getFicharEntrada();
                                      mostrarSnackBar(context, 'Fichaje de entrada realizado con éxito');
                                    } else {
                                      mostrarSnackBar(context, 'El código QR no es válido');
                                    }
                                  } catch (e) {
                                    mostrarSnackBar(context, 'El código QR no es válido');
                                  }
                                },
                                child: WidgetfileTicket(
                                  context,
                                  Iconsax.document_text_1,
                                  'Fichar entrada',
                                  ColorPalet.grisesGray5,
                                  ColorPalet.secondaryDark,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanScreen()));
                                    if (result == null) return;
                                    if (result.toString().isEmpty) return;
                                    if (result.toString().contains('jornada') || result.toString().contains('horario')) {
                                      empleadoFichajeProvider.setCodigo(result.toString());
                                      empleadoFichajeProvider.getFicharSalida();
                                      mostrarSnackBar(context, 'Fichaje de entrada realizado con éxito');
                                    } else {
                                      mostrarSnackBar(context, 'El código QR no es válido');
                                    }
                                  } catch (e) {
                                    mostrarSnackBar(context, 'El código QR no es válido');
                                  }
                                },
                                child: WidgetfileTicket(
                                  context,
                                  Iconsax.calendar_edit,
                                  'Fichar salida',
                                  ColorPalet.grisesGray5,
                                  ColorPalet.secondaryDark,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Jornada del día',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (!empleadoFichajeProvider.isLoading)
                                employeeFile(
                                  context,
                                  '/home/roboto/Documentos/proyectos/lumen/vetsoftProject/vetsoft/public/files/',
                                  empleadoFichajeProvider.horarioAvanceModel.nombreCompleto,
                                  empleadoFichajeProvider.horarioAvanceModel.rol,
                                  (empleadoFichajeProvider.horarioAvanceModel.fichaEntrada == '' &&
                                          empleadoFichajeProvider.horarioAvanceModel.fichaSalida == '')
                                      ? 'Pendiente'
                                      : (empleadoFichajeProvider.horarioAvanceModel.fichaEntrada != '' &&
                                              empleadoFichajeProvider.horarioAvanceModel.fichaSalida == '')
                                          ? 'En curso'
                                          : 'Finalizado',
                                  (empleadoFichajeProvider.horarioAvanceModel.fichaEntrada == '' &&
                                          empleadoFichajeProvider.horarioAvanceModel.fichaSalida == '')
                                      ? 'XX:XX'
                                      : (empleadoFichajeProvider.horarioAvanceModel.fichaEntrada != '' &&
                                              empleadoFichajeProvider.horarioAvanceModel.fichaSalida == '')
                                          ? 'XX:XX'
                                          : 'XX:XX',
                                  empleadoFichajeProvider.horarioAvanceModel.mensaje,
                                  empleadoFichajeProvider.horarioAvanceModel.fichaEntrada,
                                  empleadoFichajeProvider.horarioAvanceModel.fichaSalida,
                                  empleadoFichajeProvider.horarioAvanceModel.horarioAsignado,
                                  ColorPalet.grisesGray2.withOpacity(0.2),
                                  ColorPalet.secondaryDefault,
                                  empleadoFichajeProvider.horarioAvanceModel.porcentaje / 100,
                                  clientButton: false,
                                  isExpanded: empleadoFichajeProvider.isExpanded,
                                  onTap: () {
                                    empleadoFichajeProvider.switchIsExpanded();
                                  },
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
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
}
