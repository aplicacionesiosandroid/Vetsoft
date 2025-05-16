// perfil_mascota.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/clinica/citasMedicas_model.dart';
import 'package:vet_sotf_app/models/peluqueria/peluqueria_update_form.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/cirugia/cirugia_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/consulta/consulta_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/desparacitacion/desparacitacion_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/hospitalizacion_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/otrosProcedimientos/oProcedimiento_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/vacunas/vacuna_update_screen.dart';
import 'package:vet_sotf_app/presentation/screens/peluqueria/acciones_peluqueria_screen.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/programarCitaWidget.dart';
import 'package:vet_sotf_app/providers/clinica/cirugia/cirugia_provider.dart';
import 'package:vet_sotf_app/providers/clinica/clinica_update_provider.dart';
import 'package:vet_sotf_app/providers/clinica/consulta/consulta_provider.dart';
import 'package:vet_sotf_app/providers/clinica/desparacitacion/desparacitacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';
import 'package:vet_sotf_app/providers/clinica/vacuna/vacuna_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/peluqueria_provider.dart';
import 'package:vet_sotf_app/providers/perfiles/model/perfilMascota.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/perfiles/perfil_mascota_provider.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';

class PerfilMascotaWidget extends StatefulWidget {
  @override
  _PerfilMascotaWidgetState createState() => _PerfilMascotaWidgetState();
}

class _PerfilMascotaWidgetState extends State<PerfilMascotaWidget> {
  PerfilMascotaProvider? _perfilMascotaProvider;
  int selectedIndex = -1; // Índice de la tarjeta seleccionada

