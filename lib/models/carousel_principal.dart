import 'package:flutter/material.dart';

class CarouselPrincipal {
  final int id;
  final Color background;
  final Color iconBackground;
  final String title;
  final Icon icono;

  CarouselPrincipal(
      this.id, this.background, this.iconBackground, this.title, this.icono);
}

List<CarouselPrincipal> carouselPrincipalList = [
    CarouselPrincipal(
        1,
        Color.fromARGB(255, 0, 122, 160),
        Color.fromARGB(255, 26, 202, 212),
        'Clinica',
        Icon(
          Icons.contact_emergency_sharp,
          color: Colors.white,
        )),
    CarouselPrincipal(
        2,
        Color.fromARGB(255, 99, 92, 255),
        Color.fromARGB(255, 177, 173, 255),
        'Peluqueria',
        Icon(Icons.cut, color: Colors.white)),
    CarouselPrincipal(
         3,
        Color.fromARGB(255, 49, 46, 128),
        Color.fromARGB(255, 99, 92, 255),
        'Petshop',
        Icon(Icons.shopping_bag, color: Colors.white)),
    CarouselPrincipal(
        4,
        Color.fromARGB(255, 0, 122, 160),
        Color.fromARGB(255, 26, 202, 212),
        'Peluqueria',
        Icon(Icons.cut, color: Colors.white)),
    CarouselPrincipal(
        5,
        Color.fromARGB(255, 0, 122, 160),
        Color.fromARGB(255, 26, 202, 212),
        'Petshop',
        Icon(Icons.shopping_bag, color: Colors.white)),
  ];
