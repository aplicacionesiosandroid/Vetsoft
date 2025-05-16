import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/lista_productos_model.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/producto_model.dart';


import '../../../../config/global/palet_colors.dart';

final List<Product> products = [
  Product(
      name: "Royal Canin Puppy Mini",
      image: "assets/img/comida_fondo.png",
      price: 65000,
      salePrice: 5000,
      isOnSale: true),
  Product(
      name: "Plato",
      image: "assets/img/comida_fondo.png",
      price: 65000,
      salePrice: 5000,
      isOnSale: true),
  Product(
      name: "Ropa",
      image: "assets/img/comida_fondo.png",
      price: 65000,
      salePrice: 5000,
      isOnSale: true),
  Product(
      name: "Cepillo",
      image: "assets/img/comida_fondo.png",
      price: 65000,
      salePrice: 5000,
      isOnSale: true),
];

class BusquedaPetshopScreen extends StatelessWidget {
  const BusquedaPetshopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productList = Provider.of<ProductListModel>(context);
    
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalet.secondaryDefault,
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined),
            ),
          ],
          elevation: 0,
          ),
      body: ListView(children: [
        Container(
          height: size.height * 0.01,
          decoration: const BoxDecoration(
            color: ColorPalet.secondaryDefault,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: size.height * 0.90,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorPalet.grisesGray4,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: ColorPalet.grisesGray5,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorPalet.grisesGray5,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Buscar",
                            hintStyle: TextStyle(
                              color: ColorPalet.grisesGray2,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: ColorPalet.grisesGray2,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            10), // Espacio entre el campo de búsqueda y el botón de filtros
                    IconButton(
                        onPressed: () {
                          print("Filtros");
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: ColorPalet.grisesGray2,
                          size: 30,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Últimas Búsquedas",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                height: size.height * 0.6,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                            decoration: BoxDecoration(
                              color: ColorPalet.acentDefault,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              productList.removeProduct(index);
                            },
                            icon: Container(
                              height: size.height * 0.03,
                              width: size.height * 0.03,
                              decoration: BoxDecoration(
                                color: ColorPalet.grisesGray3,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
