import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/horario/admin_solicitud_ausencias_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/detalle_ausencia_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class CardAusencia extends StatelessWidget {
  final int id;
  final String name;
  final String reason;
  final String date;
  final String imageUrl;

  const CardAusencia({
    super.key,
    required this.id,
    required this.name,
    required this.reason,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final adminSolicitudAusenciasProvider = Provider.of<AdminSolicitudAusenciasProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 3, color: ColorPalet.estadoNeutral),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reason,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalet.grisesGray2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Iconsax.calendar_2, size: 16),
                        const SizedBox(width: 8.0),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorPalet.grisesGray1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -8,
              right: 10.0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
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
            ),
            Positioned(
              top: -15,
              right: 0,
              child: PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 1) {
                    adminSolicitudAusenciasProvider.setAusenciaSeleccionada(id);
                    final update = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleAusenciaScreen(
                          ausenciasSolicitadasModel: adminSolicitudAusenciasProvider.ausenciaSeleccionada!,
                        ),
                      ),
                    );
                    if (update != null) {
                      if (update) {
                        adminSolicitudAusenciasProvider.getListaAusenciasSolicitadas();
                      }
                    }
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Iconsax.edit),
                        SizedBox(width: 8.0),
                        Text('Detalle de ausencia'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
