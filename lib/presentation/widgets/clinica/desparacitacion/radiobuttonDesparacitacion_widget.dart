import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/clinica/desparacitacion/desparacitacion_provider.dart';

//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroDesp extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroDesp(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<DesparacitacionProvider>(context);

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

//Para saber el tipo de desparasitacion
class RadioButtonTipoDeDesparacitacionDesp extends StatelessWidget {
  final String intOext;
  final String valor;

  const RadioButtonTipoDeDesparacitacionDesp(
      {super.key, required this.intOext, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<DesparacitacionProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider.setSelectedInternoExterno(newValue!);
            },
            groupValue: radioButtonProvider.selectedInternoExterno,
          ),
          Text(
            intOext,
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

class RadioButtonEfecTransacDesp extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacDesp(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<DesparacitacionProvider>(context);

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
