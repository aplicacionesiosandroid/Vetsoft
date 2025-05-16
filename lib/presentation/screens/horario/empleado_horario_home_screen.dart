import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/notificacion_model.dart';
import 'package:vet_sotf_app/presentation/widgets/drawer_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/avance_empleado.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/calendar_day.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/horizontal_calendar.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/menu_card.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/spline_chart.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import 'package:vet_sotf_app/providers/horario/pantalla_inicio_empleado_provider.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_ausencia_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_fichaje_screen.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

class EmpleadoHorarioHomeScreen extends StatelessWidget {
  const EmpleadoHorarioHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PantallaInicioEmpleadoProvider(),
      child: _EmpleadoHorarioHomeScreen(),
    );
  }
}

class _EmpleadoHorarioHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final pantallaInicioProvider = Provider.of<PantallaInicioEmpleadoProvider>(context);
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;

    final List<CardNotify> cardNotifyList = [];
    // final List<CardNotify> cardNotifyList = [
    //   CardNotify(const Icon(Icons.hourglass_bottom, color: Colors.black), "Hora de cita", "La hora de tu cita medica, se cambio correctamente",
    //       "12:00", ColorPalet.acentDefault),
    //   CardNotify(
    //       const Icon(
    //         Icons.delivery_dining,
    //         color: Colors.black,
    //       ),
    //       "Hora de cita",
    //       "La hora de tu cita medica, se cambio correctamente",
    //       "12:00",
    //       ColorPalet.complementViolet2.withOpacity(0.5)),
    //   CardNotify(
    //       const Icon(Icons.hourglass_bottom), "Hora de cita", "La hora de tu cita medica, se cambio correctamente", "12:00", ColorPalet.primaryDark),
    // ];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: const Color(0xFF5E6EFF),
          leading: Container(
            child: Center(
              child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(color: const Color(0xFF5E6EFF), borderRadius: BorderRadius.circular(10)),
                  //margin: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 12),
                  //padding: EdgeInsets.all(1),
                  child: Builder(builder: (context) {
                    return IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: ImageIcon(
                          AssetImage(
                            'assets/img/menu_icon.png',
                          ),
                          color: Colors.white,
                        ));
                  })),
            ),
          ),
          actions: [
            Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(color: const Color(0xFF5E6EFF), borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(12),
                child: IconButton(
                  icon: Icon(Iconsax.notification_bing),
                  color: ColorPalet.grisesGray5,
                  onPressed: () {
                    final headerModel = Provider.of<HomePetShopProvider>(context, listen: false);
                    headerModel.toggleExpansion();
                  },
                )),
            Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(color: const Color(0xFF5E6EFF), borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(12),
                child: IconButton(
                  icon: Icon(Iconsax.message_text_1),
                  color: ColorPalet.grisesGray5,
                  onPressed: () {},
                )),
          ],
        ),
        backgroundColor: const Color(0xFF5E6EFF),
        body: Column(
          children: [
            AnimatedContainer(
              color: const Color(0xFF5E6EFF),
              duration: const Duration(milliseconds: 500),
              height: isHeaderExpanded ? sizeScreen.height * 0.23 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isHeaderExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Notificaciones',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontFamily: 'sans', fontWeight: FontWeight.w700, fontSize: 28, color: Colors.white),
                      ),
                    ),
                  if (isHeaderExpanded) Notify_card_widget(cardNotifyList: cardNotifyList),
                ],
              ),
            ),
            !isHeaderExpanded
                ? SizedBox(
                    child: Container(
                      height: sizeScreen.height * 0.1,
                      width: double.infinity,
                      color: const Color(0xFF5E6EFF),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            child: Text(
                              'Horario',
                              style: TextStyle(fontFamily: 'sans', fontWeight: FontWeight.w700, fontSize: 28, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(height: 5),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 13),
                decoration: const BoxDecoration(
                  color: ColorPalet.grisesGray5,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          children: [
                            menuCard(context, "Fichaje", "Entrada y salida", Iconsax.task_square, ColorPalet.secondaryDefault, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EmpleadoFichajeScreen()),
                              );
                            }),
                            menuCard(context, "Ausencias", "Solicitar", Iconsax.gps, ColorPalet.secondaryDark, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EmpleadoAusenciaScreen()),
                              );
                            }),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Próximos días libres",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        // read from provider, dashboardService.proximos dias libres becuase is an http request

                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            pantallaInicioProvider.isLoading
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.85,
                                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: ColorPalet.grisesGray3,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : pantallaInicioProvider.proximosDiasLibresModel.isEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return Center(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.85,
                                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(
                                                  color: ColorPalet.grisesGray3,
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Center(child: Text("No hay proximos dias libres")),
                                            ),
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pantallaInicioProvider.proximosDiasLibresModel.length,
                                        itemBuilder: (context, index) {
                                          return calendarCard(
                                              context,
                                              pantallaInicioProvider.proximosDiasLibresModel[index].titulo,
                                              pantallaInicioProvider.proximosDiasLibresModel[index].motivo,
                                              pantallaInicioProvider.proximosDiasLibresModel[index].fecha,
                                              ColorPalet.estadoPositive);
                                        },
                                      ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                          color: ColorPalet.grisesGray5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Mis Horarios",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: ColorPalet.grisesGray2),
                                    onPressed: () {},
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ver todas",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(Iconsax.arrow_circle_right, size: 24.0, color: ColorPalet.grisesGray2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              horizontalCalendar(
                                onDateSelected: (selectedDate) {
                                  pantallaInicioProvider.getGraficaJornadas(selectedDate.toString().split(" ")[0]);
                                },
                              ),
                              SizedBox(
                                height: 450,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    pantallaInicioProvider.isLoadingJornadas
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                              return Center(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.85,
                                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                    border: Border.all(
                                                      color: ColorPalet.grisesGray3,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: const Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : pantallaInicioProvider.horarioAvanceModel.isEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  return Center(
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width * 0.85,
                                                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                        border: Border.all(
                                                          color: ColorPalet.grisesGray3,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: const Center(
                                                        child: Text("No hay empleados"),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Row(
                                                children: [
                                                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                    const SizedBox(height: 35),
                                                    ...List.generate(11, (index) => Text('${index * 10}%')).toList(),
                                                  ]),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: 1,
                                                    itemBuilder: (context, index) {
                                                      return avanceEmpleado(
                                                        context,
                                                        pantallaInicioProvider.horarioAvanceModel[index].imagenUser ??
                                                            '/home/roboto/Documentos/proyectos/lumen/vetsoftProject/vetsoft/public/files/',
                                                        pantallaInicioProvider.horarioAvanceModel[index].nombreCompleto ?? "",
                                                        pantallaInicioProvider.horarioAvanceModel[index].porcentaje ??
                                                            pantallaInicioProvider.horarioAvanceModel[index].jornadaAvanzada!,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Estadisticas personales",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Últimos ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: ColorPalet.grisesGray2,
                                        ),
                                      ),
                                      DropdownButton<String>(
                                        value: pantallaInicioProvider.texto,
                                        icon: const Icon(Iconsax.arrow_circle_down, size: 24.0, color: ColorPalet.grisesGray2),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(color: ColorPalet.grisesGray2),
                                        underline: Container(height: 0),
                                        onChanged: (String? newValue) {
                                          pantallaInicioProvider.texto = newValue!;
                                          pantallaInicioProvider.setNumeroDeDias(int.parse(newValue.split(" ")[0]));
                                        },
                                        items: <String>[
                                          '7 días',
                                          '15 días',
                                          '30 días',
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (!pantallaInicioProvider.isLoading)
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0, right: 30.0, bottom: 20.0),
                                    child: SplineChart(
                                      values1: pantallaInicioProvider.ausencias.isEmpty ? {0: 0} : pantallaInicioProvider.ausencias,
                                      values2: pantallaInicioProvider.asistencias.isEmpty ? {0: 0} : pantallaInicioProvider.asistencias,
                                      verticalLineEnabled: false,
                                      verticalLinePosition: 1.0,
                                      verticalLineStrokeWidth: 2.0,
                                      xStart: 0,
                                      xStep: 1,
                                      xEnd: pantallaInicioProvider.dashboardModel != null
                                          ? pantallaInicioProvider.dashboardModel!.ejes.ejeX.length.toDouble()
                                          : 1,
                                      yStart: 0,
                                      yStep: 1,
                                      yEnd: pantallaInicioProvider.dashboardModel != null
                                          ? pantallaInicioProvider
                                              .dashboardModel!.ejes.ejeY[pantallaInicioProvider.dashboardModel!.ejes.ejeY.length - 1]
                                              .toDouble()
                                          : 1,
                                      drawCircles: true,
                                      circleRadius: 4,
                                      width: double.infinity,
                                      height: 300,
                                      legend1: "Ausencias",
                                      legend2: "Asistencias",
                                    ),
                                  ),
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorPalet.primaryDefault,
                                  ),
                                ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
