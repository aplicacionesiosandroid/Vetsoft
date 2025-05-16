// lib/datos_facturacion.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class DatosFacturacion<T> extends StatefulWidget {
  final T providerGenerico;
  final double sizeScreenWidth;
  final List<Widget> radioButtons;
  final TextEditingController controllerCIoNit;
  final TextEditingController controllerNombreFactura;
  final TextEditingController controllerApellidoFactura;
  final TextEditingController controllerMontoEfectivo;
  final TextEditingController controllerCodeDescuento;
  final String? tipoServicio;

  DatosFacturacion({
    Key? key,
    required this.providerGenerico,
    required this.sizeScreenWidth,
    required this.radioButtons,
    required this.controllerCIoNit,
    required this.controllerNombreFactura,
    required this.controllerApellidoFactura,
    required this.controllerMontoEfectivo,
    required this.controllerCodeDescuento,
    required this.tipoServicio,
  }) : super(key: key);

  @override
  _DatosFacturacionState createState() => _DatosFacturacionState<T>();
}

class _DatosFacturacionState<T> extends State<DatosFacturacion> {
  Future<String> obtieneCodigoPromocion(String codigo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlBase = apiUrlGlobal;
    String descuento = '0';
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    final response = await http.get(
      Uri.parse(
          '${urlBase}promociones/codigo-promocion?codigo=$codigo&tipo=${widget.tipoServicio}'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print('Respuesta de la API para codigo de descuento: $resp');
      print('url codigo descuento:' +
          '${urlBase}promociones/codigo-promocion?codigo=$codigo&tipo=${widget.tipoServicio}');
      descuento = resp['data'][0]['porcentaje_descuento'].toString();
    } else {
      throw Exception(
          'Error al obtener los datos de la API para codigo de descuento');
    }

    print('Descuento: $descuento'); // Imprimir el descuento obtenido

    return descuento;
  }

  Future<void> scanQrConsulta() async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      if (qrScanRes == '-1') {
        widget.controllerCodeDescuento.text = '0';
      } else {
        widget.controllerCodeDescuento.text = qrScanRes;
        String porcentajeDescuento = await obtieneCodigoPromocion(qrScanRes);
        print('Porcentaje de descuento: $porcentajeDescuento');
        double montoEfectivo =
            double.tryParse(widget.controllerMontoEfectivo.text) ?? 0.0;
        double descuento = double.tryParse(porcentajeDescuento) ?? 0.0;
        double total = montoEfectivo - (montoEfectivo * (descuento / 100));
        widget.providerGenerico.setTotalACobrarFacturacion = total.toString();
      }
    } on PlatformException {
      qrScanRes = 'failed scan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloForm('Método de pago'),
            _separacionCampos(20),
            Row(children: widget.radioButtons),
            _separacionCampos(20),
            _NombreCampos('NIT o CI'),
            _separacionCampos(15),
            TextFormFieldConHint(
              controller: widget.controllerCIoNit,
              hintText: 'Numero de NIT',
              colores: ColorPalet.secondaryLight,
            ),
            _separacionCampos(20),
            _NombreCampos('Nombre'),
            _separacionCampos(15),
            TextFormFieldConHint(
              controller: widget.controllerNombreFactura,
              hintText: 'Nombre',
              colores: ColorPalet.secondaryLight,
            ),
            _separacionCampos(20),
            _NombreCampos('Apellido'),
            _separacionCampos(15),
            TextFormFieldConHint(
              controller: widget.controllerApellidoFactura,
              hintText: 'Apellido',
              colores: ColorPalet.secondaryLight,
            ),
            _separacionCampos(20),
            Row(
              children: [
                Switch(
                  value: widget.providerGenerico.switchValueFacturacion,
                  onChanged: (value) {
                    widget.providerGenerico.setSwitchValueFacturacion = value;
                  },
                  activeColor: ColorPalet.secondaryLight,
                ),
                SizedBox(
                  width: 10,
                ),
                _NombreCampos('Guardar Datos de Facturación'),
              ],
            ),
            _separacionCampos(20),
            _NombreCampos('Ingresar Monto en Efectivo'),
            _separacionCampos(15),
            Row(
              children: [
                Container(
                  height: 60,
                  width: widget.sizeScreenWidth * 0.3,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 249, 249, 249),
                  ),
                  child: Row(
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
                          color: const Color.fromARGB(255, 139, 149, 166),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_outlined,
                          color: const Color.fromARGB(255, 139, 149, 166))
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextFormFieldNumberConHintValidator(
                    colores: ColorPalet.secondaryLight,
                    controller: widget.controllerMontoEfectivo,
                    hintText: 'Bs. 0.00',
                  ),
                ),
              ],
            ),
            //TODO realizar el calculo del descuento
            // _separacionCampos(20),
            // Row(
            //   children: [
            //     _NombreCampos('Cambio'),
            //     Spacer(),
            //     _NombreCampos('90.00 Bs'),
            //   ],
            // ),
            _separacionCampos(20),
            _NombreCampos('Código de descuento'),
            _separacionCampos(15),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextFormFieldConHint(
                      controller: widget.controllerCodeDescuento,
                      hintText: '(Ej: 43221)',
                      colores: ColorPalet.secondaryLight,
                      enabled: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        scanQrConsulta();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Iconsax.scan),
                          Text(
                            'Escanear Código',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorPalet.secondaryDefault,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _separacionCampos(20),
            Row(
              children: [
                _NombreCampos('Aplicando descuento'),
                Spacer(),
                _NombreCampos(
                    '${widget.providerGenerico.totalACobrarFacturacion} Bs.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Define métodos auxiliares como `_tituloForm`, `_separacionCampos`, etc.
  Widget _tituloForm(String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _separacionCampos(double height) {
    return SizedBox(height: height);
  }

  Widget _NombreCampos(String nombre) {
    return Text(
      nombre,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
