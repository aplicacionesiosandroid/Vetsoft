import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/producto_model.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../../../config/global/palet_colors.dart';

class Grid_productos_widget extends StatelessWidget {
  Grid_productos_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homePetshopProvider = Provider.of<HomePetShopProvider>(context);
    // final listProducts = homePetshopProvider.productsFiltre.isEmpty ? homePetshopProvider.products : homePetshopProvider.productsFiltre;
    final listProducts = homePetshopProvider.productsFiltre;
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
        ),
        itemCount: listProducts.length,
        itemBuilder: (context, index) {
          final product = listProducts[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/productoDetalleScreen',
                  arguments: product);
              //abrir una ventana de detalle del producto
            },
            child: Container(
              margin: const EdgeInsets.only(
                left: 5.0,
                right: 8.0,
                bottom: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 3),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/icon/logovs.png',
                            // image: '$imagenUrlGlobal${product.imagenes[0]}',
                            image:
                                '$imagenUrlGlobal${product.imagenes.first.replaceAll(RegExp(r'[\[\]]'), '')}',
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 200),
                            fadeInCurve: Curves.easeIn,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          product.nombreProducto ?? 'Name',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Bs. ${product.precioVentaProducto}",
                              style: const TextStyle(
                                color: ColorPalet.estadoNeutral,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            if (product.oferta != '')
                              Text(
                                "Bs. ${product.costoProducto}",
                                style: TextStyle(
                                  color: ColorPalet.grisesGray2,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (product.oferta != '')
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 202, 199),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Oferta',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
