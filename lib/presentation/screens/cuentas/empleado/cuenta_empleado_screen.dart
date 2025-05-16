import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/main.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import 'package:vet_sotf_app/providers/account/login_user_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:vet_sotf_app/providers/auth/login_provider.dart';

import 'package:vet_sotf_app/providers/auth/shared_prefer_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';
import '../../../../config/global/palet_colors.dart';
import '../../../widgets/drawer_widget.dart';
import '../widget/personal_admin.dart';

class CuentaEmpleadoScreen extends StatefulWidget {
  const CuentaEmpleadoScreen({Key? key}) : super(key: key);

  @override
  _CuentaEmpleadoScreenState createState() => _CuentaEmpleadoScreenState();
}

class _CuentaEmpleadoScreenState extends State<CuentaEmpleadoScreen> {
  @override
  void initState() {
    super.initState();
    final logigEmpProvider =
        Provider.of<LoginUserProvider>(context, listen: false);
    logigEmpProvider.checkIfUserIsAdmin().catchError((error) {
      print('Error in checkIfUserIsAdmin: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size; // Esto es correcto.
    final userEmpProvider = Provider.of<UserEmpProvider>(context);
    final logigEmpProvider = Provider.of<LoginUserProvider>(context);

    if (userEmpProvider.user == null) {
      userEmpProvider.fetchUserData().catchError((error) {
        print('Error in fetchUserData: $error');
      });
    }

    bool showEmpresaOptions = logigEmpProvider.isAdmin ?? false;
    final dataCuenta = Provider.of<SharedDataProvider>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
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
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      // Scaffold.of(context).openDrawer();
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: ImageIcon(
                      AssetImage('assets/img/menu_icon.png'),
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Cuenta',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'sans',
                fontSize: 19,
                fontWeight: FontWeight.w700),
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 99, 92, 255),
        body: ListView(
          children: [
            Container(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                width: sizeScreen.width,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (userEmpProvider.user != null) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: sizeScreen.height * 0.1,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/icon/logovs.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${userEmpProvider.user!.informacionPersonal.nombres} ${userEmpProvider.user!.informacionPersonal.apellidos}',
                          style: const TextStyle(
                            fontFamily: 'sans',
                            color: Color.fromARGB(255, 49, 46, 128),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Correo: ${userEmpProvider.user!.informacionPersonal.email ?? 'Email no disponible'}",
                          style: const TextStyle(
                            fontFamily: 'inter',
                            color: Color.fromARGB(255, 139, 149, 166),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else ...[
                        CircularProgressIndicator(),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Cuenta",
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    color: Color.fromARGB(255, 139, 149, 166),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            _accountOptionProfilWidget(sizeScreen, () {
                              Navigator.pushNamed(
                                  context, '/datosCuentaEmpleado');
                            }, Iconsax.profile_circle, 'Datos de cuenta'),
                            _accountOptionProfilWidget(sizeScreen, () {
                              final userEmpProvider =
                                  Provider.of<UserEmpProvider>(context,
                                      listen: false);
                              userEmpProvider
                                  .fetchUserData()
                                  .catchError((error) {
                                print('Error in fetchUserData: $error');
                              });
                              userEmpProvider.setIdPersonalUpdate(null);
                              userEmpProvider
                                  .setUseruserPersonal(userEmpProvider.user);
                              Navigator.pushNamed(context, '/infoPersonal',
                                  arguments: userEmpProvider.user);
                            }, Iconsax.profile_circle, 'Información personal'),
                            _accountOptionProfilWidget(sizeScreen, () {
                              Navigator.pushNamed(
                                  context, '/notificationEmpleado');
                            }, Iconsax.notification, 'Notificaciones'),
                            if (showEmpresaOptions) ...[
                              _seccionEmpresaWidget(
                                  context, sizeScreen), // Corrected call
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "General",
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    color: Color.fromARGB(255, 139, 149, 166),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            _accountOptionProfilWidget(sizeScreen, () {
                              print('Centro de ayuda');
                            }, Iconsax.lifebuoy, 'Centro de ayuda'),
                            _accountOptionProfilWidget(sizeScreen, () {
                              print('Reportar error');
                            }, Iconsax.info_circle, 'Reportar error'),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .cerrarSession();
                              context.read<UserEmpProvider>().dispose();
                              dataCuenta.removeData().then((_) async {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/onboarding', (route) => false);
                                Provider.of<UiProvider>(context, listen: false)
                                  ..setSelectedIndexBottomBar(0)
                                  ..setCurrentPageIndexOnboarding(0);
                                Provider.of<UiProvider>(context, listen: false)
                                    .setOptionSelectedDrawer('Home');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    Color.fromARGB(255, 115, 92, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                  color: ColorPalet.grisesGray5,
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      )
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

  Widget _seccionEmpresaWidget(BuildContext context, Size sizeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Empresa",
            style: TextStyle(
              fontFamily: 'inter',
              color: Color.fromARGB(255, 139, 149, 166),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _accountOptionProfilWidget(
          sizeScreen, // Pasa 'sizeScreen' en lugar de 'context'
          () => Navigator.pushNamed(context, '/gestionEmpresa'),
          Iconsax.category,
          'Gestión de empresa',
        ),
        _accountOptionProfilWidget(
          sizeScreen,
          () => print('Horarios'),
          Iconsax.timer_1,
          'Horarios',
        ),
        _accountOptionProfilWidget(
          sizeScreen,
          () {
            TareasProvider dataTareas =
                Provider.of<TareasProvider>(context, listen: false);
            dataTareas.getParticipantesTareas();
            List<ParticipanteTarea> listaParticipantes =
                dataTareas.getParticipantesTarea;
            openBottomSheetPersonalAdmin(
                dataTareas, context, listaParticipantes);
          },
          Iconsax.people,
          'Personal',
        ),
        _accountOptionProfilWidget(
          sizeScreen,
          () => print('Aspecto'),
          Iconsax.magicpen,
          'Aspecto',
        ),
        _accountOptionProfilWidget(
          sizeScreen,
          () => print('Sucursales'),
          Iconsax.building,
          'Sucursales',
        ),
      ],
    );
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
            const SizedBox(
              width: 10,
            ),
            Icon(
              icono,
              size: 30,
              color: ColorPalet.grisesGray1,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              nombre,
              style: const TextStyle(
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
}
