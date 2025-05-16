import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/screens/login_screen.dart';
import 'package:vet_sotf_app/providers/auth/shared_prefer_provider.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';

class OnboardingScreenOne extends StatelessWidget {
  final List<String> imageAssets = [
    'assets/img/onboardback1.png',
    'assets/img/onboardback2.png',
    'assets/img/onboardback3.png',
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((asset) {
      precacheImage(AssetImage(asset), context);
    });

    final loginProvider = Provider.of<SharedDataProvider>(context);
    final uiProviderOnboarding = Provider.of<UiProvider>(context);
    final currentPageIndex = uiProviderOnboarding.currentPageIndexOnboarding;
    double sizeScreenH = MediaQuery.of(context).size.height;
    double sizeScreenW = MediaQuery.of(context).size.width;

    final int _numPages = 3;
    final PageController _pageController = PageController(initialPage: 0);
    //int _currentPage = 0;

    List<Widget> _buildPageIndicator() {
      List<Widget> list = [];
      for (int i = 0; i < _numPages; i++) {
        list.add(i == currentPageIndex ? _indicator(true) : _indicator(false));
      }
      return list;
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
              image: currentPageIndex == 0
                  ? const DecorationImage(
                      image: AssetImage('assets/img/onboardback1.png'),
                      fit: BoxFit.cover)
                  : currentPageIndex == 1
                      ? const DecorationImage(
                          image: AssetImage('assets/img/onboardback2.png'),
                          fit: BoxFit.cover)
                      : const DecorationImage(
                          image: AssetImage('assets/img/onboardback3.png'),
                          fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async{
                      await loginProvider.checkToken() ? Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false) : Navigator.pushNamed(context, '/homeScreen');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: sizeScreenH * 0.7,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      uiProviderOnboarding.setCurrentPageIndexOnboarding(page);
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 35, right: 35, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/img/onboard1.gif',
                                ),
                                height: sizeScreenH * 0.3,
                                width: sizeScreenW * 0.6,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              '¡Bienvenido a VetSoft!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Mejora la atención de tus pacientes con inteligencia artificial para diagnósticos, análisis detallados de imágenes médicas y recordatorios vía WhatsApp. ¡Prepárate para llevar la atención de tus pacientes al siguiente nivel!',
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35, right: 35, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/img/onboard2.gif',
                                ),
                                height: sizeScreenH * 0.3,
                                width: sizeScreenW * 0.6,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Optimiza tu negocio',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              '¡Optimiza tu peluquería y aumenta tus ventas con VetSoft! Contamos con herramientas especializadas para el manejo de tus citas, empleados, clientes y productos. ¡Mejora tus servicios y aumenta tus ingresos!',
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35, right: 35, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/img/onboard3.gif',
                                ),
                                height: sizeScreenH * 0.3,
                                width: sizeScreenW * 0.6,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Control total, donde quieras',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Con VetSoft, controla tus estadísticas y horarios de empleados, revisa historias clínicas y delega tareas desde la comodidad de tu hogar. ¡Comienza ahora mismo y regístrate en VetSoft para disfrutar de todas estas ventajas y más!',
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                currentPageIndex == 0
                    ? Flexible(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                minimumSize: const Size(50, 50),
                                backgroundColor: currentPageIndex == 0
                                    ? const Color.fromARGB(255, 99, 92, 255)
                                    : currentPageIndex == 1
                                        ? const Color.fromARGB(
                                            255, 26, 202, 212)
                                        : const Color.fromARGB(
                                            255, 26, 202, 212)),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      )
                    : currentPageIndex == 1
                        ? Flexible(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    minimumSize: const Size(50, 50),
                                    backgroundColor: const Color.fromARGB(
                                        255, 26, 202, 212)),
                                onPressed: () {
                                  currentPageIndex != 2
                                      ? _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                },
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          )
                        : currentPageIndex == 2
                            ? Flexible(
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          //shape: CircleBorder(),
                                          //minimumSize: Size(150,50),
                                          backgroundColor: const Color.fromARGB(
                                              255, 99, 92, 255),
                                          minimumSize: const Size(200, 40)),
                                      onPressed: () async{
                                        await loginProvider.checkToken() ? Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false) : Navigator.pushNamed(context, '/homeScreen');
                                      },

                                      /* _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 900),
                                          curve: Curves.ease,
                                        ); */

                                      child: const Text(
                                        'Iniciar sesion',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              )
                            : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
