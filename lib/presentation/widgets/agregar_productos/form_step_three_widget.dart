import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/agregar_productos/agregar_almacen.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/campanas/campain_provider.dart';
import 'package:vet_sotf_app/providers/productos/productos_provider.dart';

import '../../../config/global/palet_colors.dart';
import '../../../models/petshop/registroCompra/registration_pay_model.dart';

class FormStepThreeWidget extends StatefulWidget {
  const FormStepThreeWidget({
    super.key,
    required this.size,
    required this.registroModel,
    required this.controllerCodProducto,
    required this.controllerCodBarras,
    required this.controllerDescripProducto,
    required this.controllerStockTotal,
    required this.controllerStockMinimo,
    required this.controllerPrecioUnidad,
    required this.controllerPrecioVenta,
    required this.controllerPuntosProducto,
    required this.controllerNombreProducto,
    required this.controllerAbreviatura,
    required this.controllerNombreUnidad,
    required this.controllerNombreProveedor,
    required this.controllerNumContacto,
    required this.controllerNumFactura,
    required this.controllerNotaEmision,
    required this.controllerObservacion,
  });

  final Size size;
  final RegistroModel registroModel;

  final TextEditingController controllerNombreProveedor;
  final TextEditingController controllerNumContacto;
  final TextEditingController controllerNumFactura;
  final TextEditingController controllerNotaEmision;
  final TextEditingController controllerObservacion;

  final TextEditingController controllerNombreProducto;
  final TextEditingController controllerAbreviatura;
  final TextEditingController controllerNombreUnidad;

  final TextEditingController controllerCodProducto;
  final TextEditingController controllerCodBarras;
  final TextEditingController controllerDescripProducto;
  final TextEditingController controllerStockTotal;
  final TextEditingController controllerStockMinimo;
  final TextEditingController controllerPrecioUnidad;
  final TextEditingController controllerPrecioVenta;
  final TextEditingController controllerPuntosProducto;

  @override
  State<FormStepThreeWidget> createState() => _FormStepThreeWidgetState();
}

