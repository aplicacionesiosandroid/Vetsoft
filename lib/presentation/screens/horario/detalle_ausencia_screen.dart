// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/horario/ausencias_solicitadas_model.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/providers/horario/admin_solicitud_ausencias_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class DetalleAusenciaScreen extends StatelessWidget {
  final AusenciasSolicitadasModel ausenciasSolicitadasModel;
  const DetalleAusenciaScreen({super.key, required this.ausenciasSolicitadasModel});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSolicitudAusenciasProvider(),
      child: _DetalleAusenciaScreen(
        ausenciasSolicitadasModel: ausenciasSolicitadasModel,
      ),
    );
  }
}

class _DetalleAusenciaScreen extends StatelessWidget {
  final AusenciasSolicitadasModel ausenciasSolicitadasModel;

  const _DetalleAusenciaScreen({required this.ausenciasSolicitadasModel});
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
                    const SizedBox(width: 5),
                    const Text(
                      'Detalle de la ausencia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                      iconSize: 24,
                      color: ColorPalet.grisesGray0,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ausenciasSolicitadasModel.nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorPalet.grisesGray0,
                              ),
                            ),
                            // picture
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 20,
                              child: ClipOval(
                                child: Image.network(
                                  ausenciasSolicitadasModel.imagen,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Motivo: ${ausenciasSolicitadasModel.motivo}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalet.grisesGray2,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ausencias anuales:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPalet.grisesGray2,
                              ),
                            ),
                            Text(
                              '${ausenciasSolicitadasModel.porcentaje}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorPalet.acentDefault,
                              ),
                            ),
                          ],
                        ),
                        LinearPercentIndicator(
                          padding: const EdgeInsets.all(0),
                          lineHeight: 10.0,
                          percent: ausenciasSolicitadasModel.porcentaje / 100,
                          backgroundColor: ColorPalet.grisesGray3,
                          progressColor: ColorPalet.acentDefault,
                          // rounded corners
                          barRadius: const Radius.circular(16),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha de inicio',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalet.grisesGray0,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ausenciasSolicitadasModel.fechaInicio.toString().substring(0, 10).split('-').reversed.join('/'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ColorPalet.grisesGray1,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha de finalización',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalet.grisesGray0,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ausenciasSolicitadasModel.fechaFin.toString().substring(0, 10).split('-').reversed.join('/'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ColorPalet.grisesGray1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ColorPalet.grisesGray0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ausenciasSolicitadasModel.descripcion,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalet.grisesGray1,
                          ),
                        ),
                        const SizedBox(height: 50),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await adminSolicitudAusenciasProvider.getAprobarAusencia(ausenciasSolicitadasModel.ausenciaId);
                                mostrarSnackBar(context, 'Solicitud aprobada');
                                Navigator.pop(context, true);
                              } catch (e) {
                                mostrarSnackBar(context, 'Error al aprobar la solicitud');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                ColorPalet.secondaryDark,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.clipboard_tick,
                                  color: ColorPalet.grisesGray5,
                                  size: 24,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Aprobar solicitud",
                                  style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(color: ColorPalet.secondaryDark, width: 2),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Denegar solicitud",
                              style: TextStyle(
                                color: ColorPalet.secondaryDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
