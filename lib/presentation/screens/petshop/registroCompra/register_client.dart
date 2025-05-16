import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/pay_method_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/entregar_pedido/order_form.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/entregar_pedido/pay_method_form.dart';
import 'package:vet_sotf_app/presentation/widgets/petshop/entregar_pedido/register_form.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

class RegisterClient extends StatefulWidget {
  @override
  State<RegisterClient> createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late HomePetShopProvider carritoProvider;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    carritoProvider = Provider.of<HomePetShopProvider>(context, listen: false);
    super.initState();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  //form cliente
  TextEditingController controllerCiCliente = TextEditingController();
  TextEditingController controllerNombreCliente = TextEditingController();
  TextEditingController controllerApellidoCliente = TextEditingController();
  TextEditingController controllerCelularCliente = TextEditingController();

  //form metodo de pago
  TextEditingController controllerMontoEfectivo = TextEditingController();
  TextEditingController controllerCodigoDescuento = TextEditingController();

  void _finalizarFormulario() {
    final registroClienteModel =
        Provider.of<RegistroClienteModel>(context, listen: false);
    final paymentMethodModel =
        Provider.of<PaymentMethodModel>(context, listen: false);

    // Armamos la lista de productos desde el carrito
    List<Map<String, dynamic>> resumenCompra = carritoProvider.items
        .where((item) => item != null) // Filtrar elementos nulos
        .map((item) => {
              "producto_id": item!.producto_id,
              "producto_nombre": item.producto_nombre,
              "cantidad":
                  item.cantidad.toDouble(), // Convertir a double directamente
              "precio_unitario": item.precio_unitario.toDouble(),
              "monto": item.monto.toDouble(),
              "puntos": 0 // Puedes calcular los puntos aquí si es necesario
            })
        .toList();

    carritoProvider.enviarDatos(
        controllerCiCliente.text,
        controllerNombreCliente.text,
        controllerApellidoCliente.text,
        "", // TODO: Agregar correo si es necesario
        controllerCelularCliente.text,
        double.parse(controllerMontoEfectivo.text),
        "", // TODO: Asignar vigenciaCodigo si aplica
        registroClienteModel.registrarCliente,
        false,
        paymentMethodModel.isPaymentInCash ? "Efectivo" : "Tarjeta",
        0, // TODO: Agregar descuento si aplica
        "", // TODO: Agregar fecha de pago si aplica
        resumenCompra);
  }

  @override
  Widget build(BuildContext context) {
    final registroModel =
        Provider.of<RegistroModel>(context); // Obtén RegistroModel aquí
    final registroClienteModel = Provider.of<RegistroClienteModel>(context);
    Size size = MediaQuery.of(context).size;
    //Widget currentForm;
    String currentTitle;

    switch (registroModel.currentForm) {
      // Accede a currentForm desde RegistroModel
      case FormType.register:
        /*  currentForm = RegisterForm(
            registroClienteModel: registroClienteModel, size: size); */
        currentTitle = 'Datos del Cliente';
        break;
      case FormType.payMethod:
        /* currentForm = PayMethodForm(
          size: size,
        ); */
        currentTitle = 'Método de Pago';
        break;
      case FormType.order:
        /* currentForm = const OrderForm(); */
        currentTitle = 'Entregar Pedido';
        break;
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: size.height * 0.03,
            decoration: const BoxDecoration(
              color: ColorPalet.secondaryDefault,
            ),
          ),
          Container(
            color: ColorPalet.secondaryDefault,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorPalet.grisesGray5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (registroModel.currentForm.index == 0) {
                            Navigator.of(context).pop();
                          } else {
                            _previousPage();
                            registroModel.goToPreviousForm();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_outlined),
                      ),
                      Text(
                        currentTitle,
                        style: const TextStyle(
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
                      padding:
                          const EdgeInsets.only(top: 10.0), // Espaciado arriba
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
                              ColorPalet.acentDefault),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  //currentForm,

                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: SizedBox(
                      height: size.height * 0.7,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          RegisterForm(
                            registroClienteModel: registroClienteModel,
                            size: size,
                            onNext: _nextPage,
                            controllerCiForm: controllerCiCliente,
                            controllerNombreForm: controllerNombreCliente,
                            controllerApellidoForm: controllerApellidoCliente,
                            controllerCelularForm: controllerCelularCliente,
                          ),
                          PayMethodForm(
                            size: size,
                            onNext: _nextPage,
                            onPrev: _previousPage,
                            controllerMontoEfectivo: controllerMontoEfectivo,
                            controllerCodigoDescuento:
                                controllerCodigoDescuento,
                          ),
                          OrderForm(
                            onPrev: _previousPage,
                            onFinalizar: _finalizarFormulario,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
