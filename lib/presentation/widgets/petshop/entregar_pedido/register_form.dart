import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/registration_pay_model.dart';
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../../config/global/palet_colors.dart';

class RegisterForm extends StatelessWidget {
  final Function() onNext;
  RegisterForm({
    super.key,
    required this.registroClienteModel,
    required Size size,
    required this.onNext,
    required this.controllerCiForm,
    required this.controllerNombreForm,
    required this.controllerApellidoForm,
    required this.controllerCelularForm,
  });

  final RegistroClienteModel registroClienteModel;

  final TextEditingController controllerCiForm;
  final TextEditingController controllerNombreForm;
  final TextEditingController controllerApellidoForm;
  final TextEditingController controllerCelularForm;

  @override
  Widget build(BuildContext context) {
    final registroModel = Provider.of<RegistroModel>(context);
    final carritoProvider = Provider.of<HomePetShopProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Switch(
                activeColor: ColorPalet.acentDefault,
                value: registroClienteModel.registrarCliente,
                onChanged: (value) {
                  registroClienteModel.toggleRegistrarCliente();
                },
              ),
              Text("Registrar Cliente"),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              child: _NombreCampos("NIT o CI")),
          const SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Ingresa tu NIT o CI",
              filled: true,
              fillColor: ColorPalet.backGroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            controller: controllerCiForm,
            onChanged: (value) {
              registroClienteModel
                  .setNitCi(value); //Actualiza el modelo cuando cambia el valor
            },
          ),
          const SizedBox(height: 15),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              child: _NombreCampos("Nombre")),
          const SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Ingresa tu Nombre",
              filled: true,
              fillColor: ColorPalet.backGroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            controller: controllerNombreForm,
            onChanged: (value) {
              registroClienteModel.setNombre(
                  value); // Actualiza el modelo cuando cambia el valor
            },
          ),
          const SizedBox(height: 15),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              child: _NombreCampos("Apellido")),
          const SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Ingresa tu Apellido",
              filled: true,
              fillColor: ColorPalet.backGroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            controller: controllerApellidoForm,
            onChanged: (value) {
              registroClienteModel.setApellido(
                  value); // Actualiza el modelo cuando cambia el valor
            },
          ),
          const SizedBox(height: 15),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              child: _NombreCampos("Número de Celular")),
          const SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "(Ej: 782 64987)",
              filled: true,
              fillColor: ColorPalet.backGroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            controller: controllerCelularForm,
            onChanged: (value) {
              registroClienteModel.setNumeroCelular(
                  value); // Actualiza el modelo cuando cambia el valor
            },
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Switch(
                value: registroClienteModel.facturacion,
                activeColor: ColorPalet.acentDefault,
                onChanged: (value) {
                  registroClienteModel.toggleFacturacion();
                },
              ),
              const Text("Facturación"),
            ],
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
                Utilidades.imprimir(
                    'Se presionó el botón de siguiente datos cliente ${controllerCiForm.text} > ${carritoProvider.listaProductosEnviarParaDescuento}');
                onNext();
                registroModel.goToNextForm();
                // TODO: revisar por que canjear puntos no funciona
                // carritoProvider
                //     .canjearPorPuntos(controllerCiForm.text,
                //         carritoProvider.listaProductosEnviarParaDescuento)
                //     .then((_) async {
                //   if (carritoProvider.okPostDescuentoPorproducto) {
                //     onNext();
                //     registroModel.goToNextForm();
                //   }
                // });
              },
              child: const Text("Siguiente")),
        ],
      ),
    );
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
}