class _FormStepThreeWidgetState extends State<FormStepThreeWidget> {
  @override
  Widget build(BuildContext context) {
    final dataProductos = Provider.of<ProductosProvider>(context);
    final sizeScreen = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: dataProductos.switchValueAgreeCodProducto,
              onChanged: (value) {
                dataProductos.setSwitchValueAgreeCodProducto = value;
              },
              activeColor: ColorPalet.secondaryDefault,
            ),
            SizedBox(
              width: 10,
            ),
            _NombreCampos('Agregar código de producto'),
          ],
        ),
        const SizedBox(height: 10),
        if (dataProductos.switchValueAgreeCodProducto)
          TextFormFieldConHint(
              controller: widget.controllerCodProducto,
              hintText: 'ej. 827 822 9912',
              colores: ColorPalet.secondaryLight),
        const SizedBox(height: 20),
        Row(
          children: [
            Switch(
              value: dataProductos.switchValueAgreeCodBarras,
              onChanged: (value) {
                dataProductos.setSwitchValueAgreeCodBarras = value;
              },
              activeColor: ColorPalet.secondaryDefault,
            ),
            SizedBox(
              width: 10,
            ),
            _NombreCampos('Agregar código de barra'),
          ],
        ),
        const SizedBox(height: 5),
        if (dataProductos.switchValueAgreeCodBarras)
          TextFormFieldConHint(
              controller: widget.controllerCodBarras,
              hintText: 'Codigo de barra.',
              colores: ColorPalet.secondaryLight),
        const SizedBox(height: 20),
        const Text(
          "Agregar Descripcion",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormFieldConHint(
            controller: widget.controllerDescripProducto,
            hintText: 'Desc.',
            colores: ColorPalet.secondaryLight),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Stock Total",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormFieldNumberConHint(
            controller: widget.controllerStockTotal,
            hintText: 'Total',
            colores: ColorPalet.secondaryLight),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Stock Minimo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormFieldNumberConHint(
            controller: widget.controllerStockMinimo,
            hintText: 'Minimo',
            colores: ColorPalet.secondaryLight),
        const SizedBox(
          height: 20,
        ),
        const Text("Ubicación del almacén"),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: Consumer<ProductosProvider>(
            builder: (context, provider, child) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: provider.almacenes.map((alamacen) {
                  return RadioListTile<int>(
                    activeColor: ColorPalet.secondaryDefault,
                    title: Text(alamacen.nombre),
                    value: alamacen.alamcenId,
                    groupValue: provider.selectedAlmacenId,
                    onChanged: (int? selectedValue) {
                      // Actualizar el valor seleccionado en el proveedor
                      provider.updateSelectedAlmacen(selectedValue);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        TextButton.icon(
            onPressed: () {
              // _openBottomSheetRegistrarAlmacen(
              //     context, sizeScreen, dataProductos);
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) => AlmacenBottomSheet(size: sizeScreen),
              );
            },
            icon: const Icon(
              Icons.add,
              color: ColorPalet.secondaryDefault,
            ),
            label: Text(
              "Nuevo",
              style: TextStyle(
                color: ColorPalet.secondaryDefault,
              ),
            )),
        const Text(
          "Precio de Compra por Unidad",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 60,
              width: widget.size.width * 0.28,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 249, 249, 249)),
              child: const Row(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/img/bolivia.png',
                    ),
                    width: 35,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'BOL',
                    style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 14,
                        color: const Color.fromARGB(255, 139, 149, 166)),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined,
                      color: const Color.fromARGB(255, 139, 149, 166))
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
                width: widget.size.width * 0.62,
                child: TextFormFieldNumberConHint(
                    controller: widget.controllerPrecioUnidad,
                    hintText: '',
                    colores: ColorPalet.secondaryLight)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Precio de Venta por Unidad",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 60,
              width: widget.size.width * 0.28,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 249, 249, 249)),
              child: const Row(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/img/bolivia.png',
                    ),
                    width: 35,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'BOL',
                    style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 14,
                        color: const Color.fromARGB(255, 139, 149, 166)),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined,
                      color: const Color.fromARGB(255, 139, 149, 166))
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
                width: widget.size.width * 0.62,
                child: TextFormFieldNumberConHint(
                    controller: widget.controllerPrecioVenta,
                    hintText: '',
                    colores: ColorPalet.secondaryLight)),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Puntos por producto",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormFieldNumberConHint(
            controller: widget.controllerPuntosProducto,
            hintText: '0',
            colores: ColorPalet.secondaryLight),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Agregar imagen del producto",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (dataProductos.imageFileList.isNotEmpty)
          SizedBox(child: Consumer<ProductosProvider>(
            builder: (context, imageprovider, child) {
              return SizedBox(
                height: 250,
                width: sizeScreen.width,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: imageprovider.imageFileList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 300,
                      width: 150,
                      child: Card(
                        elevation: 0,
                        color: Color.fromARGB(230, 249, 249, 249),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none),
                        child: InkWell(
                          child: Image.file(
                            File(imageprovider.imageFileList[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _showImagePickerDialog(context),
          child: Container(
            width: sizeScreen.width * 0.4, // Ancho del botón
            height: sizeScreen.height * 0.17, // Alto del botón
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: ColorPalet.secondaryDefault,
                width: 2,
              ), // Bordes redondeados
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add, // Icono de más para agregar
                  size: 40,
                  color: ColorPalet.secondaryDefault,
                ),
                SizedBox(height: 10),
                Text(
                  'Agregar Foto',
                  style: TextStyle(
                    color: ColorPalet.secondaryDefault,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
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
              print('aquiiiiiiii imagenessssssss');
              String registrarUnidad = 'false';
              if (widget.controllerNombreUnidad.text != '' &&
                  dataProductos.selectedUnidadMedidaId == null) {
                registrarUnidad = 'true';
              } else {
                widget.controllerNombreUnidad.text =
                    dataProductos.unidadSeleccionada?.unidad ?? '';
                widget.controllerAbreviatura.text =
                    dataProductos.unidadSeleccionada?.abreviatura ?? '';
              }
              dataProductos
                  .enviarDatosCrearProducto(
                      dataProductos.selectedProveedor == 'true'
                          ? '0'
                          : dataProductos.proveedorSeleccionadoActual
                              .toString(),
                      widget.controllerNombreProveedor.text,
                      widget.controllerNumContacto.text,
                      dataProductos.fechaCompra,
                      widget.controllerNumFactura.text,
                      widget.controllerNotaEmision.text,
                      widget.controllerObservacion.text,
                      dataProductos.selectedGroupId.toString(),
                      dataProductos.selectedSubGroupId.toString(),
                      dataProductos.selectedMarcaId.toString(),
                      //falta variable si se registra o no una Unidad(),
                      // 'true',
                      registrarUnidad,
                      widget.controllerNombreUnidad.text,
                      widget.controllerAbreviatura.text,
                      dataProductos.switchValueAgreeCodProducto.toString(),
                      widget.controllerCodProducto.text,
                      dataProductos.switchValueAgreeCodBarras.toString(),
                      widget.controllerCodBarras.text,
                      widget.controllerDescripProducto.text,
                      widget.controllerStockTotal.text,
                      widget.controllerStockMinimo.text,
                      dataProductos.selectedAlmacenId.toString(),
                      widget.controllerPrecioUnidad.text,
                      widget.controllerPrecioVenta.text,
                      widget.controllerPuntosProducto.text,
                      dataProductos.imageFileList,
                      dataProductos.fechaVencimiento,
                      widget.controllerNombreProducto.text)
                  .then((_) async {
                if (dataProductos.okpostDatosPostProducto) {
                  _mostrarFichaCreada(context);
                  dataProductos.getDropdownData();
                }
              });
            },
            child: dataProductos.loadingDatosPostProducto
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
                : const Text(
                    'Agregar al inventario',
                    style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
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
              widget.registroModel.goToPreviousForm();
            },
            child: const Text(
              "Anterior",
              style: TextStyle(color: ColorPalet.secondaryDefault),
            ),
          ),
        ),
        // Agregar_imagen_widget(),
      ],
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar Fuente de Imagen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Cámara'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    Provider.of<ProductosProvider>(context, listen: false)
                        .addPhoto(ImageSource.camera);
                    // _getImageFromSource(context, ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Galería'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    Provider.of<ProductosProvider>(context, listen: false)
                        .addPhoto(ImageSource.gallery);
                    //_getImageFromSource(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*  void _getImageFromSource(BuildContext context, ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    Provider.of<ProductosProvider>(context, listen: false)
        .addImage(pickedFile.path as List<String>);
  } */

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

  //mensaje de confirmacion
  void _mostrarFichaCreada(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            '¡Registro creado con éxito!',
            style: TextStyle(
                color: const Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 20),
            textAlign: TextAlign.justify,
          ),
          content: SizedBox(
            height: 350,
            child: Column(
              children: [
                Image(
                    height: 220,
                    width: 200,
                    image: AssetImage('assets/img/done.png')),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Los datos del nuevo paciente y la información de la consulta se han guardado con éxito.',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 72, 86, 109),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<RegistroModel>(context, listen: false)
                            .iniciaForm();
                        // Cerrar el AlertDialog
                        Navigator.of(context).pop();
                        //cierra bottomSheet
                        Navigator.of(context).pop();
                        Provider.of<CampainProvider>(context, listen: false)
                            .getTodosProductos();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
