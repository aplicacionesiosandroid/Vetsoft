import 'package:flutter/material.dart';
import 'package:vet_sotf_app/presentation/screens/horario/admin_horario_home_screen.dart';
import 'package:vet_sotf_app/presentation/screens/horario/empleado_horario_home_screen.dart';
import 'package:vet_sotf_app/providers/account/login_user_provider.dart';

class HorarioScreen extends StatelessWidget {
  const HorarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LoginUserProvider.getRol(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error if there is any
        } else {
          // Once the Future is complete, display the appropriate screen
          if (snapshot.data == 'ADMINISTRADOR') {
            return const AdminHorarioHomeScreen();
          } else {
            return const EmpleadoHorarioHomeScreen();
          }
        }
      },
    );
  }
}
