import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:table_calendar/table_calendar.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/clinica/datosparametricos_model.dart';
import '../../../../providers/clinica/consulta/consulta_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

void openModalBottomSheetConsultaActualizar(
    BuildContext context, ClinicaUpdateModel clinicaUpdate) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child:
                    FormularioConsultaActualizar(clinicaUpdate: clinicaUpdate),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioConsultaActualizar extends StatefulWidget {
  final ClinicaUpdateModel clinicaUpdate;
  const FormularioConsultaActualizar({Key? key, required this.clinicaUpdate})
      : super(key: key);
  @override
  _FormularioConsultaActualizarState createState() =>
      _FormularioConsultaActualizarState();
}

class _FormularioConsultaActualizarState
    extends State<FormularioConsultaActualizar> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDueno = GlobalKey<FormState>();
  final _formkeyPaciente = GlobalKey<FormState>();
  final _formkeyDatosClinicos = GlobalKey<FormState>();
  final _formkeyDatosMotivoConsulta = GlobalKey<FormState>();
  final _formkeyDiagnostico = GlobalKey<FormState>();
  final _formkeyTratamiento = GlobalKey<FormState>();
  final _formkeyProximaVisita = GlobalKey<FormState>();
  final _formkeyFacturacion = GlobalKey<FormState>();

  //editing controller para datos del dueno
  TextEditingController controllerCiDueno = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();
  TextEditingController controllerDocumentoCI = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //editing controller para datos clinicos
  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerTemperatura = TextEditingController();
  TextEditingController controllerFrecuenciaCar = TextEditingController();
  TextEditingController controllerFrecuenciaRes = TextEditingController();
  TextEditingController controllerLesiones = TextEditingController();
  TextEditingController controllerDesdeCuandoTieneMascota =
      TextEditingController();
  TextEditingController controllerDondeAdquirioMascota =
      TextEditingController();
  TextEditingController controllerEnfermedadesPadece = TextEditingController();
  TextEditingController controllerExpuestoEnfermedades =
      TextEditingController();
  TextEditingController controllerReaccionAlergica = TextEditingController();

  //editing controller para datos de peticion de muestras y pruebas
  TextEditingController controllerMuestrasRequeridas = TextEditingController();
  TextEditingController controllerPruebasRequeridas = TextEditingController();

  //editing controller para datos de diagnostico
  TextEditingController controllerListaProblemas = TextEditingController();
  TextEditingController controllerDiagnostico = TextEditingController();
  TextEditingController controllerDiagnosticoDiferencial =
      TextEditingController();

  //Editing controller para tratamiento
  TextEditingController controllerRecomendaciones = TextEditingController();

  //Editing controller para agendar proxima visita
  final SignatureController controllerFirma = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  //controllers para datos de facrturacion
  TextEditingController controllerCIoNit = TextEditingController();
  TextEditingController controllerApellidoFactura = TextEditingController();
  TextEditingController controllerNombreFactura = TextEditingController();
  TextEditingController controllerMontoEfectivo = TextEditingController();
  TextEditingController controllerCodeDescuento = TextEditingController();

  Future<void> scanQrConsulta() async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      controllerCodeDescuento.text = qrScanRes;
      double uno = double.tryParse(controllerMontoEfectivo.text) ?? 0.0;
      double dos = double.tryParse(controllerCodeDescuento.text) ?? 0.0;
      double total = uno - dos;
      // ignore: use_build_context_synchronously
      Provider.of<ConsultaProvider>(context, listen: false)
          .setTotalACobrarFacturacion = total.toString();
    } on PlatformException {
      qrScanRes = 'failed scan';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ConsultaProvider dataConsulta =
            Provider.of<ConsultaProvider>(context, listen: false);
        controllerCiDueno.text =
            widget.clinicaUpdate.data.propietario.documento;
        controllerNombre.text = widget.clinicaUpdate.data.propietario.nombres;
        controllerApellido.text =
            widget.clinicaUpdate.data.propietario.apellidos;
        controllerNumero.text = widget.clinicaUpdate.data.propietario.celular;
        controllerDireccion.text =
            widget.clinicaUpdate.data.propietario.direccion;
        controllerNombrePaciente.text =
            widget.clinicaUpdate.data.paciente.nombre;
        dataConsulta.setSelectedGender(widget.clinicaUpdate.data.paciente.sexo);
        controllerEdadPaciente.text = widget.clinicaUpdate.data.paciente.edad;
        dataConsulta.setselectedAge(
            widget.clinicaUpdate.data.paciente.tipoEdad == "años"
                ? "anios"
                : "meses");
        dataConsulta.setSelectedIdEspecie(
            widget.clinicaUpdate.data.paciente.especieId.toString());
        dataConsulta.setSelectedIdRaza(
            widget.clinicaUpdate.data.paciente.razaId.toString());
        dataConsulta
            .setDropTamanoMascota(widget.clinicaUpdate.data.paciente.tamao);
        dataConsulta.setDropTemperamento(
            widget.clinicaUpdate.data.paciente.temperamento);
        dataConsulta.setDropAlimentacion(
            widget.clinicaUpdate.data.paciente.alimentacion);
        dataConsulta
            .setDropMucosas(widget.clinicaUpdate.data.datosClinicos!.mucosas);
        controllerPeso.text = widget.clinicaUpdate.data.datosClinicos!.peso;
        controllerTemperatura.text =
            widget.clinicaUpdate.data.datosClinicos!.temperatura;
        controllerFrecuenciaCar.text =
            widget.clinicaUpdate.data.datosClinicos!.frecuenciaCardiaca;
        controllerFrecuenciaRes.text =
            widget.clinicaUpdate.data.datosClinicos!.frecuenciaRespiratoria;
        dataConsulta.setDropHidratacion(
            widget.clinicaUpdate.data.datosClinicos!.hidratacion);
        dataConsulta.setDropGanglios(
            widget.clinicaUpdate.data.datosClinicos!.gangliosLinfaticos);
        controllerLesiones.text =
            widget.clinicaUpdate.data.datosClinicos!.lesiones;
        controllerDesdeCuandoTieneMascota.text =
            widget.clinicaUpdate.data.datosClinicos!.tiempoTenencia;
        dataConsulta.setSelectedExisteAnimal(
            widget.clinicaUpdate.data.datosClinicos!.otroAnimal);
        controllerDondeAdquirioMascota.text =
            widget.clinicaUpdate.data.datosClinicos!.origenMascota;
        controllerEnfermedadesPadece.text =
            widget.clinicaUpdate.data.datosClinicos!.enfermedadesPadecidas;
        controllerExpuestoEnfermedades.text =
            widget.clinicaUpdate.data.datosClinicos!.enfermedadesRecientes;
        dataConsulta.setSelectedAplicadoTratamiento(
            (widget.clinicaUpdate.data.datosClinicos!.enferemedadTratamiento ==
                    "ninguna")
                ? "NO"
                : "SI");
        dataConsulta.setSelectedVacunasAlDia(
            widget.clinicaUpdate.data.datosClinicos!.vacunasAldia);
        controllerReaccionAlergica.text =
            widget.clinicaUpdate.data.datosClinicos!.reaccionAlergica;
        controllerMuestrasRequeridas.text =
            widget.clinicaUpdate.data.peticionesMuestras?.muestrasRequeridas ??
                '';
        controllerPruebasRequeridas.text =
            widget.clinicaUpdate.data.peticionesMuestras?.pruebasRequeridas ??
                '';
        dataConsulta.clearFileHemograma();
        dataConsulta.clearFileQuimSanguinea();
        dataConsulta.clearFileAntibiograma();
        dataConsulta.clearFileRadiografia();
        dataConsulta.clearFileEcografia();
        dataConsulta.clearFileCoprologia();

        for (int i = 0; i < widget.clinicaUpdate.data.archivo!.length; i++) {
          if (widget.clinicaUpdate.data.archivo![i].tipo == "HEMOGRAMA") {
            dataConsulta.addFileHemograma(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].tipo ==
              "QUIMICA SANGUINEA") {
            dataConsulta.addFileQuimSanguinea(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].tipo == "ANTIBIOGRAMA") {
            dataConsulta.addFileAntibiograma(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].tipo == "RADIOGRAFIAS") {
            dataConsulta.addFileRadiografia(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].tipo == "ECOGRAFIAS") {
            dataConsulta.addFileEcografia(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].tipo == "COPROLOGIA") {
            dataConsulta.addFileCoprologia(
                widget.clinicaUpdate.data.archivo![i].archivo!);
          }
          if (widget.clinicaUpdate.data.archivo![i].fotoPaciente != null) {
            dataConsulta.getFromUrl(
                widget.clinicaUpdate.data.archivo![i].fotoPaciente!);
          }
        }
        controllerListaProblemas.text =
            widget.clinicaUpdate.data.diagnostico?.listaProblemas ?? '';
        controllerDiagnostico.text =
            widget.clinicaUpdate.data.diagnostico?.diagnostico ?? '';
        controllerDiagnosticoDiferencial.text =
            widget.clinicaUpdate.data.diagnostico?.diagnosticoDiferencial ?? '';
        dataConsulta.clearTratamientos();
        for (int i = 0;
            i < widget.clinicaUpdate.data.tratamientos!.length;
            i++) {
          dataConsulta.controllersTratamiento.add(TextEditingController(
              text: widget.clinicaUpdate.data.tratamientos![i].descripcion));
        }
        controllerRecomendaciones.text =
            widget.clinicaUpdate.data.recomendacionTratamiento ?? '';
        _onDaySelected(widget.clinicaUpdate.data.proximaVisita.fecha,
            widget.clinicaUpdate.data.proximaVisita.fecha);
        dataConsulta.setHoraSelected(
            widget.clinicaUpdate.data.proximaVisita.hora.substring(0, 5) ?? '');
        dataConsulta.setIdEncargadoSelected(
            widget.clinicaUpdate.data.proximaVisita.encargadoId.toString());
        dataConsulta.setInicialEncargado(dataConsulta.getEncargados
            .firstWhere((element) =>
                element.encargadoVeteId ==
                widget.clinicaUpdate.data.proximaVisita.encargadoId)
            .nombres[0]
            .toUpperCase()
            .toString());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<ConsultaProvider>(context, listen: false)
                .selectedSquareConsulta ==
            2
        ? 6
        : 8;

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
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    ConsultaProvider dataConsulta =
        Provider.of<ConsultaProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataConsulta.getEncargados;
    List<DatosParametricos> listaDatosParametricos =
        dataConsulta.getdatosParametricos;
    double valueLinearProgress =
        dataConsulta.selectedSquareConsulta == 2 ? 6 : 7;

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
            'Actualizar consulta',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700),
          )),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Paso ${_currentPage + 1}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 121, 177),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  dataConsulta.selectedSquareConsulta == 2 ? ' de 6' : ' de 7',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 139, 149, 166),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400),
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
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 26, 202, 212)),
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
                children: dataConsulta.selectedSquareConsulta == 2
                    ? [
                        _datosClinicos(dataConsulta, sizeScreenWidth),
                        _datosPeticionPruebasMuestras(
                            dataConsulta, sizeScreenWidth),
                        _datosMotivoConsulta(
                            dataConsulta, listaDatosParametricos),
                        _datosInfoAdicional(
                            dataConsulta, listaDatosParametricos),
                        _datosDiagnostico(dataConsulta),
                        _datosTratamiento(dataConsulta, sizeScreenWidth),
                        _datosProximaVisita(
                            dataConsulta, sizeScreenWidth, listaVeterinarios)
                      ]
                    : [
                        _datosDelDueno(dataConsulta, sizeScreenWidth),
                        _datosPaciente(dataConsulta),
                        _datosClinicos(dataConsulta, sizeScreenWidth),
                        _datosPeticionPruebasMuestras(
                            dataConsulta, sizeScreenWidth),
                        _datosDiagnostico(dataConsulta),
                        _datosTratamiento(dataConsulta, sizeScreenWidth),
                        _datosProximaVisita(
                            dataConsulta, sizeScreenWidth, listaVeterinarios),
                        //_datosFacturacion(dataConsulta, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(ConsultaProvider dataConsulta, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKeyDueno,
          child: Column(
              //DATOS DEL DUENO

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos del dueño'),
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 249, 249, 249)),
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
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 14,
                                color:
                                    const Color.fromARGB(255, 139, 149, 166)),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined,
                              color: const Color.fromARGB(255, 139, 149, 166))
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
                        if (_formKeyDueno.currentState!.validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorPalet.complementVerde2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _mostrarAlertaCancelar(context);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 28, 149, 187),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 149, 187),
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosPaciente(ConsultaProvider dataConsulta) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyPaciente,
          child: Column(
              //DATOS DEL DUENO
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos del paciente'),
                _separacionCampos(20),
                _NombreCampos('Nombre del paciente'),
                _separacionCampos(15),
                TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerNombrePaciente,
                  hintText: 'Bigotes',
                ),
                _separacionCampos(15),
                _NombreCampos('Sexo'),
                _separacionCampos(15),
                RadioButtonReutilizableConsultaGenero(
                  gender: 'Macho intacto',
                  valor: 'M',
                ),
                RadioButtonReutilizableConsultaGenero(
                  gender: 'Macho castrado',
                  valor: 'MC',
                ),
                RadioButtonReutilizableConsultaGenero(
                  gender: 'Hembra intacta',
                  valor: 'H',
                ),
                RadioButtonReutilizableConsultaGenero(
                  gender: 'Hembra esterilizada',
                  valor: 'HC',
                ),
                _separacionCampos(20),
                _NombreCampos('Edad'),
                _separacionCampos(15),
                TextFormFieldNumberEdad(
                  colores: Color.fromARGB(255, 26, 202, 212),
                  hintText: 'Edad',
                  controller: controllerEdadPaciente,
                  provider: dataConsulta,
                ),
                _separacionCampos(15),
                _NombreCampos('Especie'),
                _separacionCampos(15),
                Consumer<ConsultaProvider>(builder: (context, provider, _) {
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
                          fontFamily: 'inter'),
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
                        style: TextStyle(
                            color: Color.fromARGB(255, 139, 149, 166),
                            fontSize: 15,
                            fontFamily: 'inter'),
                      ),
                    ),
                  );
                }),
                _separacionCampos(15),
                _NombreCampos('Raza'),
                _separacionCampos(15),
                Consumer<ConsultaProvider>(
                  builder: (context, provider, _) {
                    // Lista de elementos existentes
                    List<DropdownMenuItem<String>> existingItems =
                        provider.getRazas.map((raza) {
                      return DropdownMenuItem<String>(
                        value: raza.id.toString(),
                        child: Text(raza.nombre),
                      );
                    }).toList();
                    // Agregar un elemento adicional para añadir una nueva raza
                    existingItems.add(
                      DropdownMenuItem<String>(
                          value: 'nueva_raza',
                          child: Text(
                            'Añadir nueva raza...',
                            style: TextStyle(color: Colors.black),
                          )),
                    );
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
                  value: dataConsulta.dropTamanoMascota,
                  options: const ['G', 'M', 'P'],
                  onChanged: (value) {
                    dataConsulta.setDropTamanoMascota(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Temperamento'),
                _separacionCampos(15),
                CustomDropdownTemperament(
                  value: dataConsulta.dropTemperamento,
                  options: const ['S', 'C', 'A', 'M'],
                  onChanged: (value) {
                    dataConsulta.setDropTemperamento(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Alimentación'),
                _separacionCampos(15),
                CustomDropdownFood(
                  value: dataConsulta.dropAlimentacion,
                  options: const ['C', 'M', 'B'],
                  onChanged: (value) {
                    dataConsulta.setDropAlimentacion(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                dataConsulta.lastImage != null
                    ? getFotoPaciente(dataConsulta)
                    : SizedBox(
                        height: 300,
                        child: Card(
                          color: Color.fromARGB(220, 249, 249, 249),
                          elevation: 0,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          child: InkWell(
                              onTap: () {
                                dataConsulta.addPhoto();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.gallery_add,
                                      size: 30,
                                      color: Color.fromARGB(255, 94, 99, 102),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Añadir foto del paciente',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 94, 99, 102),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'inter'),
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
                        if (_formkeyPaciente.currentState!.validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
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
                              side: BorderSide(
                                  color: Color.fromARGB(255, 28, 149, 187),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 149, 187),
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosClinicos(ConsultaProvider dataConsulta, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyDatosClinicos,
          child: Column(
              //DATOS CLINICOS
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos clínicos'),
                _separacionCampos(
                  20,
                ),
                _separacionCampos(15),
                _NombreCampos('Mucosas'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataConsulta.dropMucosas,
                  options: const [
                    'NORMALES',
                    'ANEMICOS',
                    'CIANOTICAS',
                    'ICTERIAS'
                  ],
                  onChanged: (value) {
                    dataConsulta.setDropMucosas(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Peso'),
                _separacionCampos(15),
                TextFormFieldNumberConHintValidator(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerPeso,
                    hintText: 'Peso (Ej: 10,7)'),
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
                TextFormFieldNumberConHintValidator(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerFrecuenciaCar,
                    hintText: 'Frecuencia cardíaca del paciente'),
                _separacionCampos(15),
                _NombreCampos('Frecuencia respiratoria'),
                _separacionCampos(15),
                TextFormFieldNumberConHintValidator(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerFrecuenciaRes,
                    hintText: 'Frecuencia respiratoria del paciente'),
                _separacionCampos(15),
                _NombreCampos('Nivel de hidratación'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataConsulta.dropHidratacion,
                  options: const ['HIDRATADO', 'SEMIHIDRATO', 'DESHIDRATADO'],
                  onChanged: (value) {
                    dataConsulta.setDropHidratacion(value.toString());
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Ganglios linfáticos'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataConsulta.dropGanglios,
                  options: const ['NORMALES', 'INFLAMADOS'],
                  onChanged: (value) {
                    dataConsulta.setDropGanglios(value!);
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
                    hintText:
                        'Describa aquí las lesiones (Ej: Cojera, raspones, cortes, etc.)',
                    maxLines: 5,
                  ),
                ),
                _separacionCampos(20),
                _NombreCampos('¿Desde cuando tiene a la mascota?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDesdeCuandoTieneMascota,
                    hintText: 'Ej. 2 años'),
                _separacionCampos(10),
                Row(
                  children: [
                    Expanded(
                      child: _NombreCampos('¿Existe algun animal en casa?'),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiExisteAlgunAnimalConsulta(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiExisteAlgunAnimalConsulta(
                        siOno: 'No',
                        valor: 'NO',
                      ),
                    ),
                  ],
                ),
                MensajeValidadorSelecciones(
                  validator: (_) =>
                      dataConsulta.selectedExisteAnimalEnCasa == ''
                          ? 'Por favor, seleccione una opción.'
                          : null,
                ),
                _separacionCampos(20),
                _NombreCampos('¿En donde adquirió la mascota?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDondeAdquirioMascota,
                    hintText: 'Ej. Refugio de animales'),
                _separacionCampos(20),
                _NombreCampos('¿Qué enfermedades ha padecido?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerEnfermedadesPadece,
                    hintText: 'Ej. Moquillo'),
                _separacionCampos(20),
                _NombreCampos(
                    '¿Ha estado expuesto recientemente a enfermedades infectocontagiosas?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerExpuestoEnfermedades,
                    hintText: '¿Cual?'),
                _separacionCampos(20),
                Row(
                  children: [
                    Expanded(
                      child: _NombreCampos(
                          '¿Se le ha aplicado algún tratamiento para la enfermedad actual?'),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiAplicadoTratamientoConsulta(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiAplicadoTratamientoConsulta(
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
                      child: RadioButtonReutiVacunasAlDiaConsulta(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiVacunasAlDiaConsulta(
                        siOno: 'No',
                        valor: 'NO',
                      ),
                    ),
                  ],
                ),
                MensajeValidadorSelecciones(
                  validator: (_) => dataConsulta.selectedVacunasAlDia == ''
                      ? 'Por favor, seleccione una opción.'
                      : null,
                ),
                _separacionCampos(20),
                _NombreCampos(
                    '¿Alguno reacción alérgica a medicamento o vacuna?'),
                _separacionCampos(15),
                TextFormFieldConHintValidator(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerReaccionAlergica,
                    hintText: 'Ej: Vacuna antirrabica'),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkeyDatosClinicos.currentState!.validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
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
                              side: BorderSide(
                                  color: Color.fromARGB(255, 28, 149, 187),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 149, 187),
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosPeticionPruebasMuestras(
      ConsultaProvider dataConsulta, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Petición de muestras y pruebas'),
              _separacionCampos(20),
              _NombreCampos('Muestras requeridas'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerMuestrasRequeridas,
                  hintText:
                      'Indica aqui las muestras requeridas (Ej: Analisis de sangre, examen de orina)',
                  maxLines: 7),
              _separacionCampos(20),
              _NombreCampos('Pruebas requeridas'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerPruebasRequeridas,
                  hintText:
                      'Indica aqui las pruebas requeridas (Ej: radiografia, ecografia, tomografia)',
                  maxLines: 7),
              _separacionCampos(20),
              _tituloForm('Añadir análisis y estudios'),
              _separacionCampos(20),
              _NombreCampos('Hemograma'),
              _separacionCampos(15),
              dataConsulta.fileHemograma.isEmpty
                  ? addFileHemogramaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosHemograma(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileHemograma(),
                      ],
                    ),
              _separacionCampos(20),
              _NombreCampos('Química sanguínea'),
              _separacionCampos(15),
              dataConsulta.fileQuimSanguinea.isEmpty
                  ? addFileQuimicaSanguineaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosQuimicaSanguinea(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileQuimicaSanguinea(),
                      ],
                    ),
              _separacionCampos(20),
              _NombreCampos('Antibiograma'),
              _separacionCampos(15),
              dataConsulta.fileAntibiograma.isEmpty
                  ? addFileAntibiogramaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosAntibiograma(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileAntibiograma(),
                      ],
                    ),
              _separacionCampos(20),
              _NombreCampos('Radiografías'),
              _separacionCampos(15),
              dataConsulta.fileRadiografia.isEmpty
                  ? addFileRadiografiaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosRadiografia(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileRadiografia(),
                      ],
                    ),
              _separacionCampos(20),
              _NombreCampos('Ecografías'),
              _separacionCampos(15),
              dataConsulta.fileEcografia.isEmpty
                  ? addFileEcografiaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosEcografia(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileEcografia(),
                      ],
                    ),
              _separacionCampos(20),
              _NombreCampos('Coprología'),
              _separacionCampos(15),
              dataConsulta.fileCoprologia.isEmpty
                  ? addFileCoprologiaIsEmpty(context)
                  : Row(
                      children: [
                        ArchivosCoprologia(
                          sizeScreen: sizeScreenWidth,
                        ),
                        AddFileCoprologia(),
                      ],
                    ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataConsulta.getDatosParams();
                      _nextPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 28, 149, 187),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosMotivoConsulta(
    ConsultaProvider dataConsulta,
    List<DatosParametricos> listaDatosParametricos,
  ) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Motivo de consulta'),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listaDatosParametricos.length,
                itemBuilder: (context, index) {
                  final parametrica = listaDatosParametricos[index];
                  return Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        side: BorderSide(
                            color: Color.fromARGB(255, 26, 202, 212), width: 2),
                        activeColor: Color.fromARGB(255, 26, 202, 212),
                        value: parametrica.selected,
                        onChanged: (value) {
                          context
                              .read<ConsultaProvider>()
                              .toggleSelected(parametrica);
                        },
                      ),
                      SizedBox(
                          width:
                              8), // Agrega espacio entre el Checkbox y el texto
                      Expanded(
                        child: Text(
                          parametrica.parametrica,
                          style: const TextStyle(
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 72, 86, 109)),
                        ), // Texto al lado derecho
                      ),
                    ],
                  );
                },
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 28, 149, 187),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosInfoAdicional(ConsultaProvider dataConsulta,
      List<DatosParametricos> listaDatosParametricos) {
    final List<DatosParametricos> selectedParametricasA;

    final selectedParametricas = context
        .watch<ConsultaProvider>()
        .getdatosParametricos
        .where((parametrica) => parametrica.selected)
        .toList();

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Información adicional'),
              _separacionCampos(20),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: selectedParametricas.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final parametrica = selectedParametricas[index];
                  final datosParametricosProvider =
                      context.read<ConsultaProvider>();

                  final preguntasWidgets = <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        parametrica.parametrica,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ];

                  preguntasWidgets.addAll(
                    parametrica.preguntas.map<Widget>((pregunta) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '${pregunta.preguntaId}. ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 72, 86, 109),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    pregunta.pregunta,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 72, 86, 109),
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            if (pregunta.opciones.isNotEmpty &&
                                pregunta.opciones.first.tipo == Tipo.OPCION)
                              Row(
                                children: [
                                  Radio(
                                    activeColor:
                                        Color.fromARGB(255, 26, 202, 212),
                                    value: 'SI',
                                    groupValue: datosParametricosProvider
                                        .radioButtonValues[pregunta.preguntaId],
                                    onChanged: (value) {
                                      datosParametricosProvider
                                          .updateRadioButtonValue(
                                              pregunta.preguntaId, value!);
                                    },
                                  ),
                                  Text('SI'),
                                  Radio(
                                    activeColor:
                                        Color.fromARGB(255, 26, 202, 212),
                                    value: 'NO',
                                    groupValue: datosParametricosProvider
                                        .radioButtonValues[pregunta.preguntaId],
                                    onChanged: (value) {
                                      datosParametricosProvider
                                          .updateRadioButtonValue(
                                              pregunta.preguntaId, value!);
                                    },
                                  ),
                                  Text('NO'),
                                ],
                              ),
                            if (pregunta.opciones.isNotEmpty &&
                                pregunta.opciones.first.tipo == Tipo.TEXTO)
                              TextFormField(
                                onChanged: (value) {
                                  datosParametricosProvider
                                      .updateTextFormFieldValue(
                                          pregunta.preguntaId, value);
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 140, 228, 233),
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Llene campo',
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
                                // Personaliza el TextFormField según tus necesidades
                              ),
                          ],
                        ),
                      );
                    }),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: preguntasWidgets,
                  );
                },
              ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      // Llama a la función guardarDatosEnAPI pasando la lista de DatosParametricos y el provider
                      dataConsulta.guardarDatosEnAPI(selectedParametricas);

                      _nextPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 28, 149, 187),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosDiagnostico(ConsultaProvider dataConsulta) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyDiagnostico,
          child: Column(
              //DATOS CLINICOS

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Diagnóstico'),
                _separacionCampos(20),
                _NombreCampos('Lista de problemas'),
                _separacionCampos(15),
                TextFormFieldMaxLinesConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerListaProblemas,
                    hintText:
                        'Describa los síntomas o problemas de salud actuales de su mascota (Ejemplo. dolor en las articulaciones, tos persistente)',
                    maxLines: 6),
                _separacionCampos(20),
                _NombreCampos('Diagnóstico'),
                _separacionCampos(15),
                TextFormFieldMaxLinesConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDiagnostico,
                    hintText:
                        'Escriba aqui el diagnostico definitivo del paciente',
                    maxLines: 5),
                _separacionCampos(20),
                _NombreCampos('Diagnóstico diferencial'),
                _separacionCampos(15),
                TextFormFieldMaxLinesConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDiagnosticoDiferencial,
                    validar: true,
                    hintText:
                        'Escriba aquí el diagnóstico diferencial por cada problema',
                    maxLines: 5),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _previousPage();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 28, 149, 187),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 28, 149, 187),
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosTratamiento(
      ConsultaProvider dataConsulta, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Tratamiento'),
              _separacionCampos(20),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataConsulta.controllersTratamiento.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            const SizedBox(
                                width: 30,
                                child: Icon(
                                  Icons.message_outlined,
                                  color:
                                      const Color.fromARGB(255, 139, 149, 166),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormFieldConHint(
                                  colores:
                                      const Color.fromARGB(255, 140, 228, 233),
                                  controller: dataConsulta
                                      .controllersTratamiento[index],
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
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 218, 223, 230), width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    dataConsulta.agregarTratamiento();
                  },
                  child: const Row(
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
                      Text(
                        'Agregar tratamiento',
                        style: TextStyle(
                            color: Color.fromARGB(255, 139, 149, 166),
                            fontFamily: 'sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
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
                  controller: controllerRecomendaciones,
                  hintText:
                      'Escriba aqui el recomendaciones adicionales para el cuidado de la mascota (Ej. Dieta blanca)',
                  maxLines: 5),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 28, 149, 187),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosProximaVisita(ConsultaProvider dataConsulta,
      double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Próxima visita'),
              _separacionCampos(20),
              TableCalendar(
                onDaySelected: _onDaySelected,

                selectedDayPredicate: (day) => isSameDay(day, today),
                locale: 'es_ES',
                rowHeight: 43,
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: false),
                availableGestures: AvailableGestures.all,
                focusedDay: today,
                firstDay: DateTime.utc(2023, 02, 10),
                lastDay: DateTime.utc(2030, 02, 10),
                // Resto de las propiedades y personalización del TableCalendar
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    //shape: BoxShape.rectangle,
                    color: const Color.fromARGB(255, 65, 0, 152),
                    borderRadius: BorderRadius.circular(
                        5), // Ajusta el radio según tus preferencias
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromARGB(255, 65, 0, 152),
                      width: 2,
                    ),
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 65, 0, 152),
                  ),
                ),
              ),
              _separacionCampos(20),
              _NombreCampos('Encargados'),
              _separacionCampos(15),
              Row(
                children: [
                  Container(
                      child: Icon(IconlyLight.user_1,
                          color: const Color.fromARGB(255, 139, 149, 166),
                          size: 28)),
                  SizedBox(
                    width: 15,
                  ),
                  dataConsulta.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataConsulta.inicialEncargado,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Encargados',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 29, 34, 44),
                                        fontSize: 16,
                                        fontFamily: 'sans',
                                        fontWeight: FontWeight.w700)),
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
                                      backgroundColor:
                                          Color.fromARGB(255, 47, 26, 125),
                                      child: Text(
                                        veterinario.nombres[0],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ), // Mostrar el ID a la izquierda
                                    title: Text(veterinario.nombres,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 29, 34, 44),
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    subtitle: Text(veterinario.apellidos,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 139, 149, 166),
                                            fontSize: 12,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    onTap: () {
                                      guardarIdVetEncargado(
                                          context, veterinario, dataConsulta);
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
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Color.fromARGB(255, 218, 223, 230),
                                width: 2)),
                        child: Icon(Icons.add,
                            color: const Color.fromARGB(255, 139, 149, 166),
                            size: 20)),
                  ),
                ],
              ),
              MensajeValidadorSelecciones(
                validator: (value) {
                  if (dataConsulta.idEncargadoSelected == '') {
                    return 'Por favor, seleccione un encargado.';
                  }
                  return null;
                },
              ),
              _separacionCampos(20),
              _NombreCampos('Hora'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, dataConsulta);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 249, 249, 249)),
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
                      dataConsulta.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1),
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataConsulta.horaSelected,
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1),
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            )
                    ],
                  ),
                ),
              ),
              MensajeValidadorSelecciones(
                validator: (value) {
                  if (dataConsulta.horaSelected == '') {
                    return 'Por favor, seleccione una hora.';
                  }
                  return null;
                },
              ),
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
                      dataConsulta.saveSignature(
                          controllerFirma, context, dataConsulta);
                      dataConsulta
                          .actualizarDatos(
                        //propietario
                        controllerCiDueno.text,
                        controllerNombre.text,
                        controllerApellido.text,
                        controllerNumero.text,
                        controllerDireccion.text,
                        //paciente
                        controllerNombrePaciente.text,
                        dataConsulta.selectedSexoPaciente,
                        controllerEdadPaciente.text,
                        dataConsulta.selectedIdEspecie!,
                        dataConsulta.selectedIdRaza!,
                        dataConsulta.dropTamanoMascota,
                        dataConsulta.dropTemperamento,
                        dataConsulta.dropAlimentacion,
                        dataConsulta.lastImage,
                        //datos clinicos
                        dataConsulta.dropMucosas,
                        controllerPeso.text,
                        controllerTemperatura.text,
                        controllerFrecuenciaCar.text,
                        controllerFrecuenciaRes.text,
                        dataConsulta.dropHidratacion,
                        dataConsulta.dropGanglios,
                        controllerLesiones.text,
                        controllerDesdeCuandoTieneMascota.text,
                        dataConsulta.selectedExisteAnimalEnCasa,
                        controllerDondeAdquirioMascota.text,
                        controllerEnfermedadesPadece.text,
                        controllerExpuestoEnfermedades.text,
                        // dataConsulta.selectedExpuestoAEnfermedad,
                        dataConsulta.selectedAplicadoTratamiento,
                        dataConsulta.selectedVacunasAlDia,
                        controllerReaccionAlergica.text,

                        //peticiones de pruebas y muestras
                        controllerMuestrasRequeridas.text,
                        controllerPruebasRequeridas.text,
                        dataConsulta.fileHemograma,
                        dataConsulta.fileRadiografia,
                        dataConsulta.fileEcografia,
                        dataConsulta.fileQuimSanguinea,
                        dataConsulta.fileAntibiograma,
                        dataConsulta.fileCoprologia,
                        //diagnostico
                        controllerListaProblemas.text,
                        controllerDiagnostico.text,
                        controllerDiagnosticoDiferencial.text,
                        //tratamientos
                        dataConsulta.controllersTratamiento,
                        controllerRecomendaciones.text,
                        //proxima visita
                        dataConsulta.fechaVisitaSelected,
                        dataConsulta.horaSelected,
                        dataConsulta.idEncargadoSelected,
                        dataConsulta.signatureImageFirma,
                      )
                          .then((_) async {
                        if (dataConsulta.OkpostDatosConsulta) {
                          _mostrarFichaCreada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: dataConsulta.loadingDatosConsulta
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
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 28, 149, 187),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
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
              style: TextStyle(
                  color: const Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: const Text(
                      'No se guardarán los cambios que hayas realizado.',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 72, 86, 109),
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
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
                                  Provider.of<ConsultaProvider>(context,
                                          listen: false)
                                      .setSelectSquareConsulta(0);
                                  // Cerrar el AlertDialog
                                  Navigator.of(context).pop();
                                  //cierra bottomSheet
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 85, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Volver',
                                  style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
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
                                    backgroundColor:
                                        Color.fromARGB(255, 28, 149, 187),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Quedarme aquí',
                                  style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
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

  //mensaje de confirmacion
  void _mostrarFichaCreada(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            '¡Registro actualizado con éxito!',
            style: TextStyle(
                color: const Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
                fontSize: 20),
            textAlign: TextAlign.justify,
          ),
          content: SizedBox(
            height: 350,
            child: Column(
              children: [
                Image(
                    height: 220,
                    width: 200,
                    image: AssetImage('assets/img/done.png')),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Los datos del paciente y la información de la consulta se han guardado con éxito.',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 72, 86, 109),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<ConsultaProvider>(context, listen: false)
                          ..setOKsendDatosConsulta(false)
                          ..setSelectSquareConsulta(0);
                        // Cerrar el AlertDialog
                        Navigator.of(context).pop();
                        //cierra bottomSheet
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void guardarIdVetEncargado(BuildContext context, EncargadosVete encargadoVet,
      ConsultaProvider dataConsulta) {
    print(
        'ID: ${encargadoVet.encargadoVeteId}, Inicial del nombre: ${encargadoVet.nombres[0].toUpperCase()}');

    dataConsulta
        .setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataConsulta
        .setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    ConsultaProvider dataConsulta =
        Provider.of<ConsultaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataConsulta.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, ConsultaProvider dataConsulta) {
    final timePicker = TimePickerHelper<ConsultaProvider>(
      context: context,
      provider: dataConsulta,
      getHoraSelected: () => dataConsulta.horaSelected,
      setHoraSelected: dataConsulta.setHoraSelected,
    );
    timePicker.openTimePicker();
  }

  Widget getFotoPaciente(ConsultaProvider dataConsulta) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataConsulta.addPhoto();
          },
          child: Image.file(
            dataConsulta.lastImage!,
            height: 310,
            width: double.infinity,
          ),
        ),
      ),
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

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Color.fromARGB(255, 72, 86, 109),
          fontSize: 15,
          fontWeight: FontWeight.w500),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }
}

