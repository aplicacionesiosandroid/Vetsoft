// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/clinica/buscarPacientes_model.dart';
import 'package:vet_sotf_app/models/clinica/citasMedicas_model.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/cirugia/cirugia_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/consulta/consulta_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/desparacitacion/desparacitacion_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/hospitalizacion_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/hospitalizacion_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/otrosProcedimientos/oProcedimiento_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/vacunas/vacuna_update_screen.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/imagenVistaURL.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/programarCitaWidget.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:vet_sotf_app/providers/clinica/cirugia/cirugia_provider.dart';
import 'package:vet_sotf_app/providers/clinica/citasmedicas_provider.dart';
import 'package:vet_sotf_app/providers/clinica/clinica_update_provider.dart';
import 'package:vet_sotf_app/providers/clinica/consulta/consulta_provider.dart';
import 'package:vet_sotf_app/providers/clinica/desparacitacion/desparacitacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';
import 'package:vet_sotf_app/providers/clinica/vacuna/vacuna_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';

import 'package:vet_sotf_app/providers/tabBar_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../widgets/drawer_widget.dart';

import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import '../clinica/cirugia/cirugia_screen.dart';
import '../clinica/consulta/consulta_screen.dart';
import '../clinica/desparacitacion/desparacitacion_screen.dart';
import '../clinica/otrosProcedimientos/oProcedimiento_screen.dart';
import '../clinica/vacunas/vacuna_screen.dart';

class ClinicaScreen extends StatefulWidget {
  const ClinicaScreen({super.key});

  @override
  State<ClinicaScreen> createState() => _ClinicaScreenState();
}

