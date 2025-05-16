//Para saber el genero de la mascota con checkbox

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/campanas/campain_provider.dart';

import '../../../config/global/palet_colors.dart';

//PARA LOS CONTACTOS DE PROMO WHATSAPP

class RadioButtonReutilizableContactosPromoWhatsapp extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableContactosPromoWhatsapp(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.acentDefault,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider.setSelectedContactos(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedContactos,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//PARA LOS ESTILO NUMERICO O QR DE CODIGO PROMOCION

class RadioButtonReutilizableEstiloCodPromocional extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableEstiloCodPromocional(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.complementVerde1,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider
                  .setSelectedEstiloCodPromo(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedEstiloCodPromo,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//PARA SELECCIONAR TODOS LOS PRODUCTOS O BUSCAR

class RadioButtonReutilizableSeleccionProducts extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableSeleccionProducts(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.complementVerde1,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider.setSelectedProducts(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedProducts,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//PARA SELECCIONAR TODOS LOS PRODUCTOS O BUSCAR

class RadioButtonReutilizableSelectAlAzarContactos extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableSelectAlAzarContactos(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.complementVerde1,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider
                  .setSelectedAlAzarContactos(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedAlAzarContactos,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//sistema de puntos

//PARA SELECCIONAR HABILITARSISTEMA DE PUNTOS

class RadioButtonReutilizableHabilitarSisPuntos extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableHabilitarSisPuntos(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.secondaryDefault,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider
                  .setSelectedHabSisPuntos(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedHabSisPuntos,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//PARA SELECCIONAR productos en promocion

class RadioButtonReutilizableProdcutosPromocion extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableProdcutosPromocion(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.secondaryDefault,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider
                  .setSelectedproductsSisPuntos(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedproductsSisPuntos,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}

//PARA SELECCIONAR productos en promocion

class RadioButtonReutilizableContactsSisPuntos extends StatelessWidget {
  final String text;
  final String valor;

  const RadioButtonReutilizableContactsSisPuntos(
      {super.key, required this.text, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CampainProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: ColorPalet.secondaryDefault,
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider
                  .setSelectedContactsSisPuntos(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedContactsSisPuntos,
          ),
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }
}
