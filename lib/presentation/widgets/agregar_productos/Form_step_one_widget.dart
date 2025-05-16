import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/common/views/buttons_widget.dart';
import 'package:vet_sotf_app/common/views/modals_widget.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/productos/productos_provider.dart';

import '../../../config/global/palet_colors.dart';
import 'radio_reutilizable_proveedor.dart';

class FormStepOneWidget extends StatefulWidget {
  FormStepOneWidget({
    super.key,
    required this.registroModel,
    required this.registroClienteModel,
    required this.sizeScreen,
    required this.controllerNumContacto,
    required this.controllerNumFactura,
    required this.controllerNotaEmision,
    required this.controllerObservacion,
    required this.controllerNombreProveedor,
  });

  final RegistroModel registroModel;
  final RegistroClienteModel registroClienteModel;
  final Size sizeScreen;
  final TextEditingController controllerNombreProveedor;
  final TextEditingController controllerNumContacto;
  final TextEditingController controllerNumFactura;
  final TextEditingController controllerNotaEmision;
  final TextEditingController controllerObservacion;

  @override
  State<FormStepOneWidget> createState() => _FormStepOneWidgetState();
}

class _FormStepOneWidgetState extends State<FormStepOneWidget> {
  final _formKeyDistribuidor = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProducto =
          Provider.of<ProductosProvider>(context, listen: false);
      dataProducto
          .setFechaCompra(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProducto = Provider.of<ProductosProvider>(context);
    return Form(
      key: _formKeyDistribuidor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Datos del distribuidor",
            style: TextStyle(
              fontFamily: 'sans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          RadioButtonReutilizableProveedor(
            gender: 'Registrar proveedor',
            valor: 'true',
          ),
          RadioButtonReutilizableProveedor(
            gender: 'Seleccionar proveedor',
            valor: 'false',
          ),
          const SizedBox(height: 30),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "Nombre",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 5),
          dataProducto.selectedProveedor == 'true'
              ? TextFormFieldConHintValidator(
                  controller: widget.controllerNombreProveedor,
                  hintText: 'Nombre',
                  colores: ColorPalet.secondaryLight)
              : SizedBox(
                  width: widget.sizeScreen.width,
                  height: widget.sizeScreen.height * 0.07,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorPalet.grisesGray4,
                        borderRadius: BorderRadius.circular(19)),
                    child: Text(
                      dataProducto.proveedorSeleccionadoActualNombre ?? '',
                      style: const TextStyle(
                          color: ColorPalet.grisesGray2,
                          fontFamily: 'inter',
                          fontSize: 16),
                    ),
                  )),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "Número de contacto",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: widget.sizeScreen.width * 0.45,
                    child: TextFormFieldConHintValidator(
                        controller: widget.controllerNumContacto,
                        hintText: 'Numero',
                        colores: ColorPalet.secondaryLight),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "Fecha de compra",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 5),
                  SizedBox(
                      width: widget.sizeScreen.width * 0.42,
                      height: widget.sizeScreen.height * 0.07,
                      child: InkWell(
                        onTap: () {
                          _openBottomSheetFechaCompra(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorPalet.backGroundColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              dataProducto.fechaCompra,
                              style: const TextStyle(
                                  color: ColorPalet.grisesGray2,
                                  fontFamily: 'inter',
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "Número de Factura",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: widget.sizeScreen.width * 0.45,
                    child: TextFormFieldNumberConHint(
                        controller: widget.controllerNumFactura,
                        hintText: 'N. Factura',
                        colores: ColorPalet.secondaryLight),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "Nota de emisión",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 5),
                  SizedBox(
                      width: widget.sizeScreen.width * 0.42,
                      child: TextFormFieldConHint(
                          controller: widget.controllerNotaEmision,
                          hintText: '(opcional)',
                          colores: ColorPalet.secondaryLight)),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "Observación",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 5),
          TextFormFieldMaxLinesConHint(
            controller: widget.controllerObservacion,
            hintText: '',
            colores: ColorPalet.secondaryLight,
            maxLines: 4,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              if (dataProducto.selectedProveedor != 'true' ||
                  _formKeyDistribuidor.currentState!.validate()) {
                widget.registroModel.goToNextForm();
              }
            },
            text: "Siguiente",
            height: 40,
            width: widget.sizeScreen.width,
            backgroundColor: ColorPalet.secondaryDefault,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _openBottomSheetFechaCompra(BuildContext context) {
    CustomBottomSheetModal(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccionar fecha de compra',
                      style: TextStyle(
                          color: Color.fromARGB(255, 29, 34, 44),
                          fontFamily: 'sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CalendarioFormulario(
                  focusedDay: todayCompra,
                  firstDay: DateTime.utc(2023, 02, 10),
                  lastDay: DateTime.utc(2030, 02, 10),
                  onDaySelected: (day, focusedDay) {
                    setState(() {
                      todayCompra = day;
                    });
                    _onDaySelectedFCompra(day, focusedDay, context);
                  },
                  selectedDayPredicate: (day) => isSameDay(day, todayCompra),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DateTime todayCompra = DateTime.now();

  void _onDaySelectedFCompra(
      DateTime day, DateTime focusedDay, BuildContext context) {
    ProductosProvider dataProductos =
        Provider.of<ProductosProvider>(context, listen: false);
    setState(() {
      todayCompra = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayCompra);
      print(formattedDateEnviar);
      dataProductos.setFechaCompra(formattedDateEnviar);
    });
  }

  _separacionCampos(double num) {
    return SizedBox(
      height: num,
    );
  }
}
