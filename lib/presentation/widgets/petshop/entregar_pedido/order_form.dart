import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/order_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/petshop/registroCompra/pay_method_model.dart';

class OrderForm extends StatelessWidget {
  final Function() onPrev;
  final Function() onFinalizar;
  const OrderForm({
    super.key,
    required this.onPrev,
    required this.onFinalizar,
  });

  @override
  Widget build(BuildContext context) {
    final registroModel = Provider.of<RegistroModel>(context);
    final orderModel = Provider.of<OrderFormModel>(context);
    final metodoPago = Provider.of<PaymentMethodModel>(context);
    final clienteModel = Provider.of<RegistroClienteModel>(context);
    final carritoProvider = Provider.of<HomePetShopProvider>(context);

    return Column(
      children: [
        mostrarEntregaPedido(context, 'Cliente',
            '${clienteModel.nombre} ${clienteModel.apellido}'),
        const SizedBox(height: 20),
        mostrarEntregaPedido(context, 'NIT', clienteModel.nitCi),
        const SizedBox(height: 20),
        mostrarEntregaPedido(
            context,
            carritoProvider.calcularSubTotal().toString(),
            metodoPago.isPaymentInCash ? 'Pago en efectivo' : 'Pago en línea'),
        const SizedBox(height: 20),
        Row(
          children: [
            Switch(
              activeColor: ColorPalet.acentDefault,
              value: orderModel.isOrderDelivered,
              onChanged: (value) {
                orderModel.updateOrderDeliveryStatus(value);
              },
            ),
            const Text("Pedido entregado"),
          ],
        ),
        const SizedBox(height: 50),
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
              ))),
          onPressed: () {
            onPrev();
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
                ))),
            onPressed: () {
              onFinalizar();
            },
            child: const Text("Finalizar")),
      ],
    );
  }

  Container mostrarEntregaPedido(
      BuildContext context, String hint, String campo) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorPalet.backGroundColor),
      child: Row(
        children: [
          Text(campo,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'inter',
                  fontSize: 14,
                  color: ColorPalet.grisesGray1)),
          const Spacer(),
          Text(
            hint,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'inter',
                fontSize: 14,
                color: ColorPalet.grisesGray1),
          ),
        ],
      ),
    );
  }
}
