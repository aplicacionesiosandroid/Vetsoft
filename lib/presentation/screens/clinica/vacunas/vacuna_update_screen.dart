import 'package:bottom_picker/bottom_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:table_calendar/table_calendar.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/clinica/buscarPacientes_model.dart';
import '../../../../providers/clinica/vacuna/vacuna_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/clinica/vacuna/radiobuttonVacuna_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

void openModalBottomSheetVacuna(BuildContext context, ClinicaUpdateModel clinicaUpdate) {
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
                child: FormularioVacuna(clinicaUpdate: clinicaUpdate),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioVacuna extends StatefulWidget {
  final ClinicaUpdateModel clinicaUpdate;
  const FormularioVacuna({Key? key, required this.clinicaUpdate}) : super(key: key);
  @override
  _FormularioVacunaState createState() => _FormularioVacunaState();
}

class _FormularioVacunaState extends State<FormularioVacuna> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoCirugia = GlobalKey<FormState>();

  //editing controller para datos del dueno
  TextEditingController controllerCiCliente = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //controllers para CIRUGIA
  TextEditingController controllerContraQue = TextEditingController();
  TextEditingController controllerLaboratorio = TextEditingController();
  TextEditingController controllerSerie = TextEditingController();
  TextEditingController controllerProcedencia = TextEditingController();

  //Editing controller para agendar proxima visita
  final SignatureController controllerFirma = SignatureController(penStrokeWidth: 3, penColor: Colors.black, exportBackgroundColor: Colors.white);

  TextEditingController controllerCosto = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<VacunaProvider>(context, listen: false).selectedSquareVacuna == 2 ? 2 : 4;

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
        controllerCiCliente.text = widget.clinicaUpdate.data.propietario.ci;
        controllerNombre.text = widget.clinicaUpdate.data.propietario.nombres;
        controllerApellido.text = widget.clinicaUpdate.data.propietario.apellidos;
        controllerNumero.text = widget.clinicaUpdate.data.propietario.celular;
        controllerDireccion.text = widget.clinicaUpdate.data.propietario.direccion;
        controllerNombrePaciente.text = widget.clinicaUpdate.data.paciente.nombre;
        VacunaProvider dataVacuna = Provider.of<VacunaProvider>(context, listen: false);

        dataVacuna.setSelectedGender(widget.clinicaUpdate.data.paciente.sexo);
        controllerEdadPaciente.text = widget.clinicaUpdate.data.paciente.edad.toString();
        dataVacuna.setSelectedIdEspecie(widget.clinicaUpdate.data.paciente.especieId.toString());
        dataVacuna.setSelectedIdRaza(widget.clinicaUpdate.data.paciente.razaId.toString());
        dataVacuna.setDropTamanoMascota(widget.clinicaUpdate.data.paciente.tamao);
        dataVacuna.setDropTemperamento(widget.clinicaUpdate.data.paciente.temperamento);
        dataVacuna.setDropAlimentacion(widget.clinicaUpdate.data.paciente.alimentacion);
        controllerContraQue.text = widget.clinicaUpdate.data.vacuna!.contra;
        controllerLaboratorio.text = widget.clinicaUpdate.data.vacuna!.laboratorio;
        controllerSerie.text = widget.clinicaUpdate.data.vacuna!.serie;
        controllerProcedencia.text = widget.clinicaUpdate.data.vacuna!.procedencia;
        dataVacuna.setFechaExpiracion(widget.clinicaUpdate.data.vacuna!.fechaExpiracion.toString().substring(0, 10));
        if (widget.clinicaUpdate.data.archivo != null) {
          for (int i = 0; i < widget.clinicaUpdate.data.archivo!.length; i++) {
            if (widget.clinicaUpdate.data.archivo![i].vacuna != null) {
              dataVacuna.setArchivoVacuna(widget.clinicaUpdate.data.archivo![i].vacuna!);
            }
            if (widget.clinicaUpdate.data.archivo![i].fotoPaciente != null) {
              dataVacuna.getFromUrl(widget.clinicaUpdate.data.archivo![i].fotoPaciente!);
            }
          }
        }
        _onDaySelected(widget.clinicaUpdate.data.proximaVisita.fecha, widget.clinicaUpdate.data.proximaVisita.fecha);
        dataVacuna.setHoraSelected(widget.clinicaUpdate.data.proximaVisita.hora);
        dataVacuna.setIdEncargadoSelected(widget.clinicaUpdate.data.proximaVisita.encargadoId.toString());
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
    VacunaProvider dataVacuna = Provider.of<VacunaProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataVacuna.getEncargados;
    double valueLinearProgress = dataVacuna.selectedSquareVacuna == 2 ? 2 : 4;

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
            'Actualizar vacuna',
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
                  dataVacuna.selectedSquareVacuna == 2 ? ' de 2' : ' de 4',
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
                children: dataVacuna.selectedSquareVacuna == 2
                    ? [_datosCirugia(dataVacuna, sizeScreenWidth),
                      _datosProximaVisita(dataVacuna, sizeScreenWidth, listaVeterinarios)]
                    : [
                        _datosDelDueno(dataVacuna, sizeScreenWidth),
                        _datosPaciente(dataVacuna),
                        _datosCirugia(dataVacuna, sizeScreenWidth),
                        _datosProximaVisita(dataVacuna, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(VacunaProvider dataVacuna, double sizeScreenWidth) {
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
                _NombreCampos('C.I.'),
                _separacionCampos(15),
                TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerCiCliente,
                  hintText: 'Celula de Identidad (Ej: 123456)',
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

  Widget _datosPaciente(VacunaProvider dataVacuna) {
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
              RadioButtonReutilizableGeneroVacuna(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroVacuna(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroVacuna(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroVacuna(
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
                provider: dataVacuna,
              ),

              /* RadioButtonReutilizable(
                radioButton: RadioButtonModel(value: 'option1', label: 'Option 1'),
              ), */

              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<VacunaProvider>(builder: (context, provider, _) {
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
              Consumer<VacunaProvider>(
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
                value: dataVacuna.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataVacuna.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataVacuna.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataVacuna.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataVacuna.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataVacuna.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataVacuna.lastImage != null
                  ? getFotoPaciente(dataVacuna)
                  : SizedBox(
                      height: 300,
                      child: Card(
                        color: Color.fromARGB(220, 249, 249, 249),
                        elevation: 0,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: InkWell(
                            onTap: () {
                              dataVacuna.addPhoto();
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

  Widget _datosCirugia(VacunaProvider dataVacuna, double sizeScreenWidth) {
    String nombreLegible = path.basename(dataVacuna.fileArchivoVacuna);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _tituloForm('Datos de la vacuna'),
          _separacionCampos(20),
          _NombreCampos('Contra'),
          _separacionCampos(15),
          TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerContraQue, hintText: 'Ej: Parvovirus'),
          _separacionCampos(20),
          _NombreCampos('Laboratorio'),
          _separacionCampos(15),
          TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerLaboratorio, hintText: 'Ej:'),
          _separacionCampos(20),
          _NombreCampos('Serie'),
          _separacionCampos(15),
          TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerSerie, hintText: 'Ej: 001'),
          _separacionCampos(20),
          _NombreCampos('Procedencia'),
          _separacionCampos(15),
          TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerProcedencia, hintText: 'Ej: Farmacia La Paz'),
          _separacionCampos(20),
          _NombreCampos('Expiración'),
          _separacionCampos(15),
          InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 3 * 365)),
              ).then((value) {
                if (value != null) {
                  String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(value);
                  dataVacuna.setFechaExpiracion(formattedDateEnviar);
                }
              });
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
                  Icon(
                    Icons.calendar_month,
                    color: const Color.fromARGB(255, 139, 149, 166),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Center(
                    child: Text(
                      dataVacuna.fechaExpiracion,
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
          _NombreCampos('Agregar archivo'),
          _separacionCampos(15),
          dataVacuna.fileArchivoVacuna.isEmpty
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
                        //fileProvider.addFileCoprologia(fileName);
                        dataVacuna.setArchivoVacuna(fileName);
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
                      //fileProvider.addFileCoprologia(fileName);
                      dataVacuna.setArchivoVacuna(fileName);
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

  Widget _datosProximaVisita(VacunaProvider dataVacuna, double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
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
                  _openTimePicker(context, dataVacuna);
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
                      const SizedBox(
                        width: 10,
                      ),
                      dataVacuna.horaSelected.isEmpty
                          ? const Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataVacuna.horaSelected.substring(0, 5),
                              style: const TextStyle(
                                  color: Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
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
                  dataVacuna.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataVacuna.inicialEncargado,
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
                                      guardarIdVetEncargado(context, veterinario, dataVacuna);
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
              // const Row(
              //   children: [
              //     Icon(
              //       IconlyLight.more_square,
              //       color: Color.fromARGB(255, 29, 34, 44),
              //       size: 30,
              //     ),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Text(
              //       'Método de pago',
              //       style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
              //     ),
              //   ],
              // ),
              // _separacionCampos(20),
              // _NombreCampos('Costo'),
              // _separacionCampos(15),
              // Row(
              //   children: [
              //     Container(
              //       height: 60,
              //       width: sizeScreenWidth * 0.3,
              //       padding: EdgeInsets.all(8),
              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 249, 249, 249)),
              //       child: Row(
              //         children: [
              //           Image(
              //             image: AssetImage(
              //               'assets/img/bolivia.png',
              //             ),
              //             width: 35,
              //           ),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Text(
              //             'BOL',
              //             style: TextStyle(fontFamily: 'inter', fontSize: 14, color: const Color.fromARGB(255, 139, 149, 166)),
              //           ),
              //           Icon(Icons.keyboard_arrow_down_outlined, color: const Color.fromARGB(255, 139, 149, 166))
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Expanded(
              //       child: Container(child: TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), hintText: 'Bs. 0.00')),
              //     )
              //   ],
              // ),
              // RadioButtonEfecTransacVacuna(
              //   efecTransac: 'Efectivo',
              //   valor: 'EFECTIVO',
              // ),
              // RadioButtonEfecTransacVacuna(
              //   efecTransac: 'Transacción',
              //   valor: 'TRANSACCION',
              // ),
              // _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataVacuna
                          .actualizarDatos(
                        //propietario
                        controllerNombre.text,
                        controllerApellido.text,
                        controllerNumero.text,
                        controllerDireccion.text,
                        //paciente
                        controllerNombrePaciente.text,
                        dataVacuna.selectedSexoPaciente,
                        controllerEdadPaciente.text,
                        dataVacuna.selectedIdEspecie!,
                        dataVacuna.selectedIdRaza!,
                        dataVacuna.dropTamanoMascota,
                        dataVacuna.dropTemperamento,
                        dataVacuna.dropAlimentacion,
                        dataVacuna.lastImage!,

                        //cirugia
                        controllerContraQue.text,
                        controllerLaboratorio.text,
                        controllerSerie.text,
                        controllerProcedencia.text,
                        dataVacuna.fechaExpiracion,
                        dataVacuna.fileArchivoVacuna,

                        //proxima visita
                        dataVacuna.fechaVisitaSelected,
                        dataVacuna.horaSelected,
                        dataVacuna.idEncargadoSelected,
                        // documento e id de propietario
                        widget.clinicaUpdate.data.propietario.documento,
                        widget.clinicaUpdate.data.propietario.propietarioId,
                      )
                          .then((_) async {
                        if (dataVacuna.OkpostDatosVacuna) {
                          _mostrarFichaCreada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: dataVacuna.loadingDatosVacuna
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
                                  Provider.of<VacunaProvider>(context, listen: false).setSelectSquareVacuna(0);
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
                  Image(height: 220, width: 200, image: AssetImage('assets/img/done.png')),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Los datos del paciente y la información de la consulta se han guardado con éxito.',
                    style: TextStyle(color: const Color.fromARGB(255, 72, 86, 109), fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
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

  void guardarIdVetEncargado(BuildContext context, EncargadosVete encargadoVet, VacunaProvider dataVacuna) {
    dataVacuna.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataVacuna.setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    VacunaProvider dataVacuna = Provider.of<VacunaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataVacuna.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, VacunaProvider dataVacuna) {
    ///Obteniendo hora
    final timePicker = TimePickerHelper<VacunaProvider>(
      context: context,
      provider: dataVacuna,
      getHoraSelected: () => dataVacuna.horaSelected,
      setHoraSelected: dataVacuna.setHoraSelected,
    );
    timePicker.openTimePicker();
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

  Widget getFotoPaciente(VacunaProvider dataVacuna) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataVacuna.addPhoto();
          },
          child: Image.file(
            dataVacuna.lastImage!,
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
