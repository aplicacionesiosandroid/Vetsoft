import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/cuenta/user.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/empleado/update_info_adicional.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/widget/personal_admin.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/widget/radio_buttons.dart';
import 'package:vet_sotf_app/presentation/widgets/dropDown_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/horario/mostrar_snack_bar.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/account/account_empleado_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';

import '../../../../config/global/palet_colors.dart';

class InfoPersonalFormularioScreen extends StatelessWidget {
  const InfoPersonalFormularioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final dataEmpProvider = Provider.of<AccountEmpProvider>(context);
    final userEmpProvider = Provider.of<UserEmpProvider>(context);
    final userInfoPersonal = ModalRoute.of(context)!.settings.arguments as User;

    if (userEmpProvider.user == null) {
      userEmpProvider.fetchUserData().catchError((error) {
        print('Error in fetchUserData: $error');
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 99, 92, 255),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizeScreen.height * 0.03,
            ),
            Container(
              width: sizeScreen.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: IconButton(
                      iconSize: 35,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Iconsax.arrow_left),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Información personal',
                    style: TextStyle(
                      color: ColorPalet.grisesGray0,
                      fontFamily: 'sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: sizeScreen.width,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        onTap: (index) {
                          dataEmpProvider.updateTabIndex(index);
                        },
                        tabs: const [
                          Tab(text: 'Datos personales'),
                          Tab(text: 'Información adicional'),
                        ],
                        isScrollable: true,
                        labelColor: ColorPalet.secondaryDefault,
                        unselectedLabelColor: ColorPalet.grisesGray2,
                        indicatorColor: Color.fromARGB(255, 100, 92, 248),
                        labelStyle: TextStyle(
                          fontFamily: 'sans',
                          color: ColorPalet.grisesGray2,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            UpdateInfoPersonalScreen(userInfoPersonal: userInfoPersonal),
                            UpdateInfoAdicionalScreen(userInfoPersonal: userInfoPersonal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateInfoPersonalScreen extends StatefulWidget {
  final User userInfoPersonal;
  const UpdateInfoPersonalScreen({required this.userInfoPersonal});

  @override
  State<UpdateInfoPersonalScreen> createState() => _UpdateInfoPersonalScreenState();
}

class _UpdateInfoPersonalScreenState extends State<UpdateInfoPersonalScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _numIdentificacionController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();


  String _selectedPaisNacimiento = 'Bolivia';
  String _selectedCiudadNacimiento = 'La Paz';
  String _selectedPaisResidencia = 'Bolivia';
  String _selectedCiudadResidencia = 'La Paz';

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

    setState(() {
      _nombreController.text = userInfoPersonal.informacionPersonal.nombres;
      _apellidoController.text = userInfoPersonal.informacionPersonal.apellidos;
      _telefonoController.text = userInfoPersonal.informacionPersonal.telefono;
      _numIdentificacionController.text = userInfoPersonal.informacionPersonal.numIdentificacion;
      _direccionController.text = userInfoPersonal.informacionPersonal.direccion;
      _alturaController.text = userInfoPersonal.informacionPersonal.altura;
      _selectedPaisResidencia = userInfoPersonal.informacionPersonal.paisResidencia;
      _selectedCiudadResidencia = userInfoPersonal.informacionPersonal.ciudadResidencia;
      _selectedPaisNacimiento = userInfoPersonal.informacionPersonal.paisNacimiento;
      _selectedCiudadNacimiento = userInfoPersonal.informacionPersonal.ciudadNacimiento;
    });

    final userEmpProvider = Provider.of<UserEmpProvider>(context, listen: false);
    userEmpProvider.setFechanNacimiento(userInfoPersonal.informacionPersonal.fechaNacimiento);
    userEmpProvider.setSelectedGender(userInfoPersonal.informacionPersonal.sexo);
    userEmpProvider.setSelectedEstadoCivil(userInfoPersonal.informacionPersonal.estadoCivil);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _numIdentificacionController.dispose();
    _direccionController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  bool _isButtonEnabled = true; // Variable para habilitar o deshabilitar el botón de guardar

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final userEmpProvider = Provider.of<UserEmpProvider>(context);

    User? user = userEmpProvider.user;
    final userInfoPersonal = ModalRoute.of(context)!.settings.arguments as User;



    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: sizeScreen.height * 0.15,
          //   width: sizeScreen.width,
          //   child: Center(
          //     child: Stack(
          //       children: [
          //         CircleAvatar(
          //           backgroundImage: userEmpProvider.lastImageProfile != null
          //               ? FileImage(userEmpProvider.lastImageProfile!)
          //               : AssetImage('assets/img/user.png') as ImageProvider,
          //           radius: sizeScreen.width * 0.13,
          //         ),
          //         Positioned(
          //           right: 0,
          //           bottom: 0,
          //           child: Container(
          //             width: sizeScreen.height * 0.04,
          //             height: sizeScreen.height * 0.04,
          //             decoration: BoxDecoration(
          //               color: ColorPalet.primaryDefault,
          //               borderRadius: BorderRadius.circular(50),
          //             ),
          //             child: Icon(
          //               Iconsax.camera,
          //               color: ColorPalet.grisesGray5,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          _separacionCampos(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos personales'),
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
                _nombreCampos('Fecha de nacimiento'),
                _separacionCampos(15),
                InkWell(
                  onTap: () {
                    dataTimeFechaNacimiento(context, userEmpProvider, sizeScreen.width);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 249, 249, 249)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: Color.fromARGB(255, 139, 149, 166),
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        userEmpProvider.fechaNacimiento.isEmpty
                            ? Text(
                          'Seleccionar fecha y hora',
                          style: TextStyle(
                              color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                        )
                            : Text(
                          "${userEmpProvider.fechaNacimiento.replaceAll("-", "/")}",
                          style: TextStyle(
                              color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
                _separacionCampos(20),
                _nombreCampos('País de nacimiento'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedPaisNacimiento,
                  options: const ['Bolivia', 'Peru', 'Chile'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaisNacimiento = newValue ?? 'Bolivia';
                    });
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(20),
                _nombreCampos('Ciudad de nacimiento'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedCiudadNacimiento,
                  options: const [
                    'La Paz',
                    'Oruro',
                    'Tarija',
                    'Santa Cruz',
                    'Sucre',
                    'Beni',
                    'Pando',
                    'Cochabamba',
                    'Potosi',
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCiudadNacimiento = newValue ?? 'La Paz';
                    });
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(20),
                _tituloForm('Identificación'),
                _separacionCampos(20),
                _nombreCampos('Número de identificación'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _numIdentificacionController,
                  hintText: '1000-LP',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(15),
                RadioButtonConsultaGenero(),
                _separacionCampos(15),
                RadioButtonEstadoCivil(),
                _separacionCampos(20),
                _tituloForm('Residencia'),
                _separacionCampos(20),
                _nombreCampos('Dirección de residencia'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _direccionController,
                  hintText: 'Dirección de residencial (Ej: Federico Jofre)',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(20),
                _nombreCampos('Altura'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  controller: _alturaController,
                  hintText: 'Número de la dirección (Ej: 1234)',
                  colores: ColorPalet.secondaryDefault,
                ),
                _separacionCampos(20),
                _nombreCampos('País de residencia'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedPaisResidencia,
                  options: const ['Bolivia', 'Peru', 'Chile', 'Argentina', 'Brasil'],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaisResidencia = newValue ?? 'Bolivia';
                    });
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(20),
                _nombreCampos('Ciudad de residencia'),
                _separacionCampos(15),
                CustomDropdown(
                  value: _selectedCiudadResidencia,
                  options: const [
                    'La Paz',
                    'Oruro',
                    'Tarija',
                    'El Alto'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCiudadResidencia = newValue ?? 'La Paz';
                    });
                  },
                  hintText: 'Seleccionar...',
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

                      InformacionPersonal updatedInfo = InformacionPersonal(
                        email: user?.informacionPersonal.email ?? '',
                        password: user?.informacionPersonal.password ?? '',
                        nombres: _nombreController.text,
                        apellidos: _apellidoController.text,
                        telefono: _telefonoController.text,
                        fechaNacimiento: userEmpProvider.fechaNacimiento,
                        paisNacimiento: _selectedPaisNacimiento,
                        ciudadNacimiento: _selectedCiudadNacimiento,
                        numIdentificacion: _numIdentificacionController.text,
                        sexo: userEmpProvider.selectedGenero,
                        estadoCivil: userEmpProvider.selectedEstadoCivil,
                        direccion: _direccionController.text,
                        altura: _alturaController.text,
                        paisResidencia: _selectedPaisResidencia,
                        ciudadResidencia: _selectedCiudadResidencia,
                      );

                      bool success = await userEmpProvider.updatePersonalInformation(updatedInfo);
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
                    } : null, // Deshabilitar el botón si _isButtonEnabled es false
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

