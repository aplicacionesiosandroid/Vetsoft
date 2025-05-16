import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/account/account_empleado_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';

import '../../../../config/global/palet_colors.dart';

class NotificationsEmpScreen extends StatelessWidget {
  const NotificationsEmpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final accountEmpProvider = Provider.of<AccountEmpProvider>(context);
    final userEmpProvider = Provider.of<UserEmpProvider>(context);

    if (userEmpProvider.user == null){
      userEmpProvider.fetchUserData().catchError((error){
        print('Error fetching user data: $error \n');
      });
    }

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
              padding: EdgeInsets.only(top: 10),
              height: sizeScreen.height * 0.925,
              width: sizeScreen.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
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
                        Expanded(
                          child: Row(
                            children: [
                              Text('Notificaciones',
                                  style: TextStyle(
                                      color: ColorPalet.grisesGray0,
                                      fontFamily: 'sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Acceso a la cuenta",
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          _accountOptionProfilWidget(sizeScreen, () {
                            print('datos de cuenta');
                          },
                              Iconsax.sms,
                              '${userEmpProvider.user!.informacionPersonal.email}',
                              'Dirección de correo electrónico:'),
                          _accountOptionProfilWidget(sizeScreen, () {
                            print('datos de cuenta');
                          }, Iconsax.call, '${userEmpProvider.user!.informacionPersonal.telefono}', 'Número de teléfono:'),
                          _firmaElectronicaWidgetSwitchButton(
                              context, sizeScreen, () {
                            print('datos de cuenta');
                          }, Iconsax.path, 'Firma electrónica', '',
                              accountEmpProvider),
                          _accountOptionProfilWidget(sizeScreen, () {
                            print('datos de cuenta');
                          }, Iconsax.lock, 'Cambiar contraseña', ''),
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

  InkWell _accountOptionProfilWidget(Size sizeScreen, VoidCallback funcion,
      IconData icono, String nombre, String titulo) {
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

  InkWell _firmaElectronicaWidgetSwitchButton(
      context,
      Size sizeScreen,
      VoidCallback funcion,
      IconData icono,
      String nombre,
      String titulo,
      AccountEmpProvider accountEmpProvider) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );
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
            Spacer(),
            Switch(
              activeColor: Theme.of(context).primaryColor,
              thumbIcon: thumbIcon,
              value: accountEmpProvider.isSwitchedNotification,
              onChanged: (value) {
                accountEmpProvider.toggleSwitchNotification();
              },
            ),
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
}
