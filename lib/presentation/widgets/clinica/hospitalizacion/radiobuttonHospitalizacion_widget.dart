import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';
import 'package:vet_sotf_app/providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';

//Para saber el genero de la mascota con checkbox

class RadioButtonReutilizableGeneroHospitalizacion extends StatelessWidget {
  final String gender;
  final String valor;

  const RadioButtonReutilizableGeneroHospitalizacion(
      {super.key, required this.gender, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<HospitalizacionProvider>(context);

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

class RadioButtonEfecTransacHospitalizacion extends StatelessWidget {
  final String efecTransac;
  final String valor;

  const RadioButtonEfecTransacHospitalizacion(
      {super.key, required this.efecTransac, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<HospitalizacionProvider>(context);

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

//Para saber si existe algun animal en casa con check box

class RadioButtonReutiExisteAlgunAnimalHospitalizacion extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiExisteAlgunAnimalHospitalizacion(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<HospitalizacionProvider>(context);

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

//para saber si se le ha aplicado algun tratamiento a la enfermedad

class RadioButtonReutiAplicadoTratamientoHospitalizacion
    extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiAplicadoTratamientoHospitalizacion(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<HospitalizacionProvider>(context);

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
class RadioButtonReutiVacunasAlDiaHospitalizacion extends StatelessWidget {
  final String siOno;
  final String valor;

  const RadioButtonReutiVacunasAlDiaHospitalizacion(
      {super.key, required this.siOno, required this.valor});

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<HospitalizacionProvider>(context);

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
