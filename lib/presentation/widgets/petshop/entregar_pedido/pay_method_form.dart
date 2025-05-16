import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/pay_method_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';
import 'package:vet_sotf_app/providers/petshop/RegistroCompra/registrarCompra_provider.dart';

import '../../../../config/global/palet_colors.dart';

class PayMethodForm extends StatefulWidget {
  final Function() onNext;
  final Function() onPrev;
  final Size size;
  const PayMethodForm({
    Key? key,
    required this.size,
    required this.onNext,
    required this.onPrev,
    required this.controllerMontoEfectivo,
    required this.controllerCodigoDescuento,
  }) : super(key: key);

  @override
  _PayMethodFormState createState() => _PayMethodFormState();

  final TextEditingController controllerMontoEfectivo;
  final TextEditingController controllerCodigoDescuento;
}

class _PayMethodFormState extends State<PayMethodForm> {
  bool? isPaymentInCash;

  @override
  Widget build(BuildContext context) {
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final registroModel = Provider.of<RegistroModel>(context);

    final carritoProvider =
        Provider.of<HomePetShopProvider>(context, listen: true);
    final listDescripcionCarrito = carritoProvider.items;

    final registroProvider =
        Provider.of<RegistroCompraProvider>(context, listen: true);

    Future<void> scanQr() async {
      String qrScanRes;
      try {
        qrScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancelar', true, ScanMode.QR);
        widget.controllerCodigoDescuento.text = qrScanRes;
      } on PlatformException {
        qrScanRes = 'failed scan';
      }
    }

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                activeColor: ColorPalet.acentDefault,
                value: true,
                groupValue: isPaymentInCash,
                onChanged: (value) {
                  setState(() {
                    isPaymentInCash = value!;
                    paymentMethodModel.updatePaymentMethod(isPaymentInCash!);
                  });
                },
              ),
              const Text("Efectivo"),
              const SizedBox(
                width: 20,
              ),
              Radio(
                activeColor: ColorPalet.acentDefault,
                value: false,
                groupValue: isPaymentInCash,
                onChanged: (value) {
                  setState(() {
                    isPaymentInCash = value!;
                    paymentMethodModel.updatePaymentMethod(isPaymentInCash!);
                  });
                },
              ),
              const Text("Pago en Línea"),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 5),
            child: const Text("Ingresar Monto en Efectivo"),
          ),
          Row(
            children: [
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
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "0.00",
                        filled: true,
                        fillColor: ColorPalet.backGroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      controller: widget.controllerMontoEfectivo,
                      onChanged: (value) {
                        paymentMethodModel
                            .updateCashAmount(double.tryParse(value) ?? 0.0);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: 60,
            width: widget.size.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorPalet.backGroundColor),
            child: Row(
              children: [
                Text('Cambio',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'inter',
                        fontSize: 14,
                        color: ColorPalet.grisesGray1)),
                Spacer(),
                Text(
                  paymentMethodModel.cashAmount == 0
                      ? ' Bs. 0.00'
                      : 'Bs. ${(paymentMethodModel.cashAmount - carritoProvider.totalPagar).toString()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'inter',
                      fontSize: 14,
                      color: ColorPalet.grisesGray1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 5),
            child: const Text("Código de Descuento"),
          ),
          Row(
            children: [
              Container(
                width: 180,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "(Ej: 43221)",
                    filled: true,
                    fillColor: ColorPalet.backGroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: widget.controllerCodigoDescuento,
                  onChanged: (value) {
                    paymentMethodModel.updateDiscountCode(value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 45,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalet.secondaryDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    //carritoProvider.setDescuento(10.00);
                    scanQr();
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text("Escanear Código"),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalet.acentDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                carritoProvider
                    .canjearDescuento(widget.controllerCodigoDescuento.text)
                    .then((_) async {
                  if (carritoProvider.okPostCanjearCodigo) {
                    print('CODIGO CANJEADO');
                  }
                });
              },
              child: carritoProvider.loadingCanjearCodigo
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
                  : Text("Canjear"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 5),
            child: const Text(
              "Resumen de la compra",
              style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 14,
                  color: ColorPalet.grisesGray0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: widget.size.height * 0.2,
            width: widget.size.width,
            child: ListView.builder(
              itemCount: carritoProvider.items.length,
              itemBuilder: (context, index) {
                final myProductsCarrito = listDescripcionCarrito[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        carritoProvider
                            .removeProduct(myProductsCarrito!.producto_id);
                      },
                      icon: Icon(
                        Iconsax.trash,
                        color: ColorPalet.estadoNegative,
                      ),
                    ),
                    Text(
                      myProductsCarrito!.producto_nombre,
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 10,
                          color: ColorPalet.grisesGray1,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'x${myProductsCarrito.cantidad}',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 10,
                          color: ColorPalet.grisesGray1,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Bs. ${myProductsCarrito.monto}',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 10,
                          color: ColorPalet.grisesGray1,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subtotal",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "Bs. ${carritoProvider.calcularSubTotal()}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Descuento",
                style: TextStyle(color: ColorPalet.grisesGray2),
              ),
              Text(
                'Bs. ${carritoProvider.descuento.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter'),
              ),
              Text(
                "Bs. ${carritoProvider.getTotalPagar()}",
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter'),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  ColorPalet.acentDefault.withAlpha(50)),
              minimumSize: MaterialStateProperty.all(const Size(350, 50)),
              backgroundColor:
                  MaterialStateProperty.all(ColorPalet.grisesGray5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: const BorderSide(color: ColorPalet.acentDefault),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              widget.onPrev();
              registroModel.goToPreviousForm();
            },
            child: const Text(
              "Anterior",
              style: TextStyle(color: ColorPalet.acentDefault),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(350, 50)),
              backgroundColor:
                  MaterialStateProperty.all(ColorPalet.acentDefault),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              widget.onNext();
              registroModel.goToNextForm();
            },
            child: const Text("Siguiente"),
          ),
        ],
      ),
    );
  }
}
