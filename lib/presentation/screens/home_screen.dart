import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/inicio/model_avance_dash.dart';
import 'package:vet_sotf_app/models/inicio/model_caja.dart';
import 'package:vet_sotf_app/presentation/widgets/dropDown_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/dashboard_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/tareas/objetivos_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';

import '../../config/global/palet_colors.dart';
import '../../models/inicio/mode_citasDash.dart';
import '../../models/inicio/model_dash_graficos.dart';
import '../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../models/tareas/etiquetas_tareas_model.dart';
import '../../models/tareas/participantes_tareas_model.dart';
import '../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../providers/ui_provider.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import 'graficosDashboad/bar_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controllerTituloTarea = TextEditingController();
  TextEditingController controllerDescTarea = TextEditingController();
  final TextEditingController controllerBusquedaPartici =
      TextEditingController();

  final TextEditingController controllerBusquedaEtiquetas =
      TextEditingController();

  final TextEditingController controllerNombreEtiqueta =
      TextEditingController();

  final TextEditingController controllerMontoInicial = TextEditingController();
  final TextEditingController controllerMontoCierre = TextEditingController();
  final TextEditingController controllerEgreso = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Asigna los controladores en initState para asegurar que solo se creen una vez
    controllerTituloTarea = TextEditingController();
    controllerDescTarea = TextEditingController();
    // Ejecuta Future.wait solo una vez en initState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() async {
    final userEmpProvider =
        Provider.of<UserEmpProvider>(context, listen: false);
    final dataDashboard =
        Provider.of<DashBoardProvider>(context, listen: false);

    // Carga los datos necesarios
    await Future.wait([
      if (userEmpProvider.user == null) userEmpProvider.fetchUserData(),
      if (dataDashboard.estadoCaja == null) dataDashboard.getEstadoCaja(),
    ]);

    // Actualiza el estado para indicar que la carga ha finalizado
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiProviderDrawer = Provider.of<UiProvider>(context, listen: false);
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;
    final dataTareas = Provider.of<TareasProvider>(context);
    final dataObjetivos = Provider.of<ObjetivosProvider>(context);
    final userEmpProvider = Provider.of<UserEmpProvider>(context);
    final dataDashboard = Provider.of<DashBoardProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      List<ParticipanteTarea> listaParticipantes =
          dataTareas.getParticipantesTarea;
      List<EtiquetaTarea> listaEtiquetas = dataTareas.getEtiquetasTarea;

      List<AvanceDashboard> listAvanceDash = dataDashboard.avanceDashBoardList;
      List<CitaDiaDash> listCitasDash = dataDashboard.citasDiaDash;

      List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;

      final sizeScreen = MediaQuery.of(context).size;

      List<double?> weeklySummary = List.filled(7, null);

      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const DrawerWidget(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 99, 92, 255),
            leading: Container(
              child: Center(
                child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: const Color(0xFF6B64FF),
                        borderRadius: BorderRadius.circular(10)),
                    //margin: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 12),
                    //padding: EdgeInsets.all(1),
                    child: Builder(builder: (context) {
                      return IconButton(
                          iconSize: 30,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const ImageIcon(
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
                      color: const Color(0x636B64FF),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(12),
                  child: IconButton(
                    icon: const Icon(Iconsax.notification_bing),
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
                      color: const Color(0x636B64FF),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(12),
                  child: IconButton(
                    icon: const Icon(Iconsax.message_text_1),
                    color: ColorPalet.grisesGray5,
                    onPressed: () {
                      _openModalBottomSheetConsulta(context, sizeScreen);
                    },
                  )),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 99, 92, 255),
          body: Column(
            children: [
              AnimatedContainer(
                color: ColorPalet.secondaryDefault,
                duration: const Duration(milliseconds: 500),
                height: isHeaderExpanded ? sizeScreen.height * 0.23 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isHeaderExpanded)
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
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
              !isHeaderExpanded
                  ? SizedBox(
                      child: Container(
                        height: sizeScreen.height * 0.1,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 99, 92, 255),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 15),
                              child: Text(
                                'Hola, ${userEmpProvider.user?.informacionPersonal.nombres.split(' ').map((str) => str[0].toUpperCase() + str.substring(1)).join(' ')}',
                                style: const TextStyle(
                                    fontFamily: 'sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(height: 5),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 247, 246),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  clipBehavior: Clip
                      .hardEdge, // Recorta el contenido según el borderRadius
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          height: sizeScreen.height * 0.25,
                          width: sizeScreen.width,
                          child: listAvanceDash.isNotEmpty
                              ? _WidgetCarouselPrincipal(
                                  drawerProvider: uiProviderDrawer,
                                  sizeScreen: sizeScreen,
                                  listAvanceDash: listAvanceDash,
                                  controllerMontoInicial:
                                      controllerMontoInicial,
                                  controllerMontoCierre: controllerMontoCierre,
                                  controllerEgreso: controllerEgreso,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                  color: ColorPalet.secondaryDefault,
                                )),
                        ),
                        Container(
                          width: sizeScreen.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: const Row(
                            children: [
                              Text('Citas del dia',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'sans',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700)),
                              Spacer(),
                              Text('Ver todas las citas',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 139, 149, 166),
                                      fontFamily: 'inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400)),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: sizeScreen.width,
                          height: listCitasDash.isEmpty
                              ? sizeScreen.height * 0.1
                              : sizeScreen.height * 0.36,
                          child: listCitasDash.isEmpty
                              ? const Center(
                                  child: Text('No hay citas',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)))
                              : _WidgetCarouselCitas(
                                  citasList: listCitasDash,
                                  sizeScreen: sizeScreen,
                                  dataDashboard: dataDashboard,
                                ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 15, left: 15, right: 15, bottom: 0),
                            padding: const EdgeInsets.only(
                                top: 0, left: 15, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                              color: ColorPalet.grisesGray5,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            height: sizeScreen.height * 0.13,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Vista de ingresos',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 29, 34, 44),
                                        fontFamily: 'sans',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 55),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () => {
                                        _openModalBottomSheetConsulta(
                                            context, sizeScreen),
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF8F8FF),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Weekly",
                                              style: TextStyle(
                                                  color: Color(0xff615E83),
                                                  fontSize: 13,
                                                  fontFamily: 'inter'),
                                            ),
                                            Icon(
                                              CupertinoIcons.chevron_down,
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  height: 1.0,
                                  color: Color(0xffE5E5EF),
                                  thickness: 1.0,
                                ),
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 0, left: 15, right: 15, bottom: 15),
                          padding: const EdgeInsets.only(
                              top: 10, left: 5, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: ColorPalet.grisesGray5,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          height: sizeScreen.height * 0.4,
                          child: dataDashboard.graficosDash.isNotEmpty
                              ? _charPrincipalDashBoard(
                                  weeklySummary, dataDashboard)
                              : const Center(
                                  child: CircularProgressIndicator(
                                  color: ColorPalet.secondaryDefault,
                                )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: ColorPalet.grisesGray5,
                              borderRadius: BorderRadius.circular(15)),
                          height: sizeScreen.height * 0.68,
                          width: sizeScreen.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Crear nueva tarea',
                                    style: TextStyle(
                                        color: ColorPalet.grisesGray0,
                                        fontFamily: 'sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.repeat))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Título de la tarea',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray1,
                                    fontFamily: 'inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormFieldConHint(
                                  hintText: 'Tarea',
                                  controller: controllerTituloTarea,
                                  colores: ColorPalet.primaryLight),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray1,
                                    fontFamily: 'inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              _separacionCampos(15),
                              TextFormFieldConHint(
                                  hintText: 'Describe aquí la tarea',
                                  controller: controllerDescTarea,
                                  colores: ColorPalet.primaryLight),
                              _separacionCampos(20),
                              SizedBox(
                                width: dataTareas.selectedEtiquetasMap.isEmpty
                                    ? 80
                                    : sizeScreen.width,
                                child: Row(
                                  children: [
                                    const Icon(
                                      IconlyLight.ticket,
                                      color: Color.fromARGB(255, 139, 149, 166),
                                      size: 28,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: dataTareas
                                              .selectedEtiquetasMap.isNotEmpty
                                          ? Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: dataTareas
                                                  .selectedEtiquetasMap.values
                                                  .map((nombre) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 240, 230, 254),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    nombre,
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 99, 30, 191),
                                                      fontSize: 12,
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : Container(),
                                    ),
                                    const SizedBox(width: 4),
                                    InkWell(
                                      onTap: () {
                                        openBottomSheetEtiquetasTareas(
                                            dataTareas,
                                            context,
                                            listaEtiquetas);
                                        dataTareas.getEtiquetasTareas();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 218, 223, 230),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _separacionCampos(20),
                              Row(
                                children: [
                                  Container(
                                      child: const Icon(IconlyLight.user_1,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166),
                                          size: 28)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  dataTareas.selectedParticipantsMap.isNotEmpty
                                      ? Flexible(
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: dataTareas
                                                            .selectedParticipantsMap
                                                            .length >
                                                        2
                                                    ? 129
                                                    : dataTareas.selectedParticipantsMap
                                                                .length ==
                                                            2
                                                        ? 86
                                                        : 43,
                                                height: 45,
                                              ),
                                              if (dataTareas
                                                      .selectedParticipantsMap
                                                      .length >=
                                                  1)
                                                Positioned(
                                                  left: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 4.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    width: 45,
                                                    height: 45,
                                                    child: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/img/${dataTareas.selectedParticipantsMap.values.elementAt(0).toLowerCase()}.png'),
                                                      radius: 30,
                                                    ),
                                                  ),
                                                ),
                                              if (dataTareas
                                                      .selectedParticipantsMap
                                                      .length >=
                                                  2)
                                                Positioned(
                                                  left: 30,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 4.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    width: 45,
                                                    height: 45,
                                                    child: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/img/${dataTareas.selectedParticipantsMap.values.elementAt(1).toLowerCase()}.png'),
                                                      radius: 30,
                                                    ),
                                                  ),
                                                ),
                                              if (dataTareas
                                                      .selectedParticipantsMap
                                                      .length >
                                                  2)
                                                Positioned(
                                                  left: 60,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 4.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    width: 45,
                                                    height: 45,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 65, 0, 152),
                                                      radius: 30,
                                                      child: Text(
                                                        '+${dataTareas.selectedParticipantsMap.length}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openBottomSheetParticipantesTareas(
                                          dataTareas,
                                          context,
                                          listaParticipantes);
                                      dataTareas.getParticipantesTareas();
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 218, 223, 230),
                                                width: 2)),
                                        child: const Icon(Icons.add,
                                            color: Color.fromARGB(
                                                255, 139, 149, 166),
                                            size: 25)),
                                  ),
                                ],
                              ),
                              _separacionCampos(20),
                              SizedBox(
                                height: sizeScreen.height * 0.06,
                                width: sizeScreen.width,
                                child: ElevatedButton(
                                    onPressed: () {
                                      dataTareas
                                          .enviarDatosCrearTareaDashBoard(
                                        controllerTituloTarea.text,
                                        controllerDescTarea.text,
                                        dataTareas.selectedEtiquetasList,
                                        dataTareas.selectedParticipantsList,
                                      )
                                          .then((_) async {
                                        if (dataTareas
                                            .okpostDatosCrearTareaDash) {
                                          _mostrarFichaCreada(context,
                                              '¡Registro creado con éxito!');
                                          controllerTituloTarea.clear();
                                          controllerDescTarea.clear();
                                          dataTareas
                                            ..selectedParticipantsMap.clear()
                                            ..selectedEtiquetasMap.clear()
                                            ..selectedEtiquetasList.clear()
                                            ..selectedParticipantsList.clear();
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            ColorPalet.primaryDefault,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: dataTareas.loadingDatosCrearTarea
                                        ? const SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'Crear tarea',
                                            style: TextStyle(
                                                color: ColorPalet.grisesGray5,
                                                fontFamily: 'inter',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
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

  void _openModalBottomSheetConsulta(BuildContext context, Size sizeScreen) {
    final cajaProvider = Provider.of<DashBoardProvider>(context, listen: false);
    final detalleCaja = cajaProvider.cajaDetalle;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 30,
                    height: 2, // Altura de la línea
                    color: const Color.fromARGB(
                        255, 161, 158, 158), // Color de la línea
                  ),
                ),
                Text(
                  "Registro de Cajas",
                  style: TextStyle(
                      fontFamily: 'sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(
                  child: cajaProvider.loadingDetalleCaja
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              detalleCaja!.estaSemana.isEmpty
                                  ? Container()
                                  : _buildSection(
                                      'Esta semana', detalleCaja.estaSemana),
                              detalleCaja.esteMes.isEmpty
                                  ? Container()
                                  : _buildSection(
                                      'Este mes', detalleCaja.esteMes),
                              detalleCaja.anteriores.isEmpty
                                  ? Container()
                                  : _buildSection(
                                      'Anteriores', detalleCaja.anteriores),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<CajaDetalle> detalles) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'sans', fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                detalles.map((detalle) => _buildDetalleTile(detalle)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalleTile(CajaDetalle detalle) {
    return ExpansionTile(
      title: Text(
        detalle.fechaCaja,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            detalle.detalle,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _modalConsultaNuevoRegistro(context, Size sizeScreen) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('¿El paciente es nuevo o antiguo?',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 29, 34, 44),
                        fontSize: 16,
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700)),
                Divider()
              ],
            ),
            content: Container(
              width: sizeScreen.width,
              height: sizeScreen.height * 0.4,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Por favor, seleccione si este paciente ya ha sido registrado previamente en nuestra base de datos o si es un paciente nuevo.',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'inter',
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            //width: 120,
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.user_add,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Paciente nuevo',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: sizeScreen.width * 0.02),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user_search,
                                  size: 35,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Paciente antiguo',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            //shape: const CircleBorder(),
                            //minimumSize: const Size(50, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 28, 149, 187)),
                        onPressed: () {},
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'inter',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void openBottomSheetParticipantesTareas(TareasProvider dataTareas,
      BuildContext context, List<ParticipanteTarea> listaParticipantes) {
    final sizeWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 30,
                    height: 2, // Altura de la línea
                    color: const Color.fromARGB(
                        255, 161, 158, 158), // Color de la línea
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  child: Row(
                    children: [
                      const Text('Participantes',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                      Consumer<TareasProvider>(
                        builder: (context, dataTareas, child) {
                          return Text(
                              ' (${dataTareas.selectedParticipantsMap.length})',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 177, 173, 255),
                                  fontSize: 16,
                                  fontFamily: 'sans',
                                  fontWeight: FontWeight.w700));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerBusquedaPartici,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaPartici.clear();
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 177, 173, 255),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Nombre del cliente o paciente',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromARGB(220, 249, 249, 249),
                    filled: true,
                  ),
                  onChanged: (query) {
                    final listaFiltradaProvider =
                        Provider.of<TareasProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaParticipante(
                        listaParticipantes, query);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaPartici.text.isEmpty
                      ? Consumer<TareasProvider>(
                          builder: (context, provider, child) {
                            final listaParticipantesss =
                                provider.getParticipantesTarea;
                            return ListView.builder(
                              itemCount: listaParticipantesss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final participante =
                                    listaParticipantesss[index];
                                final isSelected = provider
                                    .isSelectedMap(participante.encargadoId);

                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/img/user.png'),
                                  ),
                                  title: Text(
                                    participante.nombres,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    participante.itemName.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 139, 149, 166)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.toggleSelectionMap(
                                        participante.encargadoId,
                                        participante.itemName);
                                    provider.selectedParticipantsMap
                                        .forEach((participantId, rutaImage) {
                                      print(
                                          'participantId: $participantId, rutaImage: $rutaImage');
                                    });
                                  },
                                );
                              },
                            );
                          },
                        )
                      : dataTareas.listaFiltradaParticipante.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                Image.asset('assets/img/noresults.png'),
                                const Text(
                                  'Oops, parece que no hay resultados.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 29, 34, 44)),
                                ),
                                const Expanded(
                                  child: Text(
                                    'No te desanimes, prueba con otra palabra clave o criterio de búsqueda.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 139, 149, 166)),
                                  ),
                                )
                              ],
                            ))
                          : Consumer<TareasProvider>(
                              builder: (context, provider, child) {
                                final listaFiltradaParticipante =
                                    provider.listaFiltradaParticipante;
                                return ListView.builder(
                                  itemCount: listaFiltradaParticipante.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final participante =
                                        listaFiltradaParticipante[index];
                                    final isSelected = provider.isSelectedMap(
                                        participante.encargadoId);

                                    return ListTile(
                                      leading: const CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/img/user.png'),
                                      ),
                                      title: Text(
                                        participante.nombres,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255, 99, 92, 255)
                                              : null,
                                        ),
                                      ),
                                      subtitle: Text(
                                        participante.itemName.toLowerCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255, 139, 149, 166)
                                              : null,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? const Icon(Icons.check,
                                              color: Color.fromARGB(
                                                  255, 99, 92, 255))
                                          : null,
                                      onTap: () {
                                        provider.toggleSelectionMap(
                                            participante.encargadoId,
                                            participante.itemName);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openBottomSheetEtiquetasTareas(TareasProvider dataTareas,
      BuildContext context, List<EtiquetaTarea> listaEtiquetas) {
    final sizeWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 30,
                    height: 2, // Altura de la línea
                    color: const Color.fromARGB(
                        255, 161, 158, 158), // Color de la línea
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  child: Row(
                    children: [
                      const Text('Etiquetas',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                      Consumer<TareasProvider>(
                        builder: (context, dataTareas, child) {
                          return Text(
                              ' (${dataTareas.selectedEtiquetasMap.length})',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 177, 173, 255),
                                  fontSize: 16,
                                  fontFamily: 'sans',
                                  fontWeight: FontWeight.w700));
                        },
                      ),
                    ],
                  ),
                ),
                _separacionCampos(10),
                TextFormField(
                  controller: controllerBusquedaEtiquetas,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaEtiquetas.clear();
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 177, 173, 255),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Busca una etiqueta',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromARGB(220, 249, 249, 249),
                    filled: true,
                  ),
                  onChanged: (query) {
                    final listaFiltradaProvider =
                        Provider.of<TareasProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaEtiqueta(
                        listaEtiquetas, query);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaEtiquetas.text.isEmpty
                      ? Consumer<TareasProvider>(
                          builder: (context, provider, child) {
                            final listaEtiquetasss = provider.getEtiquetasTarea;
                            return ListView.builder(
                              itemCount: listaEtiquetasss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final etiqueta = listaEtiquetasss[index];
                                final isSelected = provider
                                    .isSelectedEtiquetaMap(etiqueta.etiquetaId);

                                return ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 0),
                                  leading: isSelected
                                      ? const Icon(
                                          Icons.radio_button_checked,
                                          color:
                                              Color.fromARGB(255, 65, 0, 152),
                                        )
                                      : const Icon(
                                          Icons.radio_button_off,
                                          color:
                                              Color.fromARGB(255, 65, 0, 152),
                                        ),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 240, 230, 254),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        etiqueta.nombre,
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 99, 30, 191),
                                          fontSize: 12,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.edit,
                                      color:
                                          Color.fromARGB(255, 139, 149, 166)),
                                  onTap: () {
                                    provider.toggleSelectionEtiquetaMap(
                                        etiqueta.etiquetaId, etiqueta.nombre);
                                  },
                                );
                              },
                            );
                          },
                        )
                      : dataTareas.listaFiltradaEtiquetas.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                Image.asset('assets/img/noresults.png'),
                                const Text(
                                  'No encontramos ninguna etiqueta que coincida con tu búsqueda.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 29, 34, 44)),
                                ),
                                const Expanded(
                                  child: Text(
                                    'No te preocupes, Puedes crear una nueva etiqueta haciendo clic en el botón "Crear etiqueta" y agregarla a tu tarea para mantener todo organizado.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 139, 149, 166)),
                                  ),
                                )
                              ],
                            ))
                          : Consumer<TareasProvider>(
                              builder: (context, provider, child) {
                                final listaFiltradaEtiqueta =
                                    provider.listaFiltradaEtiquetas;
                                return ListView.builder(
                                  itemCount: listaFiltradaEtiqueta.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final etiqueta =
                                        listaFiltradaEtiqueta[index];
                                    final isSelected =
                                        provider.isSelectedEtiquetaMap(
                                            etiqueta.etiquetaId);

                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets.only(left: 0),
                                      leading: isSelected
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: Color.fromARGB(
                                                  255, 65, 0, 152),
                                            )
                                          : const Icon(
                                              Icons.radio_button_off,
                                              color: Color.fromARGB(
                                                  255, 65, 0, 152),
                                            ),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 240, 230, 254),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            etiqueta.nombre,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 99, 30, 191),
                                              fontSize: 12,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      trailing: const Icon(Icons.edit,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166)),
                                      onTap: () {
                                        provider.toggleSelectionEtiquetaMap(
                                            etiqueta.etiquetaId,
                                            etiqueta.nombre);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                ),
                ElevatedButton(
                  onPressed: () {
                    openBottomSheetCrearEtiquetaTarea(context, dataTareas);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 115, 92, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: dataTareas.loadingDatosCrearTarea
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconlyLight.ticket,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 28,
                              ),
                              Text(
                                'Crear nueva etiqueta',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  late StateSetter _setStateHexa;

  void openBottomSheetCrearEtiquetaTarea(
      BuildContext context, TareasProvider dataTareas) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext currentContext, StateSetter setState) {
                _setStateHexa = setState;

                String valorHexadecimal =
                    dataTareas.almacenColorEtiqueta.isEmpty
                        ? 'FFFFFF'
                        : dataTareas.almacenColorEtiqueta;

                return Container(
                  padding: const EdgeInsets.all(15),
                  height: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 20),
                          width: 30,
                          height: 2, // Altura de la línea
                          color: const Color.fromARGB(
                              255, 161, 158, 158), // Color de la línea
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Crear nueva etiqueta',
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      _separacionCampos(20),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(int.parse('0xFF$valorHexadecimal'))
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: Center(
                          child: Text(
                            controllerNombreEtiqueta.text,
                            style: TextStyle(
                                color:
                                    Color(int.parse('0xFF$valorHexadecimal')),
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      _separacionCampos(15),
                      _NombreCampos('Nombre de la etiqueta'),
                      _separacionCampos(15),
                      TextFormFieldConHintValidator(
                        controller: controllerNombreEtiqueta,
                        hintText: 'Nombre de la etiqueta (Ej: “Prioridad”)',
                        colores: const Color.fromARGB(255, 177, 173, 255),
                      ),
                      _separacionCampos(20),
                      _NombreCampos('Elige un color'),
                      _separacionCampos(15),
                      Wrap(
                        spacing:
                            10.0, // Espacio horizontal entre los contenedores
                        runSpacing:
                            8.0, // Espacio vertical entre las filas de contenedores
                        children: <Widget>[
                          _cuadroTicketColor(currentContext,
                              const Color(0xFFF368E0), 'F368E0'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFFDA176F), 'DA176F'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFFEE5353), 'EE5353'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFFFF9F43), 'FF9F43'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFFFEE357), 'FEE357'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFF00D2D3), '00D2D3'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFF00A3A4), '00A3A4'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFF0ABDE3), '0ABDE3'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFF2E86DE), '2E86DE'),
                          _cuadroTicketColor(currentContext,
                              const Color(0xFF735CFF), '735CFF'),
                        ],
                      ),
                      _separacionCampos(20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            dataTareas
                                .enviarDatosCrearEtiqueta(
                              controllerNombreEtiqueta.text,
                              dataTareas.almacenColorEtiqueta,
                            )
                                .then((_) async {
                              if (dataTareas.OkpostDatosCrearEtiqueta) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                _mostrarFichaCreada(
                                    context, '¡Etiqueta creada!');
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 115, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: dataTareas.loadingDatosCrearTarea
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Crear etiqueta',
                                  style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }

  InkWell _cuadroTicketColor(
      BuildContext context, Color hexaColor, String hexaString) {
    return InkWell(
      onTap: () {
        _setStateHexa(() {
          Provider.of<TareasProvider>(context, listen: false)
              .setalmacenColorEtiqueta(hexaString);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: hexaColor, borderRadius: BorderRadius.circular(10)),
        width: 60,
        height: 42,
      ),
    );
  }

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: const TextStyle(
          color: Color.fromARGB(255, 72, 86, 109),
          fontSize: 15,
          fontWeight: FontWeight.w500),
    );
  }

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 28, 149, 187),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10), // Ajusta el espacio izquierdo
              const Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Text(
                textoMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
              ),
              const Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(width: 10), // Ajusta el espacio derecho
            ],
          ),
        ),
      ),
    );
  }

  BarChart _charPrincipalDashBoard(
      List<double?> weeklySummary, DashBoardProvider dataDashboard) {
    final List<DatoGrafico> listGraficos = dataDashboard.graficosDash;
    final int variable;
    double? max;

    /* if (listGraficos.isNotEmpty && listGraficos[0].ejeX.isNotEmpty) {
      //variable = listGraficos[0].ejeX.length;
      variable = listGraficos[0].productos.length;
      for (var i = 0; i < variable; i++) {
        //weeklySummary.add(listGraficos[0].ejeX[i].toDouble());
        weeklySummary.add(listGraficos[0].productos[i].cantidad.toDouble());
      }

      max = weeklySummary
          .reduce((value, element) => value > element ? value : element);
      print(max);
      // Resto de tu código aquí
    } else {
      print("La lista o sus elementos están vacíos");
    } */

    if (listGraficos.isNotEmpty) {
      int variable =
          listGraficos.isNotEmpty ? listGraficos[0].productos.length : 0;
      for (var i = 0; i < 7; i++) {
        if (i < variable) {
          weeklySummary[i] = listGraficos[0].productos[i].cantidad.toDouble();
        }
      }

      if (weeklySummary.every((element) => element == null)) {
        max = 0;
      } else {
        // Al menos un elemento no es null, calcular el máximo
        max = weeklySummary
            .where((element) => element != null)
            .reduce((value, element) => value! > element! ? value : element);
      }
    } else {
      print("La lista o sus elementos están vacíos");
    }

    BarData myBarData = BarData(
        sunAmount: weeklySummary[0],
        monAmount: weeklySummary[1],
        tueAmount: weeklySummary[2],
        wedAmount: weeklySummary[3],
        thurAmount: weeklySummary[4],
        friAmount: weeklySummary[5],
        satAmount: weeklySummary[6]);

    myBarData.initializedBarData();

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: ColorPalet.grisesGray1,
          ),
        ),
        maxY: max! + 1,
        minY: 0,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: Color(0xAE1ACAD4),
                    width: 19,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    )),
              ]),
            )
            .toList(),
      ),
    );
  }
}

