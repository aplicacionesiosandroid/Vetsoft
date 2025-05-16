import 'package:flutter/material.dart';

class CarouselProductos {
  final int id;
  final Color background;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final Icon icono;
  final String route;

  CarouselProductos(
      this.id, this.background, this.iconBackground, this.title, this.subtitle, this.icono, this.route);
}

List<CarouselProductos> carouselMenuProductos = [
    CarouselProductos(
        1,
        const Color.fromARGB(255, 0, 122, 160),
        const Color.fromARGB(255, 26, 202, 212),
        'Agregar',
        'Nuevo Producto',
        const Icon(
          Icons.add,
          color: Colors.white,
        ),
        '/agregarProducto'),
    CarouselProductos(
        2,
        const Color.fromARGB(255, 99, 92, 255),
        const Color.fromARGB(255, 177, 173, 255),
        'Productos',
        'Control de Stock',
        const Icon(Icons.bar_chart_sharp, color: Colors.white),
        '/homePetshop'),
  ];
