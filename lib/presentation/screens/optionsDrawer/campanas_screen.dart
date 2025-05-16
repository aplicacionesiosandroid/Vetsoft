
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/crear_tarea_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verTareas_screen.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/campanas/campain_provider.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';

class CampanasScreen extends StatelessWidget {
  CampanasScreen({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;

    final dataCampain = Provider.of<CampainProvider>(context);

    final notificationsProvider = Provider.of<NotificationsProvider>(context);


    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorPalet.secondaryDefault,
          body: ListView(
            children: [
              _IconMenu(scaffoldKey: _scaffoldKey, size: sizeScreen),
              AnimatedContainer(
                color: ColorPalet.secondaryDefault,
                duration: const Duration(milliseconds: 500),
                height: isHeaderExpanded ? sizeScreen.height * 0.22 : 0,
                child: Column(
                  children: [
                    if (isHeaderExpanded)
                      Notify_card_widget(cardNotifyList: cardNotifyList),
                  ],
                ),
              ),
              _FondoVerde(sizeScreen.height),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                //height: sizeHeigth,
                width: sizeScreen.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 247, 246),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        height: sizeScreen.height * 0.39,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Ajusta el radio de borde aquí
                                  ),
                                  color: ColorPalet.complementVerde2,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Image(
                                          image: AssetImage(
                                              'assets/img/camp1.png'),
                                        )),
                                        Text(
                                          'Códigos Promocionales',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'sans',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: sizeScreen.height * 0.01),
                                        Text(
                                          'Atrae a nuevos clientes y aumenta la visibilidad de tu negocio.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/codigoPromocional');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      ColorPalet.primaryLight,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: const Text(
                                                'Crear campaña',
                                                style: TextStyle(
                                                    color: ColorPalet.acentDark,
                                                    fontFamily: 'inter',
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Ajusta el radio de borde aquí
                                  ),
                                  color: ColorPalet.secondaryDefault,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Image(
                                          image: AssetImage(
                                              'assets/img/camp1.png'),
                                        )),
                                        Text(
                                          'Sistema de          Puntos',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'sans',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: sizeScreen.height * 0.01),
                                        Text(
                                          'Atrae a nuevos clientes y aumenta la visibilidad de tu negocio.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/sistemaPuntos');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      ColorPalet.primaryLight,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: const Text(
                                                'Crear campaña',
                                                style: TextStyle(
                                                    color: ColorPalet.acentDark,
                                                    fontFamily: 'inter',
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Ajusta el radio de borde aquí
                                  ),
                                  color: ColorPalet.acentDefault,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Image(
                                          image: AssetImage(
                                              'assets/img/camp1.png'),
                                        )),
                                        Text(
                                          'Promociones por Whatsapp',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'sans',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: sizeScreen.height * 0.01),
                                        Text(
                                          'Atrae a nuevos clientes y aumenta la visibilidad de tu negocio.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'inter',
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/promoWhatsapp');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      ColorPalet.primaryLight,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: const Text(
                                                'Crear campaña',
                                                style: TextStyle(
                                                    color: ColorPalet.acentDark,
                                                    fontFamily: 'inter',
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: sizeScreen.width,
                      child: Row(
                        children: [
                          Text(
                            'Historial',
                            style: TextStyle(
                                color: ColorPalet.grisesGray0,
                                fontFamily: 'sans',
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Ver todo',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray0,
                                    fontFamily: 'inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    dataCampain.historialCampain.isNotEmpty ? SizedBox(
                              height: sizeScreen.height * 0.18,
                              width: sizeScreen.width,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    dataCampain.historialCampain[0].promociones.length,
                                itemBuilder: (context, index) {
                                  final histCamp =
                                      dataCampain.historialCampain[0].promociones[index];
                                  return InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: sizeScreen.width * 0.7,
                                      margin:
                                          EdgeInsets.only(top: 20, right: 15),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: ColorPalet.secondaryDefault,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 246, 239, 255),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: sizeScreen.width * 0.3,
                                                child: Text(
                                                    histCamp.nombrePromo,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'inter',
                                                      color: ColorPalet
                                                          .grisesGray5,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(histCamp.descuento.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'sans',
                                                    color:
                                                        ColorPalet.grisesGray5,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                              width: sizeScreen.width * 0.3,
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/img/promo.png')))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ):
                            Center(
                              child: CircularProgressIndicator(color: ColorPalet.secondaryDefault,),
                            ),
                  ],
                ),
              ),
            ],
          ),
          drawer: const DrawerWidget()),
    );
  }

  SizedBox _FondoVerde(double sizeHeigth) {
    return SizedBox(
      child: Container(
        height: sizeHeigth * 0.10,
        width: double.infinity,
        color: ColorPalet.secondaryDefault,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                'Campañas',
                style: TextStyle(
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 29,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconMenu extends StatelessWidget {
  const _IconMenu({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey, required this.size,
  }) : _scaffoldKey = scaffoldKey;

  final Size size;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
              decoration: BoxDecoration(
                  color: Color(0x636B64FF),
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                  
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const ImageIcon(
                    AssetImage(
                      'assets/img/menu_icon.png',
                    ),
                    size: 30 ,
                    color: Colors.white,
                  ) 
            )
          ),

          Spacer(),
          Container(
            height: 38,
            width: 38,
              decoration: BoxDecoration(
                  color: Color(0x636B64FF),
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                  icon: Icon(Iconsax.notification_bing),
                  color: ColorPalet.grisesGray5,
                  onPressed: () {
                    final headerModel =
                        Provider.of<HomePetShopProvider>(context, listen: false);
                    headerModel.toggleExpansion();
                  },
                  
            )
          ),

          Container(
            height: 38,
            width: 38,
              decoration: BoxDecoration(
                  color: Color(0x636B64FF),
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
              child: IconButton(
                  icon: Icon(Iconsax.message_text_1),
                  color: ColorPalet.grisesGray5,
                  onPressed: () {
                    
                  },
                  
            )
          ),      
        ]
        ,
      ),
    
    );
  }
}
