import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/peluqueria/programarCitaPelu_provider.dart';



//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroPCitaPelu extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroPCitaPelu(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ProgramarCitaPeluProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: const Color.fromARGB(255, 99, 92, 255),
            value: valor,
            onChanged: (newValue) {
              radioButtonProvider.setSelectedGender(newValue.toString());
            },
            groupValue: radioButtonProvider.selectedSexoPaciente,
          ),
          Text(
            gender,
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

