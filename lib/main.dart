import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/presentation/screens/agenda/agenda_screen.dart';
import 'package:vet_sotf_app/presentation/screens/buscador_screen.dart';
import 'package:vet_sotf_app/presentation/screens/campa%C3%B1as/codigos_prom_screen.dart';
import 'package:vet_sotf_app/presentation/screens/campa%C3%B1as/promo_whatsapp_screen.dart';
import 'package:vet_sotf_app/presentation/screens/campa%C3%B1as/sistema_puntos_screen.dart';
import 'package:vet_sotf_app/presentation/screens/chatBoot/chat_show_screen.dart';
import 'package:vet_sotf_app/presentation/screens/chatBoot/chat_screen.dart';
import 'package:vet_sotf_app/presentation/screens/chatBoot/consumo_chat_screen.dart';
import 'package:vet_sotf_app/presentation/screens/chatBoot/historial_chat.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/correo_emp_screen.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/datos_cuenta_emp_screen.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/gestion_empresa_screen.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/info_personal_screen.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/notificaciones_emp_screen.dart';
import 'package:vet_sotf_app/presentation/screens/login_screen.dart';
import 'package:vet_sotf_app/presentation/screens/petshop/HomePetshop/busqueda_screen.dart';
import 'package:vet_sotf_app/presentation/screens/petshop/HomePetshop/carrito_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verTareas_screen.dart';
import 'package:vet_sotf_app/providers/account/account_empleado_provider.dart';
import 'package:vet_sotf_app/providers/account/company_data_provider.dart';
import 'package:vet_sotf_app/providers/account/login_user_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:vet_sotf_app/providers/agenda_provider.dart';
import 'package:vet_sotf_app/providers/auth/shared_prefer_provider.dart';
import 'package:vet_sotf_app/providers/buscador_provider.dart';
import 'package:vet_sotf_app/providers/campanas/campain_provider.dart';
import 'package:vet_sotf_app/providers/chat_provider.dart';
import 'package:vet_sotf_app/providers/clinica/clinica_update_provider.dart';
import 'package:vet_sotf_app/providers/clinica/desparacitacion/desparacitacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';
import 'package:vet_sotf_app/providers/clinica/vacuna/vacuna_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/dashboard_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/horario/ausencias_nuevo_tipo_provider.dart';
import 'package:vet_sotf_app/providers/horario/evento_provider.dart';
import 'package:vet_sotf_app/providers/horario/horario_provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/citaspeluqueria_provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/peluqueria_provider.dart';
import 'package:vet_sotf_app/providers/perfiles/perfil_mascota_provider.dart';
import 'package:vet_sotf_app/providers/petshop/RegistroCompra/registrarCompra_provider.dart';
import 'package:vet_sotf_app/providers/tareas/objetivos_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';
import 'package:vet_sotf_app/presentation/screens/bottom_navigation_screen.dart';
import 'config/global/palet_colors.dart';
import 'models/agregar_productos/imagen_model.dart';
import 'models/agregar_productos/tab_controller_model.dart';
import 'models/petshop/HomePetshop/lista_productos_model.dart';
import 'models/petshop/registroCompra/client_model.dart';
import 'models/petshop/registroCompra/order_model.dart';
import 'models/petshop/registroCompra/pay_method_model.dart';
import 'models/petshop/registroCompra/registration_pay_model.dart';
import 'presentation/screens/agregar_productos/registrar_producto.dart';
import 'presentation/screens/cuentas/empleado/cuenta_empleado_screen.dart';
import 'presentation/screens/cuentas/empleado/telefono_emp_screen.dart';
import 'presentation/screens/cuentas/empleado/update_info_personal.dart';
import 'presentation/screens/optionsDrawer/campanas_screen.dart';
import 'presentation/screens/optionsDrawer/clinica_screen.dart';
import 'presentation/screens/optionsDrawer/horario_screen.dart';
import 'presentation/screens/optionsDrawer/peluqueria_screen.dart';
import 'presentation/screens/optionsDrawer/productos_screen.dart';
import 'presentation/screens/optionsDrawer/tareas_screen.dart';
import 'presentation/screens/perfiles/perfil_cliente_screen.dart';
import 'presentation/screens/perfiles/perfil_mascota_screen.dart';
import 'presentation/screens/petshop/HomePetshop/home_petshop.dart';
import 'presentation/screens/petshop/HomePetshop/producto_detalle_screen.dart';
import 'presentation/screens/petshop/registroCompra/register_client.dart';
import 'providers/productos/productos_mas_vendidos_provider.dart';
import 'providers/productos/productos_provider.dart';
import 'providers/productos/todos_productos_provider.dart';
import 'providers/auth/login_provider.dart';
import 'providers/clinica/cirugia/cirugia_provider.dart';
import 'providers/clinica/citasmedicas_provider.dart';
import 'providers/clinica/consulta/consulta_provider.dart';
import 'providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';
import 'providers/peluqueria/programarCitaPelu_provider.dart';
import 'providers/petshop/HomePetshop/home_petshop_provider.dart';
import 'providers/tabBar_provider.dart';
import 'presentation/screens/onboarding_screen.dart';

