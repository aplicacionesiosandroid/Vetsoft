import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/cuenta/user.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/widget/personal_admin.dart';
import 'package:vet_sotf_app/presentation/widgets/dropDown_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../config/global/palet_colors.dart';

class UpdateInfoAdicionalScreen extends StatefulWidget {
  final User userInfoPersonal;

  const UpdateInfoAdicionalScreen({required this.userInfoPersonal});

  @override
  State<UpdateInfoAdicionalScreen> createState() => _UpdateInfoAdicionalScreenState();
}

class _UpdateInfoAdicionalScreenState extends State<UpdateInfoAdicionalScreen> {
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  String _selectedParentesco = 'Amigo';
  String _selectedTipoSanguineo = 'ORH+';
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    // Cargar los datos del usuario al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final userInfoPersonal = widget.userInfoPersonal;

    _nombreController.text = userInfoPersonal.informacionAdicional.referenciaEmergencia.nombres;
    _apellidoController.text = userInfoPersonal.informacionAdicional.referenciaEmergencia.apellidos;
    _telefonoController.text = userInfoPersonal.informacionAdicional.referenciaEmergencia.celular;
    _alergiasController.text = userInfoPersonal.informacionAdicional.alergias;
    _selectedParentesco = userInfoPersonal.informacionAdicional.referenciaEmergencia.parentesco;
    _selectedTipoSanguineo = userInfoPersonal.informacionAdicional.grupoSanguineo;

    final userEmpProvider = Provider.of<UserEmpProvider>(context, listen: false);
    userEmpProvider.setfileCV(userInfoPersonal.informacionAdicional.formacion?.cv ?? '');
    userEmpProvider.addFilesTitulosDiplomas(userInfoPersonal.informacionAdicional.formacion!.titulosDiplomas);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _alergiasController.dispose();
    _telefonoController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final userEmpProvider = Provider.of<UserEmpProvider>(context);

    String nombreLegible = path.basename(userEmpProvider.fileCV);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _separacionCampos(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos de salud'),
                _separacionCampos(20),
                _nombreCampos('Grupo sanguíneo'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedTipoSanguineo,
                  options: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'ORH+', 'ORH-', 'No sé'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTipoSanguineo = newValue ?? 'AB-';
                    });
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(20),
                _nombreCampos('Alergias'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _alergiasController,
                  hintText: 'Escriba una alergia...',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(25),
                _tituloForm('Referencia de emergencia'),
                _separacionCampos(20),
                _nombreCampos('Nombre'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _nombreController,
                  hintText: 'Nombre (Ej: Matías)',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(20),
                _nombreCampos('Apellido'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _apellidoController,
                  hintText: 'Apellido (Ej: Pérez)',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(20),
                _nombreCampos('Número de teléfono'),
                _separacionCampos(15),
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: sizeScreen.width * 0.3,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 249, 249, 249),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage('assets/img/bolivia.png'),
                            width: 35,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '+591',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 14,
                              color: Color.fromARGB(255, 139, 149, 166),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Color.fromARGB(255, 139, 149, 166),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextFormFieldNumberConHintValidator(
                        controller: _telefonoController,
                        colores: Color.fromARGB(255, 140, 228, 233),
                        hintText: 'Número (Ej: 67778786)',
                      ),
                    ),
                  ],
                ),
                _separacionCampos(20),
                _nombreCampos('Parentesco'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedParentesco,
                  options: const [
                    'Amigo', 'Familiar', 'Compañero de trabajo', 'Conocido', 'Vecino'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedParentesco = newValue ?? 'Amigo';
                    });
                  },
                  hintText: 'Seleccionar...',
                ),

                _separacionCampos(25),
                _tituloForm('Formación'),
                _separacionCampos(20),
                _nombreCampos('CV'),
                _separacionCampos(15),
                Container(
                  height: 45,
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
                        userEmpProvider.setfileCV(fileName);
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
                ),
                _separacionCampos(20),
                _nombreCampos('Títulos y diplomas'),
                _separacionCampos(15),
                userEmpProvider.fileTitulosDiplomas.isEmpty
                    ? addFileTitulosDiplomasIsEmpty(context)
                    : Row(
                    children: [
                    ArchivosTitulosDiplomas(
                      sizeScreen: sizeScreen.width,
                    ),
                    AddFileTitulosDiplomas(),
                  ],
                ),
                _separacionCampos(20),
                SizedBox(
                  height: sizeScreen.height * 0.05,
                  width: sizeScreen.width,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? () async {
                      setState(() {
                        _isButtonEnabled = false;
                      });
                      InformacionAdicional updatedInfo = InformacionAdicional(
                        grupoSanguineo: _selectedTipoSanguineo,
                        alergias: _alergiasController.text,
                        referenciaEmergencia: ReferenciaEmergencia(
                          nombres: _nombreController.text,
                          apellidos: _apellidoController.text,
                          celular: _telefonoController.text,
                          parentesco: _selectedParentesco,
                        ),
                       formacion: Formacion(
                         cv: userEmpProvider.fileCV,
                         titulosDiplomas: userEmpProvider.fileTitulosDiplomas,
                       ),
                      );
                      bool success = await userEmpProvider.updatePersonalInformationAdicional(updatedInfo);
                      if (success) {

                        // Re-habilitar el botón después de un tiempo o evento
                        setState(() {
                          _isButtonEnabled = true;
                        });
                      } else {

                        // Re-habilitar el botón después de un tiempo o evento
                        setState(() {
                          _isButtonEnabled = true;
                        });
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 115, 92, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Guardar cambios',
                      style: TextStyle(
                        color: ColorPalet.grisesGray5,
                        fontFamily: 'inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _separacionCampos(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container addFileTitulosDiplomasIsEmpty(context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2), borderRadius: BorderRadius.circular(10)),
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

          final fileProvider = Provider.of<UserEmpProvider>(context, listen: false);
          final fileName = await selectFile();
          if (fileName != null) {
            fileProvider.addFileTitulosDiplomas(fileName);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.add_square,
              size: 25,
              color: Color.fromARGB(255, 139, 149, 166),
            ),
            SizedBox(
              width: 8,
            ),
            const Text(
              'Agregar título o diploma',
              style: TextStyle(color: const Color.fromARGB(255, 139, 149, 166), fontFamily: 'sans', fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
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

