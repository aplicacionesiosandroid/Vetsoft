import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../models/agregar_productos/carousel_productos.dart';
import '../../../models/agregar_productos/productos/ProductosFavoritosModel.dart';
import '../../../providers/productos/productos_mas_vendidos_provider.dart';
import '../../../providers/ui_provider.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({Key? key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List<ProductosFavoritosModel> productos = []; // Lista de productos

  @override
  void initState() {
    super.initState();
    cargarProductos().then((loadedProductos) {
      if (mounted) {
        // Verificar si el widget todavía está montado
        setState(() {
          productos = loadedProductos;
        });
      }
    });
  }

  Future<List<ProductosFavoritosModel>> cargarProductos() async {
    try {
      // Obtener los productos del provider
      final productosProvider =
          Provider.of<ProductosFavoritosProvider>(context, listen: false);
      final List<ProductosFavoritosModel> loadedProductos =
          await productosProvider.fetchProductos();

      return loadedProductos; // Devuelve la lista de productos
    } catch (error) {
      // Manejar errores aquí
      print('Error al cargar los productos: $error');
      return []; // En caso de error, devuelve una lista vacía o maneja el error según tu lógica
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiProviderDrawer = Provider.of<UiProvider>(context, listen: false);
    final sizeHeigth = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 107, 100, 255),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(12),
                      child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const ImageIcon(
                            AssetImage(
                              'assets/img/menu_icon.png',
                            ),
                            color: Colors.white,
                          ))),
                  const Spacer(),
                  Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 107, 100, 255),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(12),
                      child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Iconsax.notification,
                            color: Colors.white,
                            size: 30,
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 107, 100, 255),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(12),
                      child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Iconsax.message,
                            color: Colors.white,
                            size: 30,
                          ))),
                ],
              ),
              SizedBox(
                child: Container(
                  height: sizeHeigth * 0.1,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 99, 92, 255),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 15),
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                height: sizeHeigth,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 247, 246),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WidgetCarouselPrincipal(
                      carouselMenuProductos: carouselMenuProductos,
                      drawerProvider: uiProviderDrawer,
                    ),
                    Container(
                      width: sizeWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: const Row(
                        children: [
                          Text('Productos mas vendidos',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 34, 44),
                                  fontFamily: 'sans',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700)),
                          Spacer(),
                          Text('Ultimo mes',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    ProductCarouselWidget(productos: productos),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: sizeWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: const Row(
                        children: [
                          Text('Promociones Activas',
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontSize: 19,
                                fontWeight: FontWeight.w700)
                          ),
                          Spacer(),
                          Text('Ver todo',
                            style: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166),
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w400
                            )
                            ),
                        ],
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
  }
}

class _WidgetCarouselPrincipal extends StatelessWidget {
  const _WidgetCarouselPrincipal({
    required this.carouselMenuProductos,
    required this.drawerProvider,
  });

  final List<CarouselProductos> carouselMenuProductos;
  final UiProvider drawerProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
          padEnds: false,
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.55),
          itemCount: carouselMenuProductos.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homeScreen');

                drawerProvider.setOptionSelectedDrawer(
                    carouselMenuProductos[index].title);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: carouselMenuProductos[index].background),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: carouselMenuProductos[index].iconBackground),
                        child: Center(
                          child: carouselMenuProductos[index].icono,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          carouselMenuProductos[index].title,
                          style: const TextStyle(
                              fontFamily: 'inter',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 22),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                carouselMenuProductos[index].subtitle,
                                style: const TextStyle(
                                    fontFamily: 'inter',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ProductCarouselWidget extends StatelessWidget {
  final List<ProductosFavoritosModel>
      productos; // Recibir la lista de productos como argumento

  const ProductCarouselWidget({
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    // Usar la lista de productos aquí
    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return _ProductCard(producto: producto);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductosFavoritosModel producto;

  const _ProductCard({
    required this.producto,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                producto.imagenes.isNotEmpty
                    ? 'assets/img/comida_fondo.png'
                    : producto.imagenes[0],
                height: 150,
                width: 180,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                producto.productoDetalle ?? 'Producto sin nombre',
                style: const TextStyle(
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}