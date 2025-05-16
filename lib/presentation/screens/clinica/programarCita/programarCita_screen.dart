import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/agenda/response_agenda.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';
import 'package:vet_sotf_app/providers/agenda_provider.dart';
import 'package:vet_sotf_app/providers/clinica/programarCita/programarCita_provider.dart';
import 'package:vet_sotf_app/providers/tabBar_provider.dart';
import 'package:vet_sotf_app/providers/tareas/tareas_provider.dart';

import '../../../../models/clinica/consulta/veterinariosEncargados.dart';
import '../../../widgets/clinica/programarCita/radiobuttonDesparacitacion_widget.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class FormularioProgramarCita extends StatefulWidget {
  @override
  _FormularioProgramarCitaState createState() =>
      _FormularioProgramarCitaState();
}

class _FormularioProgramarCitaState extends State<FormularioProgramarCita> {
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

  //controllers para OTRO PROCEDIMIENTO
  TextEditingController controllerTipoDeProcedimiento = TextEditingController();

  //Editing controller para agendar proxima visita
  TextEditingController controllerTipoCita = TextEditingController();
  TextEditingController controllerMotivoCita = TextEditingController();

  @override
  void initState() {
    ProgramarCitaProvider dataPCita =
        Provider.of<ProgramarCitaProvider>(context, listen: false);
    dataPCita.resetearValores();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<ProgramarCitaProvider>(context, listen: false)
                .selectedSquarePCita ==
            2
        ? 1
        : 3;

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
    ProgramarCitaProvider dataPCita =
        Provider.of<ProgramarCitaProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataPCita.getEncargados;
    double valueLinearProgress = dataPCita.selectedSquarePCita == 2 ? 1 : 3;

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
            'Añadir nuevo registro',
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
            dataPCita.selectedSquarePCita == 2
                ? Row()
                : Row(
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
                        ' de 3',
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
                children: dataPCita.selectedSquarePCita == 2
                    ? [
                        _datosProximaVisita(
                            dataPCita, sizeScreenWidth, listaVeterinarios)
                      ]
                    : [
                        _datosDelDueno(dataPCita, sizeScreenWidth),
                        _datosPaciente(dataPCita),
                        _datosProximaVisita(
                            dataPCita, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(
      ProgramarCitaProvider dataPCita, double sizeScreenWidth) {
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
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 72, 86, 109),
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
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
                        if (_formKeyDuenoCirugia.currentState!.validate()) {
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

  Widget _datosPaciente(ProgramarCitaProvider dataPCita) {
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
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700),
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
              RadioButtonReutilizableGeneroPCita(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroPCita(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroPCita(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroPCita(
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
                provider: dataPCita,
              ),
              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<ProgramarCitaProvider>(builder: (context, provider, _) {
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
              Consumer<ProgramarCitaProvider>(
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
                value: dataPCita.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataPCita.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataPCita.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataPCita.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataPCita.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataPCita.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataPCita.image != null
                  ? getFotoPaciente(dataPCita)
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
                              dataPCita.addPhoto();
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
                                        color: Color.fromARGB(255, 94, 99, 102),
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

  Widget _datosProximaVisita(ProgramarCitaProvider dataPCita,
      double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    DateTime nowDate = DateTime.now();
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
              TableCalendar(
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, today),
                locale: 'es_ES',
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: false),
                availableGestures: AvailableGestures.all,
                focusedDay: today,
                firstDay: DateTime.now(),
                lastDay: DateTime(nowDate.year + 1, nowDate.month, nowDate.day,
                    nowDate.hour, nowDate.minute, nowDate.second),
                // Resto de las propiedades y personalización del TableCalendar
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Colors.transparent,
                        //shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color.fromARGB(255, 136, 64, 255),
                            width: 2)),
                    selectedTextStyle: TextStyle(
                        color: const Color.fromARGB(255, 136, 64, 255))),
              ),
              _separacionCampos(20),
              _NombreCampos('Hora'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, dataPCita);
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
                      dataPCita.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1),
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataPCita.horaSelected,
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
                  dataPCita.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataPCita.inicialEncargado,
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
                                    title: Text('${veterinario.nombres}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 29, 34, 44),
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    subtitle: Text('${veterinario.apellidos}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 139, 149, 166),
                                            fontSize: 12,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    onTap: () {
                                      guardarIdVetEncargado(
                                          context, veterinario, dataPCita);
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
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: dataPCita.selectedSquarePCita == 2
                        ? () {
                            final tabProvider = Provider.of<TabBarProvider>(
                                context,
                                listen: false);
                            dataPCita
                                .enviarDatosAntiguo(
                                    //paciente
                                    dataPCita.selectedIdPacienteAntiguo,
                                    //proxima visita
                                    dataPCita.fechaVisitaSelected,
                                    dataPCita.horaSelected,
                                    dataPCita.idEncargadoSelected,
                                    //TipoFicha
                                    tabProvider.obtieneNombreTab())
                                .then((_) async {
                              if (dataPCita.OkpostDatosPCita) {
                                _mostrarFichaCreada(context);
                              }
                            });
                          }
                        : () {
                            final tabProvider = Provider.of<TabBarProvider>(
                                context,
                                listen: false);
                            dataPCita
                                .enviarDatos(
                                    //propietario
                                    controllerCiCliente.text,
                                    controllerNombre.text,
                                    controllerApellido.text,
                                    controllerNumero.text,
                                    controllerDireccion.text,
                                    //paciente
                                    controllerNombrePaciente.text,
                                    dataPCita.selectedSexoPaciente,
                                    controllerEdadPaciente.text,
                                    dataPCita.selectedTypeAge,
                                    dataPCita.selectedIdEspecie!,
                                    dataPCita.selectedIdRaza!,
                                    dataPCita.dropTamanoMascota,
                                    dataPCita.dropTemperamento,
                                    dataPCita.dropAlimentacion,
                                    dataPCita.lastImage!,

                                    //proxima visita
                                    dataPCita.fechaVisitaSelected,
                                    dataPCita.horaSelected,
                                    dataPCita.idEncargadoSelected,
                                    //TipoFicha
                                    tabProvider.obtieneNombreTab())
                                .then((_) async {
                              if (dataPCita.OkpostDatosPCita) {
                                _mostrarFichaCreada(context);
                              }
                            });
                          },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 28, 149, 187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: dataPCita.loadingDatosPCita
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
              '¡Registro creado con éxito!',
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
                  const Image(
                      height: 220,
                      width: 200,
                      image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Perfecto! El formulario del nuevo cliente y registro de otros procedimientos ha sido completado con éxito.',
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

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    ProgramarCitaProvider dataOProced =
        Provider.of<ProgramarCitaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataOProced.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(
      BuildContext context, ProgramarCitaProvider dataOProced) {
    final timePicker = TimePickerHelper<ProgramarCitaProvider>(
      context: context,
      provider: dataOProced,
      getHoraSelected: () => dataOProced.horaSelected,
      setHoraSelected: dataOProced.setHoraSelected,
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
          style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 72, 86, 109),
              fontFamily: 'sans',
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget getFotoPaciente(ProgramarCitaProvider dataoProced) {
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

class FormularioUpdateCita extends StatefulWidget {
  final ClinicaModel clinica;
  FormularioUpdateCita({required this.clinica});

  @override
  _FormularioUpdateCita createState() => _FormularioUpdateCita(clinica);
}

class _FormularioUpdateCita extends State<FormularioUpdateCita> {
  final ClinicaModel clinica;

  _FormularioUpdateCita(this.clinica);

  //formnKey para datos del dueno
  final _formKeyDuenoCirugia = GlobalKey<FormState>();

  //obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  //Editing controller para agendar proxima visita
  TextEditingController controllerTipoCita = TextEditingController();
  TextEditingController controllerMotivoCita = TextEditingController();
  @override
  void initState() {
    final AgendaProvider dataAgendaProvider =
        Provider.of<AgendaProvider>(context, listen: false);
    ProgramarCitaProvider dataPCita =
        Provider.of<ProgramarCitaProvider>(context, listen: false);

    dataPCita.setFechaVisitaSelected(dataAgendaProvider.fechaSelected);
    dataPCita.setHoraSelected(clinica.horaAtencion);
    today = DateTime.parse(dataAgendaProvider.fechaSelected);
    //llena lista de encargados y seleccionados
    final TareasProvider dataTareas =
        Provider.of<TareasProvider>(context, listen: false);
    dataTareas.setearDatos();

    List<EncargadosVete> listaVeterinarios = dataPCita.getEncargados;
    dataTareas.setParticipantesTareas(listaVeterinarios);
    dataTareas.setToggleSelectionMap(clinica);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   Future.delayed(Duration.zero, () {
  //     final AgendaProvider dataAgendaProvider = Provider.of<AgendaProvider>(context, listen: false);
  //     ProgramarCitaProvider dataPCita = Provider.of<ProgramarCitaProvider>(context, listen: false);
  //
  //     dataPCita.setFechaVisitaSelected(dataAgendaProvider.fechaSelected);
  //
  //     setState(() {
  //       today = DateTime.parse(dataAgendaProvider.fechaSelected);
  //     });
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    ProgramarCitaProvider dataPCita =
        Provider.of<ProgramarCitaProvider>(context);
    // ProgramarCitaProvider dataPCita = context.read<ProgramarCitaProvider>();
    final dataAgendaProvider = Provider.of<AgendaProvider>(context);

    List<EncargadosVete> listaVeterinarios = dataPCita.getEncargados;

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
                child: _datosProximaVisita(dataPCita, dataAgendaProvider,
                    sizeScreenWidth, listaVeterinarios)),
          ],
        ),
      ),
    );
  }

  Widget _datosProximaVisita(
      ProgramarCitaProvider dataPCita,
      AgendaProvider dataAgendaProvider,
      double sizeScreenWidth,
      List<EncargadosVete> listaVeterinarios) {
    DateTime nowDate = DateTime.now();

    //Encargados
    TareasProvider dataTareas = Provider.of<TareasProvider>(context);
    List<ParticipanteTarea> listaParticipantes =
        dataTareas.getParticipantesTarea;
    // List<ParticipanteTarea> listaParticipantes = [];

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
                lastDay: DateTime(nowDate.year + 1, nowDate.month, nowDate.day,
                    nowDate.hour, nowDate.minute, nowDate.second),
                // Resto de las propiedades y personalización del TableCalendar
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Colors.transparent,
                        //shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color.fromARGB(255, 136, 64, 255),
                            width: 2)),
                    selectedTextStyle: TextStyle(
                        color: const Color.fromARGB(255, 136, 64, 255))),
              ),
              _separacionCampos(20),
              _NombreCampos('Hora'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, dataPCita);
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
                      Text(
                        dataPCita.horaSelected.isEmpty
                            ? 'Seleccionar hora'
                            : dataPCita.horaSelected.substring(0, 5),
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
                  dataTareas.selectedParticipantsMap.isNotEmpty
                      ? Flexible(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: sizeScreenWidth,
                                height: 45,
                              ),
                              for (var i = 0;
                                  i <
                                          dataTareas
                                              .selectedParticipantsMap.length &&
                                      i < 5;
                                  i++)
                                Positioned(
                                  left: i * 43.0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/icon/logovs.png',
                                        image:
                                            '$imagenUrlGlobal${dataTareas.selectedParticipantsMap.values.elementAt(i)}',
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                            Duration(milliseconds: 200),
                                      ),
                                    ),
                                  ),
                                ),
                              if (dataTareas.selectedParticipantsMap.length > 5)
                                Positioned(
                                  left: 5 * 43.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    width: 45,
                                    height: 45,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 65, 0, 152),
                                      radius: 30,
                                      child: Text(
                                        '+${dataTareas.selectedParticipantsMap.length - 5}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      openBottomSheetParticipantesTareas(
                          dataTareas, context, listaParticipantes);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Color.fromARGB(255, 218, 223, 230),
                                width: 2)),
                        child: Icon(Icons.add,
                            color: const Color.fromARGB(255, 139, 149, 166),
                            size: 25)),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Container(
              //         child: Icon(IconlyLight.user_1,
              //             color: const Color.fromARGB(255, 139, 149, 166),
              //             size: 28)),
              //     SizedBox(
              //       width: 15,
              //     ),
              //     dataPCita.inicialEncargado.isNotEmpty
              //         ? Padding(
              //       padding: const EdgeInsets.only(right: 8),
              //       child: CircleAvatar(
              //         backgroundColor: Color.fromARGB(255, 47, 26, 125),
              //         child: Text(
              //           dataPCita.inicialEncargado,
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     )
              //         : Container(),
              //     InkWell(
              //       onTap: () {
              //             openBottomSheetParticipantesTareas(dataTareas, context, listaParticipantes);
              //         showDialog(
              //           context: context,
              //           builder: (context) {
              //             return AlertDialog(
              //               shape: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(20)),
              //               title: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Encargados',
              //                       style: TextStyle(
              //                           color: const Color.fromARGB(
              //                               255, 29, 34, 44),
              //                           fontSize: 16,
              //                           fontFamily: 'sans',
              //                           fontWeight: FontWeight.w700)),
              //                   Divider()
              //                 ],
              //               ),
              //               content: Container(
              //                 height: 300,
              //                 width: sizeScreenWidth,
              //                 child: ListView.builder(
              //                   shrinkWrap: true,
              //                   itemCount: listaVeterinarios.length,
              //                   itemBuilder: (context, index) {
              //                     final veterinario = listaVeterinarios[index];
              //                     return ListTile(
              //                       contentPadding: EdgeInsets.only(left: 2),
              //                       leading: CircleAvatar(
              //                         backgroundColor:
              //                         Color.fromARGB(255, 47, 26, 125),
              //                         child: Text(
              //                           veterinario.nombres[0],
              //                           style: TextStyle(
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                       ), // Mostrar el ID a la izquierda
              //                       title: Text('${veterinario.nombres}',
              //                           style: TextStyle(
              //                               color: const Color.fromARGB(
              //                                   255, 29, 34, 44),
              //                               fontSize: 16,
              //                               fontFamily: 'inter',
              //                               fontWeight: FontWeight.w400)),
              //                       subtitle: Text('${veterinario.apellidos}',
              //                           style: TextStyle(
              //                               color: const Color.fromARGB(
              //                                   255, 139, 149, 166),
              //                               fontSize: 12,
              //                               fontFamily: 'inter',
              //                               fontWeight: FontWeight.w400)),
              //                       onTap: () {
              //                         // guardarIdVetEncargado(context, veterinario, dataPCita);
              //                         dataPCita.setIdEncargadoSelected(veterinario.encargadoVeteId.toString());
              //                         dataPCita.setInicialEncargado(veterinario.nombres[0].toUpperCase().toString());
              //
              //                         // Cerrar el AlertDialog
              //                         Navigator.pop(context);
              //                       },
              //                     );
              //                   },
              //                 ),
              //               ),
              //             );
              //           },
              //         );
              //       },
              //       child: Container(
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(50),
              //               border: Border.all(
              //                   color: Color.fromARGB(255, 218, 223, 230),
              //                   width: 2)),
              //           child: Icon(Icons.add,
              //               color: const Color.fromARGB(255, 139, 149, 166),
              //               size: 20)),
              //     ),
              //   ],
              // ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataAgendaProvider
                          .enviarDatosActualizarCitaAgenda(
                        'clinica',
                        clinica.fichaClinicaId,
                        dataPCita.fechaVisitaSelected,
                        dataPCita.horaSelected,
                        dataTareas.selectedParticipantsMap,
                      )
                          .then((_) async {
                        print(
                            'estado de ficha ${dataAgendaProvider.OkpostDatosPCita}');

                        if (dataAgendaProvider.OkpostDatosPCita) {
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
                    child: dataPCita.OkpostDatosPCita
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
              '¡Registro creado con éxito!',
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
                  const Image(
                      height: 220,
                      width: 200,
                      image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Perfecto! El formulario del nuevo cliente y registro de otros procedimientos ha sido completado con éxito.',
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
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataOProced.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(
      BuildContext context, ProgramarCitaProvider dataOProced) {
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
          style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 72, 86, 109),
              fontFamily: 'sans',
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget getFotoPaciente(ProgramarCitaProvider dataoProced) {
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

  void openBottomSheetParticipantesTareas(TareasProvider dataTareas,
      BuildContext context, List<ParticipanteTarea> listaParticipantes) {
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
                  child: Row(
                    children: [
                      Text('Participantes',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                      Consumer<TareasProvider>(
                        builder: (context, dataTareas, child) {
                          return Text(
                              ' (${dataTareas.selectedParticipantsMap.length})',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 177, 173, 255),
                                  fontSize: 16,
                                  fontFamily: 'sans',
                                  fontWeight: FontWeight.w700));
                        },
                      ),
                    ],
                  ),
                ),
                _separacionCampos(10),
                TextFormField(
                  controller: controllerBusquedaPartici,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
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
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 177, 173, 255),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Nombre del cliente o paciente',
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
                  onChanged: (query) {
                    final listaFiltradaProvider =
                        Provider.of<TareasProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaParticipante(
                        listaParticipantes, query);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaPartici.text.isEmpty
                      ? Consumer<TareasProvider>(
                          builder: (context, provider, child) {
                            final listaParticipantesss =
                                provider.getParticipantesTarea;

                            return ListView.builder(
                              itemCount: listaParticipantesss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final participante =
                                    listaParticipantesss[index];
                                final isSelected = provider
                                    .isSelectedMap(participante.encargadoId);

                                return ListTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/icon/logovs.png',
                                        image:
                                            '$imagenUrlGlobal${participante.imgUser}',
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                            Duration(milliseconds: 200),
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
                                    participante.itemName.toLowerCase(),
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
                                      ? Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.toggleSelectionMap(
                                        participante.encargadoId,
                                        participante.imgUser);
                                    provider.selectedParticipantsMap
                                        .forEach((participantId, rutaImage) {
                                      print(
                                          'participantId: $participantId, rutaImage: $rutaImage');
                                    });
                                  },
                                );
                              },
                            );
                          },
                        )
                      : dataTareas.listaFiltradaParticipante.isEmpty
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
                          : Consumer<TareasProvider>(
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
                                        participante.encargadoId);

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
                                        participante.itemName.toLowerCase(),
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
                                        provider.toggleSelectionMap(
                                            participante.encargadoId,
                                            participante.itemName);
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
