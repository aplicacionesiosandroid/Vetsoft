import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

import '../../../../providers/clinica/consulta/consulta_provider.dart';

//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableConsultaGenero extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableConsultaGenero(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

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

class RadioButtonValidadorConsultaGenero extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonValidadorConsultaGenero({
    super.key,
    required this.gender,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

    return FormField<String>(
      validator: (value) => radioButtonProvider.validateGenderSelection(),
      builder: (formFieldState) {
        return Container(
          width: double.infinity,
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: Color.fromARGB(255, 26, 202, 212),
                    value: valor,
                    onChanged: (newValue) {
                      formFieldState.didChange(newValue);
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
                      fontSize: 14,
                    ),
                  ),
                ]
              ),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    formFieldState.errorText!,
                    style: TextStyle(
                      color: ColorPalet.errorValidacion,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
//Para saber si existe algun animal en casa con check box

class RadioButtonReutiExisteAlgunAnimalConsulta extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiExisteAlgunAnimalConsulta(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

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

class RadioButtonReutiExpuestoAEnfermedadesConsulta extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiExpuestoAEnfermedadesConsulta(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

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

class RadioButtonReutiAplicadoTratamientoConsulta extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiAplicadoTratamientoConsulta(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

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

class RadioButtonReutiVacunasAlDiaConsulta extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiVacunasAlDiaConsulta(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

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

typedef ValidatorFunction = String? Function(String? value);

Widget MensajeValidadorSelecciones({
  required ValidatorFunction validator,
}) {
  return FormField<String>(
    validator: validator,
    builder: (FormFieldState<String> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                state.errorText ?? '',
                style: TextStyle(
                  color: ColorPalet.errorValidacion,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    },
  );
}

//Para saber efectiuvo o transaccion

class RadioButtonEfecTransacConsulta extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacConsulta(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ConsultaProvider>(context);

    return Container(
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 26, 202, 212),
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