  @override
  void initState() {
    super.initState();
    // La referencia al proveedor debe obtenerse en initState
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _perfilMascotaProvider =
          Provider.of<PerfilMascotaProvider>(context, listen: false);
      final int id = ModalRoute.of(context)!.settings.arguments as int;
      print("id de mi mascota $id");
      if (_perfilMascotaProvider!.getPerfilMascota == null &&
          !_perfilMascotaProvider!.isLoading) {
        _perfilMascotaProvider!.fetchPerfilMascota(id);
      }
    });
  }

  @override
  void dispose() {
    _perfilMascotaProvider?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;

    final mascotaPerfilProvider = Provider.of<PerfilMascotaProvider>(context);
    PerfilMascota? mascota = mascotaPerfilProvider.getPerfilMascota;
// Función para calcular la posición `top` de cada tarjeta
    double _calculateTopPosition(int index) {
      double baseHeight = 55; // Altura básica de una tarjeta no seleccionada
      double expandedHeight = 230; // Altura cuando la tarjeta está seleccionada
      double spacing = 20; // Espacio entre las tarjetas

      double top = 0;

      for (int i = 0; i < index; i++) {
        if (selectedIndex == i) {
          top += expandedHeight +
              spacing; // Si la tarjeta está seleccionada, ocupar más espacio
        } else {
          top += baseHeight +
              spacing; // Si no está seleccionada, ocupar espacio normal
        }
      }

      return top;
    }

    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 99, 92, 255),
          leading: Center(
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Color(0xFF6B64FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: ImageIcon(
                  AssetImage('assets/img/menu_icon.png'),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Color(0x636B64FF),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                icon: Icon(Iconsax.notification_bing),
                color: ColorPalet.grisesGray5,
                onPressed: () {
                  final headerModel = Provider.of<HomePetShopProvider>(
                    context,
                    listen: false,
                  );
                  headerModel.toggleExpansion();
                },
              ),
            ),
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Color(0x636B64FF),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                icon: Icon(Iconsax.message_text_1),
                color: ColorPalet.grisesGray5,
                onPressed: () {},
              ),
            ),
          ],
        ),
        backgroundColor: ColorPalet.secondaryDefault,
        body: Column(
          children: [
            AnimatedContainer(
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (isHeaderExpanded)
                    Notify_card_widget(cardNotifyList: cardNotifyList),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 15),
                      child: Text(
                        'Paciente',
                        style: TextStyle(
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: sizeScreen.width,
                      child: Container(
                        color: const Color.fromARGB(255, 99, 92, 255),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: sizeScreen.width,
                              child: Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: sizeScreen.width * 0.3,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/icon/logovs.png',
                                                image:
                                                    '$imagenUrlGlobal${mascota?.fotoPaciente ?? ''}',
                                                fit: BoxFit.cover,
                                                fadeInDuration:
                                                    Duration(milliseconds: 200),
                                                fadeInCurve: Curves.easeIn,
                                                alignment: Alignment.topCenter,
                                                width: sizeScreen.width *
                                                    0.3, // diameter of the circle
                                                height: sizeScreen.width *
                                                    0.3, // diameter of the circle
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: ColorPalet
                                                      .secondaryDefault,
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/icon/logovs.png',
                                                  image:
                                                      '$imagenUrlGlobal${mascota?.fotoPropietario ?? ''}',
                                                  fit: BoxFit.cover,
                                                  fadeInDuration: Duration(
                                                      milliseconds: 200),
                                                  fadeInCurve: Curves.easeIn,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  width: sizeScreen.width *
                                                      0.1, // diameter of the circle
                                                  height: sizeScreen.width *
                                                      0.1, // diameter of the circle
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   right: 0,
                                  //   child: Container(
                                  //     height: 38,
                                  //     width: 38,
                                  //     decoration: BoxDecoration(
                                  //       color: Color(0xFF6B64FF),
                                  //       borderRadius: BorderRadius.circular(10),
                                  //     ),
                                  //     margin: EdgeInsets.only(right: 15),
                                  //     child: IconButton(
                                  //       icon: Icon(Iconsax.edit_2),
                                  //       color: ColorPalet.grisesGray5,
                                  //       onPressed: () {},
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Text(
                              mascota?.nombrePaciente != null
                                  ? '${mascota?.nombrePaciente}'
                                  : 'Nombre no definido',
                              style: TextStyle(
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              mascota?.edadPaciente != null
                                  ? '${mascota?.edadPaciente} años'
                                  : 'Edad no definida',
                              style: TextStyle(
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              mascota?.tipoRaza != null
                                  ? '${mascota?.tipoRaza}'
                                  : 'Raza no definida',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeScreen.height < 700
                          ? sizeScreen.height * 0.85
                          : sizeScreen.height < 801
                              ? sizeScreen.height * 0.69
                              : sizeScreen.height * 0.66,
                      child: Stack(
                        children: List.generate(
                          mascotaPerfilProvider.patientData.length,
                          (index) => AnimatedPositioned(
                            duration: const Duration(
                                milliseconds: 600), // Animación más rápida
                            curve: Curves.easeInOut, // Movimiento más suave
                            top: _calculateTopPosition(
                                index), // Calcular la posición dinámica
                            left: 0,
                            right: 0,
                            child: _buildPatientRecord(
                              mascota,
                              mascotaPerfilProvider.patientData[index],
                              mascotaPerfilProvider.patientColors[index],
                              index,
                              sizeScreen,
                            ),
                            // child: Text(
                            //   sizeScreen.height.toString(),
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRecord(PerfilMascota? mascota, String title, Color color,
      int index, Size sizeScreen) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex == index) {
            selectedIndex = -1; // Deselect if already selected
          } else {
            selectedIndex = index;
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        width: sizeScreen.width,
        height: 275,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(35.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 27, 55, 112),
                      fontSize: 20.0,
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final uiProviderBottomBar =
                        Provider.of<UiProvider>(context, listen: false);
                    final uiProviderDrawer =
                        Provider.of<UiProvider>(context, listen: false);

                    if (title == "Consulta") {
                      uiProviderBottomBar.setOptionSelectedDrawer('Clinica');
                      uiProviderBottomBar.setSelectedIndexBottomBar(0);
                      uiProviderBottomBar.selectedOptionDrawer == 'Clinica';
                      uiProviderDrawer.setOptionSelectedDrawer('Clinica');
                      Navigator.pop(context);
                      print('Edit button Consulta');
                    } else if (title == "Cirugía") {
                      uiProviderBottomBar.setOptionSelectedDrawer('Clinica');
                      uiProviderBottomBar.setSelectedIndexBottomBar(0);
                      uiProviderBottomBar.selectedOptionDrawer == 'Clinica';
                      uiProviderDrawer.setOptionSelectedDrawer('Clinica');
                      Navigator.pop(context);
                    } else if (title == "Vacunación") {
                      uiProviderBottomBar.setOptionSelectedDrawer('Clinica');
                      uiProviderBottomBar.setSelectedIndexBottomBar(0);
                      uiProviderBottomBar.selectedOptionDrawer == 'Clinica';
                      uiProviderDrawer.setOptionSelectedDrawer('Clinica');
                      Navigator.pop(context);
                    } else if (title == "Desparasitación") {
                      uiProviderBottomBar.setOptionSelectedDrawer('Peluqueria');
                      uiProviderBottomBar.setSelectedIndexBottomBar(0);
                      uiProviderBottomBar.selectedOptionDrawer == 'Peluqueria';
                      uiProviderDrawer.setOptionSelectedDrawer('Peluqueria');
                      Navigator.pop(context);
                    } else if (title == "Peluquería") {
                      uiProviderBottomBar.setOptionSelectedDrawer('Peluqueria');
                      uiProviderBottomBar.setSelectedIndexBottomBar(0);
                      uiProviderBottomBar.selectedOptionDrawer == 'Peluqueria';
                      uiProviderDrawer.setOptionSelectedDrawer('Peluqueria');
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(35.0),
                    child: Icon(
                      Iconsax.edit_2,
                      color: ColorPalet.grisesGray0,
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 5, color: ColorPalet.backGroundColor),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: ColorPalet.backGroundColor,
              width: sizeScreen.width,
              child: Row(
                children: [
                  Text(
                    'Actividad reciente',
                    style: TextStyle(
                      fontFamily: 'sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              color: ColorPalet.backGroundColor,
              width: sizeScreen.width,
              height: 125,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: title == 'Peluquería'
                    ? mascota?.peluquerias.length
                    : mascota?.consultas.length,
                itemBuilder: (context, index) {
                  if (title != "Peluquería") {
                    final consultaRealizada = mascota?.consultas[index];
                    if (consultaRealizada == null) {
                      return Center(
                        child: Text(
                          " ",
                          style: TextStyle(
                            fontFamily: 'sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                    if (title == "Consulta" &&
                        (consultaRealizada?.tipoFicha == "NORMAL" ||
                            consultaRealizada?.tipoFicha == "PARAMETRIZADA")) {
                      // Condición para ficha de tipo "NORMAL" o "PARAMETRIZADA"
                      return buildConsultaItem(
                          context, sizeScreen, consultaRealizada, title, index);
                    } else if (title == "Cirugía" &&
                        consultaRealizada?.tipoFicha == "CIRUGIA") {
                      // Condición para ficha de tipo "CIRUGIA"
                      return buildConsultaItem(
                          context, sizeScreen, consultaRealizada, title, index);
                    } else if (title == "Vacunación" &&
                        consultaRealizada?.tipoFicha == "VACUNAS") {
                      // Condición para ficha de tipo "VACUNAS"
                      return buildConsultaItem(
                          context, sizeScreen, consultaRealizada, title, index);
                    } else if (title == "Desparasitación" &&
                        consultaRealizada?.tipoFicha == "DESPARASITACION") {
                      // Condición para ficha de tipo "DESPARASITACION"
                      return buildConsultaItem(
                          context, sizeScreen, consultaRealizada, title, index);
                    }
                  } else {
                    // Condición para ficha de tipo "PELUQUERIA"
                    final consultaPeluqueria = mascota?.peluquerias[index];
                    if (consultaPeluqueria == null) {
                      return Center(
                        child: Text(
                          " ",
                          style: TextStyle(
                            fontFamily: 'sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                    return buildConsultaItemPeluqueria(
                        context, sizeScreen, consultaPeluqueria, title, index);
                  }
                },
              ),
            ),
            Container(height: 19, color: ColorPalet.backGroundColor),
          ],
        ),
      ),
    );
  }
}

Widget buildConsultaItem(BuildContext context, Size sizeScreen,
    Consulta consulta, String title, int currentTabIndex) {
  final mascotaPerfilProvider =
      Provider.of<PerfilMascotaProvider>(context, listen: false);
  return InkWell(
    onTap: () async {
      int currentTabIndex = mascotaPerfilProvider.patientData.indexOf(title);

      Utilidades.imprimir("pantalla acutal: " + currentTabIndex.toString());

      final responseData = await ClinicaUpdateProvider()
          .getClinicaUpdate(consulta.fichaClinicaId);
      if (responseData != null) {
        if (consulta.tipoAtencion.toLowerCase().contains("cita")) {
          abrirModalActualizarCitaProgramada(
              context, responseData, consulta as CitaMedica);
          return;
        }
        switch (currentTabIndex) {
          case 0:
            ConsultaProvider dataConsulta =
                Provider.of<ConsultaProvider>(context, listen: false);
            dataConsulta.resetearDatosForm();
            dataConsulta.setFichaId(consulta.fichaClinicaId);
            dataConsulta.setSelectSquareConsulta(1);
            openModalBottomSheetConsultaActualizar(context, responseData);
            break;
          case 1:
            CirugiaProvider dataCirugia =
                Provider.of<CirugiaProvider>(context, listen: false);
            dataCirugia.resetearDatosForm();
            dataCirugia.setFichaId(consulta.fichaClinicaId);
            dataCirugia.setSelectSquareCirugia(1);
            openModalBottomSheetCirugia(context, responseData);
            break;
          case 2:
            VacunaProvider dataVacuna =
                Provider.of<VacunaProvider>(context, listen: false);
            dataVacuna.resetearDatosForm();
            dataVacuna.setFichaId(consulta.fichaClinicaId);
            dataVacuna.setSelectSquareVacuna(1);
            openModalBottomSheetVacuna(context, responseData);
            break;
          case 3:
            DesparacitacionProvider dataDesparacitacion =
                Provider.of<DesparacitacionProvider>(context, listen: false);
            dataDesparacitacion.resetearDatosForm();
            dataDesparacitacion.setFichaId(consulta.fichaClinicaId);
            dataDesparacitacion.setSelectSquareDesparacitacion(1);
            openModalBottomSheetDesparasitacion(context, responseData);

            break;
          case 4:
            PeluqueriaProvider dataPeluqueria =
                Provider.of<PeluqueriaProvider>(context, listen: false);
            dataPeluqueria.resetearDatos();
            dataPeluqueria.setSelectSquarePeluqueria(1);
            openModalBottomSheetOPeluqueriaUpdate(
                context, responseData as PeluqueriaUpdateForm);
            break;
          case 5:
            // TODO: realizar backend
            OProcedimientosProvider dataOProcedimiento =
                Provider.of<OProcedimientosProvider>(context, listen: false);
            dataOProcedimiento.resetearDatosForm();
            dataOProcedimiento.setFichaId(consulta.fichaClinicaId);
            openModalBottomSheetOProcedimiento(context, responseData);
            // abrirModalActualizarCitaProgramada(
            //     context, responseData, cita);
            break;
          case 6:
            HospitalizacionProvider dataHospitalizacion =
                Provider.of<HospitalizacionProvider>(context, listen: false);
            dataHospitalizacion.resetearDatosForm();
            dataHospitalizacion.setFichaId(consulta.fichaClinicaId);
            dataHospitalizacion.setSelectSquareHospitalizacion(1);
            openModalBottomSheetHospitalizacion(context, responseData);
            // abrirModalActualizarCitaProgramada(context, responseData, cita);
            break;
        }
      }
    },
    child: Container(
      width: sizeScreen.width * 0.8,
      height: sizeScreen.height * 0.1,
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: ColorPalet.grisesGray4, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorPalet.secondaryDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            width: 4,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: sizeScreen.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Iconsax.calendar_2, color: ColorPalet.grisesGray2),
                    SizedBox(width: 6),
                    Expanded(
                      child: AutoSizeText(
                        consulta?.fechaRevision != null
                            ? "${consulta?.fechaRevision}\n${consulta.horaRevision.substring(0, 5)}"
                            : "Fecha no definida",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorPalet.grisesGray2,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(IconlyLight.profile, color: ColorPalet.grisesGray2),
                    SizedBox(width: 6),
                    Expanded(
                      child: AutoSizeText(
                        consulta?.nombresEncargado != null
                            ? "${consulta?.nombresEncargado} ${consulta?.apellidosEncargado}"
                            : "Encargado no definido",
                        style: TextStyle(
                          color: ColorPalet.grisesGray2,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildConsultaItemPeluqueria(BuildContext context, Size sizeScreen,
    Peluqueria consulta, String title, int currentTabIndex) {
  final mascotaPerfilProvider =
      Provider.of<PerfilMascotaProvider>(context, listen: false);
  return InkWell(
    onTap: () async {
      int currentTabIndex = mascotaPerfilProvider.patientData.indexOf(title);
      Utilidades.imprimir("pantalla acutal: " + currentTabIndex.toString());

      PeluqueriaProvider dataPeluqueria =
          Provider.of<PeluqueriaProvider>(context, listen: false);
      await dataPeluqueria.getDatosFicha(consulta.fichaPeluqueriaId);
      // ignore: use_build_context_synchronously
      dataPeluqueria.setSelectSquarePeluqueria(1);

      openModalBottomSheetOPeluqueriaUpdate(
          context, dataPeluqueria.getPeluqueriaUpdateForm);
    },
    child: Container(
      width: sizeScreen.width * 0.8,
      height: sizeScreen.height * 0.1,
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: ColorPalet.grisesGray4, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorPalet.secondaryDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            width: 4,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: sizeScreen.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Iconsax.calendar_2, color: ColorPalet.grisesGray2),
                    SizedBox(width: 6),
                    Expanded(
                      child: AutoSizeText(
                        consulta.fechaProximaVisita != null
                            ? "${consulta?.fechaProximaVisita}\n${consulta.horaInicio?.substring(0, 5) ?? ''}"
                            : "Fecha no definida",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorPalet.grisesGray2,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(IconlyLight.profile, color: ColorPalet.grisesGray2),
                    SizedBox(width: 6),
                    Expanded(
                      child: AutoSizeText(
                        consulta.encargados[0] != null
                            ? '${consulta.encargados[0]?.nombres} ${consulta.encargados[0]?.apellidos}'
                            : "Encargado no definido",
                        style: TextStyle(
                          color: ColorPalet.grisesGray2,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
