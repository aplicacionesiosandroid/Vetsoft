
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/account/account_empleado_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class DatosCuentaEmpScreen extends StatelessWidget {
  const DatosCuentaEmpScreen({super.key});

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
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                // height: sizeScreen.height * 0.929,
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
                                Text('Datos de cuenta',
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
                              Navigator.pushNamed(
                                  context, '/direcCorreoEmpleado');
                            }, Iconsax.sms, '${userEmpProvider.user!.informacionPersonal.email}',
                                'Dirección de correo electrónico:'),
                            _accountOptionProfilWidget(sizeScreen, () {
                              Navigator.pushNamed(context, '/telefonoScreen');
                            }, Iconsax.call, '${userEmpProvider.user!.informacionPersonal.telefono}', 'Número de teléfono:'),
                            _accountOptionProfilWidget(sizeScreen, () {
                              _showModalBottomSheetEditCambiarPass(
                                  context, sizeScreen, userEmpProvider.changePassword);
                            }, Iconsax.lock, 'Cambiar contraseña', ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheetEditCambiarPass(
    BuildContext context, 
    Size sizeScreen, 
    Future<bool> Function(String, String) changePassword
) async {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController = TextEditingController();

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: sizeScreen.width * 0.1,
                    height: 2.0,
                    color: ColorPalet.grisesGray2,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Cambiar contraseña',
                  style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontFamily: 'sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Asegúrese de que su nueva contraseña sea segura y esté compuesta por al menos 8 caracteres, incluyendo al menos una letra mayúscula y un número.',
                  style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Introduzca su contraseña actual',
                  style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormFieldConHint(
                  controller: oldPasswordController,
                  hintText: 'Contraseña actual',
                  colores: ColorPalet.secondaryLight,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Introduzca su nueva contraseña',
                  style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormFieldConHint(
                  controller: newPasswordController,
                  hintText: 'Nueva contraseña',
                  colores: ColorPalet.secondaryLight,
                ),
                SizedBox(height: 15.0),
                Text(
                  'Repita su nueva contraseña',
                  style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormFieldConHint(
                  controller: confirmNewPasswordController,
                  hintText: 'Repetir contraseña',
                  colores: ColorPalet.secondaryLight,
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: sizeScreen.height * 0.06,
                  width: sizeScreen.width,
                  child: ElevatedButton(
                    onPressed: () async{
                      bool success = await changePassword(
                        oldPasswordController.text.trim(),
                        newPasswordController.text.trim()
                      );
                      if (success) {
                        Navigator.of(context).pop();
                        _mostrarFichaCreada(context, 'Los cambios se han guardado correctamente.');
                      } else {
                        _mostrarFichaCreada(context, 'No se pudo cambiar la contraseña.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 115, 92, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Guardar cambios',
                      style: TextStyle(
                        color: ColorPalet.grisesGray5,
                        fontFamily: 'inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showModalBottomSheetRecuperarContra(context, sizeScreen);
                    },
                    child: Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(
                        color: ColorPalet.estadoNeutral,
                        fontFamily: 'inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  void _showModalBottomSheetRecuperarContra(
      BuildContext context, Size sizeScreen) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        // Contenido del ModalBottomSheet
        return Container(
          height: sizeScreen.height * 0.47,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: sizeScreen.width * 0.08,
                  height: 1.5,
                  color: ColorPalet.grisesGray2,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Restablecer contraseña',
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontFamily: 'sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20.0),
              Text(
                '¿Has olvidado tu contraseña?',
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontFamily: 'sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 15.0),
              Text(
                'Restablece tu contraseña en 2 pasos rápidos.',
                style: TextStyle(
                    color: ColorPalet.grisesGray2,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20.0),
              Text(
                'Email o teléfono',
                style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15.0),
              TextFormFieldConHint(
                  hintText: 'Email o teléfono',
                  colores: ColorPalet.secondaryLight),
              SizedBox(height: 20.0),
              SizedBox(
                height: sizeScreen.height * 0.05,
                width: sizeScreen.width,
                child: ElevatedButton(
                    onPressed: () {
                      _alertCorreoEnviado(context, sizeScreen);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 115, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Restablecer',
                      style: TextStyle(
                          color: ColorPalet.grisesGray5,
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Volver',
                      style: TextStyle(
                          color: ColorPalet.estadoNeutral,
                          fontFamily: 'inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 28, 149, 187),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            children: [
              SizedBox(width: 5),
              Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  textoMessage,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _alertCorreoEnviado(BuildContext context, Size sizeScreen) {
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
              'Restablecer contraseña',
              style: TextStyle(
                  color: const Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: sizeScreen.height * 0.7,
              child: Column(
                children: [
                  Expanded(
                    child: Image(image: AssetImage('assets/img/done.png')),
                  ),
                  Expanded(
                    child: const Text(
                      'Hemos enviado un correo electrónico con los pasos para restablecer su contraseña. Por favor, revise su bandeja de entrada y siga las instrucciones. Si no recibe el correo electrónico en unos minutos, revise su carpeta de correo no deseado o intente nuevamente más tarde.',
                      style: TextStyle(
                          color: ColorPalet.grisesGray1,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: sizeScreen.width,
                    height: sizeScreen.height * 0.05,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Aceptar',
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
/* 
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
            /* Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: ColorPalet.grisesGray1,
            ),
            SizedBox(
              width: 20,
            ), */
          ],
        ),
      ),
    );
  } */

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
}