//  import 'package:device_preview/device_preview.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await eliminarTokenSiExpirado();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   runApp(DevicePreview(
//       enabled: true,
//       builder: (context) => MyApp(token: prefs.getString('myToken'))));
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await eliminarTokenSiExpirado();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(
    token: prefs.getString('myToken'),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UiProvider()),
        ChangeNotifierProvider(create: (context) => TabBarProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SharedDataProvider()),
        ChangeNotifierProvider(create: (_) => LoginUserProvider()),
        ChangeNotifierProvider(create: (context) => OProcedimientosProvider()),
        ChangeNotifierProvider(create: (context) => DesparacitacionProvider()),
        ChangeNotifierProvider(create: (context) => PeluqueriaProvider()),
        ChangeNotifierProvider(
            create: (context) => ProgramarCitaPeluProvider()),
        ChangeNotifierProvider(create: (context) => VacunaProvider()),
        ChangeNotifierProvider(create: (context) => CirugiaProvider()),
        ChangeNotifierProvider(create: (context) => ConsultaProvider()),
        ChangeNotifierProvider(create: (context) => ProgramarCitaProvider()),
        ChangeNotifierProvider(create: (context) => TareasProvider()),
        ChangeNotifierProvider(create: (context) => CitaMedicaProvider()),
        ChangeNotifierProvider(create: (context) => CitaPeluqueriaProvider()),
        ChangeNotifierProvider(create: (context) => PaymentMethodModel()),
        ChangeNotifierProvider(create: (context) => RegistroClienteModel()),
        ChangeNotifierProvider(create: (context) => RegistroModel()),
        ChangeNotifierProvider(create: (context) => OrderFormModel()),
        ChangeNotifierProvider(create: (context) => HomePetShopProvider()),
        ChangeNotifierProvider(create: (context) => ProductListModel()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => CampainProvider()),
        ChangeNotifierProvider(create: (context) => RegistroCompraProvider()),
        ChangeNotifierProvider(create: (context) => AccountEmpProvider()),
        ChangeNotifierProvider(create: (context) => CompanyProvider()),
        ChangeNotifierProvider(create: (context) => AgendaProvider()),
        ChangeNotifierProvider(create: (context) => BuscadorProvider()),
        ChangeNotifierProvider(create: (context) => ObjetivosProvider()),
        ChangeNotifierProvider(
            create: (context) => ProductosFavoritosProvider()),
        ChangeNotifierProvider(create: (context) => ProductosTodosProvider()),
        ChangeNotifierProvider(create: (context) => TabControllerModel()),
        ChangeNotifierProvider(create: (context) => ImageModel()),
        ChangeNotifierProvider(create: (context) => ProductosProvider()),
        ChangeNotifierProvider(create: (context) => PerfilMascotaProvider()),
        ChangeNotifierProvider(create: (context) => DashBoardProvider()),
        ChangeNotifierProvider(create: (context) => UserEmpProvider()),
        ChangeNotifierProvider(create: (context) => HorarioProvider()),
        ChangeNotifierProvider(create: (context) => EventoProvider()),
        ChangeNotifierProvider(
            create: (context) => AusenciasNuevoTipoProvider()),
        ChangeNotifierProvider(create: (context) => ClinicaUpdateProvider()),
        ChangeNotifierProvider(create: (context) => HospitalizacionProvider()),
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
      ],
      child: MaterialApp(
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [
          BotToastNavigatorObserver()
        ], //2. registered route observer
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: ColorPalet.secondaryDefault,
          dialogBackgroundColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
        supportedLocales: const [Locale('es', 'ES')],
        title: 'VetSoft',
        debugShowCheckedModeBanner: false,
        //initialRoute: '/onboarding',
        initialRoute: token != null
            ? JwtDecoder.isExpired(token!) == false
                ? '/homeScreen'
                : '/onboarding'
            : '/onboarding',
        routes: {
          "/onboarding": (context) => OnboardingScreenOne(),
          "/login": (context) => LoginScreen(),
          "/homeScreen": (context) => BottomNavigationWidget(),
          "/clinicaScreen": (context) => ClinicaScreen(),
          "/peluqueriaScreen": (context) => PeluqueriaScreen(),
          "/petshopScreen": (context) => HomePetshopScreen(),
          "/horarioScreen": (context) => HorarioScreen(),
          "/cuentaScreen": (context) => CuentaEmpleadoScreen(),
          "/tareasScreen": (context) => TareasScreen(),
          "/productosScreen": (context) => ProductosScreen(),
          "/CampanasScreen": (context) => CampanasScreen(),
          '/verTareasScreen': (context) => FormularioVerTareas(),
          '/productoDetalleScreen': (context) => ProductoDetalleScreen(),
          '/busquedaPetshopScreen': (context) => BusquedaPetshopScreen(),
          '/carritoScreen': (context) => CarritoScreen(),
          '/chatScreen': (context) => ChatScreen(),
          '/chatShowScreen': (context) => ChatShowScreen(),
          '/pagarScreen': (context) => RegisterClient(),
          '/codigoPromocional': (context) => CodigoPromocionalScreen(),
          '/sistemaPuntos': (context) => SistemaPuntosScreen(),
          '/promoWhatsapp': (context) => PromoWhatsappScreen(),
          '/notificationEmpleado': (context) => NotificationsEmpScreen(),
          '/datosCuentaEmpleado': (context) => DatosCuentaEmpScreen(),
          '/direcCorreoEmpleado': (context) => DirecCorreEmpScreen(),
          '/consumosChatBotScreen': (context) => ConsumoChatBootScreen(),
          '/historialChatbotScreen': (context) => ChatHistoryScreen(),
          '/agendaScreen': (context) => AgendaScreen(),
          '/buscadorScreen': (context) => BuscadorScreen(),
          '/gestionEmpresa': (context) => GestionEmpScreen(),
          '/infoPersonal': (context) => InfoPersonalScreen(),
          '/registrarProducto': (context) => RegistrarProductosScreen(),
          '/perfilMascota': (context) => PerfilMascotaWidget(),
          '/perfilCliente': (context) => PerfilCliente(),
          '/telefonoScreen': (context) => TelefonoEmpScreen(),
          '/infoPersonalUpdateScreen': (context) =>
              InfoPersonalFormularioScreen(),
          // '/infoAdicionalUpdateScreen': (context) => UpdateInfoAdicionalScreen(),
        },
      ),
    );
  }
}

Future<void> eliminarTokenSiExpirado() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('myToken');

  if (token != null) {
    Map<String, dynamic> payload = JwtDecoder.decode(token);

    DateTime fechaExpiracion =
        DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    DateTime fechaActual = DateTime.now();

    if (fechaActual.isAfter(fechaExpiracion)) {
      await prefs.remove('myToken');
      Utilidades.imprimir('Token eliminado debido a la expiración.');
    } else {
      Utilidades.imprimir('El token todavía es válido. $token');
    }
  } else {
    Utilidades.imprimir('No se encontró un token en SharedPreferences.');
  }
}
