import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/hospitalizacion_screen.dart';

void openModalBottomSheetHospitalizacion(BuildContext context, ClinicaUpdateModel clinicaUpdate) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: FormularioHospitalizacion(clinicaUpdate: clinicaUpdate),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

