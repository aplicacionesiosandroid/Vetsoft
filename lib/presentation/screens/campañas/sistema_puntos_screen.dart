import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/HomePetshop/Carrito/detalle_producto.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../providers/campanas/campain_provider.dart';
import '../../widgets/campain/radio_button__campain.dart';

class SistemaPuntosScreen extends StatefulWidget {
  SistemaPuntosScreen({super.key});

  @override
  State<SistemaPuntosScreen> createState() => _SistemaPuntosScreenState();
}

class _SistemaPuntosScreenState extends State<SistemaPuntosScreen> {
  TextEditingController controllerBuscarProductos = TextEditingController();
  TextEditingController controllerPuntosCompra = TextEditingController();
  TextEditingController controllerPorcentajeDesc = TextEditingController();

  TextEditingController controllerBuscarContacts = TextEditingController();
  TextEditingController controllerCrearMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final campanaProvider = Provider.of<CampainProvider>(context);

    return Scaffold(
        //bottomNavigationBar: const BottomNavigationBarWidget(),
        body: ListView(children: [
      Container(
        height: size.height * 0.03,
        decoration: const BoxDecoration(
          color: ColorPalet.complementViolet3,
        ),
      ),
      Container(
        color: ColorPalet.complementViolet3,
        child: Container(
          height: size.height * 0.15,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/img/secondaryback.png'), // Ruta de la imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
            //color: ColorPalet.complementVerde1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sistema de Puntos',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                'Habilitación de Sistema de Puntos',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
      Container(
        color: ColorPalet.secondaryDark,
        child: Container(
          padding: EdgeInsets.all(15),
          height: size.height * 0.8,
          width: size.width,
          decoration: const BoxDecoration(color: ColorPalet.backGroundColor),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _separacionCampos(20),
                _NombreCampos('Habilitar Sistema de Puntos'),
                _separacionCampos(15),
                RadioButtonReutilizableHabilitarSisPuntos(
                  text: 'Puntos por compra',
                  valor: 'COMPRA',
                ),
                _separacionCampos(15),
                RadioButtonReutilizableHabilitarSisPuntos(
                  text: 'Puntos por producto',
                  valor: 'PRODUCTOS',
                ),
                _separacionCampos(20),
                _NombreCampos('Cantidad de Puntos por Compra'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    controller: controllerPuntosCompra,
                    hintText: '0',
                    colores: ColorPalet.secondaryLight),
                _separacionCampos(20),
                _NombreCampos('Asignar Porcentaje de Descuento'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    controller: controllerPorcentajeDesc,
                    hintText: '(Ej: 10)',
                    colores: ColorPalet.secondaryLight),
                _separacionCampos(20),
                _NombreCampos('Añadir Productos en Promoción'),
                _separacionCampos(15),
                RadioButtonReutilizableProdcutosPromocion(
                  text: 'Todos',
                  valor: '1',
                ),
                _separacionCampos(15),
                RadioButtonReutilizableProdcutosPromocion(
                  text: 'Seleccionar uno o varios productos',
                  valor: '2',
                ),
                campanaProvider.selectedproductsSisPuntos == '2'
                    ? TextFormField(
                        controller: controllerBuscarProductos,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.search_normal,
                            color: ColorPalet.secondaryDefault,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 177, 173, 255),
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Buscar productos',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166),
                              fontSize: 15,
                              fontFamily: 'inter'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(220, 249, 249, 249),
                          filled: true,
                        ),
                        onChanged: (query) {
                          final listaFiltradaProvider =
                              Provider.of<CampainProvider>(context,
                                  listen: false);
                          listaFiltradaProvider.filtrarListaproducts(
                              campanaProvider.getproducts, query);
                        },
                      )
                    : Container(),
                campanaProvider.listaDeProductsFilter.isNotEmpty &&
                        campanaProvider.mostrarListaProducts
                    ? Container(
                        height: 300,
                        child: Consumer<CampainProvider>(
                          builder: (context, provider, child) {
                            final listaProductos =
                                provider.listaDeProductsFilter;
                            return ListView.builder(
                              itemCount: listaProductos.length,
                              itemBuilder: (BuildContext context, int index) {
                                final producto = listaProductos[index];
                                final isSelected = provider
                                    .isSelectedProduct(producto.productoId);

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/icon/logovs.png',
                                      image: '$imagenUrlGlobal${producto.imagenes[0]}',
                                      fit: BoxFit.cover,
                                      fadeInDuration: Duration(milliseconds: 200),
                                      fadeInCurve: Curves.easeIn,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: Text(
                                    producto.nombreProducto,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    producto.nombreProducto.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: isSelected
                                          ? Color.fromARGB(255, 139, 149, 166)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.toggleSelectionProducts(
                                        producto.productoId);

                                    print(provider.selectedProductList.length);
                                  },
                                );
                              },
                            );
                          },
                        ))
                    : Container(),
                _separacionCampos(20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NombreCampos('Fecha de Inicio'),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _openBottomSheetFechaInicioSisPuntos(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: ColorPalet.inputBackGroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Text(
                                    campanaProvider
                                                .fechaInicioSelectedSisPuntos ==
                                            ''
                                        ? 'Sin fecha'
                                        : campanaProvider
                                            .fechaInicioSelectedSisPuntos,
                                    style: TextStyle(
                                        color: ColorPalet.grisesGray2,
                                        fontFamily: 'inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Icon(Iconsax.calendar)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NombreCampos('Fecha de Fin'),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _openBottomSheetFechaFinalizacionSisPuntos(
                                  context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: ColorPalet.inputBackGroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Text(
                                    campanaProvider.fechaFinSelectedSisPuntos ==
                                            ''
                                        ? 'Sin fecha'
                                        : campanaProvider
                                            .fechaFinSelectedSisPuntos,
                                    style: TextStyle(
                                        color: ColorPalet.grisesGray2,
                                        fontFamily: 'inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Icon(Iconsax.calendar)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                _separacionCampos(20),
                _NombreCampos('Enviar'),
                _separacionCampos(15),
                RadioButtonReutilizableContactsSisPuntos(
                  text: 'Enviar a todos los contactos',
                  valor: '1',
                ),
                _separacionCampos(15),
                RadioButtonReutilizableContactsSisPuntos(
                  text: 'Seleccionar Contactos',
                  valor: '2',
                ),
                campanaProvider.selectedContactsSisPuntos == '2'
                    ? TextFormField(
                        controller: controllerBuscarContacts,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.search_normal,
                            color: ColorPalet.secondaryDefault,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 177, 173, 255),
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Buscar registros',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166),
                              fontSize: 15,
                              fontFamily: 'inter'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(220, 249, 249, 249),
                          filled: true,
                        ),
                        onChanged: (query) {
                          final listaFiltradaProvider =
                              Provider.of<CampainProvider>(context,
                                  listen: false);
                          listaFiltradaProvider.filtrarListaContacts(
                              campanaProvider.getcontactos, query);
                        },
                      )
                    : Container(),
                campanaProvider.listaDeContactosFilter.isNotEmpty &&
                        campanaProvider.mostrarLista
                    ? Container(
                        height: 300,
                        child: Consumer<CampainProvider>(
                          builder: (context, provider, child) {
                            final listaContactos =
                                provider.listaDeContactosFilter;
                            return ListView.builder(
                              itemCount: listaContactos.length,
                              itemBuilder: (BuildContext context, int index) {
                                final contacto = listaContactos[index];
                                final isSelected = provider
                                    .isSelectedContact(contacto.contactoId);

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/img/user.png'),
                                  ),
                                  title: Text(
                                    contacto.nombres,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    contacto.nombres +
                                        contacto.apellidos.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: isSelected
                                          ? Color.fromARGB(255, 139, 149, 166)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.toggleSelectionContact(
                                        contacto.contactoId);

                                    print(provider.selectedContactList.length);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
                _separacionCampos(20),
                _NombreCampos('Crear mensaje'),
                _separacionCampos(15),
                TextFormFieldMaxLinesConHint(
                    hintText: 'Mensaje',
                    controller: controllerCrearMessage,
                    maxLines: 6,
                    colores: ColorPalet.secondaryLight),
                _separacionCampos(20),
                ElevatedButton(
                  onPressed: () {
                    campanaProvider.openGalleryImgSisPuntos();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.secondaryLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: SizedBox(
                    //width: size.width,
                    height: 40,
                    child: Row(
                      children: [
                        Icon(Iconsax.image),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          campanaProvider.selectedNombreImagenSisPuntos == ''
                              ? 'Cargar imagen'
                              : campanaProvider.selectedNombreImagenSisPuntos,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _separacionCampos(20),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      campanaProvider
                          .enviarDatosCrearSisPuntos(
                              campanaProvider.selectedHabSisPuntos,
                              controllerPorcentajeDesc.text,
                              controllerPuntosCompra.text,
                              campanaProvider.selectedProductList,
                              campanaProvider.selectedContactList,
                              controllerCrearMessage.text,
                              campanaProvider.fechaInicioSelectedSisPuntos,
                              campanaProvider.fechaFinSelectedSisPuntos,
                              campanaProvider.selectedFilePathSisPuntos,

                              )
                          .then((_) async {
                        if (campanaProvider.OkpostDatosCrearSisPuntos) {
                          _mostrarFichaCreada(context, '¡Promoción creada!');
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorPalet.secondaryDefault,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: campanaProvider.loadingDatosSisPuntos
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Enviar',
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                _separacionCampos(20),
              ],
            ),
          ),
        ),
      ),
    ]));
  }

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 28, 149, 187),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10), // Ajusta el espacio izquierdo
              Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Text(
                textoMessage,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
              ),
              Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 10), // Ajusta el espacio derecho
            ],
          ),
        ),
      ),
    );
  }

  void _openBottomSheetFechaFinalizacionSisPuntos(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        DateTime _nowDate = DateTime.now();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(15),
              height: 500,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      width: 30,
                      height: 2, // Altura de la línea
                      color: const Color.fromARGB(
                          255, 161, 158, 158), // Color de la línea
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar fecha de finalización',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TableCalendar(
                    //onDaySelected: _onDaySelectedFInicio,
                    onDaySelected: (day, focusedDay) {
                      setState(() {
                        todayFin = day;
                      });
                      _onDaySelectedFin(day, focusedDay, context);
                    },

                    selectedDayPredicate: (day) => isSameDay(day, todayFin),
                    locale: 'es_ES',
                    rowHeight: 43,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      titleTextFormatter:
                          (DateTime focusedDay, dynamic format) {
                        final monthFormat = DateFormat('MMMM', 'es_ES');
                        final monthText = monthFormat.format(focusedDay);
                        final capitalizedMonth =
                            '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                        return '$capitalizedMonth ${focusedDay.year}';
                      },
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: todayFin,
                    firstDay: DateTime.utc(2023, 02, 10),
                    lastDay: DateTime(
                        _nowDate.year + 1,
                        _nowDate.month,
                        _nowDate.day,
                        _nowDate.hour,
                        _nowDate.minute,
                        _nowDate.second),
                    // Resto de las propiedades y personalización del TableCalendar
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        //shape: BoxShape.rectangle,
                        color: const Color.fromARGB(255, 65, 0, 152),
                        borderRadius: BorderRadius.circular(
                            5), // Ajusta el radio según tus preferencias
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color.fromARGB(255, 65, 0, 152),
                          width: 2,
                        ),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 65, 0, 152),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTime todayFin = DateTime.now();

  void _onDaySelectedFin(
      DateTime day, DateTime focusedDay, BuildContext context) {
    CampainProvider dataCampainCodPromo =
        Provider.of<CampainProvider>(context, listen: false);
    setState(() {
      todayFin = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayFin);
      print(formattedDateEnviar);
      dataCampainCodPromo.setFechaFinSelectedSisPuntos(formattedDateEnviar);
    });
  }

  void _openBottomSheetFechaInicioSisPuntos(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        DateTime _nowDate = DateTime.now();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(15),
              height: 500,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      width: 30,
                      height: 2, // Altura de la línea
                      color: const Color.fromARGB(
                          255, 161, 158, 158), // Color de la línea
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar fecha de inicio',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TableCalendar(
                    //onDaySelected: _onDaySelectedFInicio,
                    onDaySelected: (day, focusedDay) {
                      setState(() {
                        todayInicio = day;
                      });
                      _onDaySelectedInicio(day, focusedDay, context);
                    },

                    selectedDayPredicate: (day) => isSameDay(day, todayInicio),
                    locale: 'es_ES',
                    rowHeight: 43,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      titleTextFormatter:
                          (DateTime focusedDay, dynamic format) {
                        final monthFormat = DateFormat('MMMM', 'es_ES');
                        final monthText = monthFormat.format(focusedDay);
                        final capitalizedMonth =
                            '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                        return '$capitalizedMonth ${focusedDay.year}';
                      },
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: todayFin,
                    firstDay: DateTime.utc(2023, 02, 10),
                    lastDay: DateTime(
                        _nowDate.year + 1,
                        _nowDate.month,
                        _nowDate.day,
                        _nowDate.hour,
                        _nowDate.minute,
                        _nowDate.second),
                    // Resto de las propiedades y personalización del TableCalendar
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        //shape: BoxShape.rectangle,
                        color: const Color.fromARGB(255, 65, 0, 152),
                        borderRadius: BorderRadius.circular(
                            5), // Ajusta el radio según tus preferencias
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color.fromARGB(255, 65, 0, 152),
                          width: 2,
                        ),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 65, 0, 152),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTime todayInicio = DateTime.now();

  void _onDaySelectedInicio(
      DateTime day, DateTime focusedDay, BuildContext context) {
    CampainProvider dataCampainCodPromo =
        Provider.of<CampainProvider>(context, listen: false);
    setState(() {
      todayInicio = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayInicio);
      print(formattedDateEnviar);
      dataCampainCodPromo.setFechaInicioSelectedSisPuntos(formattedDateEnviar);
    });
  }

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: ColorPalet.grisesGray0,
          fontSize: 15,
          fontWeight: FontWeight.w500),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }
}
