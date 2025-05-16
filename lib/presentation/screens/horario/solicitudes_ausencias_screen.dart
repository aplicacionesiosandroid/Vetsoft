import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/card_ausencia.dart';
import 'package:vet_sotf_app/providers/horario/admin_solicitud_ausencias_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class SolicitudesAusenciasScreen extends StatelessWidget {
  const SolicitudesAusenciasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSolicitudAusenciasProvider(),
      child: _SolicitudesAusenciasScreen(),
    );
  }
}

class _SolicitudesAusenciasScreen extends StatelessWidget {
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
                    const Text(
                      'Solicitudes de ausencia',
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
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        if (adminSolicitudAusenciasProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (adminSolicitudAusenciasProvider.listaAusenciasSolicitadas.isEmpty)
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
                                    child: Text("No hay solicitudes pendientes"),
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas.length,
                            itemBuilder: (context, index) {
                              var fechaInicio = adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].fechaInicio.toString();
                              var fechaFin = adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].fechaFin.toString();
                              var fechaInicioFormat = fechaInicio.substring(0, 10).split('-').reversed.join('/');
                              var fechaFinFormat = fechaFin.substring(0, 10).split('-').reversed.join('/');
                              return CardAusencia(
                                id: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].ausenciaId,
                                name: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].nombre,
                                reason: 'Motivo: ${adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].motivo}',
                                date: '$fechaInicioFormat - $fechaFinFormat',
                                imageUrl: adminSolicitudAusenciasProvider.listaAusenciasSolicitadas[index].imagen,
                              );
                            },
                          ),
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
