
class CarouselCitas {
  final int id;
  final String imagenMascota;
  final String nombreMascota;
  final String fecha;
  final String nombreEmpleado;
  final String area;

  CarouselCitas(this.id, this.imagenMascota, this.nombreMascota, this.fecha, this.nombreEmpleado, this.area);
}

List<CarouselCitas> carouselCitaslList = [
    CarouselCitas(
      1,
      'assets/img/dogcita.png',
      'Lilo',
      'Hoy, 14:30 hrs.',
      'Dr. Perez',
      'Peluqueria'
    ),
    CarouselCitas(
      2,
      'assets/img/dogcita.png',
      'Luquita',
      'Hoy, 16:20 hrs.',
      'Dra. Maria',
      'Clinica'
    ),
    CarouselCitas(
      3,
      'assets/img/dogcita.png',
      'Pancho',
      'Hoy, 17:30 hrs.',
      'Dr. Perez',
      'Peluqueria'
    ),
  ];
