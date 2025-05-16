import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/notificacion_model.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/petshopHome/productos_grid.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../widgets/drawer_widget.dart';

class HomePetshopScreen extends StatelessWidget {
/*   final List<CardData> cardDataList = [
    CardData("Alimentos", "15 Articulos", ColorPalet.secondaryDefault),
    CardData("Accesorios", "12 Articulos", ColorPalet.secondaryDark),
    CardData("Varios", "6 Articulos", ColorPalet.primaryDark),
  ]; */

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> listColor = [
    const Color(0xFF635CFF),
    const Color(0xFF312E80),
    const Color(0xFF410098),
    const Color(0xFF20004C)
  ];

  Color getRandomColor() {
    final Random random = Random();
    final int index = random.nextInt(listColor.length);
    return listColor[index];
  }

  final TextEditingController controllerBusquedaText = TextEditingController();
  Future<void> scanQrConsulta(context) async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      controllerBusquedaText.text = qrScanRes == "-1" ? "" : qrScanRes;

      // double uno = double.tryParse(controllerMontoEfectivo.text) ?? 0.0;
      // double dos = double.tryParse(controllerCodeDescuento.text) ?? 0.0;
      // double total = uno - dos;
      // ignore: use_build_context_synchronously
      Provider.of<HomePetShopProvider>(context, listen: false)
          .filtrarPorQR(controllerBusquedaText.text);
    } on PlatformException {
      qrScanRes = 'failed scan';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;
    final listGroupsProducts = homePetshopProvider.groupProducts;
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    notificationsProvider.tipeWindow = 'home';
    notificationsProvider.notificationListWidgetChangedColor();
    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Add this line

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
                  final headerModel =
                      Provider.of<HomePetShopProvider>(context, listen: false);
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
      drawer: const DrawerWidget(),
      key: _scaffoldKey,
      backgroundColor: ColorPalet.secondaryDefault,
      body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              color: ColorPalet.secondaryDefault,
              duration: const Duration(milliseconds: 500),
              height: isHeaderExpanded ? size.height * 0.23 : 0,
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
            AnimatedContainer(
              color: ColorPalet.secondaryDefault,
              duration: const Duration(milliseconds: 500),
              height: !isHeaderExpanded ? 60 : 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 15),
                    child: Text(
                      'Petshop',
                      style: TextStyle(
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: ColorPalet.secondaryDefault,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: size.height * 0.99,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7F6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      height: size.height * 0.18,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listGroupsProducts.length,
                          itemBuilder: (context, index) {
                            final grupoProducto = listGroupsProducts[index];
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              margin: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
                                onTap: () {
                                  homePetshopProvider.getProductosDeGrupo(
                                      grupoProducto.grupoId.toString());
                                  homePetshopProvider.setCurrentCategory(
                                      grupoProducto.nombreGrupo);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Ajusta el radio de borde aquí
                                  ),
                                  color: listColor[index],
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 25,
                                      bottom: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/img/flechas.png'), // Reemplaza 'ruta_de_tu_imagen' con la ruta de tu imagen
                                        fit: BoxFit
                                            .cover, // Ajusta la imagen para cubrir el contenedor
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          grupoProducto.nombreGrupo
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Text(
                                          '${grupoProducto.cantidadProductos} Productos',
                                          style: const TextStyle(
                                            color: ColorPalet.primaryLight,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F7F6),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: TextFormField(
                                controller: controllerBusquedaText,
                                decoration: InputDecoration(
                                  hintText: "Buscar",
                                  hintStyle: TextStyle(
                                    color: ColorPalet.grisesGray2,
                                  ),
                                  prefixIcon: Icon(
                                    Iconsax.search_normal,
                                    color: ColorPalet.grisesGray2,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controllerBusquedaText.clear();
                                      homePetshopProvider
                                          .filtrarProductosCategoria(
                                              homePetshopProvider.products, "");
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: controllerBusquedaText.text.isEmpty
                                          ? Color(0xFFF5F7F6)
                                          : ColorPalet.grisesGray3,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (query) {
                                  homePetshopProvider.filtrarProductosCategoria(
                                      homePetshopProvider.products,
                                      controllerBusquedaText.text);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                              width:
                                  10), // Espacio entre el campo de búsqueda y el botón de filtros
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff635CFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                                onPressed: () {
                                  print("QR scan");
                                  scanQrConsulta(context);
                                  // Navigator.pushNamed(context, '/busquedaPetshopScreen');
                                },
                                icon: const Icon(
                                  Iconsax.scan,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    ),
                    // if(homePetshopProvider.productsFiltre.isEmpty)
                    //   homePetshopProvider.currentCategory == "Seleccione una categoría" ? SizedBox(height: size.height*0.15) : homePetshopProvider.products.isEmpty ?  SizedBox(height: size.height*0.15) : const SizedBox(height: 20),
                    homePetshopProvider.productsFiltre.isEmpty
                        ? SizedBox(height: size.height * 0.15)
                        : const SizedBox(height: 20),
                    homePetshopProvider.currentCategory ==
                            "Seleccione una categoría"
                        ? Center(
                            child: Text(
                              'Seleccione una categoría', // Esto se actualizará automáticamente cuando cambie la categoría
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : homePetshopProvider.productsFiltre.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay productos', // Esto se actualizará automáticamente cuando cambie la categoría
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Consumer<HomePetShopProvider>(
                                builder: (context, provider, child) {
                                  final category = homePetshopProvider
                                      .currentCategory
                                      .toLowerCase();
                                  final formattedCategory =
                                      category.replaceFirst(category[0],
                                          category[0].toUpperCase());
                                  return Text(
                                    formattedCategory,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                    const SizedBox(height: 20),
                    Grid_productos_widget(),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
