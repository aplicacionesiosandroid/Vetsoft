import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/agenda/response_agenda.dart';
import 'package:vet_sotf_app/presentation/screens/agenda/widgets_agenda.dart';
import 'package:vet_sotf_app/providers/agenda_provider.dart';

import '../../../../../config/global/palet_colors.dart';
import '../../../providers/clinica/citasmedicas_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../clinica/otrosProcedimientos/oProcedimiento_screen.dart';

class AgendaScreen extends StatefulWidget {
  AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime todayInicio = DateTime.now();

  @override
  void initState() {
    AgendaProvider dataAgendaProvider =
        Provider.of<AgendaProvider>(context, listen: false);
    String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayInicio);
    dataAgendaProvider.setFechaSelected(formattedDateEnviar);
    dataAgendaProvider.getAgendaDia(formattedDateEnviar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    AgendaProvider dataAgendaProvider = Provider.of<AgendaProvider>(context);

    final _scaffoldKey = GlobalKey<ScaffoldState>();

    List<ClinicaModel> clinicaList = dataAgendaProvider.clinicaList;
    List<PeluqueriaModel> peluqueriaList = dataAgendaProvider.peluqueriaList;
    List<TareaModel> tareaList = dataAgendaProvider.tareaList;

    DateTime _nowDate = DateTime.now();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 99, 92, 255),
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
            centerTitle: true,
            title: Text(
              'Agenda',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontSize: 19,
                  fontWeight: FontWeight.w700),
            ),
          ),
          key: _scaffoldKey,
          backgroundColor: Color.fromARGB(255, 99, 92, 255),
          drawer: const DrawerWidget(),
          body: Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            width: sizeScreen.width,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TableCalendar(
                    //onDaySelected: _onDaySelectedFInicio,
                    onDaySelected: (day, focusedDay) {
                      setState(() {
                        todayInicio = day;
                      });
                      _onDaySelectedInicio(day, focusedDay, context);
                    },

                    selectedDayPredicate: (day) => isSameDay(day, todayInicio),
                    locale: 'es_ES',
                    rowHeight: 43,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      titleTextFormatter:
                          (DateTime focusedDay, dynamic format) {
                        final monthFormat = DateFormat('MMMM', 'es_ES');
                        final monthText = monthFormat.format(focusedDay);
                        final capitalizedMonth =
                            '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                        return '$capitalizedMonth ${focusedDay.year}';
                      },
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: todayInicio,
                    firstDay: DateTime.utc(2023, 02, 10),
                    lastDay: DateTime(
                        _nowDate.year + 1,
                        _nowDate.month,
                        _nowDate.day,
                        _nowDate.hour,
                        _nowDate.minute,
                        _nowDate.second),
                    // Resto de las propiedades y personalización del TableCalendar
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        //shape: BoxShape.rectangle,
                        color: const Color.fromARGB(255, 65, 0, 152),
                        borderRadius: BorderRadius.circular(
                            5), // Ajusta el radio según tus preferencias
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color.fromARGB(255, 65, 0, 152),
                          width: 2,
                        ),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 65, 0, 152),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Eventos del día',
                    style: TextStyle(
                        fontFamily: 'sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorPalet.grisesGray0),
                  ),
                  areasListaTituloWidget(
                      'Clínica', ColorPalet.primaryDefault, Iconsax.hospital5),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    height: clinicaList.isEmpty
                        ? 50
                        : clinicaList.length == 1
                            ? 110
                            : clinicaList.length == 2
                                ? 210
                                : 300,
                    width: sizeScreen.width,
                    child: clinicaList.isEmpty
                        ? Center(
                            child: Text(
                              'No hay nada agendado.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: clinicaList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var clinica = clinicaList[index];
                              return Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EliminarCitaAlertDialog(
                                          textContent: 'marcar como hecho',
                                          textEliminar: 'terminado',
                                          idFicha: clinica.fichaClinicaId,
                                        );
                                      },
                                    );
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EliminarCitaAlertDialog(
                                          textContent: 'cancelar',
                                          textEliminar: 'terminado',
                                          idFicha: clinica.fichaClinicaId,
                                        );
                                      },
                                    );
                                  }
                                },
                                background: Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  color: const Color(0xFFFF6A55),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ), // Opción "Cancelar" a la izquierda
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.white),
                                        ), // Opción "Hecho" a la derecha
                                      ),
                                    ],
                                  ),
                                ),
                                secondaryBackground: Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  color: const Color(0xFF1ACAD4),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ), // Opción "Cancelar" a la izquierda
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Text(
                                          'Hecho',
                                          style: TextStyle(color: Colors.white),
                                        ), // Opción "Hecho" a  la derecha
                                      ),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5, top: 5),
                                  width: sizeScreen.width,
                                  height: 100,
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(
                                          color: ColorPalet.grisesGray4,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 3),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorPalet.primaryDefault,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            width: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, top: 5, bottom: 5),
                                            child: InkWell(
                                              onTap: () {
                                                _modalCita(context, clinica);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        clinica
                                                            .tipoConsultaNombre,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromARGB(
                                                              255, 29, 34, 44),
                                                          fontFamily: 'sans',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   padding: EdgeInsets.all(5),
                                                      //   decoration: BoxDecoration(
                                                      //     borderRadius: BorderRadius.circular(3),
                                                      //     color: Color.fromARGB(255, 235, 251, 249),
                                                      //   ),
                                                      //   child: Text(
                                                      //     'Consulta',
                                                      //     style: TextStyle(
                                                      //       fontSize: 12,
                                                      //       fontFamily: 'inter',
                                                      //       fontWeight: FontWeight.w400,
                                                      //       color: Color.fromARGB(255, 14, 106, 112),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Iconsax.calendar_2,
                                                        color: ColorPalet
                                                            .grisesGray2,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        // dataAgendaProvider.fechaSelected,
                                                        'Hoy',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ColorPalet
                                                              .grisesGray2,
                                                          fontFamily: 'inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        clinica.horaAtencion
                                                            .substring(0, 5),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ColorPalet
                                                              .grisesGray2,
                                                          fontFamily: 'inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 18),
                                                      Icon(
                                                        IconlyLight.profile,
                                                        color: Color.fromARGB(
                                                            255, 139, 149, 166),
                                                      ),
                                                      Container(
                                                        width:
                                                            sizeScreen.width *
                                                                0.3,
                                                        child: Text(
                                                            clinica
                                                                .responsables[0]
                                                                .responsableNombres,
                                                            //cita.nombresVeterinario,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            bottomSheetOptionsAgendaClinica(
                                              context,
                                              sizeScreen.width,
                                              clinica,
                                            ).then((value) {
                                              String formattedDateEnviar =
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(todayInicio);
                                              dataAgendaProvider.getAgendaDia(
                                                  formattedDateEnviar);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.more_vert_rounded,
                                            color: Color(0xFFB1ADFF),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  areasListaTituloWidget('Peluquería',
                      ColorPalet.secondaryLight, Iconsax.scissor_1),
                  SizedBox(
                    height: peluqueriaList.isEmpty
                        ? 50
                        : peluqueriaList.length == 1
                            ? 110
                            : peluqueriaList.length == 2
                                ? 210
                                : 300,
                    width: sizeScreen.width,
                    child: peluqueriaList.isEmpty
                        ? Center(
                            child: Text(
                              'No hay nada agendado.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: peluqueriaList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var peluqueria = peluqueriaList[index];
                              return Container(
                                width: sizeScreen.width,
                                height: 100,
                                margin: EdgeInsets.only(bottom: 5, top: 5),
                                padding: EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border.all(
                                        color: ColorPalet.grisesGray4,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorPalet.secondaryLight,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          width: 3,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 5, bottom: 5),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        peluqueria
                                                            .tipoConsultaNombre,
                                                        //cita.nombreMascota,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    29,
                                                                    34,
                                                                    44),
                                                            fontFamily: 'sans',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Iconsax.calendar_2,
                                                        color: ColorPalet
                                                            .grisesGray2,
                                                      ),
                                                      Text(
                                                        'Hoy',
                                                        //'${cita.fechaSiguienteRevision.toString().substring(0, 10)}, ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: ColorPalet
                                                                .grisesGray2,
                                                            fontFamily: 'inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        peluqueria.horaAtencion
                                                                ?.substring(
                                                                    0, 5) ??
                                                            '',
                                                        //cita.horaSiguienteRevision.substring(0, 5),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: ColorPalet
                                                                .grisesGray2,
                                                            fontFamily: 'inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(width: 18),
                                                      Icon(
                                                        IconlyLight.profile,
                                                        color: Color.fromARGB(
                                                            255, 139, 149, 166),
                                                      ),
                                                      Container(
                                                        width:
                                                            sizeScreen.width *
                                                                0.3,
                                                        child: Text(
                                                            peluqueria
                                                                .responsables[0]
                                                                .responsableNombres,
                                                            //cita.nombresVeterinario,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: Color(0xFFB1ADFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ),
                  areasListaTituloWidget(
                      'Tareas', Color(0xFF7948BA), Iconsax.task_square5),
                  SizedBox(
                    height: tareaList.isEmpty
                        ? 50
                        : tareaList.length == 1
                            ? 110
                            : tareaList.length == 2
                                ? 210
                                : 300,
                    width: sizeScreen.width,
                    child: tareaList.isEmpty
                        ? Center(
                            child: Text(
                              'No hay nada agendado.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tareaList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var tarea = tareaList[index];
                              if (!tarea.responsables.isEmpty ||
                                  !tarea.nombreTarea.isEmpty) {
                                return Container(
                                  width: sizeScreen.width,
                                  height: 100,
                                  margin: EdgeInsets.only(bottom: 5, top: 5),
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(
                                          color: ColorPalet.grisesGray4,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFF7948BA),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            width: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, top: 5, bottom: 5),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: sizeScreen
                                                                    .width *
                                                                0.7,
                                                            child: Text(
                                                                tarea
                                                                    .nombreTarea,
                                                                //cita.nombreMascota,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            29,
                                                                            34,
                                                                            44),
                                                                    fontFamily:
                                                                        'sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Iconsax.calendar_2,
                                                            color: ColorPalet
                                                                .grisesGray2,
                                                          ),
                                                          Text(
                                                            'Hoy',
                                                            //'${cita.fechaSiguienteRevision.toString().substring(0, 10)}, ',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: ColorPalet
                                                                    .grisesGray2,
                                                                fontFamily:
                                                                    'inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          SizedBox(width: 18),
                                                          Icon(
                                                            IconlyLight.profile,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    139,
                                                                    149,
                                                                    166),
                                                          ),
                                                          Container(
                                                            width: sizeScreen
                                                                    .width *
                                                                0.3,
                                                            child: Text(
                                                                tarea
                                                                        .responsables
                                                                        .isNotEmpty
                                                                    ? tarea
                                                                        .responsables[
                                                                            0]
                                                                        .responsableNombres
                                                                    : '',
                                                                //cita.nombresVeterinario,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: ColorPalet
                                                                        .grisesGray2,
                                                                    fontFamily:
                                                                        'inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.more_vert_rounded,
                                            color: Color(0xFFB1ADFF),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<dynamic> _modalCita(BuildContext context, ClinicaModel clinica) {
    final sizeScreen = MediaQuery.of(context).size;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              //height: 500,
              //width: 200,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 80),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/icon/logovs.png',
                        image: '$imagenUrlGlobal${clinica.fotoMascota}',
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 200),
                        fadeInCurve: Curves.easeIn,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Color(0xb3f1fffd),
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            size: 19,
                            Icons.close,
                            color: Color(0xff0E6A70),
                          ),
                        ),
                      ),
                      right: 12,
                      top: 10,
                    ),
                    Positioned(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xb3f1fffd),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Clínica',
                          style: TextStyle(
                              color: Color(0xff0E6A70),
                              fontFamily: 'inter',
                              fontSize: 14),
                        ),
                      ),
                      right: 12,
                      bottom: 10,
                    )
                  ]),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          clinica.nombreMascota.replaceFirst(
                              clinica.nombreMascota[0],
                              clinica.nombreMascota[0].toUpperCase()),
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          IconlyLight.calendar,
                          size: 25,
                          color: Color.fromARGB(255, 139, 149, 166),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Hoy ${clinica.horaAtencion.substring(0, 5)}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166),
                              fontFamily: 'inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        clinica.responsables.isNotEmpty
                            ? Flexible(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 45,
                                    ),
                                    for (var i = 0;
                                        i < clinica.responsables.length &&
                                            i < 1;
                                        i++)
                                      Positioned(
                                        left: i * 43.0,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/icon/logovs.png',
                                              image:
                                                  '$imagenUrlGlobal${clinica.responsables[i].responsableFoto}',
                                              fit: BoxFit.cover,
                                              fadeInDuration:
                                                  Duration(milliseconds: 200),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (clinica.responsables.length > 0)
                                      Positioned(
                                        left: 1 * 30.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          width: 45,
                                          height: 45,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 65, 0, 152),
                                            radius: 30,
                                            child: Text(
                                              '+${clinica.responsables.length - 1}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          'Motivo',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      clinica.motivo,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 139, 149, 166)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              verPerfil(context, clinica);
                            },
                            child: Text(
                              'Ir al Perfil',
                              style: TextStyle(color: Color(0xff27A4CB)),
                            )),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 248, 255),
                                borderRadius: BorderRadius.circular(5)),
                            child: Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 177, 173, 255),
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            verPerfil(context, clinica);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 248, 255),
                                borderRadius: BorderRadius.circular(5)),
                            child: Icon(
                              Icons.check,
                              size: 20,
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

  Padding areasListaTituloWidget(String titulo, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                icon: Icon(icon),
                iconSize: 17,
                color: ColorPalet.grisesGray5,
                onPressed: () {},
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            titulo,
            style: TextStyle(
                fontFamily: 'sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ColorPalet.grisesGray1),
          ),
        ],
      ),
    );
  }

  void _onDaySelectedInicio(
      DateTime day, DateTime focusedDay, BuildContext context) {
    AgendaProvider dataAgendaProvider =
        Provider.of<AgendaProvider>(context, listen: false);
    //setState(() {
    todayInicio = day;
    String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayInicio);
    print(formattedDateEnviar);
    dataAgendaProvider.setFechaSelected(formattedDateEnviar);
    dataAgendaProvider.getAgendaDia(formattedDateEnviar);
    // });
  }

  InkWell _accountOptionProfilWidget(
      Size sizeScreen, VoidCallback funcion, IconData icono, String nombre) {
    return InkWell(
      onTap: funcion,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: sizeScreen.height * 0.1,
        width: sizeScreen.width,
        decoration: BoxDecoration(
            color: ColorPalet.backGroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: ColorPalet.grisesGray3)),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icono,
              size: 30,
              color: ColorPalet.grisesGray1,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              nombre,
              style: TextStyle(
                  fontFamily: 'inter',
                  color: ColorPalet.grisesGray0,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: ColorPalet.grisesGray1,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetOptionsAgendaClinica(
      BuildContext context, double sizeWidth, ClinicaModel clinica) {
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: 40,
                    color: ColorPalet.grisesGray3,
                    height: 3.0,
                  ),
                ),
                Container(
                  width: sizeWidth,
                  height: 100,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      border:
                          Border.all(color: ColorPalet.grisesGray4, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorPalet.primaryDefault,
                            borderRadius: BorderRadius.circular(8)),
                        width: 2,
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
                                  clinica.nombreMascota,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                // Container(
                                //   padding: EdgeInsets.all(5),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(3),
                                //     color: Color.fromARGB(255, 235, 251, 249),
                                //   ),
                                //   child: Text(
                                //     'Consulta',
                                //     style: TextStyle(
                                //         fontSize: 12, fontFamily: 'inter', fontWeight: FontWeight.w400, color: Color.fromARGB(255, 14, 106, 112)),
                                //   ),
                                // ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Hoy,',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  clinica.horaAtencion.substring(0, 5),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 29, 34, 44),
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  IconlyLight.profile,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  clinica.responsables[0].responsableNombres,
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
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Provider.of<ProgramarCitaProvider>(context, listen: false)
                    //     .setSelectedIdPacienteAntiguo('3');
                    // Provider.of<ProgramarCitaProvider>(context, listen: false)
                    //   ..setSelectSquarePCita(2)
                    //   ..setSelectedIndexPaciente(-1);
                    openModalBottomSheetUpdateCita(context, clinica);
                    // ..clearBusquedas();
                  },
                  child: const Row(
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
                    Provider.of<CitaMedicaProvider>(context, listen: false)
                        .marcarCitaComo('terminado', clinica.fichaClinicaId)
                        .then((value) async {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Marcar como hecha',
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EliminarCitaAlertDialog(
                          textContent: 'eliminar',
                          textEliminar: 'terminado',
                          idFicha: clinica.fichaClinicaId,
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        //Iconsax.close_circle,
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

  Future<dynamic> verPerfil(BuildContext context, ClinicaModel clinica) {
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
                Center(
                  child: Container(
                    width: 55,
                    height: 2.0,
                    color: ColorPalet.grisesGray2,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image:
                              '$imagenUrlGlobal${clinica.propietario.imagenPropietario}',
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${clinica.propietario.nombres}',
                          // 'Juan Montes',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${clinica.propietario.ultimaVisita}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 139, 149, 166)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          // '${clinica.nombredueño}',
                          'Datos Cliente',
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${clinica.propietario.celular}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 139, 149, 166)),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${clinica.propietario.direccion}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 139, 149, 166)),
                        ),
                        SizedBox(height: 5),
                      ],
                    )
                  ],
                ),
                Divider(
                  // Línea superior
                  color: ColorPalet.grisesGray3,
                  thickness: 1.0,
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image: '$imagenUrlGlobal${clinica.fotoMascota}',
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinica.nombreMascota,
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${clinica.edadMascota}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 139, 149, 166)),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
        );
      },
    );
  }
}
