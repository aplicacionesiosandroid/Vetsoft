import 'package:bottom_picker/bottom_picker.dart';
//import 'package:bottom_picker/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:table_calendar/table_calendar.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../../models/clinica/buscarPacientes_model.dart';
import '../../../../providers/clinica/cirugia/cirugia_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/clinica/cirugia/radiobuttonCirugia_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

void openModalBottomSheetCirugia(BuildContext context, ClinicaUpdateModel clinicaUpdate) {
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
                child: FormularioCirugia(clinicaUpdate: clinicaUpdate),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioCirugia extends StatefulWidget {
  final ClinicaUpdateModel clinicaUpdate;
  const FormularioCirugia({Key? key, required this.clinicaUpdate}) : super(key: key);
  @override
  _FormularioCirugiaState createState() => _FormularioCirugiaState();
}

class _FormularioCirugiaState extends State<FormularioCirugia> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoCirugia = GlobalKey<FormState>();

  //editing controller para datos del dueno
  TextEditingController controllerCiDueno = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //editing controller para datos clinicos
  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerTemperatura = TextEditingController();
  TextEditingController controllerFrecuenciaCar = TextEditingController();
  TextEditingController controllerFrecuenciaRes = TextEditingController();
  TextEditingController controllerLesiones = TextEditingController();
  TextEditingController controllerDesdeCuandoTieneMascota = TextEditingController();
  TextEditingController controllerDondeAdquirioMascota = TextEditingController();
  TextEditingController controllerEnfermedadesPadece = TextEditingController();
  TextEditingController controllerExpuestoEnfermedades = TextEditingController();
  TextEditingController controllerReaccionAlergica = TextEditingController();

  //controllers para CIRUGIA
  TextEditingController controllerTipoCirugia = TextEditingController();
  TextEditingController controllerAnestisicos = TextEditingController();
  TextEditingController controllerObserPreCirugia = TextEditingController();
  TextEditingController controllerObserPostOperatorio = TextEditingController();
  TextEditingController controllerRecomendacionCirugia = TextEditingController();

  //Editing controller para agendar proxima visita
  final SignatureController controllerFirma = SignatureController(penStrokeWidth: 3, penColor: Colors.black, exportBackgroundColor: Colors.white);

  TextEditingController controllerCosto = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<CirugiaProvider>(context, listen: false).selectedSquareCirugia == 2 ? 3 : 5;

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
        controllerCiDueno.text = widget.clinicaUpdate.data.propietario.ci;
        controllerNombre.text = widget.clinicaUpdate.data.propietario.nombres;
        controllerApellido.text = widget.clinicaUpdate.data.propietario.apellidos;
        controllerNumero.text = widget.clinicaUpdate.data.propietario.celular;
        controllerDireccion.text = widget.clinicaUpdate.data.propietario.direccion;
        controllerNombrePaciente.text = widget.clinicaUpdate.data.paciente.nombre;
        CirugiaProvider dataCirugia = Provider.of<CirugiaProvider>(context, listen: false);
        dataCirugia.setSelectedGender(widget.clinicaUpdate.data.paciente.sexo);
        controllerEdadPaciente.text = widget.clinicaUpdate.data.paciente.edad.toString();
        dataCirugia.setSelectedIdEspecie(widget.clinicaUpdate.data.paciente.especieId.toString());
        dataCirugia.setSelectedIdRaza(widget.clinicaUpdate.data.paciente.razaId.toString());
        dataCirugia.setDropTamanoMascota(widget.clinicaUpdate.data.paciente.tamao);
        dataCirugia.setDropTemperamento(widget.clinicaUpdate.data.paciente.temperamento);
        dataCirugia.setDropAlimentacion(widget.clinicaUpdate.data.paciente.alimentacion);
        dataCirugia.setDropMucosas(widget.clinicaUpdate.data.datosClinicos!.mucosas.toString());
        controllerPeso.text = widget.clinicaUpdate.data.datosClinicos!.peso.toString();
        controllerTemperatura.text = widget.clinicaUpdate.data.datosClinicos!.temperatura.toString();
        controllerFrecuenciaCar.text = widget.clinicaUpdate.data.datosClinicos!.frecuenciaCardiaca.toString();
        controllerFrecuenciaRes.text = widget.clinicaUpdate.data.datosClinicos!.frecuenciaRespiratoria.toString();
        dataCirugia.setDropHidratacion(widget.clinicaUpdate.data.datosClinicos!.hidratacion.toString());
        dataCirugia.setDropGanglios(widget.clinicaUpdate.data.datosClinicos!.gangliosLinfaticos.toString());
        controllerLesiones.text = widget.clinicaUpdate.data.datosClinicos!.lesiones;
        controllerDesdeCuandoTieneMascota.text = widget.clinicaUpdate.data.datosClinicos!.tiempoTenencia;
        dataCirugia.setSelectedExisteAnimal(widget.clinicaUpdate.data.datosClinicos!.otroAnimal);
        controllerDondeAdquirioMascota.text = widget.clinicaUpdate.data.datosClinicos!.origenMascota;
        controllerEnfermedadesPadece.text = widget.clinicaUpdate.data.datosClinicos!.enfermedadesPadecidas;
        controllerExpuestoEnfermedades.text = widget.clinicaUpdate.data.datosClinicos!.enfermedadesRecientes;
        dataCirugia.setSelectedAplicadoTratamiento((widget.clinicaUpdate.data.datosClinicos!.enferemedadTratamiento == "ninguna" ? "NO" : "SI"));
        dataCirugia.setSelectedVacunasAlDia((widget.clinicaUpdate.data.datosClinicos!.vacunasAldia));
        controllerReaccionAlergica.text = widget.clinicaUpdate.data.datosClinicos!.reaccionAlergica;
        if (widget.clinicaUpdate.data.archivo != null) {
          for (int i = 0; i < widget.clinicaUpdate.data.archivo!.length; i++) {
            if (widget.clinicaUpdate.data.archivo![i].autorizacionQuirurgica != null) {
              dataCirugia.setAutorizacionQuirurgica(widget.clinicaUpdate.data.archivo![i].autorizacionQuirurgica!);
            }
            if (widget.clinicaUpdate.data.archivo![i].fotoPaciente != null) {
              dataCirugia.getFromUrl(widget.clinicaUpdate.data.archivo![i].fotoPaciente!);
            }
            if (widget.clinicaUpdate.data.archivo![i].avancesPostOperatorios != null) {
              dataCirugia.getFromUrlCirugia(widget.clinicaUpdate.data.archivo![i].avancesPostOperatorios![0]);
            }
          }
        }
        controllerTipoCirugia.text = widget.clinicaUpdate.data.cirugia!.tipoCirugia;
        controllerAnestisicos.text = widget.clinicaUpdate.data.cirugia!.anestesicos;
        controllerObserPreCirugia.text = widget.clinicaUpdate.data.cirugia!.observacionesPrecirugia;
        controllerObserPostOperatorio.text = widget.clinicaUpdate.data.cirugia!.postOperatorio;
        controllerRecomendacionCirugia.text = "";
        _onDaySelected(widget.clinicaUpdate.data.proximaVisita.fecha, widget.clinicaUpdate.data.proximaVisita.fecha);
        dataCirugia.setHoraSelected(widget.clinicaUpdate.data.proximaVisita.hora);
        dataCirugia.setIdEncargadoSelected(widget.clinicaUpdate.data.proximaVisita.encargadoId.toString());
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
    CirugiaProvider dataCirugia = Provider.of<CirugiaProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataCirugia.getEncargados;
    double valueLinearProgress = dataCirugia.selectedSquareCirugia == 2 ? 3 : 5;

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
            'Actualizar cirugía',
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
                  dataCirugia.selectedSquareCirugia == 2 ? ' de 3' : ' de 5',
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
                children:
                // dataCirugia.selectedSquareCirugia == 2
                //     ? [
                //         _datosClinicos(dataCirugia, sizeScreenWidth),
                //         _datosCirugia(dataCirugia, sizeScreenWidth),
                //         _datosProximaVisita(dataCirugia, sizeScreenWidth, listaVeterinarios)
                //       ]
                //     : [
                [
                  _datosDelDueno(dataCirugia, sizeScreenWidth),
                  _datosPaciente(dataCirugia),
                  _datosClinicos(dataCirugia, sizeScreenWidth),
                  _datosCirugia(dataCirugia, sizeScreenWidth),
                  _datosProximaVisita(dataCirugia, sizeScreenWidth, listaVeterinarios)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(CirugiaProvider dataCirugia, double sizeScreenWidth) {
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
                  controller: controllerCiDueno,
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

  Widget _datosPaciente(CirugiaProvider dataCirugia) {
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
              RadioButtonReutilizableGeneroCirugia(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroCirugia(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroCirugia(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroCirugia(
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
                provider: dataCirugia,
              ),
              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<CirugiaProvider>(builder: (context, provider, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(220, 249, 249, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    isExpanded: false,
                    style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontSize: 15, fontFamily: 'inter'),
                    value: provider.selectedIdEspecie,
                    onChanged: (value) {
                      provider.setSelectedIdEspecie(value.toString());
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
              Consumer<CirugiaProvider>(
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
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
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
                value: dataCirugia.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataCirugia.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataCirugia.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataCirugia.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataCirugia.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataCirugia.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataCirugia.lastImage != null
                  ? getFotoPaciente(dataCirugia)
                  : SizedBox(
                      height: 300,
                      child: Card(
                        color: Color.fromARGB(220, 249, 249, 249),
                        elevation: 0,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: InkWell(
                            onTap: () {
                              dataCirugia.addPhoto();
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

  Widget _datosClinicos(CirugiaProvider dataCirugia, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS
            mainAxisSize: MainAxisSize.min,
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
                    'Datos clínicos',
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _separacionCampos(15),
              _NombreCampos('Mucosas'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataCirugia.dropMucosas,
                options: const ['NORMALES', 'ANEMICOS', 'CIANOTICAS', 'ICTERIAS'],
                onChanged: (value) {
                  dataCirugia.setDropMucosas(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Peso'),
              _separacionCampos(15),
              TextFormFieldNumberConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerPeso, hintText: 'Peso (Ej: 10,7)'),
              _separacionCampos(15),
              _NombreCampos('Temperatura'),
              _separacionCampos(15),
              TextFormFieldNumberConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerTemperatura,
                  hintText: 'Temperatura del paciente (Ej: ºC 37)'),
              _separacionCampos(15),
              _NombreCampos('Frecuencia cardíaca'),
              _separacionCampos(15),
              TextFormFieldNumberConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerFrecuenciaCar,
                  hintText: 'Frecuencia cardíaca del paciente'),
              _separacionCampos(15),
              _NombreCampos('Frecuencia respiratoria'),
              _separacionCampos(15),
              TextFormFieldNumberConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerFrecuenciaRes,
                  hintText: 'Frecuencia respiratoria del paciente'),
              _separacionCampos(15),
              _NombreCampos('Nivel de hidratación'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataCirugia.dropHidratacion,
                options: const ['HIDRATADO', 'SEMIHIDRATO', 'DESHIDRATADO'],
                onChanged: (value) {
                  dataCirugia.setDropHidratacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Ganglios linfáticos'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataCirugia.dropGanglios,
                options: const ['NORMALES', 'INFLAMADOS'],
                onChanged: (value) {
                  dataCirugia.setDropGanglios(value.toString());
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Lesiones'),
              _separacionCampos(15),
              Container(
                width: double.infinity,
                child: TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerLesiones,
                  hintText: 'Describa aquí las lesiones (Ej: Cojera, raspones, cortes, etc.)',
                  maxLines: 5,
                ),
              ),
              _separacionCampos(20),
              _NombreCampos('¿Desde cuando tiene a la mascota?'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerDesdeCuandoTieneMascota, hintText: 'Ej. 2 años'),
              _separacionCampos(10),
              Row(
                children: [
                  Expanded(
                    child: _NombreCampos('¿Existe algun animal en casa?'),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiExisteAlgunAnimalCirugia(
                      siOno: 'Si',
                      valor: 'SI',
                    ),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiExisteAlgunAnimalCirugia(
                      siOno: 'No',
                      valor: 'NO',
                    ),
                  ),
                ],
              ),
              _separacionCampos(20),
              _NombreCampos('¿En donde adquirió la mascota?'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerDondeAdquirioMascota, hintText: 'Ej. Refugio de animales'),
              _separacionCampos(20),
              _NombreCampos('¿Qué enfermedades ha padecido?'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerEnfermedadesPadece, hintText: 'Ej. Moquillo'),
              _separacionCampos(20),
              _NombreCampos('¿Ha estado expuesto recientemente a enfermedades infectocontagiosas?'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerExpuestoEnfermedades, hintText: '¿Cual?'),
              _separacionCampos(20),
              Row(
                children: [
                  Expanded(
                    child: _NombreCampos('¿Se le ha aplicado algún tratamiento para la enfermedad actual?'),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiAplicadoTratamientoCirugia(
                      siOno: 'Si',
                      valor: 'SI',
                    ),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiAplicadoTratamientoCirugia(
                      siOno: 'No',
                      valor: 'NO',
                    ),
                  ),
                ],
              ),
              _separacionCampos(20),
              Row(
                children: [
                  Expanded(
                    child: _NombreCampos('¿Tiene las vacunas al día?'),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiVacunasAlDiaCirugia(
                      siOno: 'Si',
                      valor: 'SI',
                    ),
                  ),
                  Container(
                    width: 70,
                    child: RadioButtonReutiVacunasAlDiaCirugia(
                      siOno: 'No',
                      valor: 'NO',
                    ),
                  ),
                ],
              ),
              _separacionCampos(20),
              _NombreCampos('¿Alguno reacción alérgica a medicamento o vacuna?'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerReaccionAlergica, hintText: 'Ej: Vacuna antirrabica'),
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

  Widget _datosCirugia(CirugiaProvider dataCirugia, double sizeScreenWidth) {
    String nombreLegible = path.basename(dataCirugia.fileAutorizacionQuirurgica);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Datos de la cirugía'),
              _separacionCampos(20),
              _NombreCampos('Tipo de cirugía'),
              _separacionCampos(15),
              TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerTipoCirugia, hintText: 'Tipo cirugía'),
              _separacionCampos(20),
              _NombreCampos('Autorización quirúrgica'),
              _separacionCampos(15),
              InkWell(
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
                    dataCirugia.setAutorizacionQuirurgica(fileName);
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _separacionCampos(20),
              _NombreCampos('Anestésicos'),
              _separacionCampos(15),
              TextFormFieldConHint(colores: const Color.fromARGB(255, 140, 228, 233), controller: controllerAnestisicos, hintText: 'Ej: Propofol'),
              _separacionCampos(20),
              _NombreCampos('Observaciones pre-cirugía'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  maxLines: 6,
                  controller: controllerObserPreCirugia,
                  hintText: 'Escriba cualquier observación o recomendación relevante sobre la pre-cirugía aqui'),
              _separacionCampos(20),
              _tituloForm('Post operatorio'),
              _separacionCampos(20),
              _NombreCampos('Observaciones'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  maxLines: 6,
                  controller: controllerObserPostOperatorio,
                  hintText: 'Agregue cualquier nota sobre el post operatorio que sea importante para el cuidado del paciente'),
              _separacionCampos(20),
              _NombreCampos('Avances post operatorios'),
              _separacionCampos(15),
              dataCirugia.imageCirugia != null
                  ? getFotoCirugia(dataCirugia)
                  : SizedBox(
                      height: 300,
                      child: Card(
                        color: Color.fromARGB(220, 249, 249, 249),
                        elevation: 0,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: InkWell(
                            onTap: () {
                              dataCirugia.addPhotoCirugia();
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
                                    'Añadir foto',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 94, 99, 102), fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'inter'),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
              _separacionCampos(20),
              _NombreCampos('Tratamiento'),
              _separacionCampos(15),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataCirugia.controllersTratamientoCirugia.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            SizedBox(
                                width: 30,
                                child: Icon(
                                  Icons.message_outlined,
                                  color: const Color.fromARGB(255, 139, 149, 166),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormFieldConHint(
                                  colores: const Color.fromARGB(255, 140, 228, 233),
                                  controller: dataCirugia.controllersTratamientoCirugia[index],
                                  hintText: 'Tratamiento ${index + 1}',
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  );
                },
              ),
              _separacionCampos(15),
              Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2), borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    dataCirugia.agregarTratamiento();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        size: 25,
                        color: Color.fromARGB(255, 139, 149, 166),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Agregar tratamiento',
                        style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontFamily: 'sans', fontSize: 14, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              _separacionCampos(20),
              _NombreCampos('Recomendaciones'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerRecomendacionCirugia,
                  hintText: 'Escriba aqui el recomendaciones adicionales para el cuidado de la mascota (Ej. Dieta blanca)',
                  maxLines: 5),
              _separacionCampos(20),
              _tituloForm('Firma eletrónica'),
              _separacionCampos(15),
              _NombreCampos('Firma eletrónica'),
              _separacionCampos(15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                width: sizeScreenWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Signature(
                        controller: controllerFirma,
                        width: sizeScreenWidth,
                        height: 200,
                        backgroundColor: Color.fromARGB(255, 249, 249, 249),
                      ),
                      Positioned(
                          left: 5,
                          top: 5,
                          child: IconButton(
                              onPressed: () {
                                controllerFirma.clear();
                              },
                              icon: Icon(Icons.clear)))
                    ],
                  ),
                ),
              ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataCirugia.saveSignature(controllerFirma, context, dataCirugia);
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

  Widget _datosProximaVisita(CirugiaProvider dataCirugia, double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
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
                  _openTimePicker(context, dataCirugia);
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
                      dataCirugia.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataCirugia.horaSelected.substring(0, 5),
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
                  dataCirugia.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataCirugia.inicialEncargado,
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
                                      guardarIdVetEncargado(context, veterinario, dataCirugia);
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
              //       child: const Row(
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
              //       child: Container(child: TextFormFieldNumberConHint(colores: const Color.fromARGB(255, 140, 228, 233), hintText: 'Bs. 0.00')),
              //     )
              //   ],
              // ),
              // RadioButtonEfecTransacCirugia(
              //   efecTransac: 'Efectivo',
              //   valor: 'EFECTIVO',
              // ),
              // RadioButtonEfecTransacCirugia(
              //   efecTransac: 'Transacción',
              //   valor: 'TRANSACCION',
              // ),
              // _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataCirugia
                          .actualizarDatos(
                        //propietario
                        controllerNombre.text,
                        controllerApellido.text,
                        controllerNumero.text,
                        controllerDireccion.text,
                        //paciente
                        controllerNombrePaciente.text,
                        dataCirugia.selectedSexoPaciente,
                        controllerEdadPaciente.text,
                        dataCirugia.selectedIdEspecie!,
                        dataCirugia.selectedIdRaza!,
                        dataCirugia.dropTamanoMascota,
                        dataCirugia.dropTemperamento,
                        dataCirugia.dropAlimentacion,
                        dataCirugia.lastImage!,

                        //datos clinicos
                        dataCirugia.dropMucosas,
                        controllerPeso.text,
                        controllerTemperatura.text,
                        controllerFrecuenciaCar.text,
                        controllerFrecuenciaRes.text,
                        dataCirugia.dropHidratacion,
                        dataCirugia.dropGanglios,
                        controllerLesiones.text,
                        controllerDesdeCuandoTieneMascota.text,
                        dataCirugia.selectedExisteAnimalEnCasa,
                        controllerDondeAdquirioMascota.text,
                        controllerEnfermedadesPadece.text,
                        dataCirugia.selectedExpuestoAEnfermedad,
                        dataCirugia.selectedAplicadoTratamiento,
                        dataCirugia.selectedVacunasAlDia,
                        controllerReaccionAlergica.text,

                        //cirugia
                        controllerTipoCirugia.text,
                        dataCirugia.fileAutorizacionQuirurgica,
                        controllerAnestisicos.text,
                        controllerObserPreCirugia.text,
                        controllerObserPostOperatorio.text,
                        dataCirugia.lastImageCirugia!,
                        dataCirugia.controllersTratamientoCirugia,
                        controllerRecomendacionCirugia.text,
                        //proxima visita
                        dataCirugia.fechaVisitaSelected,
                        dataCirugia.horaSelected,
                        dataCirugia.idEncargadoSelected,
                        dataCirugia.signatureImageFirma,
                        // documento e id de propietario
                        widget.clinicaUpdate.data.propietario.documento,
                        widget.clinicaUpdate.data.propietario.propietarioId,
                      )
                          .then((_) async {
                        if (dataCirugia.OkpostDatosCirugia) {
                          _mostrarFichaCreada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: dataCirugia.loadingDatosCirugia
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
                                  Provider.of<CirugiaProvider>(context, listen: false).setSelectSquareCirugia(0);
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
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  'Los datos del paciente y la información de la cirugía se han guardado con éxito.',
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
        );
      },
    );
  }

  void guardarIdVetEncargado(BuildContext context, EncargadosVete encargadoVet, CirugiaProvider dataCirugia) {
    print('ID: ${encargadoVet.encargadoVeteId}, Inicial del nombre: ${encargadoVet.nombres[0].toUpperCase()}');

    dataCirugia.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataCirugia.setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    CirugiaProvider dataCirugia = Provider.of<CirugiaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataCirugia.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, CirugiaProvider dataCirugia) {
    final timePicker = TimePickerHelper<CirugiaProvider>(
      context: context,
      provider: dataCirugia,
      getHoraSelected: () => dataCirugia.horaSelected,
      setHoraSelected: dataCirugia.setHoraSelected,
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

  Widget getFotoPaciente(CirugiaProvider dataCirugia) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataCirugia.addPhoto();
          },
          child: Image.file(
            dataCirugia.lastImage!,
            height: 310,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget getFotoCirugia(CirugiaProvider dataCirugia) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataCirugia.addPhotoCirugia();
          },
          child: Image.file(
            dataCirugia.lastImageCirugia!,
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
