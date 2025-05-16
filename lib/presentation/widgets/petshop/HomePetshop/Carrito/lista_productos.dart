import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';

import '../../../../../config/global/palet_colors.dart';
import '../../../../../providers/petshop/HomePetshop/home_petshop_provider.dart';

class Lista_productos_carrito_widget extends StatelessWidget {
  const Lista_productos_carrito_widget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<HomePetShopProvider>(context);
    final listaProductosCarrito = carritoProvider.items;
    return SizedBox(
      height: size.height * 0.5,
      child: listaProductosCarrito.isEmpty
          ? Center(
              child: Text(
                'Agrega productos al carrito',
                style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontSize: 16,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: listaProductosCarrito.length,
              itemBuilder: (context, index) {
                final myProducts = listaProductosCarrito[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorPalet.grisesGray5,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: size.height,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: ColorPalet.grisesGray5,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/img/comida_fondo.png',
                          image:
                              '$imagenUrlGlobal${myProducts!.imagen.replaceAll(RegExp(r'[\[\]]'), '')}',
                          fit: BoxFit.cover, // Cambiado de contain a cover
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeInCurve: Curves.easeIn,
                          alignment: Alignment
                              .center, // Asegura que la imagen se centre bien
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            myProducts!.producto_nombre,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  carritoProvider
                                      .decreaseQuantity(myProducts.producto_id);
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: ColorPalet.gradientPrimary,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                myProducts.cantidad
                                    .toString(), // Aquí puedes mostrar la cantidad actual
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  carritoProvider.increaseQuantity(
                                      myProducts.producto_id,
                                      carritoProvider.cantDisponible
                                          .toDouble());
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: ColorPalet.gradientPrimary,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  carritoProvider
                                      .removeProduct(myProducts.producto_id);
                                },
                                icon: const Icon(
                                  Iconsax.trash,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Bs. ${myProducts.monto}', // Precio a la derecha
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorPalet.estadoNeutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
