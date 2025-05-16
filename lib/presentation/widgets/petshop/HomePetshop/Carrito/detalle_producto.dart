import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../../../config/global/palet_colors.dart';
import '../../../../../models/petshop/HomePetshop/producto_model.dart';

class producto_detalles_widget extends StatelessWidget {
  const producto_detalles_widget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    Productos productDetail =
        ModalRoute.of(context)!.settings.arguments as Productos;
    final carritoProvider = Provider.of<HomePetShopProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/icon/logovs.png',
                // image: '$imagenUrlGlobal${productDetail.imagenes[0]}',
                image:
                    '$imagenUrlGlobal${productDetail.imagenes.first.replaceAll(RegExp(r'[\[\]]'), '')}',
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 200),
                fadeInCurve: Curves.easeIn,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productDetail.nombreProducto,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Bs. ${productDetail.precioVentaProducto}",
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorPalet.acentDefault,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          carritoProvider.setDecrementProduct();
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
                        carritoProvider.cantidadProduct.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          carritoProvider.setCantDisponible(
                              productDetail.cantidadDisponible);
                          if (carritoProvider.cantidadProduct <
                              productDetail.cantidadDisponible) {
                            carritoProvider.setincrementProduct();
                          } else {
                            final snackBar = SnackBar(
                              content: Text('¡No hay suficiente stock!'),
                              duration: Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
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
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Detalle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (productDetail.stockEstado.toLowerCase() == 'stock bajo')
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 213, 210),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                productDetail.stockEstado,
                style: TextStyle(
                  color: productDetail.stockEstado.toLowerCase() == 'stock bajo'
                      ? ColorPalet.estadoNegative
                      : ColorPalet.estadoPositive,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 15),
          Text(
            productDetail.productoDetalle,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vencimiento',
                style: TextStyle(fontSize: 14, color: ColorPalet.acentDefault),
              ),
              const Spacer(),
              Text(
                productDetail.fechaVencimiento ?? '00/00/0000',
                style: TextStyle(fontSize: 14, color: ColorPalet.acentDefault),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (carritoProvider.cantidadProduct > 0) {
                carritoProvider.addToCart(
                    productDetail.productoId,
                    carritoProvider.cantidadProduct,
                    productDetail.nombreProducto,
                    productDetail.precioVentaProducto,
                    productDetail.cantidadDisponible,
                    productDetail.imagenes[0]);
                carritoProvider.setCantidadProduct(0);

                Future.delayed(Duration(milliseconds: 300), () {
                  carritoProvider.setOKisAgree(false);
                });
              } else {
                final snackBar = SnackBar(
                  content: Text('¡Agregue cantidad!'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: ColorPalet
                      .gradientPrimary, // Cambia los colores según tus preferencias
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  transform: GradientRotation(0.5),
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: size.height * 0.07,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Añadir al Carrito',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
