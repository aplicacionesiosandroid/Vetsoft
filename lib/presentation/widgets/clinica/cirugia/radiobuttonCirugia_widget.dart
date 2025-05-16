import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/clinica/cirugia/cirugia_provider.dart';

//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroCirugia extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroCirugia(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              print(newValue);
              radioButtonProvider.setSelectedGender(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedSexoPaciente,
          ),
          Text(
            gender,
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

//Para saber si existe algun animal en casa con check box

class RadioButtonReutiExisteAlgunAnimalCirugia extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiExisteAlgunAnimalCirugia(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider.setSelectedExisteAnimal(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedExisteAnimalEnCasa,
          ),
          Text(
            siOno,
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

//Para saber si ha estado expuesto a enfermedades recientes

class RadioButtonReutiExpuestoAEnfermedadesCirugia extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiExpuestoAEnfermedadesCirugia(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider
                  .setSelectedExpuestoAEnfermedad(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedExpuestoAEnfermedad,
          ),
          Text(
            siOno,
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

//para saber si se le ha aplicado algun tratamiento a la enfermedad

class RadioButtonReutiAplicadoTratamientoCirugia extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiAplicadoTratamientoCirugia(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider
                  .setSelectedAplicadoTratamiento(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedAplicadoTratamiento,
          ),
          Text(
            siOno,
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

//Para saber si tiene vacunas al dia

class RadioButtonReutiVacunasAlDiaCirugia extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiVacunasAlDiaCirugia(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider.setSelectedVacunasAlDia(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedVacunasAlDia,
          ),
          Text(
            siOno,
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

//Para saber efectiuvo o transaccion

class RadioButtonEfecTransacCirugia extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacCirugia(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<CirugiaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider
                  .setSelectedEfectivoTransac(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedEfectivoTransac,
          ),
          Text(
            efecTransac,
            style: const TextStyle(
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
