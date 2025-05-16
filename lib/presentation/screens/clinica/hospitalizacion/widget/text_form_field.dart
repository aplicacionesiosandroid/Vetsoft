import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFormFieldNumberIntervalo<T> extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color colores;
  final T provider; // Variable para el provider genérico

  TextFormFieldNumberIntervalo({
    Key? key,
    this.controller,
    required this.hintText,
    required this.colores,
    required this.provider, // Actualización del constructor
  }) : super(key: key);

  @override
  _TextFormFieldNumberEdadState createState() =>
      _TextFormFieldNumberEdadState();
}

class _TextFormFieldNumberEdadState extends State<TextFormFieldNumberIntervalo> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            constraints: BoxConstraints(minWidth: 50, maxWidth: 240) ,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Color.fromARGB(220, 249, 249, 249)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Alinea al centro horizontalmente
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: widget.controller,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: widget.colores,
                          width: 1.0,
                        ),
                      ),
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(220, 249, 249, 249),
                      filled: true,

                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Alinea al centro verticalmente
                      children: [
                        Container(
                          width: 50,
                          height: 25,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffDADFE6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0), // Radio en la esquina superior izquierda
                              topRight: Radius.circular(12.0), // Radio en la esquina superior derecha
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            icon: Icon(Icons.arrow_drop_up, size: 30, color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                _value++;
                                if (widget.controller != null) {
                                  widget.controller!.text = _value.toString();
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 4,),
                        Container(
                          width: 50,
                          height: 25,
                          padding: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            color: Color(0xffDADFE6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center( // Centra el contenido del Container
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.white,),
                              onPressed: () {
                                setState(() {
                                  _value = _value > 1 ? _value - 1 : 1;
                                  if (widget.controller != null) {
                                    widget.controller!.text = _value.toString();
                                  }
                                });
                              },
                            ),
                          ),
                        ),

                      ]
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: widget.colores,
                    value: "horas",
                    onChanged: (newValue) {
                      widget.provider.setselectedInterval(newValue.toString());
                      print(widget.provider.selectedTypeInterval);
                    },
                    groupValue: widget.provider.selectedTypeInterval,
                  ),
                  Text(
                    "Horas",
                    style: TextStyle(
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'inter',
                        fontSize: 14),
                  )
                ],
              ),
              Row(
                children: [
                  Radio(
                    activeColor: widget.colores,
                    value: "minutos",
                    onChanged: (newValue) {
                      widget.provider.setselectedInterval(newValue.toString());
                      print(widget.provider.selectedTypeInterval);
                    },
                    groupValue: widget.provider.selectedTypeInterval,
                  ),
                  Text(
                    "Minutos",
                    style: TextStyle(
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'inter',
                        fontSize: 14),
                  )
                ],
              ),
            ],
          ),
        ]);
  }
}