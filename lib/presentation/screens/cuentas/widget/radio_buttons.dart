import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';

class RadioButtonConsultaGenero extends StatelessWidget {

  const RadioButtonConsultaGenero({super.key});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<UserEmpProvider>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Sexo",
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          ),
          Row(
            children: [
              Radio(
                activeColor: Color.fromARGB(255, 26, 202, 212),
                value: "M",
                onChanged: (newValue) {
                  print(newValue);
                  radioButtonProvider.setSelectedGender(newValue.toString());
                },
                groupValue: radioButtonProvider.selectedGenero,
              ),
              Text(
                "Masculino",
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 86, 109),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter',
                    fontSize: 14),
              ),
              Radio(
                activeColor: Color.fromARGB(255, 26, 202, 212),
                value: "F",
                onChanged: (newValue) {
                  print(newValue);
                  radioButtonProvider.setSelectedGender(newValue.toString());
                },
                groupValue: radioButtonProvider.selectedGenero,
              ),
              Text(
                "Femenino",
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 86, 109),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter',
                    fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RadioButtonEstadoCivil extends StatelessWidget {


  const RadioButtonEstadoCivil({super.key});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<UserEmpProvider>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Estado civil",
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          ),
          Row(
            children: [
              Radio(
                activeColor: Color.fromARGB(255, 26, 202, 212),
                value: "SOLTERO(A)",
                onChanged: (newValue) {
                  radioButtonProvider.setSelectedEstadoCivil(newValue.toString());
                },
                groupValue: radioButtonProvider.selectedEstadoCivil,
              ),
              Text(
                "Soltero(a)",
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 86, 109),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter',
                    fontSize: 14),
              ),
              Radio(
                activeColor: Color.fromARGB(255, 26, 202, 212),
                value: "CASADO(A)",
                onChanged: (newValue) {
                  radioButtonProvider.setSelectedEstadoCivil(newValue.toString());
                },
                groupValue: radioButtonProvider.selectedEstadoCivil,
              ),
              Text(
                "Casado(a)",
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 86, 109),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter',
                    fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}