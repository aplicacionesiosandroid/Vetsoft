import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/screens/agenda/agenda_screen.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/cuenta_empleado_screen.dart';
import 'package:vet_sotf_app/presentation/screens/optionsDrawer/campanas_screen.dart';
import 'package:vet_sotf_app/presentation/screens/optionsDrawer/clinica_screen.dart';
import 'package:vet_sotf_app/presentation/screens/optionsDrawer/peluqueria_screen.dart';
import 'package:vet_sotf_app/presentation/screens/optionsDrawer/productos_screen.dart';
import 'package:vet_sotf_app/presentation/screens/optionsDrawer/tareas_screen.dart';
import 'package:vet_sotf_app/presentation/screens/petshop/HomePetshop/home_petshop.dart';
import 'package:vet_sotf_app/presentation/widgets/drawer_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/horario_screen.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';
import '../../config/global/palet_colors.dart';
import '../../providers/auth/shared_prefer_provider.dart';
import '../../providers/dashboard/notifications_provider.dart';
import 'buscador_screen.dart';
import 'home_screen.dart';
import 'package:iconly/iconly.dart';

class BottomNavigationWidget extends StatefulWidget {
  BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  Timer? _timer;
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _isRead = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedProvider = Provider.of<SharedDataProvider>(context);
    final notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isRead) {
        notificationsProvider.getNotificaciones();
        if (mounted) {
          setState(() {
            _isRead = true;
          });
        }
      }
    });

    final uiProviderBottomBar = Provider.of<UiProvider>(context);
    List<Widget> _sections = [
      uiProviderBottomBar.selectedOptionDrawer == 'Clinica'
          ? const ClinicaScreen()
          : uiProviderBottomBar.selectedOptionDrawer == 'Peluqueria'
              ? PeluqueriaScreen()
              : uiProviderBottomBar.selectedOptionDrawer == 'Tareas'
                  ? TareasScreen()
                  : uiProviderBottomBar.selectedOptionDrawer == 'Petshop'
                      ? HomePetshopScreen()
                      : uiProviderBottomBar.selectedOptionDrawer == 'Campañas'
                          ? CampanasScreen()
                          : uiProviderBottomBar.selectedOptionDrawer ==
                                  'Productos'
                              ? ProductosScreen()
                              : uiProviderBottomBar.selectedOptionDrawer ==
                                      'Horario'
                                  ? const HorarioScreen()
                                  : const HomeScreen(),
      BuscadorScreen(),
      AgendaScreen(),
      const CuentaEmpleadoScreen()
    ];

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                50), // Personaliza el radio para redondear
          ),
          onPressed: () async {
            await sharedProvider.checkToken()
                ? Navigator.of(context)
                    .pushNamedAndRemoveUntil('/onboarding', (route) => false)
                : Navigator.pushNamed(context, '/chatScreen');
          },
          backgroundColor: const Color.fromARGB(255, 28, 149, 187),
          child: const Icon(
            Iconsax.message_2,
            color: ColorPalet.grisesGray5,
          ),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'inter',
                  fontSize: 12),
              selectedIconTheme: const IconThemeData(
                color: Color.fromARGB(255, 28, 149, 187),
              ),
              //unselectedIconTheme,

              selectedItemColor: const Color.fromARGB(255, 28, 149, 187),
              unselectedItemColor: const Color.fromARGB(255, 139, 149, 166),
              type: BottomNavigationBarType.fixed, // Desactiva la animación

              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Iconsax.home_1,
                    ),
                    activeIcon: Icon(
                      Iconsax.home5,
                    ),
                    label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: Icon(
                      IconlyLight.search,
                    ),
                    activeIcon: Icon(
                      IconlyBold.search,
                    ),
                    label: 'Buscador'),
                BottomNavigationBarItem(
                    icon: Icon(
                      IconlyLight.calendar,
                    ),
                    activeIcon: Icon(
                      IconlyBold.calendar,
                    ),
                    label: 'Agenda'),
                BottomNavigationBarItem(
                    icon: Icon(
                      IconlyLight.profile,
                    ),
                    activeIcon: Icon(
                      IconlyBold.profile,
                    ),
                    label: 'Cuenta'),
              ],
              currentIndex: uiProviderBottomBar.selectedIndexBottomBar,
              onTap: (value) {
                uiProviderBottomBar.setSelectedIndexBottomBar(value);
                if (uiProviderBottomBar.selectedIndexBottomBar == 0) {
                  uiProviderBottomBar.setOptionSelectedDrawer('Home');
                }
                if (uiProviderBottomBar.selectedIndexBottomBar == 3) {
                  Navigator.pushNamed(context, '/cuentaScreen');
                  uiProviderBottomBar.setOptionSelectedDrawer('Home');
                  uiProviderBottomBar.setSelectedIndexBottomBar(0);
                }
                if (uiProviderBottomBar.selectedIndexBottomBar == 2) {
                  // Navigator.pushNamed(context, '/agendaScreen');
                  uiProviderBottomBar.setOptionSelectedDrawer('Agenda');
                  uiProviderBottomBar.setSelectedIndexBottomBar(2);
                }
                if (uiProviderBottomBar.selectedIndexBottomBar == 1) {
                  // Navigator.pushNamed(context, '/buscadorScreen');
                  uiProviderBottomBar.setOptionSelectedDrawer('Buscador');
                  uiProviderBottomBar.setSelectedIndexBottomBar(1);
                }
              },
            ),
          ),
        ),
        body: _sections[uiProviderBottomBar.selectedIndexBottomBar],
        drawer: const DrawerWidget(),
      ),
    );
  }
}
