import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/providers/clinica/citasmedicas_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';

class EliminarCitaAlertDialog extends StatelessWidget {
  final String textEliminar;
  final int idFicha;
  final String textContent;

  const EliminarCitaAlertDialog({
    Key? key,
    required this.textEliminar,
    required this.idFicha,
    required this.textContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Estás seguro/a de $textContent esta cita?',
          style: TextStyle(
            color: const Color.fromARGB(255, 29, 34, 44),
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          textAlign: TextAlign.justify,
        ),
        content: SizedBox(
          height: 50,
          child: Column(
            children: [
              // Expanded(
              //   child:  Text(
              //     'Se $textContent la cita.',
              //     style: const TextStyle(
              //       color:  Color.fromARGB(255, 72, 86, 109),
              //       fontFamily: 'inter',
              //       fontWeight: FontWeight.w400,
              //       fontSize: 14,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 255, 85, 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(fontFamily: 'inter', fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            // Cerrar el AlertDialog
                            Provider.of<CitaMedicaProvider>(context, listen: false)
                                .marcarCitaComo(textEliminar, idFicha)
                                .then((value) async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 28, 149, 187),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Sí',
                            style: TextStyle(fontFamily: 'inter', fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
