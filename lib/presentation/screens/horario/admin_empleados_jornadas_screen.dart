import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/employee_file.dart';
import 'package:vet_sotf_app/providers/horario/admin_fichaje_provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

class AdminEmpeadosJornadasScreen extends StatelessWidget {
  const AdminEmpeadosJornadasScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminFichajeProvider(),
      child: _AdminEmpleadosJornadasProvider(),
    );
  }
}

class _AdminEmpleadosJornadasProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminFichajeProvider = Provider.of<AdminFichajeProvider>(context);

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
            padding: const EdgeInsets.all(24.0),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                      const Text(
                        "Jornadas del día",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorPalet.grisesGray0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: ColorPalet.grisesGray0,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  adminFichajeProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : adminFichajeProvider.horarioAvanceModel.isEmpty
                          ? ListView.builder(
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
                                      child: Text("No hay jornadas asignadas"),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: adminFichajeProvider.horarioAvanceModel.length,
                              itemBuilder: (context, index) {
                                return employeeFile(
                                  context,
                                  '/home/roboto/Documentos/proyectos/lumen/vetsoftProject/vetsoft/public/files/',
                                  adminFichajeProvider.horarioAvanceModel[index].nombreCompleto,
                                  adminFichajeProvider.horarioAvanceModel[index].rol,
                                  (adminFichajeProvider.horarioAvanceModel[index].fichaEntrada == '' &&
                                          adminFichajeProvider.horarioAvanceModel[index].fichaSalida == '')
                                      ? 'Pendiente'
                                      : (adminFichajeProvider.horarioAvanceModel[index].fichaEntrada != '' &&
                                              adminFichajeProvider.horarioAvanceModel[index].fichaSalida == '')
                                          ? 'En curso'
                                          : 'Finalizado',
                                  (adminFichajeProvider.horarioAvanceModel[index].fichaEntrada == '' &&
                                          adminFichajeProvider.horarioAvanceModel[index].fichaSalida == '')
                                      ? 'XX:XX'
                                      : (adminFichajeProvider.horarioAvanceModel[index].fichaEntrada != '' &&
                                              adminFichajeProvider.horarioAvanceModel[index].fichaSalida == '')
                                          ? 'XX:XX'
                                          : 'XX:XX',
                                  adminFichajeProvider.horarioAvanceModel[index].mensaje,
                                  adminFichajeProvider.horarioAvanceModel[index].fichaEntrada,
                                  adminFichajeProvider.horarioAvanceModel[index].fichaSalida,
                                  adminFichajeProvider.horarioAvanceModel[index].horarioAsignado,
                                  ColorPalet.grisesGray2.withOpacity(0.2),
                                  ColorPalet.secondaryDefault,
                                  adminFichajeProvider.horarioAvanceModel[index].porcentaje / 100,
                                  clientButton: false,
                                  isExpanded: adminFichajeProvider.isExpandedList[index],
                                  onTap: () {
                                    adminFichajeProvider.switchIsExpanded(index);
                                  },
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
