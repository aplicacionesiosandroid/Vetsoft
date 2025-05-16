import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/peluqueria_provider.dart';


//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroPeluqueria extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroPeluqueria(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<PeluqueriaProvider>(context);

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 99, 92, 255),

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


//Para saber efectiuvo o transaccion

class RadioButtonEfecTransacPeluqueria extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacPeluqueria(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<PeluqueriaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 68, 0, 153),
            //fillColor:
            //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider.setSelectedEfectivoTransac(newValue.toString());
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
