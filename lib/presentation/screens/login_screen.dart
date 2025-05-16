import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/login_provider.dart';
import 'bottom_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context) {
    final heigthScreen = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    final isPasswordVisible = authProvider.isPasswordVisiblePass;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Image(
                        image: AssetImage('assets/img/logo_login.png'),
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/img/dog_login.png'),
                      width: 90,
                      height: 90,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image(
                      image: AssetImage('assets/img/doctor_login.png'),
                      width: 180,
                      height: 180,
                    ),
                  ],
                ),
                Text(
                  '¡Bienvenido a Vetsoft!',
                  style: TextStyle(
                      fontFamily: 'sans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text(
                  'Ingresa los datos que te proporcionó la compañía\npara acceder a tu clínica veterinaria.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'inter',
                      color: Color.fromARGB(255, 72, 86, 109),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuario',
                        style: TextStyle(
                            color: Color.fromARGB(255, 72, 86, 109),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: heigthScreen * 0.02,
                      ),
                      TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su usuario',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(99, 233, 231, 231),
                          filled: true,
                        ),
                      ),
                      SizedBox(
                        height: heigthScreen * 0.03,
                      ),
                      Text(
                        'Contraseña',
                        style: TextStyle(
                            color: Color.fromARGB(255, 72, 86, 109),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: heigthScreen * 0.02,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                            //prefixIcon: Icon(Icons.menu),
                            prefixIcon: Icon(IconlyLight.lock),
                            hintText: 'Ingrese su contraseña',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            fillColor: Color.fromARGB(99, 233, 231, 231),
                            filled: true,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  authProvider.tooglePasswordVisivilityPass();
                                },
                                icon: Icon(isPasswordVisible
                                    ? IconlyLight.show
                                    : IconlyLight.hide))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: heigthScreen * 0.03,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                      ),
                    )),
                SizedBox(
                  height: heigthScreen * 0.03,
                ),
                Text(
                  authProvider.mensajeError,
                  style: TextStyle(
                      color: Color.fromARGB(255, 72, 86, 109),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: authProvider.loading
                            ? null
                            : () async {
                                authProvider
                                    .loginUser(userController.text.toString(),
                                        passwordController.text.toString())
                                    .then((_) async {
                                  if (authProvider.inicioSesion) {
                                    await authProvider.saveData(
                                        authProvider
                                                .resultOriginal[0]
                                                .user
                                                .configuraciones
                                                .fichaParametrica ??
                                            '',
                                        authProvider
                                            .resultOriginal[0].accessToken,
                                        authProvider
                                            .resultOriginal[0].user.clienteId,
                                        authProvider
                                            .resultOriginal[0].user.email,
                                        authProvider
                                            .resultOriginal[0].user.nombres,
                                        authProvider
                                            .resultOriginal[0].user.imagenUser,
                                        authProvider
                                                .resultOriginal[0].user.rol ??
                                            '');
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // print('mi token ${prefs.getString('myToken') ?? ''}');
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavigationWidget()));
                                  }
                                });
                              },
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                stops: [
                                  0.0,
                                  0.56,
                                  1.0
                                ],
                                colors: [
                                  Color.fromARGB(255, 72, 147, 231),
                                  Color.fromARGB(255, 64, 164, 223),
                                  Color.fromARGB(255, 44, 204, 205),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: authProvider.loading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 86),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        )),
                  ],
                )
              ],
            )),
      )),
    );
  }
}
