import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/tareas/model_tareas_progreso.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/crear_tarea_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/objetivos/tablero_objetivos_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verTareas_screen.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../../providers/tareas/objetivos_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import '../tareas/objetivos/crear_objetivos_screen.dart';

class TareasScreen extends StatelessWidget {
  TareasScreen({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cargadoTarea = false;
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;

    final dataTareas = Provider.of<TareasProvider>(context);
    final dataObjetivos = Provider.of<ObjetivosProvider>(context);
    final listaTareasEnProgreso = dataTareas.tareasProgreso;
    final listaActRecientesTareas = dataTareas.getTareasActReciente;
    final porcentajeTareaHome =  dataTareas.getTareaPorcentajeHome;
    final porcentajeObjetivoHome =  dataObjetivos.getObjetivoPorcentajeHome;
    final notificationsProvider = Provider.of<NotificationsProvider>(context);


    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;


    final List<String> usernames = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    // Agrega más nombres de usuario según tu lista
  ];

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Color(0xFF735CFF),
            leading: Container(
              child: Center(
                child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: Color(0xFF6B64FF),
                        borderRadius: BorderRadius.circular(10)),
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
                  decoration: BoxDecoration(
                      color: Color(0x636B64FF),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(12),
                  child: IconButton(
                    icon: Icon(Iconsax.notification_bing),
                    color: ColorPalet.grisesGray5,
                    onPressed: () {
                      final headerModel = Provider.of<HomePetShopProvider>(
                          context,
                          listen: false);
                      headerModel.toggleExpansion();
                    },
                  )),
              Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                      color: Color(0x636B64FF),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(12),
                  child: IconButton(
                    icon: Icon(Iconsax.message_text_1),
                    color: ColorPalet.grisesGray5,
                    onPressed: () {},
                  )),
            ],
          ),
          key: _scaffoldKey,
          backgroundColor: Color(0xFF735CFF),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                color: Color(0xFF735CFF),
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
                          style: TextStyle(
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: Colors.white),
                        ),
                      ),
                    if (isHeaderExpanded)
                      Notify_card_widget(cardNotifyList: cardNotifyList),
                  ],
                ),
              ),
              AnimatedContainer(
                color: Color(0xFF735CFF),
                duration: const Duration(milliseconds: 500),
                height: !isHeaderExpanded ? 80 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 15),
                      child: Text(
                        'Tareas',
                        style: TextStyle(
                            fontFamily: 'sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //height: sizeScreen.height * 0.681,
                  width: sizeScreen.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 247, 246),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          FlipCard(porcentajeTareaHome,porcentajeObjetivoHome, sizeScreen),
                            // tareasObjetivosView(porcentajeTareaHome.mensaje,porcentajeObjetivoHome.mensaje, (){},sizeScreen),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: Color.fromARGB(255, 94, 65, 211),
                          //       borderRadius: BorderRadius.circular(10)),
                          //   padding: EdgeInsets.all(30),
                          //   child: Row(
                          //     children: [
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           SizedBox(
                          //             width: sizeScreen.width * 0.5,
                          //             child: Text(
                          //                 "Estas a solo 3 tareas  de terminar las tareas del día",
                          //                 textAlign: TextAlign.left,
                          //                 style: TextStyle(
                          //                   fontFamily: 'sans',
                          //                   color: Color.fromARGB(
                          //                       255, 255, 255, 255),
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.w700,
                          //                 )),
                          //           ),
                          //           ElevatedButton(
                          //               style: ElevatedButton.styleFrom(
                          //                   elevation: 0,
                          //                   backgroundColor: Color.fromARGB(
                          //                       255, 255, 255, 255),
                          //                   shape: RoundedRectangleBorder(
                          //                       borderRadius:
                          //                           BorderRadius.circular(10))),
                          //               onPressed: () {
                          //                 dataTareas
                          //                     .listaFiltradaTareaFechas.clear;
                          //                 dataTareas.getTareasPorFecha.clear();
                          //                 openModalBottomSheetVerTareas(
                          //                     context);
                          //                 dataTareas.getTareasFecha('');
                          //                 /* Navigator.of(context)
                          //                     .pushNamed('/verTareasScreen'); */
                          //               },
                          //               child: const Text(
                          //                 'Ver tareas',
                          //                 style: TextStyle(
                          //                     color: Color.fromARGB(
                          //                         255, 32, 0, 76),
                          //                     fontFamily: 'inter',
                          //                     fontSize: 14,
                          //                     fontWeight: FontWeight.w600),
                          //               ))
                          //         ],
                          //       ),
                          //       const Expanded(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: [
                          //             Stack(
                          //               alignment: Alignment.center,
                          //               children: [
                          //                 SizedBox(
                          //                   width: 80,
                          //                   height: 80,
                          //                   child: CircularProgressIndicator(
                          //                       color: Color.fromARGB(
                          //                           255, 255, 255, 255),
                          //                       strokeWidth: 10,
                          //                       value: 0.75,
                          //                       backgroundColor: Colors.grey),
                          //                 ),
                          //                 Text(
                          //                   '75%',
                          //                   style: TextStyle(
                          //                     fontFamily: 'sans',
                          //                     fontWeight: FontWeight.w700,
                          //                     fontSize: 20,
                          //                     color: Color.fromARGB(
                          //                         255, 255, 255, 255),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: SizedBox(
                              width: sizeScreen.width * 1,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        openModalBottomSheetCrearTarea(context);
                                      },
                                      child: Container(
                                        //width: sizeScreen.width * 0.42,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 115, 92, 255),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 133, 113, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Iconsax.task_square,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Tareas',
                                              style: TextStyle(
                                                fontFamily: 'sans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            const Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Crear tarea',
                                                    style: TextStyle(
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: sizeScreen.width * 0.03,
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        openModalBottomSheetCrearObjetivo(
                                            context);
                                      },
                                      child: Container(
                                        //width: sizeScreen.width * 0.42,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 49, 46, 128),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 72, 69, 151),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Iconsax.gps,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Objetivos',
                                              style: TextStyle(
                                                fontFamily: 'sans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            const Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Crear objetivo',
                                                    style: TextStyle(
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: sizeScreen.width,
                            child: Row(
                              children: [
                                const Text("Tarea en progreso",
                                    style: TextStyle(
                                      fontFamily: 'sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )),
                                Text("(${listaTareasEnProgreso.length})",
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      color: ColorPalet.secondaryLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    openModalBottomSheetVerTareas(context);
                                    dataTareas.setSelectButton(2);
                                  },
                                  child: const Row(
                                    children: [
                                      Text("Ver todas",
                                          style: TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray2,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Icon(
                                        Iconsax.arrow_right,
                                        color: ColorPalet.grisesGray2,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sizeScreen.height * 0.2,
                            width: sizeScreen.width,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: listaTareasEnProgreso.length,
                              itemBuilder: (context, index) {
                                final tareaProgreso =
                                    listaTareasEnProgreso[index];
                                return InkWell(
                                  onTap: () {
                                    dataTareas
                                        .getVerTareaID(tareaProgreso.tareaId)
                                        .then((_) async {
                                      if (dataTareas
                                          .loadingDatosParaDetalleTarea) {
                                        openModalBottomSheetVerDetalleTarea(
                                            context, dataTareas);
                                        dataTareas
                                            .setLoadingDatosParaDetalleTarea(
                                                false);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20, right: 15),
                                    padding: const EdgeInsets.only(left:15, right: 15, bottom: 15, top: 15),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 246, 239, 255),
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 224, 76, 55),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          width: 4,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: sizeScreen.width * 0.65,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      tareaProgreso.titulo,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromARGB(
                                                              255, 29, 34, 44),
                                                          fontFamily: 'sans',
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                        onPressed: () {
                                                          bottomSheetOptionsTareas(
                                                              context,
                                                              sizeScreen,
                                                              tareaProgreso);
                                                        },
                                                        icon: Icon(
                                                          Icons.more_horiz,
                                                          color: ColorPalet
                                                              .secondaryLight,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Estado: ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 139, 149, 166),
                                                        fontFamily: 'inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    tareaProgreso.estado,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 29, 34, 44),
                                                        fontFamily: 'inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              tareaProgreso.totalSubtareas != 0
                                                  ? SizedBox(
                                                      width: sizeScreen.width *
                                                          0.6,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${tareaProgreso.subtareasRealizadas}/',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: ColorPalet
                                                                    .grisesGray1,
                                                                fontFamily:
                                                                    'sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text(
                                                            tareaProgreso
                                                                .totalSubtareas
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            '${tareaProgreso.porcentaje}%',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              tareaProgreso.totalSubtareas != 0
                                                  ? SizedBox(
                                                      width: sizeScreen.width *
                                                          0.6,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            LinearProgressIndicator(
                                                          minHeight: 12,
                                                          value: tareaProgreso
                                                                  .subtareasRealizadas /
                                                              tareaProgreso
                                                                  .totalSubtareas,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  246,
                                                                  248,
                                                                  251),
                                                          valueColor:
                                                              const AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  ColorPalet
                                                                      .acentDefault),
                                                        ),
                                                      ),
                                                    )
                                                  : Text('Sin subtareas'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                         
                         
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: sizeScreen.width,
                            child: Row(
                              children: [
                                const Text("Objetivos en progreso",
                                    style: TextStyle(
                                      fontFamily: 'sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    dataObjetivos.getTableroObjetivosList();
                                    openModalBottomSheetVerObjetivos(context);
                                  },
                                  child: const Row(
                                    children: [
                                      Text("Ver todos",
                                          style: TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray2,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Icon(
                                        Iconsax.arrow_right,
                                        color: ColorPalet.grisesGray2,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 150,
                            width: sizeScreen.width,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: listaTareasEnProgreso.length,
                              itemBuilder: (context, index) {
                                final tareaProgreso =
                                    listaTareasEnProgreso[index];
                                return InkWell(
                                  onTap: () {
                                    dataTareas
                                        .getVerTareaID(tareaProgreso.tareaId)
                                        .then((_) async {
                                      if (dataTareas
                                          .loadingDatosParaDetalleTarea) {
                                        openModalBottomSheetVerDetalleTarea(
                                            context, dataTareas);
                                        dataTareas
                                            .setLoadingDatosParaDetalleTarea(
                                                false);
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 300,
                                    height: 150,
                                    margin: EdgeInsets.only(top: 20, right: 15),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 246, 239, 255),
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 224, 76, 55),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          width: 4,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, top: 5, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                tareaProgreso.titulo,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Color.fromARGB(
                                                        255, 29, 34, 44),
                                                    fontFamily: 'sans',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Estado: ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 139, 149, 166),
                                                        fontFamily: 'inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    tareaProgreso.estado,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 29, 34, 44),
                                                        fontFamily: 'inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              tareaProgreso.totalSubtareas != 0
                                                  ? SizedBox(
                                                      width: sizeScreen.width *
                                                          0.5,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${tareaProgreso.subtareasRealizadas}/',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: ColorPalet
                                                                    .grisesGray1,
                                                                fontFamily:
                                                                    'sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text(
                                                            tareaProgreso
                                                                .totalSubtareas
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            '${tareaProgreso.porcentaje}%',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              tareaProgreso.totalSubtareas != 0
                                                  ? SizedBox(
                                                      width: sizeScreen.width *
                                                          0.52,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            LinearProgressIndicator(
                                                          minHeight: 12,
                                                          value: tareaProgreso
                                                                  .subtareasRealizadas /
                                                              tareaProgreso
                                                                  .totalSubtareas,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  246,
                                                                  248,
                                                                  251),
                                                          valueColor:
                                                              const AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  ColorPalet
                                                                      .acentDefault),
                                                        ),
                                                      ),
                                                    )
                                                  : Text('Sin subtareas'),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  bottomSheetOptionsTareas(
                                                      context,
                                                      sizeScreen,
                                                      tareaProgreso);
                                                },
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color:
                                                      ColorPalet.secondaryLight,
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: sizeScreen.width,
                            child: Row(
                              children: [
                                const Text("Actividad reciente",
                                    style: TextStyle(
                                      fontFamily: 'sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: const Row(
                                    children: [
                                      Text("Ver todas",
                                          style: TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray2,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Icon(
                                        Iconsax.arrow_right,
                                        color: ColorPalet.grisesGray2,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          listaActRecientesTareas.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  padding: EdgeInsets.all(15),
                                  width: sizeScreen.width,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 246, 239, 255),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: listaActRecientesTareas.length,
                                    itemBuilder: (context, index) {
                                      final actRec =
                                          listaActRecientesTareas[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width:
                                                      16, // Ancho del cuadrado rojo
                                                  height:
                                                      16, // Altura del cuadrado rojo
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                ),
                                                Container(
                                                  height:
                                                      195, // Altura de la línea segmentada
                                                  child: CustomPaint(
                                                    painter: MyDividerPainter(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width:
                                                      sizeScreen.width * 0.72,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            sizeScreen.width *
                                                                0.4,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  actRec
                                                                      .mensajeActualizacion,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'inter',
                                                                    color: ColorPalet
                                                                        .grisesGray0,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                          actRec
                                                              .horaActualizacion,
                                                          style: TextStyle(
                                                            fontFamily: 'inter',
                                                            color: ColorPalet
                                                                .grisesGray2,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    /*  dataTareas
                                                .getVerTareaID(tareaProgreso.tareaId)
                                                .then((_) async {
                                              if (dataTareas
                                                  .loadingDatosParaDetalleTarea) {
                                                openModalBottomSheetVerDetalleTarea(
                                                    context, dataTareas);
                                                dataTareas
                                                    .setLoadingDatosParaDetalleTarea(
                                                        false);
                                              }
                                            }); */
                                                  },
                                                  child: Container(
                                                    width:
                                                        sizeScreen.width * 0.7,
                                                    height: 150,
                                                    margin: EdgeInsets.only(
                                                        top: 20, right: 15),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        border: Border.all(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                246, 239, 255),
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  224, 76, 55),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          width: 4,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                height: 40,
                                                                width: sizeScreen
                                                                        .width *
                                                                    0.4,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        actRec
                                                                            .tituloTarea,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                29,
                                                                                34,
                                                                                44),
                                                                            fontFamily:
                                                                                'sans',
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Text(
                                                                    'Estado: ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            139,
                                                                            149,
                                                                            166),
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    actRec
                                                                        .estado,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            29,
                                                                            34,
                                                                            44),
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Icon(
                                                                    Iconsax
                                                                        .calendar_2,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            139,
                                                                            149,
                                                                            166),
                                                                  ),
                                                                  Text(
                                                                    actRec
                                                                        .fechaInicio
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            29,
                                                                            34,
                                                                            44),
                                                                        fontFamily:
                                                                            'inter',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  Icons
                                                                      .more_horiz,
                                                                  color: ColorPalet
                                                                      .secondaryLight,
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  width: sizeScreen.width,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      'No hay actividad reciente',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ColorPalet.grisesGray2,
                                          fontFamily: 'sans',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                          SizedBox(height: 15,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: const DrawerWidget()),
    );
  }
}

Future<dynamic> bottomSheetOptionsTareas(
    BuildContext context, Size sizeScreen, TareaProgreso tareaProgreso) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    child: Divider(
                      // Línea superior
                      color: ColorPalet.grisesGray3,
                      thickness: 3.0,
                    ),
                  ),
                ],
              ),
              Container(
                width: sizeScreen.width,
                height: 100,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: ColorPalet.grisesGray4, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 224, 76, 55),
                          borderRadius: BorderRadius.circular(8)),
                      width: 4,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tareaProgreso.titulo,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Estado: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                tareaProgreso.estado,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      Iconsax.edit,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Editar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Iconsax.arrow_left,
                                            color: ColorPalet.grisesGray0),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Marcar como',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'sans',
                                          fontWeight: FontWeight.w700,
                                          color: ColorPalet.grisesGray0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                /* InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clipboard_text,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'En progreso',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), */
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    Provider.of<TareasProvider>(context,
                                            listen: false)
                                        .moverEstadoTarea(
                                            tareaProgreso.tareaId, 'terminadas')
                                        .then((value) async {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clipboard_tick,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Terminado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.recovery_convert,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Mover a',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _mostrarAlertaEliminarCita(context, tareaProgreso.tareaId);
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.trash,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Eliminar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10)
            ]),
      );
    },
  );
}

void _mostrarAlertaEliminarCita(BuildContext context, int idTarea) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            '¿Estás seguro/a de que quieres eliminar esta tarea?',
            style: TextStyle(
                color: const Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: const Text(
                    'Si eliminas esta tarea, no podrás recuperarla más tarde.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 85, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'No, cancelar',
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                // Cerrar el AlertDialog
                                Provider.of<TareasProvider>(context,
                                        listen: false)
                                    .eliminarTarea(idTarea)
                                    .then((value) async {
                                  Provider.of<TareasProvider>(context,
                                          listen: false)
                                      .setOKsendEliminarTarea(false);
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: ColorPalet.secondaryDefault,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'Sí, eliminar',
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetCrearTarea(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              _mostrarAlertaCancelar(context);
              return true;
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: FormularioCrearTarea(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}
void _mostrarAlertaCancelar(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            '¿Estás seguro/a de querer volver atrás?',
            style: TextStyle(
                color: const Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: const Text(
                    'No se guardarán los cambios que hayas realizado.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                // Cerrar el AlertDialog
                                Navigator.of(context).pop();
                                //cierra bottomSheet
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                  Color.fromARGB(255, 255, 85, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
                              child: const Text(
                                'Volver',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                // Cerrar el AlertDialog
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                  Color.fromARGB(255, 99, 92, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
                              child: const Text(
                                'Quedarme aquí',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
void openModalBottomSheetCrearObjetivo(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: FormularioCrearObjetivo(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetVerObjetivos(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              child: FormularioVerobjetivos(),
            ),
          ]),
        ),
      );
    },
  );
}

void openModalBottomSheetVerTareas(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              child: FormularioVerTareas(),
            ),
          ]),
        ),
      );
    },
  );
}

class MyDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double dashWidth = 5; // Ancho de los segmentos
    final double dashSpace = 1; // Espacio entre segmentos
    final double startY = 0;
    final double endY = size.height;

    Paint paint = Paint()
      ..color = ColorPalet.grisesGray3
      ..strokeWidth = 1;

    double currentY = startY;
    bool draw = true;

    while (currentY < endY) {
      if (draw) {
        canvas.drawLine(
            Offset(0, currentY), Offset(0, currentY + dashWidth), paint);
      }
      currentY += dashWidth + dashSpace;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FlipCard extends StatefulWidget {
  final TareaPorcentajeHome porcentajeTareaHome;
  final TareaPorcentajeHome porcentajeObjetivoHome;
  final Size sizeScreen;
  FlipCard(this.porcentajeTareaHome, this.porcentajeObjetivoHome, this.sizeScreen);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showFrontSide = true;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }
  void _flipCard() {
    if (_showFrontSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(_animation.value * (_showFrontSide ? 3.141592 : -3.141592)), // Cambio aquí
            alignment: Alignment.center,
            child: _showFrontSide
                ? tareasObjetivosView(
              widget.porcentajeTareaHome.mensaje,
              "Tareas",
              widget.porcentajeTareaHome.porcentaje,
                  () {
                openModalBottomSheetVerTareas(context);
              },
              widget.sizeScreen,
              rotateText: 0, // Sin rotación adicional para el texto de la cara frontal
            )
                : tareasObjetivosView(
              widget.porcentajeObjetivoHome.mensaje,
              "Objetivos",
              widget.porcentajeObjetivoHome.porcentaje,
                  () {
                Provider.of<ObjetivosProvider>(context, listen: false).getTableroObjetivosList();
                openModalBottomSheetVerObjetivos(context);
              },
              widget.sizeScreen,
              rotateText: -_animation.value * 3.141592, // Rotación adicional para el texto de la cara trasera
            ),
          );
        },
      ),
    );
  }


  Widget tareasObjetivosView(String mensaje, String botonTexto, int porcentaje, VoidCallback buttonPressed, Size sizeScreen, {double rotateText = 0}) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 94, 65, 211),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Transform(
        transform: Matrix4.rotationY(rotateText),
        alignment: Alignment.center,
        child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child:  Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: sizeScreen.width * 0.5,
                        child: Text(
                          mensaje,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'sans',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: buttonPressed,
                        child: Text(
                          botonTexto,
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 0, 76),
                            fontFamily: 'inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 255, 255, 255),
                                strokeWidth: 10,
                                value: porcentaje / 100,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Text(
                              '$porcentaje%',
                              style: TextStyle(
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              Icons.repeat_on_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      ),

    );
  }


}