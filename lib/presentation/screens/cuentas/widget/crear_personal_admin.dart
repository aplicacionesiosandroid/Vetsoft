
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:path/path.dart' as path;

void openBottomCreatePersonal(BuildContext context) {
  final sizeWidth = MediaQuery.of(context).size.width;
  final userEmpProvider = Provider.of<UserEmpProvider>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 30,
                      height: 2,
                      color: const Color.fromARGB(255, 161, 158, 158),
                    ),
                  ),
                  SizedBox(
                    width: sizeWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Personal',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontSize: 18,
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: UpdateInfoPersonalScreen(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((value) {
    userEmpProvider.setImageEmpelado(""); // Reset image path when modal closes
  });
}



class UpdateInfoPersonalScreen extends StatefulWidget {
  const UpdateInfoPersonalScreen({super.key});
  @override
  State<UpdateInfoPersonalScreen> createState() => _UpdateInfoPersonalScreenState();
}

class _UpdateInfoPersonalScreenState extends State<UpdateInfoPersonalScreen> {
  final _formKeyDueno = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmaContrasenaController = TextEditingController();
  final TextEditingController _accesoEmpleadoController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmaContrasenaController.dispose();
    _accesoEmpleadoController.dispose();
    super.dispose();
  }

  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final userEmpProvider = Provider.of<UserEmpProvider>(context);

    String nombreLegible = path.basename(userEmpProvider.imageEmpelado);

    bool verificaContrasenas(String contrasena, String confirmaContrasena) {
      if(contrasena.isEmpty || confirmaContrasena.isEmpty){
        BotToast.showText(text: "Ingrese una contraseña y confirme la contraseña.");
        return false;
      }
      if(contrasena.length < 6){
        BotToast.showText(text: "La contraseña debe tener al menos 6 caracteres.");
        return false;
      }
      if(contrasena != confirmaContrasena){
        BotToast.showText(text: "Las contraseñas no coinciden.");
        return false;
      }
      return contrasena == confirmaContrasena;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _separacionCampos(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKeyDueno,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nombreCampos('Nombre del empleado'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _nombreController,
                    hintText: 'Nombre (Ej: Matías)',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  _nombreCampos('Apellido del empleado'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _apellidoController,
                    hintText: 'Apellido (Ej: Fernandez)',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  _nombreCampos('Correo electrónico del empleado'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _correoController,
                    hintText: 'Escriba un correo electrónico...',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  _nombreCampos('Contraseña'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _contrasenaController,
                    hintText: 'Escriba una contraseña...',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  _nombreCampos('Confirmar la contraseña'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _confirmaContrasenaController,
                    hintText: 'Escriba la contraseña nuevamente...',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  _nombreCampos('Acceso del empleado'),
                  _separacionCampos(15),
                  TextFormFieldConHintValidator(
                    controller: _accesoEmpleadoController,
                    hintText: 'Agregar el acceso...',
                    colores: ColorPalet.secondaryDefault,
                  ),
                  _separacionCampos(20),
                  Container(
                    height: sizeScreen.height*0.10,
                    width: sizeScreen.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorPalet.grisesGray6,
                          ),
                          width: sizeScreen.width * 0.2,
                          height:  sizeScreen.height * 0.2,
                          child: userEmpProvider?.imageEmpelado != '' ? Image.file(
                            File(userEmpProvider.imageEmpelado!),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            width: sizeScreen.width * 0.2,
                            height: sizeScreen.height * 0.2,
                          ) : SvgPicture.asset(
                            'assets/icon/fondo_img_gallery.svg', // Reemplaza 'assets/your_image.svg' con la ruta de tu imagen SVG
                            width: sizeScreen.width * 0.01,
                            height:  sizeScreen.height * 0.01,
                            fit: BoxFit.none,
                            alignment: Alignment.center,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Foto del empleado',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray1,
                                    fontFamily: 'inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 45,
                                width: sizeScreen.width*0.60,
                                decoration: BoxDecoration(
                                    color: ColorPalet.grisesGray6,
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                  onTap: () async {

                                    Future<String?> selectFile() async {
                                      final result = await FilePicker.platform.pickFiles();
                                      if (result != null) {
                                        final path = result.files.single.path;
                                        return path;
                                      }
                                      return null;
                                    }

                                    final fileName = await selectFile();
                                    if (fileName != null) {
                                      userEmpProvider.setImageEmpelado(fileName);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizeScreen.width*0.45,
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                              nombreLegible  == '' ? 'Seleccionar imagen' : ''+nombreLegible,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(255, 139, 149, 166),
                                                  fontFamily: 'sans',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Iconsax.document_download,
                                          size: 25,
                                          color: Color.fromARGB(255, 139, 149, 166),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _separacionCampos(20),

                  SizedBox(
                    width: sizeScreen.width, // Ajusta el ancho del SizedBox al ancho de la pantalla
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? () async {
                        if (_formKeyDueno.currentState!.validate()) {

                          if (verificaContrasenas(_contrasenaController.text, _confirmaContrasenaController.text)) {
                            setState(() {
                              _isButtonEnabled = false;
                            });

                            bool success = await userEmpProvider.createPersonal(
                              _nombreController.text,
                              _apellidoController.text,
                              _correoController.text,
                              _contrasenaController.text,
                              _accesoEmpleadoController.text,
                              userEmpProvider.imageEmpelado,
                            );

                            if (success) {
                              setState(() {
                                _isButtonEnabled = true;
                              });
                              BotToast.showText(text: "Cuenta creada exitosamente");
                              Navigator.pop(context);
                            } else {
                              // Re-habilitar el botón después de un tiempo o evento
                              setState(() {
                                _isButtonEnabled = true;
                              });
                            }
                          }
                        }
                      } : null, // Deshabilita el botón si _isButtonEnabled es false
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.zero, // Ajusta el padding del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent, // Hace transparente el color de fondo del botón
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: ColorPalet.gradientBottomCompany,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          constraints: BoxConstraints(minWidth: sizeScreen.width), // Asegura que el botón tenga al menos el ancho de la pantalla
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta el padding interno del contenido del botón
                            child: Text(
                              'Guardar cambios',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  _separacionCampos(10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 28, 149, 187),
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }

  Text _nombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Color.fromARGB(255, 72, 86, 109),
          fontSize: 15,
          fontWeight: FontWeight.w500),
    );
  }

  Row _tituloForm(String titulo) {
    return Row(
      children: [
        Icon(
          Iconsax.firstline,
          color: Color.fromARGB(255, 29, 34, 44),
          size: 30,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          titulo,
          style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 72, 86, 109),
              fontFamily: 'sans',
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
