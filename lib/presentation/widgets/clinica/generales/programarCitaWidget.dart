import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/models/clinica/citasMedicas_model.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';
import 'package:vet_sotf_app/providers/agenda_provider.dart';
import 'package:vet_sotf_app/providers/clinica/citasmedicas_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';

void abrirModalActualizarCitaProgramada(BuildContext context,
    ClinicaUpdateModel responseData, CitaMedica citaMedica) {
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
                child: FormularioUpdateCita(
                    respuestaFicha: responseData, citaMedica: citaMedica),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioUpdateCita extends StatefulWidget {
  final ClinicaUpdateModel respuestaFicha;
  final CitaMedica citaMedica;
  const FormularioUpdateCita(
      {super.key, required this.respuestaFicha, required this.citaMedica});

  @override
  FormularioUpdateCitaState createState() =>
      FormularioUpdateCitaState(respuestaFicha, citaMedica);
}

class FormularioUpdateCitaState extends State<FormularioUpdateCita> {
  final ClinicaUpdateModel respuestaFicha;
  final CitaMedica citaMedica;
  FormularioUpdateCitaState(this.respuestaFicha, this.citaMedica);

  //obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  //Editing controller para agendar proxima visita
  TextEditingController controllerTipoCita = TextEditingController();
  TextEditingController controllerMotivoCita = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final citaMedicaProvider =
            Provider.of<CitaMedicaProvider>(context, listen: false);
        final programarCitaProvider =
            Provider.of<ProgramarCitaProvider>(context, listen: false);
        programarCitaProvider
            .setHoraSelected(respuestaFicha.data.proximaVisita.hora);
        programarCitaProvider.setFechaVisitaSelected(DateFormat('yyyy-MM-dd')
            .format(respuestaFicha.data.proximaVisita.fecha));
        citaMedicaProvider.setIdEncargadoSeleccionado(
            respuestaFicha.data.proximaVisita.encargadoId, ' ');
        today = respuestaFicha.data.proximaVisita.fecha;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    final programarCitaProvider =
        Provider.of<ProgramarCitaProvider>(context, listen: true);
    final listaVeterinarios = programarCitaProvider.getEncargados;
    final citaMedicaProvider =
        Provider.of<CitaMedicaProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => _mostrarAlertaCancelar(context),
            icon: const Icon(
              IconlyLight.arrow_left,
              color: Color.fromARGB(255, 29, 34, 44),
              size: 30,
            ),
          ),
          title: const Text(
            'Actualizar cita',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700),
          )),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: _datosProximaVisita(
                  programarCitaProvider,
                  citaMedicaProvider,
                  sizeScreenWidth,
                  listaVeterinarios,
                  respuestaFicha,
                  citaMedica),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosProximaVisita(
      ProgramarCitaProvider programarCitaProvider,
      CitaMedicaProvider citaMeditaProvider,
      double sizeScreenWidth,
      List<EncargadosVete> listaVeterinarios,
      ClinicaUpdateModel responseData,
      CitaMedica citaMedica) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (listaVeterinarios.isNotEmpty) {
          citaMeditaProvider.setInicialEncargado(listaVeterinarios
              .firstWhere((element) =>
                  element.encargadoVeteId ==
                  citaMeditaProvider.idEncargadoSeleccionado)
              .nombres[0]
              .toUpperCase()
              .toString());
        }
      }
    });
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
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              _separacionCampos(20),
              CalendarioFormulario(
                focusedDay: today,
                firstDay: DateTime.utc(2023, 02, 10),
                lastDay: DateTime.utc(2030, 02, 10),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, today),
              ),
              // TableCalendar(
              //   onDaySelected: _onDaySelected,
              //   selectedDayPredicate: (day) => isSameDay(day, today),
              //   locale: 'es_ES',
              //   rowHeight: 43,
              //   headerStyle: const HeaderStyle(
              //       formatButtonVisible: false, titleCentered: false),
              //   availableGestures: AvailableGestures.all,
              //   focusedDay: today,
              //   firstDay: DateTime.now(),
              //   lastDay: DateTime.now().add(Duration(days: 365)),
              //   // Resto de las propiedades y personalización del TableCalendar
              //   calendarStyle: CalendarStyle(
              //       selectedDecoration: BoxDecoration(
              //           color: Colors.transparent,
              //           //shape: BoxShape.circle,
              //           //borderRadius: BorderRadius.circular(10),
              //           border: Border.all(
              //               color: const Color.fromARGB(255, 136, 64, 255),
              //               width: 2)),
              //       selectedTextStyle: TextStyle(
              //           color: const Color.fromARGB(255, 136, 64, 255))),
              // ),
              _separacionCampos(20),
              _NombreCampos('Hora'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, programarCitaProvider);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 249, 249, 249)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),
                      const Icon(
                        Icons.access_time,
                        color: Color.fromARGB(255, 139, 149, 166),
                        size: 28,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        programarCitaProvider.horaSelected.isEmpty
                            ? 'Seleccionar hora'
                            : programarCitaProvider.horaSelected
                                .substring(0, 5),
                        style: const TextStyle(
                            color: Color.fromRGBO(139, 149, 166, 1),
                            fontSize: 14,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w400),
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
                  const Icon(IconlyLight.user_1,
                      color: const Color.fromARGB(255, 139, 149, 166),
                      size: 28),
                  const SizedBox(
                    width: 15,
                  ),
                  Consumer<CitaMedicaProvider>(
                    builder: (context, provider, child) {
                      return provider.inicialEncargado.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 47, 26, 125),
                                child: Text(
                                  provider.inicialEncargado,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      openBottomSheetParticipantesTareas(responseData, context,
                          listaVeterinarios, citaMeditaProvider);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: const Color.fromARGB(255, 218, 223, 230),
                                width: 2)),
                        child: const Icon(Icons.add,
                            color: Color.fromARGB(255, 139, 149, 166),
                            size: 25)),
                  ),
                ],
              ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      citaMeditaProvider
                          .enviarDatosActualizarCitaAgenda(
                        citaMeditaProvider.esTipoClinica(citaMedica.tipoFicha)
                            ? 'clinica'
                            : 'peluqueria',
                        citaMedica.idFichaClinica,
                        programarCitaProvider.fechaVisitaSelected,
                        programarCitaProvider.horaSelected,
                        citaMeditaProvider.idEncargadoSeleccionado,
                      )
                          .then((_) async {
                        if (citaMeditaProvider.OkpostDatosPCita) {
                          Navigator.of(context).pop();
                          _mostrarFichaActualizada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: programarCitaProvider.OkpostDatosPCita
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
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 28, 149, 187),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          color: Color.fromARGB(255, 28, 149, 187),
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
            title: const Text(
              '¿Estás seguro/a de querer volver atrás?',
              style: TextStyle(
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  const Expanded(
                    child: Text(
                      'No se guardarán los cambios que hayas realizado.',
                      style: TextStyle(
                          color: Color.fromARGB(255, 72, 86, 109),
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
                                  Provider.of<ProgramarCitaProvider>(context,
                                          listen: false)
                                      .setSelectSquarePCita(0);
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
                        const SizedBox(
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
                                        const Color.fromARGB(255, 28, 149, 187),
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

  void _mostrarFichaActualizada(BuildContext context) {
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
            title: const Text(
              '¡Registro actualizado con éxito!',
              style: TextStyle(
                  color: Color.fromARGB(255, 29, 34, 44),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            content: SizedBox(
              height: 350,
              child: Column(
                children: [
                  const Image(
                      height: 220,
                      width: 200,
                      image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Perfecto! El formulario fue actualizado con éxito.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ProgramarCitaProvider>(context,
                              listen: false)
                            ..setOKsendDatosPCita(false)
                            ..setSelectSquarePCita(0);
                          // Cerrar el AlertDialog
                          Navigator.of(context).pop();
                          //cierra bottomSheet
                          Navigator.of(context).pop();
                          final providerCitas = Provider.of<CitaMedicaProvider>(
                              context,
                              listen: false);
                          providerCitas.getCitasMedicas(
                              providerCitas.fechaCalendarioClinica);
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
          ),
        );
      },
    );
  }

  void guardarIdVetEncargado(BuildContext context, EncargadosVete encargadoVet,
      ProgramarCitaProvider dataOProced) {
    dataOProced.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataOProced
        .setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    ProgramarCitaProvider dataOProced =
        Provider.of<ProgramarCitaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(day);
      dataOProced.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(
      BuildContext context, ProgramarCitaProvider dataConsulta) {
    final timePicker = TimePickerHelper<ProgramarCitaProvider>(
      context: context,
      provider: dataConsulta,
      getHoraSelected: () => dataConsulta.horaSelected,
      setHoraSelected: dataConsulta.setHoraSelected,
    );
    timePicker.openTimePicker();
  }

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: const TextStyle(
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

  void openBottomSheetParticipantesTareas(
    ClinicaUpdateModel responseFicha,
    BuildContext context,
    List<EncargadosVete> listaParticipantes,
    CitaMedicaProvider citaMeditaProvider,
  ) {
    final TextEditingController controllerBusquedaPartici =
        TextEditingController();

    final sizeWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 30,
                    height: 2, // Altura de la línea
                    color: const Color.fromARGB(
                        255, 161, 158, 158), // Color de la línea
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  child: const Row(
                    children: [
                      Text('Participantes',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                _separacionCampos(10),
                TextFormField(
                  controller: controllerBusquedaPartici,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaPartici.clear();
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 177, 173, 255),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Nombre del cliente o paciente',
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
                  onChanged: (query) {
                    final listaFiltradaProvider =
                        Provider.of<CitaMedicaProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaParticipante(
                        listaParticipantes, query);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaPartici.text.isEmpty
                      ? Consumer<CitaMedicaProvider>(
                          builder: (context, provider, child) {
                            final listaParticipantesss = listaParticipantes;
                            return ListView.builder(
                              itemCount: listaParticipantesss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final participante =
                                    listaParticipantesss[index];
                                final isSelected = provider.isSelectedMap(
                                    citaMeditaProvider.idEncargadoSeleccionado,
                                    participante.encargadoVeteId);
                                return ListTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 47, 26, 125),
                                        child: Text(
                                          participante.nombres
                                                  .substring(0, 1)
                                                  .toUpperCase() ??
                                              '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    participante.nombres,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    participante.nombres.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: isSelected
                                          ? Color.fromARGB(255, 139, 149, 166)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.setInicialEncargado(
                                        participante.nombres[0].toUpperCase());
                                    citaMeditaProvider
                                        .setIdEncargadoSeleccionado(
                                            participante.encargadoVeteId,
                                            participante.nombres);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                        )
                      : citaMeditaProvider.listaFiltradaParticipante.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                Image.asset('assets/img/noresults.png'),
                                const Text(
                                  'Oops, parece que no hay resultados.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 29, 34, 44)),
                                ),
                                const Expanded(
                                  child: Text(
                                    'No te desanimes, prueba con otra palabra clave o criterio de búsqueda.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 139, 149, 166)),
                                  ),
                                )
                              ],
                            ))
                          : Consumer<CitaMedicaProvider>(
                              builder: (context, provider, child) {
                                final listaFiltradaParticipante =
                                    provider.listaFiltradaParticipante;
                                return ListView.builder(
                                  itemCount: listaFiltradaParticipante.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final participante =
                                        listaFiltradaParticipante[index];
                                    final isSelected = provider.isSelectedMap(
                                        citaMeditaProvider
                                            .idEncargadoSeleccionado,
                                        participante.encargadoVeteId);
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/img/user.png'),
                                      ),
                                      title: Text(
                                        participante.nombres,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Color.fromARGB(255, 99, 92, 255)
                                              : null,
                                        ),
                                      ),
                                      subtitle: Text(
                                        participante.nombres.toLowerCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                          color: isSelected
                                              ? Color.fromARGB(
                                                  255, 139, 149, 166)
                                              : null,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(Icons.check,
                                              color: Color.fromARGB(
                                                  255, 99, 92, 255))
                                          : null,
                                      onTap: () {
                                        provider.setInicialEncargado(
                                            participante.nombres[0]
                                                .toUpperCase());
                                        citaMeditaProvider
                                            .setIdEncargadoSeleccionado(
                                                participante.encargadoVeteId,
                                                participante.nombres);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
