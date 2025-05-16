import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';

//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroOProcedimi extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroOProcedimi(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<OProcedimientosProvider>(context);

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

//Para saber efectiuvo o transaccion

class RadioButtonEfecTransacOProcedimi extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacOProcedimi(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<OProcedimientosProvider>(context);

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
