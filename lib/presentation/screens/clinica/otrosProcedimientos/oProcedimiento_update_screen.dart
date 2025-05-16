import 'package:bottom_picker/bottom_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/models/clinica/buscarPacientes_model.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/providers/clinica/otrosProcedimientos/otrosProcedimientos_provider.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../providers/clinica/programarCita/programarCita_provider.dart';
import '../../../widgets/clinica/otrosProcedimientos/radiobuttonDesparacitacion_widget.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';
import '../programarCita/programarCita_screen.dart';

void openModalBottomSheetOProcedimiento(BuildContext context, ClinicaUpdateModel clinicaUpdate) {
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
                child: FormularioOProcedimiento(clinicaUpdate: clinicaUpdate),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioOProcedimiento extends StatefulWidget {
  final ClinicaUpdateModel clinicaUpdate;
  const FormularioOProcedimiento({
    Key? key,
    required this.clinicaUpdate,
  }) : super(key: key);
  @override
  _FormularioOProcedimientoState createState() => _FormularioOProcedimientoState();
}

class _FormularioOProcedimientoState extends State<FormularioOProcedimiento> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoCirugia = GlobalKey<FormState>();

  //editing controller para datos del dueno
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //controllers para OTRO PROCEDIMIENTO
  TextEditingController controllerTipoDeProcedimiento = TextEditingController();

  //Editing controller para agendar proxima visita
  TextEditingController controllerCosto = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<OProcedimientosProvider>(context, listen: false).selectedSquareOProced == 2 ? 2 : 4;

    if (_currentPage < numPages) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controllerNombre.text = widget.clinicaUpdate.data.propietario.nombres;
        controllerApellido.text = widget.clinicaUpdate.data.propietario.apellidos;
        controllerNumero.text = widget.clinicaUpdate.data.propietario.celular;
        controllerDireccion.text = widget.clinicaUpdate.data.propietario.direccion;
        controllerNombrePaciente.text = widget.clinicaUpdate.data.paciente.nombre;
        OProcedimientosProvider dataOProced = Provider.of<OProcedimientosProvider>(context, listen: false);
        dataOProced.setSelectedGender(widget.clinicaUpdate.data.paciente.sexo);
        controllerEdadPaciente.text = widget.clinicaUpdate.data.paciente.edad.toString();
        dataOProced.setSelectedIdEspecie(widget.clinicaUpdate.data.paciente.especieId.toString());
        dataOProced.setSelectedIdRaza(widget.clinicaUpdate.data.paciente.razaId.toString());
        dataOProced.setDropTamanoMascota(widget.clinicaUpdate.data.paciente.tamao);
        dataOProced.setDropTemperamento(widget.clinicaUpdate.data.paciente.temperamento);
        dataOProced.setDropAlimentacion(widget.clinicaUpdate.data.paciente.alimentacion);
        controllerTipoDeProcedimiento.text = widget.clinicaUpdate.data.datosClinicos?.procedimiento ?? '';
        dataOProced.setArchivoOProcedimiento(widget.clinicaUpdate.data.datosClinicos!.procedimientoArchivo!);
        if (widget.clinicaUpdate.data.archivo != null) {
          for (int i = 0; i < widget.clinicaUpdate.data.archivo!.length; i++) {
            if (widget.clinicaUpdate.data.archivo![i].fotoPaciente != null) {
              dataOProced.getFromUrl(widget.clinicaUpdate.data.archivo![i].fotoPaciente!);
            }
          }
        }
        _onDaySelected(widget.clinicaUpdate.data.proximaVisita.fecha, widget.clinicaUpdate.data.proximaVisita.fecha);
        dataOProced.setHoraSelected(widget.clinicaUpdate.data.proximaVisita.hora);
        dataOProced.setIdEncargadoSelected(widget.clinicaUpdate.data.proximaVisita.encargadoId.toString());
        //List<EncargadosVete> listaVeterinarios = dataConsulta.getEncargados;
        // dataConsulta.setInicialEncargado(listaVeterinarios
        //     .firstWhere((element) => element.encargadoVeteId == widget.clinicaUpdate.data.proximaVisita.encargadoId)
        //     .nombres[0]
        //     .toUpperCase()
        //     .toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    OProcedimientosProvider dataOProced = Provider.of<OProcedimientosProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataOProced.getEncargados;
    double valueLinearProgress = dataOProced.selectedSquareOProced == 2 ? 2 : 4;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              _mostrarAlertaCancelar(context);
            },
            icon: const Icon(
              IconlyLight.arrow_left,
              color: Color.fromARGB(255, 29, 34, 44),
              size: 30,
            ),
          ),
          title: const Text(
            'Actualizar otro procedimiento',
            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontWeight: FontWeight.w700),
          )),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Paso ${_currentPage + 1}',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 121, 177), fontFamily: 'inter', fontWeight: FontWeight.w400),
                ),
                Text(
                  dataOProced.selectedSquareOProced == 2 ? ' de 2' : ' de 4',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 139, 149, 166), fontFamily: 'inter', fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: (_currentPage + 1) / valueLinearProgress,
                backgroundColor: Color.fromARGB(255, 246, 248, 251),
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 26, 202, 212)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: dataOProced.selectedSquareOProced == 2
                    ? [_datosOtroProced(dataOProced, sizeScreenWidth), _datosProximaVisita(dataOProced, sizeScreenWidth, listaVeterinarios)]
                    : [
                        _datosDelDueno(dataOProced, sizeScreenWidth),
                        _datosPaciente(dataOProced),
                        _datosOtroProced(dataOProced, sizeScreenWidth),
                        _datosProximaVisita(dataOProced, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(OProcedimientosProvider dataOProced, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKeyDuenoCirugia,
          child: Column(
              //DATOS DEL DUENO

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      IconlyLight.more_square,
                      color: Color.fromARGB(255, 29, 34, 44),
                      size: 30,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Datos del dueño',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                _separacionCampos(20),
                _NombreCampos('Nombre'),
                _separacionCampos(15),
                TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerNombre,
                  hintText: 'Nombre (Ej: Miguel)',
                ),
                _separacionCampos(20),
                _NombreCampos('Apellidos'),
                _separacionCampos(20),
                TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerApellido,
                  hintText: 'Apellido (Ej: Perez)',
                ),
                _separacionCampos(20),
                _NombreCampos('Número'),
                _separacionCampos(15),
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: sizeScreenWidth * 0.3,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 249, 249, 249)),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/img/bolivia.png',
                            ),
                            width: 35,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '+591',
                            style: TextStyle(fontFamily: 'inter', fontSize: 14, color: const Color.fromARGB(255, 139, 149, 166)),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined, color: const Color.fromARGB(255, 139, 149, 166))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        child: TextFormFieldNumberConHintValidator(
                          colores: const Color.fromARGB(255, 140, 228, 233),
                          controller: controllerNumero,
                          hintText: 'Número (Ej: 67778786)',
                        ),
                      ),
                    )
                  ],
                ),
                _separacionCampos(15),
                _NombreCampos('Dirección'),
                _separacionCampos(15),
                TextFormFieldConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerDireccion,
                  hintText: 'Dirección  (Ceja)',
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        //dataConsulta
                        //    .sendDatosDueno(
                        //        controllerNombre.text,
                        //        controllerApellido.text,
                        //        controllerNumero.text,
                        //        controllerDireccion.text)
                        //    .then((_) async {
                        //  if (dataConsulta.OksendDatosDueno) {

                        if (_formKeyDuenoCirugia.currentState!.validate()) {
                          _nextPage();
                        }

                        // }
                        //});
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _previousPage();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color.fromARGB(255, 28, 149, 187), width: 1.5), borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Cancelar',
                        style:
                            TextStyle(color: const Color.fromARGB(255, 28, 149, 187), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosPaciente(OProcedimientosProvider dataOProced) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS DEL DUENO

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    IconlyLight.more_square,
                    color: Color.fromARGB(255, 29, 34, 44),
                    size: 30,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Datos del paciente',
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              _separacionCampos(20),
              _NombreCampos('Nombre del paciente'),
              _separacionCampos(15),
              TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerNombrePaciente,
                hintText: 'Bigotes',
              ),
              _separacionCampos(15),
              _NombreCampos('Sexo'),
              _separacionCampos(15),
              RadioButtonReutilizableGeneroOProcedimi(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroOProcedimi(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroOProcedimi(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroOProcedimi(
                gender: 'Hembra esterilizada',
                valor: 'HC',
              ),
              _separacionCampos(20),
              _NombreCampos('Edad'),
              _separacionCampos(15),
              TextFormFieldNumberEdad(
                colores: const Color.fromARGB(255, 140, 228, 233),
                hintText: 'Edad',
                controller: controllerEdadPaciente,
                provider: dataOProced,
              ),
              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<OProcedimientosProvider>(builder: (context, provider, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(220, 249, 249, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    icon: const Icon(CupertinoIcons.chevron_down),
                    isExpanded: false,
                    style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontSize: 15, fontFamily: 'inter'),
                    value: provider.selectedIdEspecie,
                    onChanged: (value) {
                      provider.setSelectedIdEspecie(value!);
                    },
                    items: provider.getEspecies.map((especie) {
                      return DropdownMenuItem<String>(
                        value: especie.id.toString(),
                        child: Text(especie.nombre),
                      );
                    }).toList(),
                    hint: Text(
                      'Seleccionar',
                      style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontSize: 15, fontFamily: 'inter'),
                    ),
                  ),
                );
              }),
              _separacionCampos(15),
              _NombreCampos('Raza'),
              _separacionCampos(15),
              Consumer<OProcedimientosProvider>(
                builder: (context, provider, _) {
                  // Lista de elementos existentes
                  List<DropdownMenuItem<String>> existingItems = provider.getRazas.map((raza) {
                    return DropdownMenuItem<String>(
                      value: raza.id.toString(),
                      child: Text(raza.nombre),
                    );
                  }).toList();

                  // Agregar un elemento adicional para añadir una nueva raza
                  existingItems.add(DropdownMenuItem<String>(
                      value: 'nueva_raza',
                      child: Text('Añadir nueva raza...',style: TextStyle(color: Colors.black),)
                  ),);

                  return Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(220, 249, 249, 249),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      icon: const Icon(CupertinoIcons.chevron_down),
                      isExpanded: false,
                      style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter',
                      ),
                      value: provider.selectedIdRaza,
                      onChanged: (value) {
                        if (value == 'nueva_raza') {
                          provider.setSelectedIdRaza(null);
                          dialogAddRaza(context, provider);
                        } else {
                          provider.setSelectedIdRaza(value!);
                        }
                      },
                      items: existingItems,
                      hint: Text(
                        'Seleccionar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter',
                        ),
                      ),
                    ),
                  );
                },
              ),
              _separacionCampos(15),
              _NombreCampos('Tamaño de la mascota'),
              _separacionCampos(15),
              CustomDropdownSize(
                value: dataOProced.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataOProced.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataOProced.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataOProced.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataOProced.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataOProced.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataOProced.lastImage != null
                  ? getFotoPaciente(dataOProced)
                  : SizedBox(
                      height: 300,
                      child: Card(
                        color: Color.fromARGB(220, 249, 249, 249),
                        elevation: 0,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: InkWell(
                            onTap: () {
                              dataOProced.addPhoto();
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 30,
                                    color: Color.fromARGB(255, 94, 99, 102),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Añadir foto del paciente',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 94, 99, 102), fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'inter'),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _nextPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                    )),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _previousPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color.fromARGB(255, 28, 149, 187), width: 1.5), borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 28, 149, 187), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosOtroProced(OProcedimientosProvider dataOProced, double sizeScreenWidth) {
    String nombreLegible = path.basename(dataOProced.fileArchivoOProcedimiento);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _tituloForm('Datos del procedimiento'),
          _separacionCampos(20),
          _NombreCampos('Tipo de procedimiento'),
          _separacionCampos(15),
          TextFormFieldConHint(
              colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerTipoDeProcedimiento, hintText: 'Ej: Drontal Plus'),
          _separacionCampos(20),
          _NombreCampos('Agregar archivo'),
          _separacionCampos(15),
          dataOProced.fileArchivoOProcedimiento.isEmpty
              ? Container(
                  height: 50,
                  decoration:
                      BoxDecoration(border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2), borderRadius: BorderRadius.circular(10)),
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
                        dataOProced.setArchivoOProcedimiento(fileName);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: 25,
                          color: Color.fromARGB(255, 139, 149, 166),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Añadir archivo',
                          style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontFamily: 'sans', fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                )
              : InkWell(
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
                      dataOProced.setArchivoOProcedimiento(fileName);
                    }
                  },
                  child: Container(
                    height: 60,
                    width: sizeScreenWidth,
                    //padding: EdgeInsets.only(top: 15, bottom: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 249, 249, 249)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Center(
                          child: Text(
                            nombreLegible,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 139, 149, 166),
                              fontSize: 15,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          _separacionCampos(20),
          _separacionCampos(20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _nextPage();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 28, 149, 187),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                )),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _previousPage();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color.fromARGB(255, 28, 149, 187), width: 1.5), borderRadius: BorderRadius.circular(12))),
                child: Text(
                  'Atrás',
                  style: TextStyle(color: const Color.fromARGB(255, 28, 149, 187), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                )),
          ),
        ]),
      ),
    );
  }

  Widget _datosProximaVisita(OProcedimientosProvider dataOProced, double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    IconlyLight.more_square,
                    color: Color.fromARGB(255, 29, 34, 44),
                    size: 30,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Próxima visita',
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              _separacionCampos(20),
              TableCalendar(
                onDaySelected: _onDaySelected,

                selectedDayPredicate: (day) => isSameDay(day, today),
                locale: 'es_ES',
                rowHeight: 43,
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: false),
                availableGestures: AvailableGestures.all,
                focusedDay: today,
                firstDay: DateTime.utc(2023, 02, 10),
                lastDay: DateTime.utc(2030, 02, 10),
                // Resto de las propiedades y personalización del TableCalendar
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Colors.transparent,
                        //shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromARGB(255, 136, 64, 255), width: 2)),
                    selectedTextStyle: TextStyle(color: const Color.fromARGB(255, 136, 64, 255))),
              ),
              _separacionCampos(20),
              _NombreCampos('Hora'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, dataOProced);
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
                          Icons.access_time,
                          color: Color.fromARGB(255, 139, 149, 166),
                          size: 28,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      dataOProced.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataOProced.horaSelected,
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                            )
                    ],
                  ),
                ),
              ),
              _separacionCampos(20),
              _NombreCampos('Encargados'),
              _separacionCampos(15),
              Row(
                children: [
                  Container(child: Icon(IconlyLight.user_1, color: const Color.fromARGB(255, 139, 149, 166), size: 28)),
                  SizedBox(
                    width: 15,
                  ),
                  dataOProced.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataOProced.inicialEncargado,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Encargados',
                                    style: TextStyle(
                                        color: const Color.fromARGB(255, 29, 34, 44), fontSize: 16, fontFamily: 'sans', fontWeight: FontWeight.w700)),
                                Divider()
                              ],
                            ),
                            content: Container(
                              height: 300,
                              width: sizeScreenWidth,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listaVeterinarios.length,
                                itemBuilder: (context, index) {
                                  final veterinario = listaVeterinarios[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 2),
                                    leading: CircleAvatar(
                                      backgroundColor: Color.fromARGB(255, 47, 26, 125),
                                      child: Text(
                                        veterinario.nombres[0],
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ), // Mostrar el ID a la izquierda
                                    title: Text('${veterinario.nombres}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 29, 34, 44),
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    subtitle: Text('${veterinario.apellidos}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 139, 149, 166),
                                            fontSize: 12,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    onTap: () {
                                      guardarIdVetEncargado(context, veterinario, dataOProced);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50), border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2)),
                        child: Icon(Icons.add, color: const Color.fromARGB(255, 139, 149, 166), size: 20)),
                  ),
                ],
              ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataOProced
                          .actualizarDatos(
                        //propietario
                        controllerNombre.text,
                        controllerApellido.text,
                        controllerNumero.text,
                        controllerDireccion.text,
                        //paciente
                        controllerNombrePaciente.text,
                        dataOProced.selectedSexoPaciente,
                        controllerEdadPaciente.text,
                        dataOProced.selectedIdEspecie!,
                        dataOProced.selectedIdRaza!,
                        dataOProced.dropTamanoMascota,
                        dataOProced.dropTemperamento,
                        dataOProced.dropAlimentacion,
                        dataOProced.lastImage!,

                        //otro procedimiento

                        controllerTipoDeProcedimiento.text,
                        dataOProced.fileArchivoOProcedimiento,

                        //proxima visita
                        dataOProced.fechaVisitaSelected,
                        dataOProced.horaSelected,
                        dataOProced.idEncargadoSelected,

                        // documento e id de propietario
                        widget.clinicaUpdate.data.propietario.documento,
                        widget.clinicaUpdate.data.propietario.propietarioId,
                      )
                          .then((_) async {
                        if (dataOProced.OkpostDatosOProcedimientos) {
                          _mostrarFichaCreada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: dataOProced.loadingDatosOProcedimientos
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : const Text(
                            'Finalizar',
                            style: TextStyle(fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                          )),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _previousPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color.fromARGB(255, 28, 149, 187), width: 1.5), borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 28, 149, 187), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  void _mostrarAlertaCancelar(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '¿Estás seguro/a de querer volver atrás?',
              style: TextStyle(color: const Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontWeight: FontWeight.w700, fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: const Text(
                      'No se guardarán los cambios que hayas realizado.',
                      style: TextStyle(color: const Color.fromARGB(255, 72, 86, 109), fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<OProcedimientosProvider>(context, listen: false).setSelectSquareOproced(0);
                                  // Cerrar el AlertDialog
                                  Navigator.of(context).pop();
                                  //cierra bottomSheet
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Color.fromARGB(255, 255, 85, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: const Text(
                                  'Volver',
                                  style: TextStyle(fontFamily: 'inter', fontSize: 13, fontWeight: FontWeight.w600),
                                )),
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
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Color.fromARGB(255, 28, 149, 187),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: const Text(
                                  'Quedarme aquí',
                                  style: TextStyle(fontFamily: 'inter', fontSize: 13, fontWeight: FontWeight.w600),
                                )),
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
      },
    );
  }

  void _mostrarFichaCreada(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '¡Registro actualizado con éxito!',
              style: TextStyle(color: const Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontWeight: FontWeight.w700, fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: 350,
              child: Column(
                children: [
                  const Image(height: 220, width: 200, image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '¡Genial! El registro ha sido acutalizado correctamente.',
                    style: TextStyle(color: const Color.fromARGB(255, 72, 86, 109), fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<OProcedimientosProvider>(context, listen: false)
                            ..setOKsendDatosOProcedimientos(false)
                            ..setSelectSquareOproced(0);
                          // Cerrar el AlertDialog
                          Navigator.of(context).pop();
                          //cierra bottomSheet
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 28, 149, 187),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void guardarIdVetEncargado(BuildContext context, EncargadosVete encargadoVet, OProcedimientosProvider dataOProced) {
    dataOProced.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataOProced.setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    OProcedimientosProvider dataOProced = Provider.of<OProcedimientosProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataOProced.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, OProcedimientosProvider dataOProced) {
    BottomPicker.time(
      title: 'Selecciona un horario',
      titleStyle: const TextStyle(
        fontFamily: 'sans',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Color.fromARGB(255, 29, 34, 44),
      ),
      dismissable: true,
      onSubmit: (index) {
        DateTime dateTime = DateTime.parse(index.toString());
        String formattedTime = DateFormat.Hm().format(dateTime);
        dataOProced.setHoraSelected(formattedTime);

        //print(index);
      },
      onClose: () {
        print('Picker closed');
      },
      //bottomPickerTheme: BottomPickerTheme.orange,
      use24hFormat: false,
    ).show(context);
  }

  Row _tituloForm(String titulo) {
    return Row(
      children: [
        Icon(
          IconlyLight.more_square,
          color: Color.fromARGB(255, 29, 34, 44),
          size: 30,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          titulo,
          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget getFotoPaciente(OProcedimientosProvider dataoProced) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataoProced.addPhoto();
          },
          child: Image.file(
            dataoProced.lastImage!,
            height: 310,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(color: Color.fromARGB(255, 72, 86, 109), fontSize: 15, fontWeight: FontWeight.w500),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }
}