class _ClinicaScreenState extends State<ClinicaScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var programarCitaProvider;
  late TabController _tabController;
  final List<String> _tabs = [
    'Consulta',
    'Cirugia',
    'Vacuna',
    'Desparacitación',
    'Procedimientos especiales',
    'Hospitalización',
  ];
  final List<String> _hiddenTabs = [
    'Consulta',
    'Cirugia',
    'Vacunas',
    'Desparasitacion',
    'Procedimiento',
    'Hospitalizacion',
  ];

  @override
  void initState() {
    super.initState();
    programarCitaProvider =
        Provider.of<ProgramarCitaProvider>(context, listen: false);
    programarCitaProvider.getBusquedasPacienteClinica();
    final userEmpProvider = context.read<UserEmpProvider>();
    if (!userEmpProvider.isLoadingFicha) {
      userEmpProvider.obtieneTipoFicha();
    }

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabBarProvider = Provider.of<TabBarProvider>(context);
    final citaMedicaProvider = Provider.of<CitaMedicaProvider>(context);
    final size = MediaQuery.of(context).size;
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;

    final listaPacientes = programarCitaProvider.getResultadoBusquedasPaciente;

    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    notificationsProvider.tipeWindow = 'clinica';
    notificationsProvider.notificationListWidgetChangedColor();

    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorPalet.complementVerde2,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Container(color:ColorPalet.complementVerde2, height: 30 ,),
              _IconMenu(scaffoldKey: _scaffoldKey, size: size),
              AnimatedContainer(
                color: ColorPalet.complementVerde2,
                duration: const Duration(milliseconds: 500),
                height: isHeaderExpanded ? size.height * 0.22 : 0,
                child: Column(
                  children: [
                    if (isHeaderExpanded)
                      Notify_card_widget(cardNotifyList: cardNotifyList),
                  ],
                ),
              ),
              _FondoVerde(size.height),
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                height: 950,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 247, 246),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TabBarOptions(tabBarProvider),
                    Flexible(
                        child: _TabBarViews(
                            citaMedicaProvider, size.width, listaPacientes)),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: const DrawerWidget());
  }

  TabBarView _TabBarViews(CitaMedicaProvider citaMedicaProvider,
      double sizeWidth, List<ResultBusPacientes> listaPacientes) {
    List<CitaMedica> listaCitaMedica = citaMedicaProvider.getcitasMedicas;
    final providerCitas =
        Provider.of<CitaMedicaProvider>(context, listen: false);
    return TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroConsulta(
                      listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesConsulta(listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroCirugia(
                      listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesCirugia(listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroVacuna(listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesVacuna(listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroDesp(listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesDesp(listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroOProced(
                      listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesOProced(listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 247, 246),
            child: Center(
              child: Column(
                children: [
                  ButtonNuevoRegistroHospitalizacion(
                      listaPacientesBusq: listaPacientes),
                  ButtonProgramarCitaGeneralClinica(
                      listaPacientesBusq: listaPacientes),
                  ButtonPacientesHospitalizacion(
                      listaPacientesBusq: listaPacientes),
                  fechasHorizontalCitaMedica(providerCitas),
                  providerCitas.getcitasMedicas.isNotEmpty
                      ? listadoCitasMedicas(listaCitaMedica, sizeWidth)
                      : Container(
                          padding: EdgeInsets.only(top: sizeWidth * 0.2),
                          child: Center(
                            child: Text(
                              'No hay citas',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ]);
  }

  Container listadoCitasMedicas(
      List<CitaMedica> listaCitaMedica, double sizeWidth) {
    final currentTabIndex =
        Provider.of<TabBarProvider>(context, listen: true).currentIndex;
    final sizeScreen = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      height: 400,
      child: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: listaCitaMedica
            .length, // Cambiar esto por la cantidad real de elementos
        itemBuilder: (BuildContext context, int index) {
          final cita = listaCitaMedica[index];
          // print("Ventana actual: "+_hiddenTabs[currentTabIndex]+ " Tipo de ficha: "+cita.tipoFicha.toLowerCase() + " index actual: "+currentTabIndex.toString());
          if ((currentTabIndex == 0) &&
              ((cita.tipoFicha.toLowerCase() == 'normal') ||
                  (cita.tipoFicha.toLowerCase() == 'parametrizada'))) {
            return Container(
                height: 110,
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 110,
                      width: 120,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: ImageWidgetURL(
                            imageUrl:
                                '$imagenUrlGlobal${cita.fotoMascota ?? ''}',
                            placeholderImage: 'assets/icon/logovs.png',
                            width: sizeScreen.width *
                                0.1, // Ajusta el tamaño según lo necesites
                            height: sizeScreen.width *
                                0.1, // Ajusta el tamaño según lo necesites
                          )),
                    ),
                    Container(
                      width: sizeWidth * 0.6,
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 5.0, top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: sizeWidth * 0.25,
                                child: AutoSizeText(
                                  cita.nombreMascota,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Color.fromARGB(255, 235, 251, 249),
                                ),
                                child: const Text(
                                  'Consulta',
                                  // cita.tipoFicha[0].toUpperCase() + cita.tipoFicha.substring(1).toLowerCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 14, 106, 112)),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    bottomSheetOptionsCitaMedica(
                                        context, sizeWidth, cita);
                                  },
                                  icon: Icon(Iconsax.more))
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                              // SizedBox(width: 5,),
                              Text(
                                cita.horaSiguienteRevision.substring(0, 5),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 139, 149, 166)),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ));
          } else if (_hiddenTabs[currentTabIndex].toLowerCase() ==
              cita.tipoFicha.toLowerCase()) {
            return Container(
                height: 110,
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 110,
                      width: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: ImageWidgetURL(
                            imageUrl:
                                '$imagenUrlGlobal${cita.fotoMascota ?? ''}',
                            placeholderImage: 'assets/icon/logovs.png',
                            width: sizeScreen.width *
                                0.1, // Ajusta el tamaño según lo necesites
                            height: sizeScreen.width *
                                0.1, // Ajusta el tamaño según lo necesites
                          )),
                    ),
                    Container(
                      width: sizeWidth * 0.6,
                      padding: const EdgeInsets.only(
                          left: 7.0, right: 0.0, top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: sizeWidth * 0.2,
                                child: AutoSizeText(
                                  cita.nombreMascota,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color:
                                      const Color.fromARGB(255, 235, 251, 249),
                                ),
                                child: Text(
                                  cita.tipoFicha[0].toUpperCase() +
                                      cita.tipoFicha.substring(1).toLowerCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 14, 106, 112)),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    bottomSheetOptionsCitaMedica(
                                        context, sizeWidth, cita);
                                  },
                                  icon: Icon(Iconsax.more))
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 139, 149, 166)),
                              // SizedBox(width: 5,),
                              Text(
                                cita.horaSiguienteRevision.substring(0, 5),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 139, 149, 166)),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ));
          } else {
            // print("ficha lower case: "+_hiddenTabs[currentTabIndex].toLowerCase());
            // print("tipo ficha: " +cita.tipoFicha.toLowerCase());
            return Container(
                // child: Center(
                //   child: Text(
                //     'No hay citas',
                //     style: TextStyle(fontSize: 16, fontFamily: 'inter', fontWeight: FontWeight.w400, color: Color.fromARGB(255, 139, 149, 166)),
                //   ),
                // ),
                );
          }
        },
      ),
    );
  }

  Flexible fechasHorizontalCitaMedica(CitaMedicaProvider providerCitas) {
    DateTime _currentDate = providerCitas.fechaCalendarioClinica.isEmpty
        ? DateTime.now()
        : DateTime.tryParse(providerCitas.fechaCalendarioClinica) ??
            DateTime.now();

    return Flexible(
      child: Container(
        height: 145,
        child: EasyDateTimeLine(
          headerProps: const EasyHeaderProps(
            showSelectedDate: true,
            selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY,
            monthPickerType: MonthPickerType.switcher,
          ),
          dayProps: EasyDayProps(
            inactiveBorderRadius: 35,
            dayStructure: DayStructure.dayStrDayNum,
            height: 85,
            width: 45,
            inactiveDayNumStyle: const TextStyle(
              color: ColorPalet.complementVerde3,
              fontSize: 20,
              fontFamily: 'sans',
              fontWeight: FontWeight.bold,
            ),
            activeDayDecoration: BoxDecoration(
              color: ColorPalet.complementVerde3,
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          activeColor: ColorPalet.complementVerde3,
          locale: 'es_ES',
          initialDate: _currentDate,
          onDateChange: (selectedDate) {
            final fechaSeleccionada =
                DateFormat("yyyy-MM-dd").format(selectedDate);
            providerCitas.fechaCalendarioClinica = fechaSeleccionada;
            providerCitas.getCitasMedicas(fechaSeleccionada);
          },
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetOptionsCitaMedica(
      BuildContext context, double sizeWidth, CitaMedica cita) {
    final tabsProvider = Provider.of<TabBarProvider>(context, listen: false);
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
                const Row(
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
                  width: sizeWidth,
                  height: 100,
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 15, left: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border:
                          Border.all(color: ColorPalet.grisesGray4, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 224, 76, 55),
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
                            Row(
                              children: [
                                Text(
                                  cita.nombreMascota,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: const Color.fromARGB(
                                        255, 235, 251, 249),
                                  ),
                                  child: Text(
                                    _tabs[tabsProvider.currentIndex],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 14, 106, 112)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                Text(
                                  '${cita.fechaSiguienteRevision.toString().substring(0, 10)}, ',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  cita.horaSiguienteRevision.substring(0, 5),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400),
                                ),
                                const Icon(
                                  IconlyLight.profile,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                Text(
                                  cita.nombresVeterinario,
                                  style: const TextStyle(
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
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    final currentTabIndex = tabsProvider.currentIndex;
                    print("pantalla acutal" + _tabs[currentTabIndex]);
                    final responseData = await ClinicaUpdateProvider()
                        .getClinicaUpdate(cita.idFichaClinica);
                    if (responseData != null) {
                      if (cita.descripcion.toLowerCase().contains("cita")) {
                        abrirModalActualizarCitaProgramada(
                            context, responseData, cita);
                        return;
                      }
                      switch (currentTabIndex) {
                        case 0:
                          ConsultaProvider dataConsulta =
                              Provider.of<ConsultaProvider>(context,
                                  listen: false);
                          dataConsulta.resetearDatosForm();
                          dataConsulta.setFichaId(cita.idFichaClinica);
                          dataConsulta.setSelectSquareConsulta(1);
                          openModalBottomSheetConsultaActualizar(
                              context, responseData);
                          break;
                        case 1:
                          CirugiaProvider dataCirugia =
                              Provider.of<CirugiaProvider>(context,
                                  listen: false);
                          dataCirugia.resetearDatosForm();
                          dataCirugia.setFichaId(cita.idFichaClinica);
                          dataCirugia.setSelectSquareCirugia(1);
                          openModalBottomSheetCirugia(context, responseData);
                          break;
                        case 2:
                          VacunaProvider dataVacuna =
                              Provider.of<VacunaProvider>(context,
                                  listen: false);
                          dataVacuna.resetearDatosForm();
                          dataVacuna.setFichaId(cita.idFichaClinica);
                          dataVacuna.setSelectSquareVacuna(1);
                          openModalBottomSheetVacuna(context, responseData);
                          break;
                        case 3:
                          DesparacitacionProvider dataDesparacitacion =
                              Provider.of<DesparacitacionProvider>(context,
                                  listen: false);
                          dataDesparacitacion.resetearDatosForm();
                          dataDesparacitacion.setFichaId(cita.idFichaClinica);
                          dataDesparacitacion.setSelectSquareDesparacitacion(1);
                          openModalBottomSheetDesparasitacion(
                              context, responseData);
                          break;
                        case 4:
                          // TODO: realizar backend
                          OProcedimientosProvider dataOProcedimiento =
                              Provider.of<OProcedimientosProvider>(context,
                                  listen: false);
                          dataOProcedimiento.resetearDatosForm();
                          dataOProcedimiento.setFichaId(cita.idFichaClinica);
                          openModalBottomSheetOProcedimiento(
                              context, responseData);
                          // abrirModalActualizarCitaProgramada(
                          //     context, responseData, cita);
                          break;
                        case 5:
                          HospitalizacionProvider dataHospitalizacion =
                              Provider.of<HospitalizacionProvider>(context,
                                  listen: false);
                          dataHospitalizacion.resetearDatosForm();
                          dataHospitalizacion.setFichaId(cita.idFichaClinica);
                          dataHospitalizacion.setSelectSquareHospitalizacion(1);
                          openModalBottomSheetHospitalizacion(
                              context, responseData);
                          // abrirModalActualizarCitaProgramada(context, responseData, cita);
                          break;
                      }
                    }
                  },
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.recovery_convert,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'En espera',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 72, 86, 109),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CitaMedicaProvider>(context,
                                              listen: false)
                                          .marcarCitaComo(
                                              'terminado', cita.idFichaClinica)
                                          .then((value) async {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.trash,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Terminado',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 72, 86, 109),
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
                        'Mover como',
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
                    _mostrarAlertaEliminarCita(
                      context,
                      'terminado',
                      cita.idFichaClinica,
                    );
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
                  height: 20,
                ),
              ]),
        );
      },
    );
  }

  TabBar _TabBarOptions(TabBarProvider tabBarProvider) {
    return TabBar(
        indicatorColor: const Color.fromARGB(255, 26, 202, 212),
        labelColor: const Color.fromARGB(255, 26, 202, 212),
        unselectedLabelColor: const Color.fromARGB(255, 139, 149, 166),
        controller: _tabController,
        isScrollable: true,
        tabs: const [
          Tab(
            child: Text(
              'Consulta',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Cirugia',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Vacuna',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Desparasitacion',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Procedimientos especiales',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
          Tab(
            child: Text(
              'Hospitalización',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans',
                  fontSize: 16),
            ),
          ),
        ],
        onTap: (value) {
          tabBarProvider.setCurrentTabIndex(value);
        });
  }

  SizedBox _FondoVerde(double sizeHeigth) {
    return SizedBox(
      child: Container(
        height: sizeHeigth * 0.1,
        width: double.infinity,
        color: ColorPalet.complementVerde2,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                'Clinica',
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
    );
  }

  void _mostrarAlertaEliminarCita(
      BuildContext context, String textEliminar, int idFicha) {
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
              '¿Estás seguro/a de eliminar esta cita?',
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
                      'Se eliminará la cita.',
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
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'No',
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
                                  Provider.of<CitaMedicaProvider>(context,
                                          listen: false)
                                      .marcarCitaComo(textEliminar, idFicha)
                                      .then((value) async {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        Color.fromARGB(255, 28, 149, 187),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Sí',
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
}

class _IconMenu extends StatelessWidget {
  const _IconMenu({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.size,
  }) : _scaffoldKey = scaffoldKey;

  final Size size;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                  color: ColorPalet.complementVerde1,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const ImageIcon(
                    AssetImage(
                      'assets/img/menu_icon.png',
                    ),
                    size: 30,
                    color: Colors.white,
                  ))),
          Spacer(),
          Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                  color: ColorPalet.complementVerde1,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                icon: Icon(Iconsax.notification_bing),
                color: ColorPalet.grisesGray5,
                onPressed: () {
                  final headerModel =
                      Provider.of<HomePetShopProvider>(context, listen: false);
                  headerModel.toggleExpansion();
                },
              )),
          Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                  color: ColorPalet.complementVerde1,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                icon: Icon(Iconsax.message_text_1),
                color: ColorPalet.grisesGray5,
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
