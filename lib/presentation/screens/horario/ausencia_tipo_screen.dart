// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/horario/admin_lista_ausencias_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/ausencia_tipo_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/loading_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'ausencia_nuevo_tipo_screen.dart';

class AusenciasTipoScreen extends StatelessWidget {
  const AusenciasTipoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminListaAusenciasProvider(),
      child: const _AusenciasTipoScreen(),
    );
  }
}

class _AusenciasTipoScreen extends StatelessWidget {
  const _AusenciasTipoScreen();
  @override
  Widget build(BuildContext context) {
    final listaAusenciasProvider = Provider.of<AdminListaAusenciasProvider>(context);
    if (listaAusenciasProvider.isLoading) return const LoadingScreen();
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
                      'Tipo de ausencia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {},
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gestiona los tipos de ausencia dentro de tu empresa para que tus empleados/as puedan seleccionarlos cuando soliciten una ausencia.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPalet.grisesGray2,
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            _addNewTypeButton(context),
                            const SizedBox(height: 20.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listaAusenciasProvider.listaAusenciasAdmin.length,
                              itemBuilder: (context, index) {
                                return _ausenciaTypeItem(
                                  context,
                                  listaAusenciasProvider.listaAusenciasAdmin[index].nombreAusencia,
                                  Color(int.parse(listaAusenciasProvider.listaAusenciasAdmin[index].color.replaceAll('#', '0xFF'))),
                                  listaAusenciasProvider.listaAusenciasAdmin[index].tipoAusenciaId,
                                );
                              },
                            ),
                            // _ausenciaTypeItem('Vacaciones', Colors.purple),
                            // _ausenciaTypeItem('Enfermedad', Colors.red),
                            // _ausenciaTypeItem('Enfermedad de un familiar', Colors.pink),
                            // _ausenciaTypeItem('Maternidad / Paternidad', Colors.orange),
                            // _ausenciaTypeItem('Compensación por tiempo de servicios', Colors.yellow),
                            // _ausenciaTypeItem('Otro', Colors.blue),
                          ],
                        ),
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

  Widget _addNewTypeButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final update = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AusenciasNuevoTipoScreen()));
        if (update != null) {
          if (update) {
            final listaAusenciasProvider = Provider.of<AdminListaAusenciasProvider>(context, listen: false);
            listaAusenciasProvider.getListaAusenciasAdmin();
          }
        }
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Iconsax.add_square, size: 24, color: ColorPalet.estadoNeutral),
          SizedBox(width: 10),
          Text(
            'Añadir nuevo tipo de ausencia',
            style: TextStyle(
              color: ColorPalet.estadoNeutral,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _ausenciaTypeItem(BuildContext context, String title, Color color, int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 8,
              ),
              const SizedBox(width: 20),
              Container(
                color: ColorPalet.grisesGray4,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorPalet.grisesGray1,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              final update = await Navigator.push(context, MaterialPageRoute(builder: (context) => AusenciasTipoUpdateScreen(id: id)));
              if (update != null) {
                if (update) {
                  final listaAusenciasProvider = Provider.of<AdminListaAusenciasProvider>(context, listen: false);
                  listaAusenciasProvider.getListaAusenciasAdmin();
                }
              }
            },
            child: const Icon(
              Iconsax.setting_24,
              size: 20,
              color: ColorPalet.grisesGray2,
            ),
          )
        ],
      ),
    );
  }
}
