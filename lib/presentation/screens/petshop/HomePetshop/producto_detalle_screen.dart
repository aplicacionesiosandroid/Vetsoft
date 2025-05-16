import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/Carrito/detalle_producto.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../providers/petshop/HomePetshop/home_petshop_provider.dart';

class ProductoDetalleScreen extends StatelessWidget {
  const ProductoDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final carritoProvider = Provider.of<HomePetShopProvider>(context);
    return Scaffold(
        //bottomNavigationBar: const BottomNavigationBarWidget(),
      body: ListView(children: [
        Container(
          height: size.height * 0.03,
          decoration: const BoxDecoration(
            color: ColorPalet.secondaryDefault,
          ),
        ),
        Container(
          color: ColorPalet.secondaryDefault,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: size.height * 0.9,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorPalet.grisesGray4,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        carritoProvider.setCantidadProduct(0);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text(
                      'Producto',
                      style: TextStyle(
                        fontFamily: 'sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      transform: carritoProvider.isAgree
                          ? Matrix4.translationValues(
                              3, 4, 0) // Mueve hacia abajo
                          : Matrix4.identity(),
                      child: SizedBox(
                        height: 65,
                        width: 65,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/carritoScreen');
                          },
                          icon: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: carritoProvider.isAgree
                                      ? ColorPalet.secondaryDark
                                      : ColorPalet.secondaryDefault,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  Iconsax.shopping_cart,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            carritoProvider.items.isNotEmpty
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 17.0,
                                      height: 17.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                const Color.fromARGB(255, 0, 0, 0)
                                                    .withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Text(
                                        carritoProvider.items.length.toString(),
                                        style: TextStyle(
                                            color: ColorPalet.grisesGray5,
                                            fontSize: 11,
                                            fontFamily: 'sans'),
                                      )),
                                    ),
                                  )
                                : Container()
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                producto_detalles_widget(size: size),
              ],
            ),
          ),
        ),
    ]));
  }
}
