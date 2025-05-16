import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/agregar_productos/productos/dropdowns_mode.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/productos/productos_provider.dart';
import 'package:http/http.dart' as http;

class AlmacenBottomSheet extends StatefulWidget {
  final Size size;

  const AlmacenBottomSheet({Key? key, required this.size}) : super(key: key);

  @override
  _AlmacenBottomSheetState createState() => _AlmacenBottomSheetState();
}

class _AlmacenBottomSheetState extends State<AlmacenBottomSheet> {
  final _formKeyAlmacen = GlobalKey<FormState>();
  final TextEditingController controllerNombreAlmacen = TextEditingController();
  final TextEditingController controllerDescripcion = TextEditingController();

  final String _urlBase = apiUrlGlobal;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    controllerNombreAlmacen.dispose();
    controllerDescripcion.dispose();
    super.dispose();
  }

  Future<void> _enviarDatos(BuildContext context) async {
    final productosProvider =
        Provider.of<ProductosProvider>(context, listen: false);
    final url = Uri.parse('${_urlBase}petshop/crear-almacen');

    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Map<String, String> datos = {
      "nombre": controllerNombreAlmacen.text,
      "descripcion": controllerDescripcion.text,
      "responsables": productosProvider.selectedParticipantsMap.keys
          .join(","), // Convierte IDs en string
    };
    print("DATOS ENVIADOS A ALMACEN >>>" + jsonEncode(datos));
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(datos),
      );

      if (response.statusCode == 200) {
        print("Almacén creado correctamente. ${response.body}");
        // productosProvider.almacenes.add(
        //     new Almacene(alamcenId: 0, nombre: controllerNombreAlmacen.text));
        productosProvider.getDropdownData();
        // productosProvider.notifyListeners();
        Navigator.of(context).pop();
      } else {
        print("Error al crear el almacén: ${response.body}");
      }
    } catch (e) {
      print("Error en la petición: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProductos = Provider.of<ProductosProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(),
            _buildForm(dataProductos),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Asegura alineación a la izquierda

      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 30,
            height: 2,
            color: const Color.fromARGB(255, 161, 158, 158),
          ),
        ),
        const Text(
          'Añadir un Almacén',
          style: TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontFamily: 'sans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildForm(ProductosProvider dataProductos) {
    return Form(
      key: _formKeyAlmacen,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Asegura alineación a la izquierda

        children: [
          TextFormFieldConHintValidator(
            controller: controllerNombreAlmacen,
            hintText: 'Nombre',
            colores: ColorPalet.secondaryDefault,
          ),
          const SizedBox(height: 20),
          TextFormFieldConHintValidator(
            controller: controllerDescripcion,
            hintText: 'Descripción',
            colores: ColorPalet.secondaryDefault,
          ),
          const SizedBox(height: 20),
          _NombreCampos('Participantes'),
          const SizedBox(height: 20),
          _buildParticipantsRow(dataProductos),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildParticipantsRow(ProductosProvider dataProductos) {
    return Row(
      children: [
        const Icon(IconlyLight.user_1,
            color: Color.fromARGB(255, 139, 149, 166), size: 28),
        const SizedBox(width: 15),
        if (dataProductos.selectedParticipantsMap.isNotEmpty)
          _buildParticipantsImages(dataProductos),
        InkWell(
          onTap: () async {
            await dataProductos.getParticipantesTareas();
            openBottomSheetParticipantesTareas(
              dataProductos,
              // ignore: use_build_context_synchronously
              context,
              dataProductos.getParticipantesTarea,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Color.fromARGB(255, 218, 223, 230),
                width: 2,
              ),
            ),
            child: const Icon(Icons.add,
                color: Color.fromARGB(255, 139, 149, 166), size: 25),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsImages(ProductosProvider dataProductos) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            dataProductos.selectedParticipantsMap.length,
            (index) => Padding(
              padding:
                  const EdgeInsets.only(right: 5.0), // Espacio entre imágenes
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3.0),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 45,
                height: 45,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/icon/logovs.png',
                    image:
                        '$imagenUrlGlobal${dataProductos.selectedParticipantsMap.values.elementAt(index)}',
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeInCurve: Curves.easeIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.size.height * 0.06,
          width: widget.size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorPalet.secondaryDefault),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              if (_formKeyAlmacen.currentState!.validate()) {
                // Navigator.of(context).pop();
                _enviarDatos(context);
              }
            },
            child: const Text("Agregar"),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: widget.size.height * 0.06,
          width: widget.size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  ColorPalet.secondaryDefault.withAlpha(50)),
              backgroundColor:
                  MaterialStateProperty.all(ColorPalet.grisesGray5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: const BorderSide(color: ColorPalet.secondaryDefault),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              controllerNombreAlmacen.clear();
              controllerDescripcion.clear();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(color: ColorPalet.secondaryDefault),
            ),
          ),
        ),
      ],
    );
  }
}

