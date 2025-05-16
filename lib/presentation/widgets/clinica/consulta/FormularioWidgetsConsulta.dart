import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/clinica/cirugia/cirugia_provider.dart';
import 'package:vet_sotf_app/providers/clinica/consulta/consulta_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';
//
// Future<void> dialogAddRazaConsulta(BuildContext context, ConsultaProvider dataConsulta) async {
//   // Restablecer el valor del controlador
//   TextEditingController controllerNombre = TextEditingController();
//
//   controllerNombre.text = '';
//   bool isLoading = false; // Mueve esta declaración a nivel de estado
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Ingrese una nueva raza'),
//             content: TextFormFieldConHintValidator(
//               colores: const Color.fromARGB(255, 140, 228, 233),
//               controller: controllerNombre,
//               hintText: 'Raza (Ej: Chihuahua)',
//             ),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () async {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   await dataConsulta.setNewRaza(controllerNombre.text);
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: const Color.fromARGB(255, 26, 202, 212),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (isLoading)
//                       SizedBox(
//                         width: 25,
//                         height: 25,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         ),
//                       )
//                     else
//                       Text(
//                         'Añadir',
//                         style: TextStyle(
//                           fontFamily: 'inter',
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Color.fromARGB(255, 26, 202, 212), width: 1.5),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Cancelar',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 26, 202, 212),
//                     fontFamily: 'inter',
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
//
// Future<void> dialogAddRazaCita(BuildContext context, ProgramarCitaProvider dataConsulta) async {
//   // Restablecer el valor del controlador
//   TextEditingController controllerNombre = TextEditingController();
//   controllerNombre.text = '';
//   bool isLoading = false; // Mueve esta declaración a nivel de estado
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Ingrese una nueva raza'),
//             content: TextFormFieldConHintValidator(
//               colores: const Color.fromARGB(255, 140, 228, 233),
//               controller: controllerNombre,
//               hintText: 'Raza (Ej: Chihuahua)',
//             ),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () async {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   await dataConsulta.setNewRaza(controllerNombre.text);
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: const Color.fromARGB(255, 26, 202, 212),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (isLoading)
//                       SizedBox(
//                         width: 25,
//                         height: 25,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         ),
//                       )
//                     else
//                       Text(
//                         'Añadir',
//                         style: TextStyle(
//                           fontFamily: 'inter',
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Color.fromARGB(255, 26, 202, 212), width: 1.5),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Cancelar',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 26, 202, 212),
//                     fontFamily: 'inter',
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

Future<void> dialogAddRaza(BuildContext context, dataConsulta) async {
  // Restablecer el valor del controlador
  TextEditingController controllerNombre = TextEditingController();
  controllerNombre.text = '';
  bool isLoading = false; // Mueve esta declaración a nivel de estado
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Ingrese una nueva raza'),
            content: TextFormFieldConHintValidator(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerNombre,
              hintText: 'Raza (Ej: Chihuahua)',
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await dataConsulta.setNewRaza(controllerNombre.text);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 26, 202, 212),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Añadir',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(255, 26, 202, 212), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 26, 202, 212),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
//
// class TextFormFieldNumberEdadCita extends StatefulWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final Color colores;
//
//   const TextFormFieldNumberEdadCita({
//     Key? key,
//     this.controller,
//     required this.hintText,
//     required this.colores,
//   }) : super(key: key);
//
//   @override
//   _TextFormFieldNumberEdadCita createState() =>
//       _TextFormFieldNumberEdadCita();
// }
//
// class _TextFormFieldNumberEdadCita extends State<TextFormFieldNumberEdadCita> {
//   int _value = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final radioButtonProvider = Provider.of<ProgramarCitaProvider>(context);
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//
//         children: [
//           Container(
//             constraints: BoxConstraints(minWidth: 50, maxWidth: 240) ,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Color.fromARGB(220, 249, 249, 249)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center, // Alinea al centro horizontalmente
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     keyboardType: TextInputType.number,
//                     controller: widget.controller,
//                     onChanged: (value) {
//                       setState(() {
//                         _value = int.tryParse(value) ?? 0;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: widget.colores,
//                           width: 1.0,
//                         ),
//                       ),
//                       hintText: widget.hintText,
//                       hintStyle: TextStyle(
//                           color: Color.fromARGB(255, 139, 149, 166),
//                           fontSize: 15,
//                           fontFamily: 'inter'),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none),
//                       fillColor: Color.fromARGB(220, 249, 249, 249),
//                       filled: true,
//
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center, // Alinea al centro verticalmente
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 25,
//                           padding: EdgeInsets.zero,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Color(0xffDADFE6),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(12.0), // Radio en la esquina superior izquierda
//                               topRight: Radius.circular(12.0), // Radio en la esquina superior derecha
//                             ),
//                           ),
//                           child: IconButton(
//                             padding: EdgeInsets.zero,
//                             alignment: Alignment.center,
//                             icon: Icon(Icons.arrow_drop_up, size: 30, color: Colors.white,),
//                             onPressed: () {
//                               setState(() {
//                                 _value++;
//                                 if (widget.controller != null) {
//                                   widget.controller!.text = _value.toString();
//                                 }
//                               });
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 4,),
//                         Container(
//                           width: 50,
//                           height: 25,
//                           padding: EdgeInsets.only(bottom: 0),
//                           decoration: BoxDecoration(
//                             color: Color(0xffDADFE6),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(12.0),
//                               bottomRight: Radius.circular(12.0),
//                             ),
//                           ),
//                           child: Center( // Centra el contenido del Container
//                             child: IconButton(
//                               padding: EdgeInsets.zero,
//                               icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.white,),
//                               onPressed: () {
//                                 setState(() {
//                                   _value = _value > 1 ? _value - 1 : 1;
//                                   if (widget.controller != null) {
//                                     widget.controller!.text = _value.toString();
//                                   }
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//
//                       ]
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment:CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Radio(
//                     activeColor: widget.colores,
//                     value: "meses",
//                     onChanged: (newValue) {
//                       print(newValue);
//                       radioButtonProvider.setselectedAge(newValue.toString());
//                     },
//                     groupValue: radioButtonProvider.selectedTypeAge,
//                   ),
//                   Text(
//                     "Meses",
//                     style: TextStyle(
//                         color: Color.fromARGB(255, 72, 86, 109),
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'inter',
//                         fontSize: 14),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Radio(
//                     activeColor: widget.colores,
//                     value: "anios",
//                     onChanged: (newValue) {
//                       print(newValue);
//                       radioButtonProvider.setselectedAge(newValue.toString());
//                     },
//                     groupValue: radioButtonProvider.selectedTypeAge,
//                   ),
//                   Text(
//                     "Años",
//                     style: TextStyle(
//                         color: Color.fromARGB(255, 72, 86, 109),
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'inter',
//                         fontSize: 14),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ]);
//   }
// }