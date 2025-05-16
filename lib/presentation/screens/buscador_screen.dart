import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/providers/buscador_provider.dart';
import '../widgets/drawer_widget.dart';

class BuscadorScreen extends StatefulWidget {
  BuscadorScreen({super.key});

  @override
  State<BuscadorScreen> createState() => _BuscadorScreenState();
}

class _BuscadorScreenState extends State<BuscadorScreen> {
  final TextEditingController controllerBuscadorGeneral =
      TextEditingController();
  bool isSelectedCliente = false;
  bool isSelectedPaciente = false;
  bool isSelectedProducto = false;

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final dataBuscador = Provider.of<BuscadorProvider>(context);

    // Busca la mascota correspondiente por pacienteId

    //final _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 99, 92, 255),
          leading: Container(
            child: Center(
              child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6B64FF),
                      borderRadius: BorderRadius.circular(10)),
                  //margin: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 12),
                  //padding: EdgeInsets.all(1),
                  child: Builder(builder: (context) {
                    return IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const ImageIcon(
                          AssetImage(
                            'assets/img/menu_icon.png',
                          ),
                          color: Colors.white,
                        ));
                  })),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Buscador',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'sans',
                fontSize: 19,
                fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
        body: Container(
          height: sizeScreen.height,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autofocus: false,
              controller: controllerBuscadorGeneral,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      controllerBuscadorGeneral.clear();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: ColorPalet.grisesGray3,
                    )),
                prefixIcon: const Icon(
                  Iconsax.search_normal_1,
                  color: ColorPalet.primaryDefault,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: ColorPalet.secondaryLight,
                    width: 1.0,
                  ),
                ),
                hintText: 'Prueba con el nombre de un cliente',
                hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 139, 149, 166),
                    fontSize: 15,
                    fontFamily: 'inter'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                fillColor: const Color.fromARGB(220, 249, 249, 249),
                filled: true,
              ),
              onChanged: (query) {
                print(query);
                final listaFiltradaProvider =
                    Provider.of<BuscadorProvider>(context, listen: false);
                listaFiltradaProvider.filtrarListasBuscador(
                    dataBuscador.buscadorGeneral[0].propietarios,
                    dataBuscador.buscadorGeneral[0].pacientes,
                    dataBuscador.buscadorGeneral[0].productos,
                    query);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 5,
              children: [
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorPalet.complementViolet2, // Color del borde
                      width: 1.0, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(40.0), // Radio de borde
                  ),
                  child: InputChip(
                    label: const Text("Clientes"),
                    labelStyle: TextStyle(
                      color: isSelectedCliente
                          ? ColorPalet.secondaryDefault
                          : ColorPalet.grisesGray2,
                      fontFamily: 'inter',
                      fontSize: 12,
                    ),
                    backgroundColor: isSelectedCliente
                        ? ColorPalet.secondaryLight
                        : Colors.white,
                    onSelected: (bool value) {
                      setState(() {
                        isSelectedCliente = value;
                      });
                    },
                    deleteIcon: const Icon(
                      Icons.cancel,
                      color: ColorPalet.secondaryLight,
                    ),
                    onDeleted: isSelectedCliente
                        ? () {
                            setState(() {
                              isSelectedCliente = !isSelectedCliente;
                            });
                          }
                        : null, // Evita mostrar el icono de cierre cuando no está seleccionado
                    selected: isSelectedCliente,
                    selectedColor: Colors.white,
                    showCheckmark: false,
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorPalet.complementViolet2, // Color del borde
                      width: 1.0, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(40.0), // Radio de borde
                  ),
                  child: InputChip(
                    label: const Text("Pacientes"),
                    labelStyle: TextStyle(
                      color: isSelectedPaciente
                          ? ColorPalet.secondaryDefault
                          : ColorPalet.grisesGray2,
                      fontFamily: 'inter',
                      fontSize: 12,
                    ),
                    backgroundColor: isSelectedPaciente
                        ? ColorPalet.secondaryLight
                        : Colors.white,
                    onSelected: (bool value) {
                      setState(() {
                        isSelectedPaciente = value;
                      });
                    },
                    deleteIcon: const Icon(
                      Icons.cancel,
                      color: ColorPalet.secondaryLight,
                    ),
                    onDeleted: isSelectedPaciente
                        ? () {
                            setState(() {
                              isSelectedPaciente = !isSelectedPaciente;
                            });
                          }
                        : null, // Evita mostrar el icono de cierre cuando no está seleccionado
                    selected: isSelectedPaciente,
                    selectedColor: Colors.white,
                    showCheckmark: false,
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorPalet.complementViolet2, // Color del borde
                      width: 1.0, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(40.0), // Radio de borde
                  ),
                  child: InputChip(
                    label: const Text("Productos"),
                    labelStyle: TextStyle(
                      color: isSelectedProducto
                          ? ColorPalet.secondaryDefault
                          : ColorPalet.grisesGray2,
                      fontFamily: 'inter',
                      fontSize: 12,
                    ),
                    backgroundColor: isSelectedProducto
                        ? ColorPalet.secondaryLight
                        : Colors.white,
                    onSelected: (bool value) {
                      setState(() {
                        isSelectedProducto = value;
                      });
                    },
                    deleteIcon: const Icon(
                      Icons.cancel,
                      color: ColorPalet.secondaryLight,
                    ),
                    onDeleted: isSelectedProducto
                        ? () {
                            setState(() {
                              isSelectedProducto = !isSelectedProducto;
                            });
                          }
                        : null, // Evita mostrar el icono de cierre cuando no está seleccionado
                    selected: isSelectedProducto,
                    selectedColor: Colors.white,
                    showCheckmark: false,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: dataBuscador.buscadorGeneral.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalet.acentDefault,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isSelectedCliente
                              ? subTituloText('Clientes')
                              : Container(),
                          isSelectedCliente
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 200,
                                  width: sizeScreen.width,
                                  child: ListView.builder(
                                    itemCount:
                                        controllerBuscadorGeneral.text.isEmpty
                                            ? dataBuscador.buscadorGeneral[0]
                                                .propietarios.length
                                            : dataBuscador
                                                .listaFiltradaClientes.length,
                                    itemBuilder: (context, index) {
                                      final cliente =
                                          controllerBuscadorGeneral.text.isEmpty
                                              ? dataBuscador.buscadorGeneral[0]
                                                  .propietarios[index]
                                              : dataBuscador
                                                  .listaFiltradaClientes[index];

                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 2),
                                        // leading: const CircleAvatar(
                                        //   radius: 25,
                                        //   backgroundImage: AssetImage('assets/img/user.png'),
                                        // ), // Mostrar el ID a la izquierda
                                        leading: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/img/user.png',
                                            image:
                                                '$imagenUrlGlobal${cliente.imagenPropietario}',
                                            fit: BoxFit.cover,
                                            fadeInDuration:
                                                Duration(milliseconds: 200),
                                            fadeInCurve: Curves.easeIn,
                                            alignment: Alignment.topCenter,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        title: Text(cliente.nombreCompleto,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 34, 44),
                                                fontSize: 16,
                                                fontFamily: 'inter',
                                                fontWeight: FontWeight.w600)),
                                        subtitle: Row(children: [
                                          const Icon(
                                            Icons.pets,
                                            color: Color.fromARGB(
                                                255, 139, 149, 166),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              cliente.mascotas
                                                  .map((mascota) =>
                                                      mascota.nombre)
                                                  .join(', '),
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 86, 109),
                                                  fontSize: 14,
                                                  fontFamily: 'inter',
                                                  fontWeight: FontWeight.w500)),
                                        ]),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/perfilCliente',
                                              arguments: cliente.propietarioId);
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          isSelectedPaciente
                              ? subTituloText('Pacientes')
                              : Container(),
                          isSelectedPaciente
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 200,
                                  width: sizeScreen.width,
                                  child: ListView.builder(
                                    itemCount:
                                        controllerBuscadorGeneral.text.isEmpty
                                            ? dataBuscador.buscadorGeneral[0]
                                                .pacientes.length
                                            : dataBuscador
                                                .listaFiltradaPacientes.length,
                                    itemBuilder: (context, index) {
                                      final paciente = controllerBuscadorGeneral
                                              .text.isEmpty
                                          ? dataBuscador.buscadorGeneral[0]
                                              .pacientes[index]
                                          : dataBuscador
                                              .listaFiltradaPacientes[index];

                                      return ListTile(
                                        onTap: () {
                                          print(paciente.mascotaId);
                                          Navigator.pushNamed(
                                              context, '/perfilMascota',
                                              arguments: paciente.mascotaId);
                                        },
                                        contentPadding:
                                            const EdgeInsets.only(left: 2),
                                        // leading: const CircleAvatar(
                                        //   radius: 25,
                                        //   backgroundImage: AssetImage(
                                        //       'assets/img/dogcita.png'),
                                        // ), // Mostrar el ID a la izquierda
                                        leading: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/img/dogcita.png',
                                            image:
                                                '$imagenUrlGlobal${paciente.imagenMascota}',
                                            fit: BoxFit.cover,
                                            fadeInDuration:
                                                Duration(milliseconds: 200),
                                            fadeInCurve: Curves.easeIn,
                                            alignment: Alignment.topCenter,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        title: Text(paciente.nombreMascota,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 34, 44),
                                                fontSize: 16,
                                                fontFamily: 'inter',
                                                fontWeight: FontWeight.w600)),
                                        subtitle: Row(children: [
                                          const Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                                255, 139, 149, 166),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              paciente.propietario[0]
                                                  .nombreCompleto,
                                              style:
                                                  const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 72, 86, 109),
                                                      fontSize: 14,
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ]),
                                      );
                                    },
                                  ))
                              : Container(),
                          isSelectedProducto
                              ? subTituloText('Productos')
                              : Container(),
                          isSelectedProducto
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 200,
                                  width: sizeScreen.width,
                                  child: ListView.builder(
                                    itemCount:
                                        controllerBuscadorGeneral.text.isEmpty
                                            ? dataBuscador.buscadorGeneral[0]
                                                .productos.length
                                            : dataBuscador
                                                .listaFiltradaProductos.length,
                                    itemBuilder: (context, index) {
                                      final product = controllerBuscadorGeneral
                                              .text.isEmpty
                                          ? dataBuscador.buscadorGeneral[0]
                                              .productos[index]
                                          : dataBuscador
                                              .listaFiltradaProductos[index];
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 2),
                                        leading: const ClipRRect(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/img/comida_fondo.png'),
                                          ),
                                        ),
                                        title: Text(
                                            product.nombreProducto ??
                                                'nombre product',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 34, 44),
                                                fontSize: 16,
                                                fontFamily: 'inter',
                                                fontWeight: FontWeight.w600)),
                                        subtitle: Row(children: [
                                          Text(
                                              'Bs. ${product?.precioVentaProducto}',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 86, 109),
                                                  fontSize: 14,
                                                  fontFamily: 'inter',
                                                  fontWeight: FontWeight.w500)),
                                        ]),
                                        onTap: () {},
                                      );
                                    },
                                  ))
                              : Container(),
                          const SizedBox(height: 25)
                        ],
                      ),
                    ),
            )
          ]),
        ),
      ),
    );
  }

  Container subTituloText(String titulo) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Text(
        titulo,
        style: const TextStyle(
            fontFamily: 'sans',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorPalet.grisesGray2),
      ),
    );
  }
}