Text _NombreCampos(String texto) {
  return Text(
    texto,
    textAlign: TextAlign.left,
    style: TextStyle(
        color: Color.fromARGB(255, 72, 86, 109),
        fontSize: 15,
        fontWeight: FontWeight.w500),
  );
}

void openBottomSheetParticipantesTareas(ProductosProvider dataTareas,
    BuildContext context, List<ParticipanteTarea> listaParticipantes) {
  final sizeWidth = MediaQuery.of(context).size.width;
  final TextEditingController controllerBusquedaPartici =
      TextEditingController();
  showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 30,
                  height: 2, // Altura de la línea
                  color: const Color.fromARGB(
                      255, 161, 158, 158), // Color de la línea
                ),
              ),
              SizedBox(
                width: sizeWidth,
                child: Row(
                  children: [
                    const Text('Participantes',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontSize: 16,
                            fontFamily: 'sans',
                            fontWeight: FontWeight.w700)),
                    Consumer<ProductosProvider>(
                      builder: (context, dataTareas, child) {
                        return Text(
                            ' (${dataTareas.selectedParticipantsMap.length})',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 177, 173, 255),
                                fontSize: 16,
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700));
                      },
                    ),
                  ],
                ),
              ),
              _separacionCampos(10),
              TextFormField(
                controller: controllerBusquedaPartici,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controllerBusquedaPartici.clear();
                    },
                    child: const Icon(Icons.clear_rounded),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 177, 173, 255),
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Nombre del cliente o paciente',
                  hintStyle: const TextStyle(
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
                      Provider.of<ProductosProvider>(context, listen: false);
                  listaFiltradaProvider.filtrarListaParticipante(
                      listaParticipantes, query);
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: controllerBusquedaPartici.text.isEmpty
                    ? Consumer<ProductosProvider>(
                        builder: (context, provider, child) {
                          final listaParticipantesss =
                              provider.getParticipantesTarea;
                          return ListView.builder(
                            itemCount: listaParticipantesss.length,
                            itemBuilder: (BuildContext context, int index) {
                              final participante = listaParticipantesss[index];
                              final isSelected = provider
                                  .isSelectedMap(participante.encargadoId);

                              return ListTile(
                                leading: FadeInImage.assetNetwork(
                                  placeholder: 'assets/icon/logovs.png',
                                  image:
                                      '$imagenUrlGlobal${participante.imgUser}',
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration(milliseconds: 200),
                                  fadeInCurve: Curves.easeIn,
                                ),
                                title: Text(
                                  participante.nombres,
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
                                  participante.itemName.toLowerCase(),
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
                                    ? const Icon(Icons.check,
                                        color: Color.fromARGB(255, 99, 92, 255))
                                    : null,
                                onTap: () {
                                  provider.toggleSelectionMap(
                                      participante.encargadoId,
                                      participante.imgUser);
                                  provider.selectedParticipantsMap
                                      .forEach((participantId, rutaImage) {
                                    print(
                                        'participantId: $participantId, rutaImage: $rutaImage');
                                  });
                                },
                              );
                            },
                          );
                        },
                      )
                    : dataTareas.listaFiltradaParticipante.isEmpty
                        ? Center(
                            child: Column(
                            children: [
                              Image.asset('assets/img/noresults.png'),
                              const Text(
                                'Oops, parece que no hay resultados.',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'sans',
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 29, 34, 44)),
                              ),
                              const Expanded(
                                child: Text(
                                  'No te desanimes, prueba con otra palabra clave o criterio de búsqueda.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color.fromARGB(255, 139, 149, 166)),
                                ),
                              )
                            ],
                          ))
                        : Consumer<ProductosProvider>(
                            builder: (context, provider, child) {
                              final listaFiltradaParticipante =
                                  provider.listaFiltradaParticipante;
                              return ListView.builder(
                                itemCount: listaFiltradaParticipante.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final participante =
                                      listaFiltradaParticipante[index];
                                  final isSelected = provider
                                      .isSelectedMap(participante.encargadoId);

                                  return ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/img/user.png'),
                                    ),
                                    title: Text(
                                      participante.nombres,
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
                                      participante.itemName.toLowerCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w400,
                                        color: isSelected
                                            ? const Color.fromARGB(
                                                255, 139, 149, 166)
                                            : null,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check,
                                            color: Color.fromARGB(
                                                255, 99, 92, 255))
                                        : null,
                                    onTap: () {
                                      provider.toggleSelectionMap(
                                          participante.encargadoId,
                                          participante.itemName);
                                    },
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _separacionCampos(double valor) {
  return SizedBox(
    height: valor,
  );
}
