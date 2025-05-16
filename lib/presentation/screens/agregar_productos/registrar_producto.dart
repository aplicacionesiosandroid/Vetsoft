import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/presentation/widgets/agregar_productos/Form_step_one_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/agregar_productos/form_step_three_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/agregar_productos/form_step_two_widget.dart';

import '../../../config/global/palet_colors.dart';

class RegistrarProductosScreen extends StatefulWidget {
  @override
  _RegistrarProductosScreen createState() => _RegistrarProductosScreen();
}

class _RegistrarProductosScreen extends State<RegistrarProductosScreen> {
  //controller para formularios proveedor
  final TextEditingController controllerNombreProveedor =
      TextEditingController();

  final TextEditingController controllerNumContacto = TextEditingController();

  final TextEditingController controllerNumFactura = TextEditingController();

  final TextEditingController controllerNotaEmision = TextEditingController();

  final TextEditingController controllerObservacion = TextEditingController();

  //controller para 1er form productos
  final TextEditingController controllerNombreProducto =
      TextEditingController();

  final TextEditingController controllerAbreviatura = TextEditingController();
  final TextEditingController controllerNombreUnidad = TextEditingController();

  //controller para 2do form productos
  final TextEditingController controllerCodProducto = TextEditingController();
  final TextEditingController controllerCodBarras = TextEditingController();
  final TextEditingController controllerDescripProducto =
      TextEditingController();
  final TextEditingController controllerStockTotal = TextEditingController();
  final TextEditingController controllerStockMinimo = TextEditingController();
  final TextEditingController controllerPrecioUnidad = TextEditingController();
  final TextEditingController controllerPrecioVenta = TextEditingController();
  final TextEditingController controllerPuntosProducto =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registroModel =
        Provider.of<RegistroModel>(context); // Obtén RegistroModel aquí
    final registroClienteModel = Provider.of<RegistroClienteModel>(context);
    Size sizeScreen = MediaQuery.of(context).size;
    ScrollController _scrollController = ScrollController();

    Widget currentForm;

    switch (registroModel.currentForm) {
      // Accede a currentForm desde RegistroModel
      case FormType.register:
        // WidgetsBinding.instance?.addPostFrameCallback((_) {
        //   _scrollController.animateTo(
        //     0.0, // Desplaza al principio del formulario actual
        //     duration: Duration(milliseconds: 200), // Duración de la animación
        //     curve: Curves.easeInOut, // Curva de la animación
        //   );
        // });
        currentForm = FormStepOneWidget(
            registroModel: registroModel,
            registroClienteModel: registroClienteModel,
            sizeScreen: sizeScreen,
            controllerNombreProveedor: controllerNombreProveedor,
            controllerNumContacto: controllerNumContacto,
            controllerNumFactura: controllerNumFactura,
            controllerNotaEmision: controllerNotaEmision,
            controllerObservacion: controllerObservacion);
        break;
      case FormType.payMethod:
        // WidgetsBinding.instance?.addPostFrameCallback((_) {
        //   _scrollController.animateTo(
        //     0.0, // Desplaza al principio del formulario actual
        //     duration: Duration(milliseconds: 200), // Duración de la animación
        //     curve: Curves.easeInOut, // Curva de la animación
        //   );
        // });
        currentForm = FormStepTwoWidget(
            registroModel: registroModel,
            controllerNombreProducto: controllerNombreProducto,
            controllerAbreviatura: controllerAbreviatura,
            controllerNombreUnidad: controllerNombreUnidad);

        break;
      case FormType.order:
        // WidgetsBinding.instance?.addPostFrameCallback((_) {
        //   _scrollController.animateTo(
        //     0.0, // Desplaza al principio del formulario actual
        //     duration: Duration(milliseconds: 200), // Duración de la animación
        //     curve: Curves.easeInOut, // Curva de la animación
        //   );
        // });
        currentForm = FormStepThreeWidget(
            size: sizeScreen,
            registroModel: registroModel,
            controllerNombreProveedor: controllerNombreProveedor,
            controllerNumContacto: controllerNumContacto,
            controllerNumFactura: controllerNumFactura,
            controllerNotaEmision: controllerNotaEmision,
            controllerObservacion: controllerObservacion,
            controllerNombreProducto: controllerNombreProducto,
            controllerAbreviatura: controllerAbreviatura,
            controllerNombreUnidad: controllerNombreUnidad,
            controllerCodProducto: controllerCodProducto,
            controllerCodBarras: controllerCodBarras,
            controllerDescripProducto: controllerDescripProducto,
            controllerStockTotal: controllerStockTotal,
            controllerStockMinimo: controllerStockMinimo,
            controllerPrecioUnidad: controllerPrecioUnidad,
            controllerPrecioVenta: controllerPrecioVenta,
            controllerPuntosProducto: controllerPuntosProducto);
        break;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPalet.backGroundColor,
        body: Column(
          children: [
            Container(
              height: sizeScreen.height * 0.03,
              decoration: const BoxDecoration(
                color: ColorPalet.secondaryDefault,
              ),
            ),
            Container(
              color: ColorPalet.secondaryDefault,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorPalet.backGroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            registroModel.irAlPrimerForm();
                          },
                          icon: const Icon(Icons.arrow_back_outlined),
                        ),
                        const Text(
                          "Registro de Productos",
                          style: TextStyle(
                            fontFamily: 'sans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Barra de progreso con 3 pasos
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0), // Espaciado arriba
                        child: Text(
                          'Paso ${registroModel.currentForm.index + 1} de 3',
                          style: const TextStyle(
                            fontSize: 16, // Tamaño del texto
                            color: Colors
                                .black, // Cambia el color según tu preferencia
                          ),
                        ),
                      ),
                    ),
                    // Barra de progreso con 3 pasos
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20), // Bordes redondeados
                          child: LinearProgressIndicator(
                            minHeight: 12,
                            value: (registroModel.currentForm.index + 1) / 3,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorPalet.secondaryDefault),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: currentForm,
                    ))),
          ],
        ),
      ),
    );
  }
}
