import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/update_horario_from.dart';
import 'package:vet_sotf_app/providers/horario/admin_horario_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class HorarioUpdateScreen extends StatelessWidget {
  final int horarioId;
  const HorarioUpdateScreen({Key? key, required this.horarioId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHorarioProvider.horarioId(horarioId),
      child: _HorarioUpdateScreen(),
    );
  }
}

class _HorarioUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminHorarioProvider = Provider.of<AdminHorarioProvider>(context);
    if (adminHorarioProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Editar Horario',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorPalet.grisesGray0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 24,
                      color: ColorPalet.grisesGray0,
                    ),
                  ],
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: UpdateHorarioForm(
                        horario: adminHorarioProvider.horarioUpdateModel!,
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
