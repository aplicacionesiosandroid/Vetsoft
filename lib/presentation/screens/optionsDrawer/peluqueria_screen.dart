import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/peluqueria/citasPeluqueria_model.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/imagenVistaURL.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/peluqueria_provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/programarCitaPelu_provider.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/peluqueria/citaspeluqueria_provider.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../widgets/drawer_widget.dart';

import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import '../peluqueria/acciones_peluqueria_screen.dart';

class PeluqueriaScreen extends StatefulWidget {
  PeluqueriaScreen({Key? key});

  @override
  _PeluqueriaScreenState createState() => _PeluqueriaScreenState();
}

class _PeluqueriaScreenState extends State<PeluqueriaScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider =
        Provider.of<ProgramarCitaPeluProvider>(context, listen: false);
    await provider.getBusquedasPaciente();
    print("datos cargados dueños");
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final providerCitasPelu =
        Provider.of<CitaPeluqueriaProvider>(context, listen: true);
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;
    final provider =
        Provider.of<ProgramarCitaPeluProvider>(context, listen: true);
    final listaPacientes = provider.getResultadoBusquedasPaciente;

    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    notificationsProvider.tipeWindow = 'peluqeria';
    notificationsProvider.notificationListWidgetChangedColor();

    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color.fromARGB(255, 71, 67, 188),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _IconMenu(scaffoldKey: _scaffoldKey, size: sizeScreen),
                AnimatedContainer(
                  color: const Color.fromARGB(255, 71, 67, 188),
                  duration: const Duration(milliseconds: 500),
                  height: isHeaderExpanded ? sizeScreen.height * 0.22 : 0,
                  child: Column(
                    children: [
                      if (isHeaderExpanded)
                        Notify_card_widget(cardNotifyList: cardNotifyList),
                    ],
                  ),
                ),
                _letraTitulo(sizeScreen.height),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  height: 950,
                  width: sizeScreen.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 247, 246),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          color: const Color.fromARGB(255, 245, 247, 246),
                          child: Center(
                            child: Column(
                              children: [
                                ButtonNuevoRegistroPeluqueria(
                                    listaPacientesBusq: listaPacientes),
                                ButtonProgramarCitaPeluqueria(
                                    listaPacientesBusq: listaPacientes),
                                ButtonPacientesPeluqueria(
                                    listaPacientesBusq: listaPacientes),
                                fechasHorizontalCitaMedica(providerCitasPelu),
                                providerCitasPelu.getcitasPeluquerias.isNotEmpty
                                    ? listadoCitasPeluqueria(
                                        providerCitasPelu.getcitasPeluquerias,
                                        sizeScreen.width)
                                    : Container(
                                        child: Center(
                                          child: Text(
                                            'No hay citas',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'inter',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 139, 149, 166)),
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
              ],
            ),
          ),
          drawer: const DrawerWidget()),
    );
  }

  Container listadoCitasPeluqueria(
      List<CitaPeluqueria> listaCitaPeluqueria, double sizeWidth) {
    final sizeScreen = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      height: 400,
      child: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: listaCitaPeluqueria
            .length, // Cambiar esto por la cantidad real de elementos
        itemBuilder: (BuildContext context, int index) {
          final cita = listaCitaPeluqueria[index];
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
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        child: ImageWidgetURL(
                          imageUrl: '$imagenUrlGlobal${cita.fotoMascota ?? ''}',
                          placeholderImage: 'assets/icon/logovs.png',
                          width: sizeScreen.width *
                              0.1, // Ajusta el tamaño según lo necesites
                          height: sizeScreen.width *
                              0.1, // Ajusta el tamaño según lo necesites
                        )),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 5.0, top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              cita.nombreMascota,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'sans',
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color.fromARGB(255, 235, 251, 249),
                              ),
                              child: Text(
                                'Pelquería',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 14, 106, 112)),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () {
                                  bottomSheetOptionsCitaMedica(
                                      context, sizeWidth, cita);
                                },
                                icon: Icon(Icons.more_horiz))
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.access_time,
                                    color: Color.fromARGB(255, 139, 149, 166))),
                            // SizedBox(width: 5,),
                            Text(
                              cita.fechaProximaVisita
                                  .toString()
                                  .substring(0, 10),
                              style: TextStyle(
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
        },
      ),
    );
  }

  Future<dynamic> bottomSheetOptionsCitaMedica(
      BuildContext context, double sizeWidth, CitaPeluqueria cita) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: sizeWidth,
                    height: 100,
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, right: 15, left: 5),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        border: Border.all(
                            color: Color.fromARGB(255, 246, 239, 255),
                            width: 2),
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
                              Row(
                                children: [
                                  Text(
                                    cita.nombreMascota,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 29, 34, 44),
                                        fontFamily: 'sans',
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Color.fromARGB(255, 235, 251, 249),
                                    ),
                                    child: Text(
                                      'Consulta',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(
                                              255, 14, 106, 112)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: Color.fromARGB(255, 139, 149, 166),
                                  ),
                                  Text(
                                    '${cita.fechaProximaVisita.toString().substring(0, 10)}, ',
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
                                    cita.fechaProximaVisita
                                        .toString()
                                        .substring(0, 5),
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
                  InkWell(
                    onTap: () async {
                      await Provider.of<PeluqueriaProvider>(context,
                              listen: false)
                          .getDatosFicha(cita.idFichaPeluqueria);
                      // ignore: use_build_context_synchronously
                      openModalBottomSheetOPeluqueriaUpdate(
                          context,
                          Provider.of<PeluqueriaProvider>(context,
                                  listen: false)
                              .getPeluqueriaUpdateForm);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.edit,
                          color: Color.fromARGB(255, 72, 86, 109),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Editar turno',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            color: Color.fromARGB(
                                                255, 72, 86, 109),
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
                                        Provider.of<CitaPeluqueriaProvider>(
                                                context,
                                                listen: false)
                                            .marcarCitaPeluqueriaComo(
                                                'terminado',
                                                cita.idFichaPeluqueria)
                                            .then((value) async {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.trash,
                                            color: Color.fromARGB(
                                                255, 72, 86, 109),
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
                  InkWell(
                    onTap: () {
                      _mostrarAlertaEliminarCitaPelu(
                        context,
                        'terminado',
                        cita.idFichaPeluqueria,
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
                  )
                ]),
          ),
        );
      },
    );
  }

  void _mostrarAlertaEliminarCitaPelu(
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
                                  Provider.of<CitaPeluqueriaProvider>(context,
                                          listen: false)
                                      .marcarCitaPeluqueriaComo(
                                          textEliminar, idFicha)
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

  Flexible fechasHorizontalCitaMedica(
      CitaPeluqueriaProvider providerCitasPeluqueria) {
    return Flexible(
      child: Container(
        height: 200,
        child: EasyDateTimeLine(
          headerProps: const EasyHeaderProps(
              showSelectedDate: true,
              selectedDateFormat: SelectedDateFormat.fullDateMonthAsStrDY,
              monthPickerType: MonthPickerType.switcher),
          dayProps: EasyDayProps(
            inactiveBorderRadius: 35,
            dayStructure: DayStructure.dayStrDayNum,
            height: 90,
            width: 45,
            inactiveDayNumStyle: TextStyle(
                color: ColorPalet.secondaryDefault,
                fontSize: 20,
                fontFamily: 'sans',
                fontWeight: FontWeight.bold),
            activeDayDecoration: BoxDecoration(
                color: ColorPalet.secondaryDefault,
                borderRadius: BorderRadius.circular(35)),
          ),
          activeColor: ColorPalet.secondaryDefault,
          locale: 'es_ES',
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            final fechaSeleccionada =
                DateFormat("yyyy-MM-dd").format(selectedDate);
            providerCitasPeluqueria.getCitasPeluqueria(fechaSeleccionada);
          },
        ),
      ),
    );
  }

  SizedBox _letraTitulo(double sizeHeigth) {
    return SizedBox(
      child: Container(
        height: sizeHeigth * 0.10,
        width: double.infinity,
        color: const Color.fromARGB(255, 71, 67, 188),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                'Peluquería',
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
                  color: Color(0x636B64FF),
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
                  color: Color(0x636B64FF),
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
    );
  }
}
