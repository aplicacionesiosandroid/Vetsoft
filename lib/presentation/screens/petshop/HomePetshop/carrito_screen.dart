import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/Carrito/lista_productos.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../providers/petshop/HomePetshop/home_petshop_provider.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final carritoProvider = Provider.of<HomePetShopProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
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
              // height: size.height * 0.9,
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
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: size.width * 0.3),
                      const Text(
                        'Carrito',
                        style: TextStyle(
                          fontFamily: 'sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Productos',
                    style: TextStyle(
                      fontFamily: 'sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Lista_productos_carrito_widget(size: size),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subtotal",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Bs. ${carritoProvider.calcularSubTotal().toString()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Descuento",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Bs. 0.00",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total"),
                      Text("Bs. ${carritoProvider.calcularSubTotal().toString()}"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (carritoProvider.items.isNotEmpty ) {
                        carritoProvider.cargarProductosParaObtenerDescuentos(carritoProvider.items);
                        Navigator.pushNamed(context, '/pagarScreen');
                      } else {
                        final snackBar = SnackBar(
                          content: Text('¡No tiene productos!'),
                          duration: Duration(seconds: 2), // Duración del SnackBar
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
                          colors: [
                            Colors.blue,
                            ColorPalet.acentDefault
                          ], // Cambia los colores según tus preferencias
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
                          'Ir a pagar',
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
            ),
          ),
        ],
      ),
    );
  }
}
