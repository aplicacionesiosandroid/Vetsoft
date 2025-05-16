import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/common/mensajes/mensajes_widget.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String nombre = 'Espera..';
  String imgUser = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    obtieneDatos();
    super.initState();
  }

  Future<void> obtieneDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nombre = prefs.getString('nombre') ?? '';
      imgUser = prefs.getString('imgUser') ?? '';
    });
    print(
        'mi nombre ${prefs.getString('nombre')} ${prefs.getString('imgUser')}');
  }

  Future<void> _subirImagen() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      try {
        final url = Uri.parse('${apiUrlGlobal}cuenta/subir-imagen');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('myToken') ?? '';
        Map<String, String> headers = {
          'Authorization':
              'Bearer $token', // Incluye el token en el encabezado de autorización
        };
        final request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);

        request.files
            .add(await http.MultipartFile.fromPath('imagen', pickedImage.path));

        final response = await request.send();
        final responseData = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          final parsedResponse = json.decode(responseData);

          if (!parsedResponse['error']) {
            final String newImagePath = parsedResponse['data']['mensaje'];

            // Guarda la nueva URL de la imagen en las preferencias compartidas
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('imgUser', newImagePath);

            setState(() {
              imgUser = newImagePath;
            });
            mensajeInferior(context, 'Imagen subida exitosamente.');
          } else {
            mensajeInferior(context, 'Error en la respuesta del servidor.');
          }
        } else {
          mensajeInferior(context, 'Error al subir la imagen.');
        }
      } catch (e) {
        BotToast.showText(
            text: e.toString(), duration: const Duration(seconds: 3));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180, // Incrementamos la altura para incluir el botón
      padding: const EdgeInsets.only(top: 20.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            right: 10,
            top: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0x66F8F8FF),
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  Icons.close,
                  color: Color(0xffB1ADFF),
                  size: 22,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/icon/logovs.png',
                        image:
                            '$imagenUrlGlobal$imgUser?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 200),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _subirImagen,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xffB1ADFF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Color del borde
                            width: 2.0, // Ancho del borde
                          ),
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                nombre.replaceRange(0, 1, nombre.substring(0, 1).toUpperCase()),
                style: const TextStyle(
                    fontFamily: 'sans',
                    color: Color.fromARGB(255, 49, 46, 128),
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )
        ],
      ),
    );
  }
}
