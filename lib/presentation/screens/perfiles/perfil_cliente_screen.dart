// perfil_mascota.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/buscador/cliente_model.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/perfiles/perfil_mascota_provider.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({Key? key}) : super(key: key);

  @override
  _PerfilClienteState createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    print("id de cliente: $id");
    final perfilMascotaProvider = Provider.of<PerfilMascotaProvider>(context, listen: false);

    perfilMascotaProvider.getCliente(id).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final perfilMascotaProvider = Provider.of<PerfilMascotaProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => PerfilMascotaProvider(),
      child: isLoading ? Center(child: CircularProgressIndicator()) : PerfilClienteWidget(perfilMascotaProvider.getPerfilCliente?.data[0]),
    );
  }
}


class PerfilClienteWidget extends StatelessWidget {
  final ClienteData? cliente;
  PerfilClienteWidget(this.cliente);
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final mascotaPerfilProvider = Provider.of<PerfilMascotaProvider>(context);
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;

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
                  //margin: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 12),
                  //padding: EdgeInsets.all(1),
                  child: Builder(builder: (context) {
                    return IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: ImageIcon(
                          AssetImage(
                            'assets/img/menu_icon.png',
                          ),
                          color: Colors.white,
                        ));
                  })),
            ),
          ),
          actions: [
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
                    final headerModel = Provider.of<HomePetShopProvider>(
                        context,
                        listen: false);
                    headerModel.toggleExpansion();
                  },
                )),
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
                  onPressed: () {},
                )),
          ],
        ),
        backgroundColor: ColorPalet.secondaryDefault,
        body: Column(
          children: [
            AnimatedContainer(
              color: ColorPalet.secondaryDefault,
              duration: const Duration(milliseconds: 500),
              height: isHeaderExpanded ? sizeScreen.height * 0.23 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isHeaderExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Notificaciones',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                    ),
                  if (isHeaderExpanded)
                    Notify_card_widget(cardNotifyList: cardNotifyList),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 15),
                    child: Text(
                      'Cliente',
                      style: TextStyle(
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      height: sizeScreen.height * 0.25,
                      width: sizeScreen.width,
                      color: const Color.fromARGB(255, 99, 92, 255),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: sizeScreen.width,
                            child: Stack(
                              children: [
                                Container(
                                  width: sizeScreen.width,
                                  height: sizeScreen.height * 0.13,
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: sizeScreen.height * 0.07, // Adjust radius as needed
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/icon/logovs.png',
                                          image: '$imagenUrlGlobal${cliente?.fotoPropietario}',
                                          fit: BoxFit.cover,
                                          width: sizeScreen.height * 0.24, // Double the radius
                                          height: sizeScreen.height * 0.24, // Double the radius
                                          fadeInDuration: Duration(milliseconds: 200),
                                          fadeInCurve: Curves.easeIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF6B64FF),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(right: 15),
                                      child: IconButton(
                                        icon: Icon(Iconsax.edit_2),
                                        color: ColorPalet.grisesGray5,
                                        onPressed: () {},
                                      )),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '${cliente!.nombresPropietario} ${cliente!.apellidosPropietario}',
                            style: TextStyle(
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeScreen.width * 0.2,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: ColorPalet
                                                  .grisesGray5,
                                              width: 3)),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/icon/logovs.png',
                                            image: '$imagenUrlGlobal${cliente?.mascotas[0].fotoPaciente}',
                                            fit: BoxFit.cover,
                                            width: sizeScreen.height * 0.24, // Double the radius
                                            height: sizeScreen.height * 0.24, // Double the radius
                                            fadeInDuration: Duration(milliseconds: 200),
                                            fadeInCurve: Curves.easeIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: ColorPalet
                                                    .grisesGray5,
                                                width: 3)),
                                        child: CircleAvatar(
                                          backgroundColor: ColorPalet.primaryDark,
                                          child: Text('+${cliente!.mascotas.length  - 1}'),
                                          radius: sizeScreen.width * 0.05,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Iconsax.pet5, color: ColorPalet.grisesGray5,),
                              Text(
                            '${cliente!.mascotas.length} mascotas',
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ColorPalet.backGroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                    padding: EdgeInsets.all(10.0),
                    width: sizeScreen.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _textClientePerfil(ColorPalet.grisesGray2, 'Teléfono'),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                },
                                icon: Icon(
                                  Iconsax.edit_2,
                                  color: ColorPalet.secondaryDefault,
                                ))
                          ],
                        ),
                        _textClientePerfil(ColorPalet.grisesGray1, '${cliente!.telefonoCelular}'),

                        Divider(color: ColorPalet.grisesGray2,),

                        _textClientePerfil(ColorPalet.grisesGray2, 'Dirección'),
                        _textClientePerfil(ColorPalet.grisesGray1, '${cliente!.direccion}'),

                         Divider(color: ColorPalet.grisesGray2,),

                        _textClientePerfil(ColorPalet.grisesGray2, 'NIT'),
                        _textClientePerfil(ColorPalet.grisesGray1, '${cliente!.nit}'),

                         Divider(color: ColorPalet.grisesGray2,),

                        _textClientePerfil(ColorPalet.grisesGray2, 'Cliente'),
                        _textClientePerfil(ColorPalet.grisesGray1, '${cliente!.cliente}'),

                      ],
                    ),
                  ),
 
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _textClientePerfil(Color color, String texto) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Text(
        texto,
        style: TextStyle(
            color: color,
            fontSize: 16.0,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700),
      ),
    );
  }



}
