import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/cuenta/user.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';

import '../../../../config/global/palet_colors.dart';

class InfoPersonalScreen extends StatelessWidget {
  const InfoPersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final userEmpProvider = Provider.of<UserEmpProvider>(context);
    final userInfoPersonal = ModalRoute.of(context)!.settings.arguments as User;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 99, 92, 255),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: sizeScreen.height * 0.03,
            ),
            Container(
              width: sizeScreen.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Iconsax.arrow_left))),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Información personal',
                      style: TextStyle(
                          color: ColorPalet.grisesGray0,
                          fontFamily: 'sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: sizeScreen.width,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  /* borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)), */
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sizeScreen.width,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/img/user.png'),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userEmpProvider.userPersonal!.informacionPersonal.nombres} ${userEmpProvider.userPersonal!.informacionPersonal.apellidos}',
                                      style: TextStyle(
                                        color: ColorPalet.grisesGray0,
                                        fontFamily: 'sans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      width: sizeScreen.width * 0.75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${userEmpProvider.userPersonal!.informacionPersonal.email}',
                                              style: TextStyle(
                                                  color: ColorPalet.grisesGray2,
                                                  fontFamily: 'inter',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/infoPersonalUpdateScreen', arguments: userInfoPersonal);
                                              },
                                              icon: Icon(
                                                Iconsax.edit_2,
                                                color: ColorPalet.grisesGray2,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sizeScreen.height * 0.75,
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  const TabBar(
                                    tabs: [
                                      Tab(text: 'Datos personales'),
                                      Tab(text: 'Información adicional'),
                                    ],
                                    isScrollable: true,
                                    labelColor: ColorPalet.secondaryDefault,
                                    unselectedLabelColor:
                                        ColorPalet.grisesGray2,
                                    indicatorColor:
                                        Color.fromARGB(255, 100, 92, 248),
                                    labelStyle: TextStyle(
                                        fontFamily: 'sans',
                                        color: ColorPalet.grisesGray2,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        _WidgetDatosPersonales(sizeScreen, context, userEmpProvider.userPersonal!),
                                        _WidgetInformacionAdicional(sizeScreen, context, userEmpProvider.userPersonal!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _WidgetDatosPersonales(
      Size sizeScreen, BuildContext context, User userEmpProvider) {
    return SingleChildScrollView(
      child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloAccount('Datos personales'),
              Container(
                width: sizeScreen.width,
                decoration: BoxDecoration(
                    color: ColorPalet.backGroundColor,
                    border: Border.all(color: ColorPalet.grisesGray3, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    _accountOptionProfilWidget(
                        sizeScreen,
                            () {
                          Navigator.pushNamed(context, '/datosCuentaEmpleado');
                        },
                        Iconsax.profile_circle,
                        '${userEmpProvider.informacionPersonal.nombres} ${userEmpProvider.informacionPersonal.apellidos}',
                        'Nombre y apellido:'
                    ),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.sms, '${userEmpProvider.informacionPersonal.email}',
                        'Dirección de correo electrónico:'),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.call, '${userEmpProvider.informacionPersonal.telefono}', 'Número de teléfono:'),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(
                        sizeScreen,
                        () { Navigator.pushNamed(context, '/datosCuentaEmpleado');},
                        Iconsax.calendar_2, '${userEmpProvider.informacionPersonal.fechaNacimiento}',
                        'Fecha y lugar de nacimiento'
                    ),
                  ],
                ),
              ),
              _tituloAccount('Identificación'),
              Container(
                width: sizeScreen.width,
                decoration: BoxDecoration(
                    color: ColorPalet.backGroundColor,
                    border: Border.all(color: ColorPalet.grisesGray3, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.user_square, '${userEmpProvider.informacionPersonal.numIdentificacion}', 'Carnet:'),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.creative_commons, '${userEmpProvider.informacionPersonal.estadoCivil}', 'Estado civil:'),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.man, '${userEmpProvider.informacionPersonal.sexo}', 'Sexo:'),
                  ],
                ),
              ),
              _tituloAccount('Residencia'),
              Container(
                width: sizeScreen.width,
                decoration: BoxDecoration(
                    color: ColorPalet.backGroundColor,
                    border: Border.all(color: ColorPalet.grisesGray3, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.location, '${userEmpProvider.informacionPersonal.ciudadResidencia}', 'País:'),
                    _MyDivider(sizeScreen),
                    _accountOptionProfilWidget(sizeScreen, () {
                      Navigator.pushNamed(context, '/datosCuentaEmpleado');
                    }, Iconsax.home, '${userEmpProvider.informacionPersonal.direccion}', 'Dirección:'),
                  ],
                ),
              )
            ],
          ),
    );
  }

  SingleChildScrollView _WidgetInformacionAdicional(
      Size sizeScreen, BuildContext context, User userInfoPersonal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloAccount('Datos de salud'),
          Container(
            width: sizeScreen.width,
            height: sizeScreen.height * 0.24,
            decoration: BoxDecoration(
                color: ColorPalet.backGroundColor,
                border: Border.all(color: ColorPalet.grisesGray3, width: 1),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.profile_circle, '${userInfoPersonal.informacionAdicional.grupoSanguineo}',
                    'Grupo sanguíneo:'),
                _MyDivider(sizeScreen),
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.danger, '${userInfoPersonal.informacionAdicional.alergias}', 'Alergias:'),
              ],
            ),
          ),
          _tituloAccount('Referencia de emergencia'),
          Container(
            width: sizeScreen.width,
            height: sizeScreen.height * 0.35,
            decoration: BoxDecoration(
                color: ColorPalet.backGroundColor,
                border: Border.all(color: ColorPalet.grisesGray3, width: 1),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.profile_circle, '${userInfoPersonal.informacionAdicional.referenciaEmergencia.nombres},${userInfoPersonal.informacionAdicional.referenciaEmergencia.apellidos}',
                    'Nombre y apellido:'),
                _MyDivider(sizeScreen),
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.call, '${userInfoPersonal.informacionAdicional.referenciaEmergencia.celular}', 'Celular:'),
                _MyDivider(sizeScreen),
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.people, '${userInfoPersonal.informacionAdicional.referenciaEmergencia.parentesco}', 'Parentesco:'),
              ],
            ),
          ),
          _tituloAccount('Formación'),
          Container(
            width: sizeScreen.width,
            height: sizeScreen.height * 0.12,
            decoration: BoxDecoration(
              color: ColorPalet.backGroundColor,
              border: Border.all(
                color: ColorPalet.grisesGray3,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _accountOptionProfilWidget(sizeScreen, () {
                  Navigator.pushNamed(context, '/datosCuentaEmpleado');
                }, Iconsax.document_text, '${userInfoPersonal.informacionAdicional.formacion?.cv}', 'CV:'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _MyDivider(Size sizeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: sizeScreen.width * 0.85,
            child: Divider(
              color: ColorPalet.grisesGray3,
              thickness: 1,
            )),
      ],
    );
  }

  Padding _tituloAccount(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        texto,
        style: TextStyle(
            fontFamily: 'inter',
            color: ColorPalet.grisesGray2,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  InkWell _accountOptionProfilWidget(Size sizeScreen, VoidCallback funcion,
      IconData icono, String nombre, String titulo) {
    return InkWell(
      onTap: funcion,
      child: Container(
        height: sizeScreen.height * 0.1,
        width: sizeScreen.width,
        decoration: const BoxDecoration(
          color: Color(0xFFF4F4F4),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icono,
              size: 30,
              color: ColorPalet.secondaryLight,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titulo != ''
                    ? Text(
                        titulo,
                        style: TextStyle(
                            fontFamily: 'inter',
                            color: ColorPalet.grisesGray2,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    : Container(),
                Text(
                  nombre,
                  style: TextStyle(
                      fontFamily: 'inter',
                      color: ColorPalet.grisesGray0,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
