import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/models/peluqueria/encargadosPeluqueros.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';

import '../../../../providers/peluqueria/programarCitaPelu_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/peluqueria/programarCita/radiobuttonPCitaPeluqueria_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class FormularioProgramarCitaPelu extends StatefulWidget {
  @override
  _FormularioProgramarCitaPeluState createState() => _FormularioProgramarCitaPeluState();
}

class _FormularioProgramarCitaPeluState extends State<FormularioProgramarCitaPelu> {
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

  //controllers para OTRO PROCEDIMIENTO
  TextEditingController controllerTipoDeProcedimiento = TextEditingController();

  //Editing controller para agendar proxima visita
  TextEditingController controllerTipoCita = TextEditingController();
  TextEditingController controllerMotivoCita = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<ProgramarCitaPeluProvider>(context, listen: false).selectedSquarePCitaPelu == 2 ? 1 : 3;

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
    ProgramarCitaPeluProvider dataPCitaPelu = Provider.of<ProgramarCitaPeluProvider>(context, listen: true);
    List<EncarPeluqueros> listaPeluqueros = dataPCitaPelu.getEncargadosPelu;
    double valueLinearProgress = dataPCitaPelu.selectedSquarePCitaPelu == 2 ? 1 : 3;

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
            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontWeight: FontWeight.w700),
          )),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            dataPCitaPelu.selectedSquarePCitaPelu == 2
                ? Row()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Paso ${_currentPage + 1}',
                        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 99, 92, 255), fontFamily: 'inter', fontWeight: FontWeight.w400),
                      ),
                      Text(
                        ' de 3',
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
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 99, 92, 255)),
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
                children: dataPCitaPelu.selectedSquarePCitaPelu == 2
                    ? [_datosProximaVisita(dataPCitaPelu, sizeScreenWidth, listaPeluqueros)]
                    : [
                        _datosDelDueno(dataPCitaPelu, sizeScreenWidth),
                        _datosPaciente(dataPCitaPelu),
                        _datosProximaVisita(dataPCitaPelu, sizeScreenWidth, listaPeluqueros)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(ProgramarCitaPeluProvider dataPCita, double sizeScreenWidth) {
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
                  colores: const Color.fromARGB(255, 177, 173, 255),
                  controller: controllerNombre,
                  hintText: 'Nombre (Ej: Miguel)',
                ),
                _separacionCampos(20),
                _NombreCampos('Apellidos'),
                _separacionCampos(20),
                TextFormFieldConHintValidator(
                  colores: const Color.fromARGB(255, 177, 173, 255),
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
                          colores: const Color.fromARGB(255, 177, 173, 255),
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
                  colores: const Color.fromARGB(255, 177, 173, 255),
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
                          backgroundColor: const Color.fromARGB(255, 99, 92, 255),
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
                              side: BorderSide(color: Color.fromARGB(255, 68, 0, 153), width: 1.5), borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Color.fromARGB(255, 68, 0, 153), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _datosPaciente(ProgramarCitaPeluProvider dataPCitaPelu) {
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
                colores: const Color.fromARGB(255, 177, 173, 255),
                controller: controllerNombrePaciente,
                hintText: 'Bigotes',
              ),
              _separacionCampos(15),
              _NombreCampos('Sexo'),
              _separacionCampos(15),
              RadioButtonReutilizableGeneroPCitaPelu(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroPCitaPelu(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroPCitaPelu(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroPCitaPelu(
                gender: 'Hembra esterilizada',
                valor: 'HC',
              ),
              _separacionCampos(20),
              _NombreCampos('Edad'),
              _separacionCampos(15),
              TextFormFieldNumberEdad(
                colores: const Color.fromARGB(255, 177, 173, 255),
                hintText: 'Edad',
                controller: controllerEdadPaciente,
                provider: dataPCitaPelu,
              ),
              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<ProgramarCitaPeluProvider>(builder: (context, provider, _) {
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
              Consumer<ProgramarCitaPeluProvider>(
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
                value: dataPCitaPelu.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataPCitaPelu.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataPCitaPelu.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataPCitaPelu.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataPCitaPelu.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataPCitaPelu.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataPCitaPelu.image != null
                  ? getFotoPaciente(dataPCitaPelu)
                  : SizedBox(
                      height: 300,
                      child: Card(
                        color: Color.fromARGB(220, 249, 249, 249),
                        elevation: 0,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: InkWell(
                            onTap: () {
                              dataPCitaPelu.addPhoto();
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
                        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
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
                            side: BorderSide(color: Color.fromARGB(255, 68, 0, 153), width: 1.5), borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(color: Color.fromARGB(255, 68, 0, 153), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosProximaVisita(ProgramarCitaPeluProvider dataPCitaPelu, double sizeScreenWidth, List<EncarPeluqueros> listaPeluqueros) {
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
                  _openTimePicker(context, dataPCitaPelu);
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
                      dataPCitaPelu.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1), fontSize: 14, fontFamily: 'inter', fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataPCitaPelu.horaSelected,
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
                  dataPCitaPelu.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataPCitaPelu.inicialEncargado,
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
                                itemCount: listaPeluqueros.length,
                                itemBuilder: (context, index) {
                                  final peluquero = listaPeluqueros[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 2),
                                    leading: CircleAvatar(
                                      backgroundColor: Color.fromARGB(255, 47, 26, 125),
                                      child: Text(
                                        peluquero.nombres[0],
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ), // Mostrar el ID a la izquierda
                                    title: Text('${peluquero.nombres}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 29, 34, 44),
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    subtitle: Text('${peluquero.apellidos}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 139, 149, 166),
                                            fontSize: 12,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    onTap: () {
                                      guardarIdVetEncargado(context, peluquero, dataPCitaPelu);
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
                    onPressed: dataPCitaPelu.selectedSquarePCitaPelu == 2
                        ? () {
                            dataPCitaPelu
                                .enviarDatosAntiguo(
                                    //paciente
                                    dataPCitaPelu.selectedIdPacienteAntiguo,

                                    //proxima visita
                                    dataPCitaPelu.fechaVisitaSelected,
                                    dataPCitaPelu.horaSelected,
                                    dataPCitaPelu.idEncargadoSelected)
                                .then((_) async {
                              if (dataPCitaPelu.OkpostDatosPCitaPelu) {
                                _mostrarFichaCreada(context, antiguo: true);
                              }
                            });
                          }
                        : () {
                            dataPCitaPelu
                                .enviarDatos(
                                    //propietario
                                    controllerCiDueno.text,
                                    controllerNombre.text,
                                    controllerApellido.text,
                                    controllerNumero.text,
                                    controllerDireccion.text,
                                    //paciente
                                    controllerNombrePaciente.text,
                                    dataPCitaPelu.selectedSexoPaciente,
                                    controllerEdadPaciente.text,
                                    dataPCitaPelu.selectedIdEspecie!,
                                    dataPCitaPelu.selectedIdRaza!,
                                    dataPCitaPelu.dropTamanoMascota,
                                    dataPCitaPelu.dropTemperamento,
                                    dataPCitaPelu.dropAlimentacion,
                                    dataPCitaPelu.lastImage!,

                                    //proxima visita
                                    dataPCitaPelu.fechaVisitaSelected,
                                    dataPCitaPelu.horaSelected,
                                    dataPCitaPelu.idEncargadoSelected)
                                .then((_) async {
                              if (dataPCitaPelu.OkpostDatosPCitaPelu) {
                                _mostrarFichaCreada(context, antiguo: false);
                              }
                            });
                          },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: dataPCitaPelu.loadingDatosPCitaPelu
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
                            side: BorderSide(color: Color.fromARGB(255, 68, 0, 153), width: 1.5), borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(color: Color.fromARGB(255, 68, 0, 153), fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
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
                                  Provider.of<ProgramarCitaPeluProvider>(context, listen: false).setSelectSquarePCitaPelu(0);
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
                                    backgroundColor: Color.fromARGB(255, 99, 92, 255),
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

  void _mostrarFichaCreada(BuildContext context, {required bool antiguo}) {
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
              style: TextStyle(color: const Color.fromARGB(255, 29, 34, 44), fontFamily: 'sans', fontWeight: FontWeight.w700, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 350,
              child: Column(
                children: [
                  const Image(height: 220, width: 200, image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    antiguo ? '¡Listo! Tu nuevo registro ha sido creado con éxito' : '¡Perfecto! El formulario del nuevo cliente y registro de otros procedimientos ha sido completado con éxito.',
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
                          Provider.of<ProgramarCitaPeluProvider>(context, listen: false)
                            ..setOKsendDatosPCitaPelu(false)
                            ..setSelectSquarePCitaPelu(0);
                          // Cerrar el AlertDialog
                          Navigator.of(context).pop();
                          //cierra bottomSheet
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255),
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

  void guardarIdVetEncargado(BuildContext context, EncarPeluqueros encargadoPelu, ProgramarCitaPeluProvider dataPelu) {
    dataPelu.setIdEncargadoSelected(encargadoPelu.encargadoPeluqueroId.toString());
    dataPelu.setInicialEncargado(encargadoPelu.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    ProgramarCitaPeluProvider dataOProced = Provider.of<ProgramarCitaPeluProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataOProced.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, ProgramarCitaPeluProvider dataCitaPelu) {
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
        dataCitaPelu.setHoraSelected(formattedTime);

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

  Widget getFotoPaciente(ProgramarCitaPeluProvider dataCitaPelu) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(230, 249, 249, 249),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        child: InkWell(
          onTap: () {
            dataCitaPelu.addPhoto();
          },
          child: Image.file(
            dataCitaPelu.lastImage!,
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
