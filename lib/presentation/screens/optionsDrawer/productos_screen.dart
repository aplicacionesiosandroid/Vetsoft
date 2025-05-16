import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/tareas/model_tareas_progreso.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/crear_tarea_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/objetivos/tablero_objetivos_screen.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verTareas_screen.dart';
import 'package:vet_sotf_app/providers/campanas/campain_provider.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/HomePetshop/notificacion_model.dart';
import '../../../providers/petshop/HomePetshop/home_petshop_provider.dart';
import '../../../providers/productos/productos_provider.dart';
import '../../../providers/tareas/objetivos_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/petshop/HomePetshop/petshopHome/Notify_card.dart';
import '../tareas/objetivos/crear_objetivos_screen.dart';

class ProductosScreen extends StatelessWidget {
  ProductosScreen({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    final campainProvider = Provider.of<CampainProvider>(context);
    final isHeaderExpanded = homePetshopProvider.isExpanded;

    final productosProvider = Provider.of<ProductosProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    List<CardNotify> cardNotifyList = notificationsProvider.cardNotifyList;
    final listProducts = campainProvider.getproducts;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Color(0xFF735CFF),
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
          key: _scaffoldKey,
          backgroundColor: Color(0xFF735CFF),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                color: Color(0xFF735CFF),
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
              AnimatedContainer(
                color: Color(0xFF735CFF),
                duration: const Duration(milliseconds: 500),
                height: !isHeaderExpanded ? 50 : 0,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'Productos',
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
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //height: sizeScreen.height * 0.681,
                  width: sizeScreen.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 247, 246),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: sizeScreen.width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<ProductosProvider>(context,
                                              listen: false)
                                          .resetearForm();
                                      Navigator.pushNamed(
                                          context, '/registrarProducto');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      height: sizeScreen.height * 0.2,
                                      decoration: BoxDecoration(
                                          color: ColorPalet.secondaryDefault,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF8571FF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Iconsax.add,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Agregar',
                                            style: TextStyle(
                                              fontFamily: 'sans',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Nuevo producto',
                                                  style: TextStyle(
                                                    fontFamily: 'inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_outlined,
                                                size: 25,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      productosProvider.setVistaControlStock();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      height: sizeScreen.height * 0.2,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF4A2FB1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 72, 69, 151),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Icon(
                                                Iconsax.gps,
                                                color: Colors.white,
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Productos',
                                            style: TextStyle(
                                              fontFamily: 'sans',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Control de stock',
                                                  style: TextStyle(
                                                    fontFamily: 'inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_outlined,
                                                size: 25,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (!productosProvider.vistaControlStock)
                            SizedBox(
                              width: sizeScreen.width,
                              child: Row(
                                children: [
                                  const Text("Productos mas vendidos",
                                      style: TextStyle(
                                        fontFamily: 'sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      /* openModalBottomSheetVerTareas(context);
                                    dataTareas.setSelectButton(2); */
                                    },
                                    child: Text("Ver todas",
                                        style: TextStyle(
                                          fontFamily: 'inter',
                                          color: ColorPalet.grisesGray2,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          if (!productosProvider.vistaControlStock)
                            SizedBox(
                              height: sizeScreen.height * 0.25,
                              width: sizeScreen.width,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: productosProvider
                                    .productsMasVendidos.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      productosProvider.productsMasVendidos;
                                  return InkWell(
                                    onTap: () {
                                      /* dataTareas
                                        .getVerTareaID(tareaProgreso.tareaId)
                                        .then((_) async {
                                      if (dataTareas
                                          .loadingDatosParaDetalleTarea) {
                                        openModalBottomSheetVerDetalleTarea(
                                            context, dataTareas);
                                        dataTareas
                                            .setLoadingDatosParaDetalleTarea(
                                                false);
                                      }
                                    }); */
                                    },
                                    child: Container(
                                      width: sizeScreen.width * 0.35,
                                      margin:
                                          EdgeInsets.only(top: 20, right: 15),
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          bottom: 15,
                                          top: 15),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 246, 239, 255),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/icon/logovs.png',
                                              image:
                                                  '$imagenUrlGlobal${product[index].imagenes[0]}',
                                              fit: BoxFit.cover,
                                              fadeInDuration:
                                                  Duration(milliseconds: 200),
                                              fadeInCurve: Curves.easeIn,
                                            ),
                                          ),
                                          if (product.isNotEmpty)
                                            Text(
                                                product[index].nombreProducto ??
                                                    'Nombre',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'inter',
                                                  color: ColorPalet.grisesGray0,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (!productosProvider.vistaControlStock)
                            SizedBox(
                              height: 20,
                            ),
                          if (!productosProvider.vistaControlStock)
                            SizedBox(
                              width: sizeScreen.width,
                              child: Row(
                                children: [
                                  const Text("Promociones activas",
                                      style: TextStyle(
                                        fontFamily: 'sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      /* openModalBottomSheetVerTareas(context);
                                    dataTareas.setSelectButton(2); */
                                    },
                                    child: Text("Ver todo",
                                        style: TextStyle(
                                          fontFamily: 'inter',
                                          color: ColorPalet.grisesGray2,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          if (!productosProvider.vistaControlStock)
                            productosProvider.historialCampain.isNotEmpty
                                ? SizedBox(
                                    height: sizeScreen.height * 0.18,
                                    width: sizeScreen.width,
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productosProvider
                                          .historialCampain[0]
                                          .promociones
                                          .length,
                                      itemBuilder: (context, index) {
                                        final histCamp = productosProvider
                                            .historialCampain[0]
                                            .promociones[index];
                                        return InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: sizeScreen.width * 0.7,
                                            margin: EdgeInsets.only(
                                                top: 20, right: 15),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorPalet.secondaryDefault,
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
                                                      width: sizeScreen.width *
                                                          0.3,
                                                      child: Text(
                                                          histCamp.nombrePromo,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: 'inter',
                                                            color: ColorPalet
                                                                .grisesGray5,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                                    Text(
                                                        histCamp.descuento
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily: 'sans',
                                                          color: ColorPalet
                                                              .grisesGray5,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                    width:
                                                        sizeScreen.width * 0.3,
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/img/promo.png')))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: ColorPalet.secondaryDefault,
                                    ),
                                  ),
                          productosProvider.vistaControlStock
                              ? const Text("Productos",
                                  style: TextStyle(
                                    fontFamily: 'sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ))
                              : Container(),
                          productosProvider.vistaControlStock
                              ? SizedBox(
                                  height: sizeScreen.height * 0.6,
                                  width: sizeScreen.width,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: listProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = listProducts[index];
                                      return InkWell(
                                        onTap: () {
                                          /* dataTareas
                                        .getVerTareaID(tareaProgreso.tareaId)
                                        .then((_) async {
                                      if (dataTareas
                                          .loadingDatosParaDetalleTarea) {
                                        openModalBottomSheetVerDetalleTarea(
                                            context, dataTareas);
                                        dataTareas
                                            .setLoadingDatosParaDetalleTarea(
                                                false);
                                      }
                                    }); */
                                        },
                                        child: Container(
                                          height: sizeScreen.height * 0.15,
                                          width: sizeScreen.width,
                                          margin: EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorPalet.backGroundColor),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'assets/icon/logovs.png',
                                                      image:
                                                          '$imagenUrlGlobal${product.imagenes[0].replaceAll(RegExp(r'[\[\]]'), '')}',
                                                      fit: BoxFit.cover,
                                                      fadeInDuration: Duration(
                                                          milliseconds: 200),
                                                      fadeInCurve:
                                                          Curves.easeIn,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        sizeScreen.width * 0.04,
                                                  ),
                                                  Container(
                                                    width:
                                                        sizeScreen.width * 0.3,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 5.0,
                                                    ),
                                                    child: Text(
                                                      product.nombreProducto ??
                                                          'Nombre',
                                                      style: TextStyle(
                                                        fontFamily: 'inter',
                                                        color: ColorPalet
                                                            .grisesGray1,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      "Bs. ${product.precioVentaProducto}",
                                                      style: const TextStyle(
                                                        fontFamily: 'sans',
                                                        color: ColorPalet
                                                            .grisesGray1,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                  ClipOval(
                                                    child: Material(
                                                      color: Colors
                                                          .transparent, // Color del fondo transparente
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/productoDetalleScreen',
                                                              arguments:
                                                                  product);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(
                                                              8.0), // Ajusta el tamaño del área clicable
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: ColorPalet
                                                                .grisesGray2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: sizeScreen.height * 0.09,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: product
                                                                    .stockEstado ==
                                                                "Stock bajo"
                                                            ? ColorPalet
                                                                .stockBajo
                                                            : product.stockEstado ==
                                                                    "Por expirar"
                                                                ? ColorPalet
                                                                    .porExpirar
                                                                : ColorPalet
                                                                    .porPedido,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7)),
                                                    child: Text(
                                                        product.stockEstado ==
                                                                ""
                                                            ? "Sin estado"
                                                            : product
                                                                .stockEstado,
                                                        style: TextStyle(
                                                          fontFamily: 'inter',
                                                          color: product
                                                                      .stockEstado ==
                                                                  "Stock bajo"
                                                              ? ColorPalet
                                                                  .letraStockBajo
                                                              : product.stockEstado ==
                                                                      "Por expirar"
                                                                  ? ColorPalet
                                                                      .letraStockExpirar
                                                                  : ColorPalet
                                                                      .letraStockPedido,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        sizeScreen.width * 0.04,
                                                  ),
                                                  Text(
                                                      "${product.cantidadDisponible} items",
                                                      style: TextStyle(
                                                        fontFamily: 'inter',
                                                        color: product
                                                                    .stockEstado ==
                                                                "Stock bajo"
                                                            ? ColorPalet
                                                                .letraStockBajo
                                                            : ColorPalet
                                                                .grisesGray2,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  Spacer(),
                                                  Text(
                                                      "Costo Bs. ${product.costoProducto}",
                                                      style: TextStyle(
                                                        fontFamily: 'inter',
                                                        color: ColorPalet
                                                            .grisesGray1,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: const DrawerWidget()),
    );
  }
}

Future<dynamic> bottomSheetOptionsTareas(
    BuildContext context, Size sizeScreen, TareaProgreso tareaProgreso) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    child: Divider(
                      // Línea superior
                      color: ColorPalet.grisesGray3,
                      thickness: 3.0,
                    ),
                  ),
                ],
              ),
              Container(
                width: sizeScreen.width,
                height: 100,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: ColorPalet.grisesGray4, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 224, 76, 55),
                          borderRadius: BorderRadius.circular(8)),
                      width: 4,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tareaProgreso.titulo,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Estado: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                tareaProgreso.estado,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      Iconsax.edit,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Editar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Iconsax.arrow_left,
                                            color: ColorPalet.grisesGray0),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Marcar como',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'sans',
                                          fontWeight: FontWeight.w700,
                                          color: ColorPalet.grisesGray0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                /* InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clipboard_text,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'En progreso',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), */
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    Provider.of<TareasProvider>(context,
                                            listen: false)
                                        .moverEstadoTarea(
                                            tareaProgreso.tareaId, 'terminadas')
                                        .then((value) async {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clipboard_tick,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Terminado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.recovery_convert,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Mover a',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _mostrarAlertaEliminarCita(context, tareaProgreso.tareaId);
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.trash,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Eliminar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10)
            ]),
      );
    },
  );
}

void _mostrarAlertaEliminarCita(BuildContext context, int idTarea) {
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
            '¿Estás seguro/a de que quieres eliminar esta tarea?',
            style: TextStyle(
                color: const Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: const Text(
                    'Si eliminas esta tarea, no podrás recuperarla más tarde.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 85, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'No, cancelar',
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                // Cerrar el AlertDialog
                                Provider.of<TareasProvider>(context,
                                        listen: false)
                                    .eliminarTarea(idTarea)
                                    .then((value) async {
                                  Provider.of<TareasProvider>(context,
                                          listen: false)
                                      .setOKsendEliminarTarea(false);
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: ColorPalet.secondaryDefault,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'Sí, eliminar',
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetCrearTarea(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: FormularioCrearTarea(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetCrearObjetivo(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: FormularioCrearObjetivo(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetVerObjetivos(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              child: FormularioVerobjetivos(),
            ),
          ]),
        ),
      );
    },
  );
}

void openModalBottomSheetVerTareas(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              child: FormularioVerTareas(),
            ),
          ]),
        ),
      );
    },
  );
}

class MyDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double dashWidth = 5; // Ancho de los segmentos
    final double dashSpace = 1; // Espacio entre segmentos
    final double startY = 0;
    final double endY = size.height;

    Paint paint = Paint()
      ..color = ColorPalet.grisesGray3
      ..strokeWidth = 1;

    double currentY = startY;
    bool draw = true;

    while (currentY < endY) {
      if (draw) {
        canvas.drawLine(
            Offset(0, currentY), Offset(0, currentY + dashWidth), paint);
      }
      currentY += dashWidth + dashSpace;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