class _WidgetCarouselPrincipal extends StatelessWidget {
  const _WidgetCarouselPrincipal({
    required this.drawerProvider,
    required this.sizeScreen,
    required this.listAvanceDash,
    required this.controllerMontoInicial,
    required this.controllerMontoCierre,
    required this.controllerEgreso,
  });

  final UiProvider drawerProvider;
  final Size sizeScreen;
  final List<AvanceDashboard> listAvanceDash;
  final TextEditingController controllerMontoInicial;
  final TextEditingController controllerMontoCierre;
  final TextEditingController controllerEgreso;

  @override
  Widget build(BuildContext context) {
    double progressClinica = listAvanceDash[0].clinica.totalAcabados.toDouble();
    double totalClinica = listAvanceDash[0].clinica.totalCitasDia.toDouble();
    double porcentajeClinica =
        totalClinica != 0 ? progressClinica / totalClinica : 0.0;

    double progressPeluqueria =
        listAvanceDash[0].peluqueria.totalAcabados.toDouble();
    double totalPeluqueria =
        listAvanceDash[0].peluqueria.totalCitasDia.toDouble();
    double porcentajePeluqueria =
        totalPeluqueria != 0 ? progressPeluqueria / totalPeluqueria : 0.0;

    final dataDashboard = Provider.of<DashBoardProvider>(context);

    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: [
        if (!(dataDashboard.estadoCaja!.data.estadoCaja == 'abierto'))
          InkWell(
            onTap: () async {
              _alertAbrirCaja(
                  context, controllerMontoInicial, 1, controllerMontoCierre);
              // await dataDashboard.getEstadoCaja();
            },
            child: Container(
              width: sizeScreen.width * 0.55,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorPalet.complementViolet3),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPalet.secondaryDefault),
                      child: const Center(
                        child: Icon(Iconsax.dollar_square,
                            color: ColorPalet.grisesGray5),
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Abrir caja',
                            style: TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          InkWell(
            onTap: () async {
              _alertAbrirCaja(
                  context, controllerMontoInicial, 2, controllerMontoCierre);
              // await dataDashboard.getEstadoCaja();
            },
            child: Container(
              width: sizeScreen.width * 0.55,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorPalet.complementViolet3),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPalet.secondaryDefault),
                      child: const Center(
                        child: Icon(Iconsax.dollar_square,
                            color: ColorPalet.grisesGray5),
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cerrar caja',
                            style: TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        InkWell(
          onTap: () {
            _alertEgreso(context, controllerEgreso);
          },
          child: Container(
            width: sizeScreen.width * 0.55,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorPalet.complementViolet3),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorPalet.secondaryDefault),
                    child: const Center(
                      child: Icon(Iconsax.dollar_square,
                          color: ColorPalet.grisesGray5),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Egresos',
                          style: TextStyle(
                              fontFamily: 'inter',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/homeScreen");

            drawerProvider.setOptionSelectedDrawer('Clinica');
          },
          child: Container(
            width: sizeScreen.width * 0.48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorPalet.complementVerde2),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorPalet.primaryDefault),
                    child: const Center(
                      child: Icon(Iconsax.hospital5,
                          color: ColorPalet.grisesGray5),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Clínica',
                      style: TextStyle(
                          fontFamily: 'inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            progressClinica.round().toString(),
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 19),
                          ),
                          Text(
                            " / ${totalClinica.round()}",
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LinearProgressIndicator(
                        value: porcentajeClinica,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            ColorPalet.primaryLight),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Turnos",
                            style: TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                          const Spacer(),
                          Text(
                            "${listAvanceDash[0].clinica.porcentaje}%",
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/homeScreen");

            drawerProvider.setOptionSelectedDrawer('Peluqueria');
          },
          child: Container(
            width: sizeScreen.width * 0.48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorPalet.secondaryDefault),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorPalet.secondaryLight),
                    child: const Center(
                      child: Icon(Iconsax.scissor_1,
                          color: ColorPalet.grisesGray5),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Peluquería',
                      style: TextStyle(
                          fontFamily: 'inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            progressPeluqueria.round().toString(),
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 19),
                          ),
                          Text(
                            " / ${totalPeluqueria.round()}",
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LinearProgressIndicator(
                        value: porcentajePeluqueria,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            ColorPalet.secondaryLight),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Turnos",
                            style: TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                          const Spacer(),
                          Text(
                            "${listAvanceDash[0].peluqueria.porcentaje}%",
                            style: const TextStyle(
                                fontFamily: 'inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/homeScreen");

            drawerProvider.setOptionSelectedDrawer('Petshop');
          },
          child: Container(
            width: sizeScreen.width * 0.48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorPalet.secondaryDark),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorPalet.secondaryDefault),
                    child: const Center(
                      child: Icon(Iconsax.shopping_bag5,
                          color: ColorPalet.grisesGray5),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Petshop',
                      style: TextStyle(
                          fontFamily: 'inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  const Text(
                    "Ventas",
                    style: TextStyle(
                        fontFamily: 'inter',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  const Text(
                    "Bs. 250K",
                    style: TextStyle(
                        fontFamily: 'sans',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*  void _alertAbrirCajas(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            title: Text(
              'Seleccionar caja',
              style: TextStyle(
                  color: ColorPalet.grisesGray2,
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.35,
              width: sizeScreen.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  checkDeCajas('Caja Clínica', Iconsax.hospital),
                  checkDeCajas('Caja Peluqueria', Iconsax.scissor_1),
                  checkDeCajas('Caja PetShop', Iconsax.shopping_bag),
                  Spacer(),
                  SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          _alertAbrirCaja(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                              color: ColorPalet.grisesGray5,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
 */

  Container checkDeCajas(String titulo, IconData icono) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: ColorPalet.grisesGray5,
          border: Border.all(width: 1, color: ColorPalet.backGroundColor),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icono, color: ColorPalet.grisesGray1),
          const SizedBox(
            width: 10,
          ),
          Text(
            titulo,
            style: const TextStyle(
                color: ColorPalet.grisesGray0,
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 14),
            textAlign: TextAlign.justify,
          ),
          const Spacer(),
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.5),
            ),
            side:
                const BorderSide(color: ColorPalet.complementVerde1, width: 2),
            activeColor: ColorPalet.complementVerde1,
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  void _alertAbrirCaja(
      BuildContext context,
      TextEditingController controllerMontoInicial,
      int tipo,
      TextEditingController controllerMontoCierre) {
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
              tipo == 1
                  ? '¿Estás seguro/a de querer abrir la caja?'
                  : '¿Estás seguro/a de querer cerrar la caja?',
              style: const TextStyle(
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.20,
              child: Column(
                children: [
                  Text(
                    tipo == 1
                        ? '¡Bienvenido a un nuevo día! ¿Estás seguro/a de que deseas abrir la caja? Estamos listos para atender a nuestros valiosos clientes.'
                        : 'Gracias por un día de trabajo productivo. ¿Estás seguro/a de que deseas cerrar la caja? Descansa y recarga energías para mañana.',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
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
                                        const Color.fromARGB(255, 255, 85, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Atrás',
                                  style: TextStyle(
                                      color: ColorPalet.grisesGray5,
                                      fontFamily: 'inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: ElevatedButton(
                                onPressed: tipo == 1
                                    ? () {
                                        _alertInserteMontoInicial(
                                            context, controllerMontoInicial);
                                      }
                                    : () {
                                        _alertInserteMontoCierre(
                                            context, controllerMontoCierre);
                                      },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        const Color.fromARGB(255, 99, 92, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Siguiente',
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

  void _alertInserteMontoInicial(
      BuildContext context, TextEditingController controllerMontoInicial) {
    final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
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
            title: const Center(
              child: Text(
                'Inserte monto inicial',
                style: TextStyle(
                    color: Color.fromARGB(255, 29, 34, 44),
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.27,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingrese el monto inicial con el que comenzará la jornada. Si no tienes un monto inicial coloca 0 en el espacio provisto.',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormFieldNumberConHint(
                      controller: controllerMontoInicial,
                      hintText: 'Escriba aquí el numero',
                      colores: ColorPalet.secondaryLight),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          dashboardProvider
                              .enviarDatosAbrirCaja(controllerMontoInicial.text)
                              .then((_) async {
                            if (dashboardProvider.okpostDatosAbrirCaja) {
                              await dashboardProvider.getEstadoCaja();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              controllerMontoInicial.clear();
                              _mostrarFichaCreada(context,
                                  dashboardProvider.mensajeDeAbrirCaja);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 99, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Guardar monto',
                          style: TextStyle(
                              color: ColorPalet.grisesGray5,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorPalet.grisesGray5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              color: ColorPalet.estadoNeutral,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _alertInserteMontoCierre(
      BuildContext context, TextEditingController controllerMontoCierre) {
    final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
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
            title: const Center(
              child: Text(
                'Inserte monto de cierre',
                style: TextStyle(
                    color: Color.fromARGB(255, 29, 34, 44),
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.27,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingrese el monto de egresos en la jornada. Si no tienes un monto inicial coloca 0 en el espacio provisto.',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldNumberConHint(
                      controller: controllerMontoCierre,
                      hintText: 'Escriba aquí el numero',
                      colores: ColorPalet.secondaryLight),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          dashboardProvider
                              .enviarDatosCerrarCaja(controllerMontoCierre.text)
                              .then((_) async {
                            if (dashboardProvider.okpostDatosCerrarCaja) {
                              controllerMontoCierre.clear();
                              await dashboardProvider.getEstadoCaja();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              _mostrarFichaCreada(
                                  context,
                                  Provider.of<DashBoardProvider>(context,
                                          listen: false)
                                      .mensajeDeCerrarCaja);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 99, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Guardar monto',
                          style: TextStyle(
                              color: ColorPalet.grisesGray5,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorPalet.grisesGray5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              color: ColorPalet.estadoNeutral,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _alertEgreso(
      BuildContext context, TextEditingController controllerEgreso) {
    final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
    final TextEditingController controllerEgresoDescripcion =
        TextEditingController();
    controllerEgreso.clear();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text(
                'Inserte egresos',
                style: TextStyle(
                    color: Color.fromARGB(255, 29, 34, 44),
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.30,
              child: Column(
                children: [
                  const Expanded(
                    child: Text(
                      'Ingrese el monto y descripción  de egreso.',
                      style: TextStyle(
                          color: Color.fromARGB(255, 72, 86, 109),
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextFormFieldNumberConHint(
                      controller: controllerEgreso,
                      hintText: 'Escriba aquí el numero',
                      colores: ColorPalet.secondaryLight),
                  const SizedBox(height: 10),
                  TextFormFieldConHint(
                      controller: controllerEgresoDescripcion,
                      hintText: 'Escriba aquí la descripción',
                      colores: ColorPalet.secondaryLight),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          dashboardProvider
                              .enviarDatosEgresos(controllerEgreso.text,
                                  controllerEgresoDescripcion.text)
                              .then((_) async {
                            if (dashboardProvider.okpostDatosEgresos) {
                              Navigator.of(context).pop();
                              _mostrarFichaCreada(
                                  context, dashboardProvider.mensajeDeEgresos);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 99, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Guardar monto',
                          style: TextStyle(
                              color: ColorPalet.grisesGray5,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.04,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controllerEgreso.clear();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorPalet.grisesGray5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              color: ColorPalet.estadoNeutral,
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2500),
        backgroundColor: const Color.fromARGB(255, 28, 149, 187),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10), // Ajusta el espacio izquierdo
              const Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Text(
                textoMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              const Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(width: 10), // Ajusta el espacio derecho
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(
      context, String title, IconData icon, bool selected, String screen) {
    final uiProviderDrawer = Provider.of<UiProvider>(context);
    return Material(
      textStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: selected
          ? const Color.fromARGB(255, 99, 92, 255)
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, screen);

          uiProviderDrawer.setOptionSelectedDrawer(title);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? Colors.white
                      : const Color.fromARGB(255, 72, 86, 109),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'inter',
                      color: selected
                          ? Colors.white
                          : const Color.fromARGB(255, 72, 86, 109),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WidgetCarouselCitas extends StatelessWidget {
  const _WidgetCarouselCitas(
      {super.key,
      required this.citasList,
      required this.sizeScreen,
      required this.dataDashboard});

  final List<CitaDiaDash> citasList;
  final Size sizeScreen;
  final DashBoardProvider dataDashboard;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: citasList.length,
        itemBuilder: (context, index) {
          final cita = citasList[index];

          final String imagen = cita.fotoPaciente.replaceAll('\\', '/');
          //print('mi rutita ejej${imagen}');

          return GestureDetector(
            onTap: () {
              _modalCita(context, cita, sizeScreen, dataDashboard);
            },
            child: Container(
                // height: sizeScreen.height * 0.2,
                width: sizeScreen.width * 0.48,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      SizedBox(
                        height: sizeScreen.height * 0.15,
                        width: double.infinity,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image: '$imagenUrlGlobal${cita.fotoPaciente}',
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeInCurve: Curves.easeIn,
                          alignment: Alignment.topCenter,
                          width:
                              sizeScreen.width * 0.1, // diameter of the circle
                          height:
                              sizeScreen.width * 0.1, // diameter of the circle
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 10,
                        child: GestureDetector(
                          onTap: () {
                            //Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 248, 248, 255),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Color.fromARGB(255, 99, 92, 255),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            cita.tipo,
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 99, 92, 255),
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ]),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cita.nombrePaciente,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      dataDashboard
                                          .marcarCitaDash(
                                              cita.tipo, 'no', cita.pacienteId)
                                          .then((value) {
                                        if (value) {
                                          // _showConfirmationDialogmarcarCita(context, Icons.check, ColorPalet.estadoPositive);
                                          mostrarFichaCreada(context,
                                              'Cita marcada como no realizada.');
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.close,
                                        size: 18,
                                        color: ColorPalet.secondaryLight)),
                                IconButton(
                                    onPressed: () {
                                      dataDashboard
                                          .marcarCitaDash(
                                              cita.tipo, 'si', cita.pacienteId)
                                          .then((value) {
                                        if (value) {
                                          // _showConfirmationDialogmarcarCita(context, Icons.check, ColorPalet.estadoPositive);
                                          mostrarFichaCreada(context,
                                              'Cita marcada como realizada.');
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.check,
                                        size: 18,
                                        color: ColorPalet.primaryDefault)),
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  IconlyLight.calendar,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  cita.hora,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 139, 149, 166),
                                      fontFamily: 'inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  IconlyLight.profile,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var responsable in cita.responsables)
                                      Text(
                                        responsable.nombreResponsable,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 139, 149, 166),
                                          fontFamily: 'inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Future<dynamic> _modalCita(BuildContext context, CitaDiaDash cita,
      Size sizeScreen, DashBoardProvider dataDashBoard) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              //height: 500,
              width: sizeScreen.width,
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Container(
                        width: double
                            .infinity, // Ancho de la imagen es todo el ancho del contenedor
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image: '${imagenUrlGlobal}${cita.fotoPaciente}',
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeInCurve: Curves.easeIn,
                          alignment: Alignment.topCenter,
                          width:
                              sizeScreen.width * 0.1, // diameter of the circle
                          height:
                              sizeScreen.width * 0.1, // diameter of the circle
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 248, 255),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 14, 106, 112),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          cita.tipo,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 14, 106, 112)),
                        ),
                      ),
                    )
                  ]),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          cita.nombrePaciente,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              IconlyLight.calendar,
                              size: 25,
                              color: Color.fromARGB(255, 139, 149, 166),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              cita.hora,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontFamily: 'inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 10,
                        ),
                        cita.responsables.length == 1
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/img/user.png'),
                                  )
                                ],
                              )
                            : cita.responsables.length > 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: sizeScreen.height * 0.059,
                                            width: sizeScreen.width * 0.26,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorPalet
                                                          .grisesGray5,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const CircleAvatar(
                                                radius: 23,
                                                backgroundImage: AssetImage(
                                                    'assets/img/user.png'),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorPalet
                                                          .grisesGray5,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: CircleAvatar(
                                                radius: 23,
                                                backgroundColor:
                                                    ColorPalet.acentDefault,
                                                child: Text(
                                                    '${cita.responsables.length - 1}+'),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                : Container()
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Motivo',
                      style: TextStyle(
                          color: ColorPalet.grisesGray1,
                          fontFamily: 'inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      cita.motivo,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 139, 149, 166)),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/perfilMascota',
                                  arguments: cita.pacienteId);
                            },
                            child: const Text(
                              'Ir al Perfil',
                              style:
                                  TextStyle(color: ColorPalet.primaryDefault),
                            )),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // _showConfirmationDialogmarcarCita(context, Icons.close, ColorPalet.secondaryLight);
                            dataDashboard
                                .marcarCitaDash(
                                    cita.tipo, 'no', cita.pacienteId)
                                .then((value) {
                              if (value) {
                                mostrarFichaCreada(
                                    context, 'Cita marcada como no realizada.');
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 248, 248, 255),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 177, 173, 255),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            dataDashboard
                                .marcarCitaDash(
                                    cita.tipo, 'si', cita.pacienteId)
                                .then((value) {
                              if (value) {
                                // _showConfirmationDialogmarcarCita(context, Icons.check, ColorPalet.estadoPositive);
                                mostrarFichaCreada(
                                    context, 'Cita marcada como realizada.');
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 248, 248, 255),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(
                              Icons.check,
                              color: Color.fromARGB(255, 26, 202, 212),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  void _showConfirmationDialogmarcarCita(
      BuildContext context, IconData icon, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        const duration = Duration(seconds: 1);

        Timer(duration, () {
          Navigator.of(context).pop();
        });

        return AlertDialog(
          content: SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}
