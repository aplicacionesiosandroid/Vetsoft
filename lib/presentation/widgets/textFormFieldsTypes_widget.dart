import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../config/global/palet_colors.dart';

class TextFormFieldConHint extends StatelessWidget {
  //final ValueChanged<String>? onChange;
  final TextEditingController? controller;
  final String hintText;
  final Color colores;
  final bool? enabled;

  const TextFormFieldConHint({
    Key? key,
    this.controller,
    required this.hintText,
    required this.colores,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled ?? true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        filled: true,
      ),
    );
  }
}

class TextFormFieldNumberConHint extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color colores;

  const TextFormFieldNumberConHint(
      {super.key,
      this.controller,
      required this.hintText,
      required this.colores});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: Color.fromARGB(220, 249, 249, 249),
        filled: true,
      ),
    );
  }
}

class TextFormFieldNumberEdad<T> extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color colores;
  final T provider; // Variable para el provider genérico

  TextFormFieldNumberEdad({
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

class _TextFormFieldNumberEdadState extends State<TextFormFieldNumberEdad> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 50, maxWidth: 240),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(220, 249, 249, 249)),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Alinea al centro horizontalmente
              children: [
                Expanded(
                  child: TextFormField(
                    validator: requiredValidator,
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
                      hintStyle: const TextStyle(
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
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Alinea al centro verticalmente
                      children: [
                        Container(
                          width: 50,
                          height: 25,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xffDADFE6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  12.0), // Radio en la esquina superior izquierda
                              topRight: Radius.circular(
                                  12.0), // Radio en la esquina superior derecha
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            icon: const Icon(
                              Icons.arrow_drop_up,
                              size: 30,
                              color: Colors.white,
                            ),
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
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: 50,
                          height: 25,
                          padding: const EdgeInsets.only(bottom: 0),
                          decoration: const BoxDecoration(
                            color: Color(0xffDADFE6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            // Centra el contenido del Container
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.white,
                              ),
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
                      ]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: widget.colores,
                    value: "meses",
                    onChanged: (newValue) {
                      print(newValue);
                      widget.provider.setselectedAge(newValue.toString());
                    },
                    groupValue: widget.provider.selectedTypeAge,
                  ),
                  const Text(
                    "Meses",
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
                    value: "anios",
                    onChanged: (newValue) {
                      print(newValue);
                      widget.provider.setselectedAge(newValue.toString());
                    },
                    groupValue: widget.provider.selectedTypeAge,
                  ),
                  const Text(
                    "Años",
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

void mostrarFichaCreada(BuildContext context, String textoMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromARGB(255, 28, 149, 187),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      content: Container(
        height: 50,
        child: Row(
          children: [
            const SizedBox(width: 5),
            const Icon(
              Icons.check_circle_outline,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AutoSizeText(
                textoMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                maxLines: 1,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(Icons.close,
                  size: 20, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    ),
  );
}

class TextFormFieldMaxLinesConHint extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final int maxLines;
  final Color colores;
  final bool? validar;

  const TextFormFieldMaxLinesConHint(
      {super.key,
      this.controller,
      required this.hintText,
      required this.maxLines,
      required this.colores,
      this.validar});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      validator: (validar ?? false) ? requiredValidator : null,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: ColorPalet.inputBackGroundColor,
        filled: true,
      ),
    );
  }
}

class TextFormFieldMaxLinesConHintLlenadoAutomatico extends StatelessWidget {
  final String? valorDefecto;
  final TextEditingController? controller;
  final String hintText;
  final int maxLines;
  final Color colores;

  const TextFormFieldMaxLinesConHintLlenadoAutomatico(
      {super.key,
      this.controller,
      required this.hintText,
      required this.maxLines,
      required this.colores,
      this.valorDefecto});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: valorDefecto,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 140, 228, 233),
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(220, 249, 249, 249),
        filled: true,
      ),
    );
  }
}

class TextFormFieldConHintValidator extends StatelessWidget {
  //final ValueChanged<String>? onChange;
  final TextEditingController? controller;
  final String hintText;
  final Color colores;

  const TextFormFieldConHintValidator(
      {super.key,
      this.controller,
      required this.hintText,
      required this.colores});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: requiredValidator,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(220, 249, 249, 249),
        filled: true,
      ),
    );
  }
}

//myValidator

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Debe llenar este campo';
  }
  return null;
}

class TextFormFieldNumberConHintValidator extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color colores;

  const TextFormFieldNumberConHintValidator(
      {super.key,
      this.controller,
      required this.hintText,
      required this.colores});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: numberValidator,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(220, 249, 249, 249),
        filled: true,
      ),
    );
  }
}

String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es requerido';
  }

  const numberRegex = r'^-?(([0-9]+([.][0-9]*)?)|([.][0-9]+))$';
  // const numberRegex = r'^(([0-9]+([.][0-9]*)?)|([.][0-9]+))$';

  final regex = RegExp(numberRegex);

  if (!regex.hasMatch(value)) {
    return 'Por favor, ingresa un número válido';
  }

  return null;
}

class TextFormFieldNumberConHintValidatorParams extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color colores;

  const TextFormFieldNumberConHintValidatorParams(
      {super.key,
      this.controller,
      required this.hintText,
      required this.colores});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: numberValidatorParams,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colores,
            width: 1.0,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(220, 249, 249, 249),
        filled: true,
      ),
    );
  }
}

String? numberValidatorParams(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es requerido';
  }
  final number = int.tryParse(value);

  if (number == null || number < 1 || number > 100) {
    return 'Por favor, ingresa un número entre 1 y 100';
  }

  const numberRegex = r'^-?(([0-9]+([.][0-9]*)?)|([.][0-9]+))$';
  final regex = RegExp(numberRegex);

  if (!regex.hasMatch(value)) {
    return 'Por favor, ingresa un número válido';
  }

  return null;
}