//Clases para agregar archivos varios HEMOGRAMA

Container addFileHemogramaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileHemograma(fileName);
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
            'Agregar hemográma',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileHemograma extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileHemograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosHemograma extends StatelessWidget {
  final double sizeScreen;
  ArchivosHemograma({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileHemograma.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileHemograma.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}

//Clases para agregar archivos varios QUIMICA SANGUINEA

Container addFileQuimicaSanguineaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileQuimSanguinea(fileName);
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
            'Agregar análisis',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileQuimicaSanguinea extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileHemograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosQuimicaSanguinea extends StatelessWidget {
  final double sizeScreen;
  ArchivosQuimicaSanguinea({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileQuimSanguinea.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileQuimSanguinea.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}

//Clases para agregar archivos varios ANTIBIOGRAMA

Container addFileAntibiogramaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileAntibiograma(fileName);
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
            'Agregar antibiograma',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileAntibiograma extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileAntibiograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosAntibiograma extends StatelessWidget {
  final double sizeScreen;
  ArchivosAntibiograma({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileAntibiograma.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileAntibiograma.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}

//Clases para agregar archivos varios RADIOGRAFIA

Container addFileRadiografiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileRadiografia(fileName);
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
            'Agregar radiografía',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileRadiografia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileRadiografia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosRadiografia extends StatelessWidget {
  final double sizeScreen;
  ArchivosRadiografia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileRadiografia.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileRadiografia.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}

//Clases para agregar archivos varios ECOGRAFIA

Container addFileEcografiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileEcografia(fileName);
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
            'Agregar ecografía',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileEcografia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileEcografia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosEcografia extends StatelessWidget {
  final double sizeScreen;
  ArchivosEcografia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileEcografia.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileEcografia.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}

//Clases para agregar archivos varios COPROLOGIA

Container addFileCoprologiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
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

        final fileProvider =
            Provider.of<ConsultaProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileCoprologia(fileName);
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
            'Agregar coprología',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileCoprologia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
                Provider.of<ConsultaProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileCoprologia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosCoprologia extends StatelessWidget {
  final double sizeScreen;
  ArchivosCoprologia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<ConsultaProvider>(context);
    return provFiles.fileCoprologia.isEmpty
        ? Container(
            margin: EdgeInsets.only(right: 5),
            height: 60,
            width: sizeScreen * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(220, 249, 249, 249),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text('',
                      style: TextStyle(
                          color: Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter')),
                ),
              ],
            )),
          )
        : Consumer<ConsultaProvider>(
            builder: (context, fileProvider, _) {
              return Column(
                children: fileProvider.fileCoprologia.map((fileName) {
                  String nombreLegible = path.basename(fileName);
                  return Container(
                    margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
                    padding: EdgeInsets.only(right: 5),
                    height: 60,
                    width: sizeScreen * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(220, 249, 249, 249),
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(nombreLegible,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 149, 166),
                                  fontSize: 15,
                                  fontFamily: 'inter')),
                        ),
                      ],
                    )),
                  );
                }).toList(),
              );
            },
          );
  }
}
