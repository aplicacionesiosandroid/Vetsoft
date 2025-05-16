import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/models/tareas/objetivos/model_tareas_obj.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import 'package:vet_sotf_app/presentation/widgets/tareas/checkboxReutilizable_widget.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../providers/tareas/objetivos_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class FormularioCrearObjetivo extends StatefulWidget {
  const FormularioCrearObjetivo({super.key});

  @override
  State<FormularioCrearObjetivo> createState() =>
      _FormularioCrearObjetivoState();
}

class _FormularioCrearObjetivoState extends State<FormularioCrearObjetivo> {
  //controller para los buscadores

  final TextEditingController controllerBusquedaPartici =
      TextEditingController();

  final TextEditingController controllerBusquedaTareas =
      TextEditingController();

//controller para los demas

  TextEditingController controllerTituloObjetivo = TextEditingController();
  TextEditingController controllerDescObjetivo = TextEditingController();

  TextEditingController controllerRecompensaObjetivo = TextEditingController();

  //controller en caso de que la medicion sea numerico

  TextEditingController controllerNumericoObjetivo = TextEditingController();
  TextEditingController controllerNumericoActual = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    ObjetivosProvider dataObjetivos =
        Provider.of<ObjetivosProvider>(context, listen: true);
    List<ParticipanteTarea> listaParticipantes =
        dataObjetivos.getParticipantesObjetivo;

    List<TareaObjetivo> listaTareas = dataObjetivos.tareaObjetivo;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
            'Crear objetivo',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _mostrarAlertaCancelar(context);
              },
              icon: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 29, 34, 44),
                size: 30,
              ),
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(15.0),
            child: _crearTarea(dataObjetivos, sizeScreenWidth,
                listaParticipantes, listaTareas)));
  }

  Widget _crearTarea(
    ObjetivosProvider dataObjetivos,
    double sizeScreenWidth,
    List<ParticipanteTarea> listaParticipantes,
    List<TareaObjetivo> listaTareas,
  ) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _separacionCampos(20),
              _NombreCampos('Título del objetivo'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                controller: controllerTituloObjetivo,
                colores: const Color.fromARGB(255, 177, 173, 255),
                hintText: 'Título',
              ),
              _separacionCampos(20),
              _NombreCampos('Estado'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataObjetivos.dropEstadoObjetivo,
                options: const ['PENDIENTE', 'EN PROCESO', 'REALIZADO'],
                onChanged: (value) {
                  dataObjetivos.setDropEstadoObjetivo(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(20),
              _NombreCampos('Participantes'),
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
                  dataObjetivos.selectedParticipantsMap.isNotEmpty
                      ? Flexible(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: dataObjetivos
                                            .selectedParticipantsMap.length >
                                        2
                                    ? 129
                                    : dataObjetivos.selectedParticipantsMap
                                                .length ==
                                            2
                                        ? 86
                                        : 43,
                                height: 45,
                              ),
                              if (dataObjetivos
                                      .selectedParticipantsMap.length >=
                                  1)
                                Positioned(
                                  left: 0,
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
                                      backgroundImage: AssetImage(
                                          'assets/img/${dataObjetivos.selectedParticipantsMap.values.elementAt(0).toLowerCase()}.png'),
                                      radius: 30,
                                    ),
                                  ),
                                ),
                              if (dataObjetivos
                                      .selectedParticipantsMap.length >=
                                  2)
                                Positioned(
                                  left: 30,
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
                                      backgroundImage: AssetImage(
                                          'assets/img/${dataObjetivos.selectedParticipantsMap.values.elementAt(1).toLowerCase()}.png'),
                                      radius: 30,
                                    ),
                                  ),
                                ),
                              if (dataObjetivos.selectedParticipantsMap.length >
                                  2)
                                Positioned(
                                  left: 60,
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
                                        '+${dataObjetivos.selectedParticipantsMap.length}',
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
                      _openBottomSheetParticipantes(
                          dataObjetivos, context, listaParticipantes);
                      dataObjetivos.getParticipantesObjetivos();
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
              _separacionCampos(20),
              _separacionCampos(15),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        'Fecha de inicio',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromARGB(255, 29, 34, 44),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeScreenWidth * 0.02,
                  ), // Esto expandirá el espacio entre los dos Text
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        'Vencimiento',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromARGB(255, 29, 34, 44),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 0),
                child: SizedBox(
                  height: 90,
                  width: sizeScreenWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _openBottomSheetFechaInicio(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 249, 249, 249),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.calendar_1,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    dataObjetivos.fechaInicioSelected,
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 139, 149, 166),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sizeScreenWidth * 0.02,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _openBottomSheetFechaFinalizacion(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 249, 249, 249),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.calendar_1,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    dataObjetivos.fechaFinSelected,
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 139, 149, 166),
                                    ),
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
              ),
              _NombreCampos('Descripción del objetivo'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                controller: controllerDescObjetivo,
                hintText: 'Descripción',
                maxLines: 6,
                colores: const Color.fromARGB(255, 177, 173, 255),
              ),
              _separacionCampos(20),
              _NombreCampos('¿Cómo vas a medir el progreso?'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataObjetivos.dropTipoProgreso,
                options: const [
                  'Progreso numérico',
                  'Progreso por tareas',
                  'No quiero medir el progreso'
                ],
                onChanged: (value) {
                  dataObjetivos.setDropTipoProgreso(value!);
                },
                hintText: 'Seleccionar...',
              ),
              if (dataObjetivos.widgetTipoProgreso != 0) _separacionCampos(15),
              dataObjetivos.widgetTipoProgreso == 1
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                'Objetivo',
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 29, 34, 44),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeScreenWidth * 0.02,
                          ), // Esto expandirá el espacio entre los dos Text
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                'Actual',
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 29, 34, 44),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              dataObjetivos.widgetTipoProgreso == 1
                  ? Container(
                      padding: EdgeInsets.only(left: 15),
                      width: sizeScreenWidth,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextFormFieldNumberConHint(
                              colores: ColorPalet.secondaryLight,
                              hintText: '0',
                            ),
                          ),
                          SizedBox(
                            width: sizeScreenWidth * 0.02,
                          ),
                          Flexible(
                            child: TextFormFieldNumberConHint(
                              colores: ColorPalet.secondaryLight,
                              hintText: '0',
                            ),
                          ),
                        ],
                      ),
                    )
                  : dataObjetivos.widgetTipoProgreso == 2
                      ? InkWell(
                          onTap: () {
                            _openBottomSheetTareasObjetivos(
                                dataObjetivos, context, listaTareas);
                            dataObjetivos.getTareasObjetivos();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Icon(Iconsax.add_square,
                                    color: ColorPalet.estadoNeutral),
                                SizedBox(
                                  width: sizeScreenWidth * 0.02,
                                ),
                                Text(
                                  'Agregar tarea',
                                  style: TextStyle(
                                      color: ColorPalet.estadoNeutral,
                                      fontFamily: 'inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                      _separacionCampos(20),
                      dataObjetivos.widgetTipoProgreso == 2
                      ? Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: Text(
                          '${dataObjetivos.selectedTareasList.length} Tarea(s) seleccionada(s)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w500,
                            color: ColorPalet.grisesGray2
                          ),
                        ),
                      )
                      :Container(),
              _separacionCampos(20),
              ReusableCheckboxAddRecompensa(
                desc: 'Agregar recompensa',
                onChanged: (newValue) {
                  dataObjetivos.setCheckAddRecompensa(newValue!);
                },
                value: dataObjetivos.isCheckedAddRecompensa,
              ),
              dataObjetivos.isCheckedAddRecompensa
                  ? TextFormFieldConHint(
                      hintText: 'Día libre',
                      colores: ColorPalet.secondaryLight,
                      controller: controllerRecompensaObjetivo,
                    )
                  : Container(),
              _separacionCampos(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      final datosTarea = <String, dynamic>{
                        "titulo": controllerTituloObjetivo.text,
                        "estado": dataObjetivos.dropEstadoObjetivo,
                        "participantes": dataObjetivos.selectedParticipantsList,
                        "fecha_inicio": dataObjetivos.fechaInicioSelected,
                        "fecha_fin": dataObjetivos.fechaFinSelected,
                        "descripcion": controllerDescObjetivo.text,
                        "medicion_objetivo": dataObjetivos.dropTipoProgreso ==
                                'Progreso por tareas'
                            ? 'tareas'
                            : 'ninguno',
                        "tareas": dataObjetivos.selectedTareasList.join(','),
                        "recompensa_estado":
                            dataObjetivos.isCheckedAddRecompensa,
                        "recompensa": controllerRecompensaObjetivo.text
                      };

                      final datosNumerico = <String, dynamic>{
                        "titulo": controllerTituloObjetivo.text,
                        "estado": dataObjetivos.dropEstadoObjetivo,
                        "participantes": dataObjetivos.selectedParticipantsList,
                        "fecha_inicio": dataObjetivos.fechaInicioSelected,
                        "fecha_fin": dataObjetivos.fechaFinSelected,
                        "descripcion": controllerDescObjetivo.text,
                        "medicion_objetivo": dataObjetivos.dropTipoProgreso ==
                                'Progreso numérico'
                            ? 'numerico'
                            : 'ninguno',
                        "objetivo": controllerNumericoObjetivo.text,
                        "actual": controllerNumericoActual.text,
                        "recompensa_estado":
                            dataObjetivos.isCheckedAddRecompensa,
                        "recompensa": controllerRecompensaObjetivo.text
                      };

                      final datosNinguno = <String, dynamic>{
                        "titulo": controllerTituloObjetivo.text,
                        "estado": dataObjetivos.dropEstadoObjetivo,
                        "participantes": dataObjetivos.selectedParticipantsList,
                        "fecha_inicio": dataObjetivos.fechaInicioSelected,
                        "fecha_fin": dataObjetivos.fechaFinSelected,
                        "descripcion": controllerDescObjetivo.text,
                        "medicion_objetivo": 'ninguno',
                        "recompensa_estado":
                            dataObjetivos.isCheckedAddRecompensa,
                        "recompensa": controllerRecompensaObjetivo.text
                      };

                      final Map<String, dynamic> datos;

                      if (dataObjetivos.dropTipoProgreso ==
                          'Progreso por tareas') {
                        datos = datosTarea;
                      } else if (dataObjetivos.dropTipoProgreso ==
                          'Progreso numérico') {
                        datos = datosNumerico; 
                      } else {
                        datos = datosNinguno;
                      }

                      dataObjetivos.enviarDatosCrearObjetivo(datos).then((_) async {
                        if (dataObjetivos.okpostDatosCrearObjetivo) {
                          Navigator.of(context).pop();
                          _mostrarFichaCreada(
                              context, '¡Registro creado con éxito!');
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 115, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: dataObjetivos.loadingDatosCrearObjetivo
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
                            'Crear objetivo',
                            style: TextStyle(
                                color: ColorPalet.grisesGray5,
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
              ),
            ]),
      ),
    );

    // Obteniendo fecha del table calendar fecha inicio
  }

  void _openBottomSheetFechaInicio(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        DateTime _nowDate = DateTime.now();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(15),
              height: 500,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      width: 30,
                      height: 2, // Altura de la línea
                      color: const Color.fromARGB(
                          255, 161, 158, 158), // Color de la línea
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar fecha de inicio',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TableCalendar(
                    //onDaySelected: _onDaySelectedFInicio,
                    onDaySelected: (day, focusedDay) {
                      setState(() {
                        todayInicio = day;
                      });
                      _onDaySelectedFInicio(day, focusedDay, context);
                    },

                    selectedDayPredicate: (day) => isSameDay(day, todayInicio),
                    locale: 'es_ES',
                    rowHeight: 43,

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      titleTextFormatter:
                          (DateTime focusedDay, dynamic format) {
                        final monthFormat = DateFormat('MMMM', 'es_ES');
                        final monthText = monthFormat.format(focusedDay);
                        final capitalizedMonth =
                            '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                        return '$capitalizedMonth ${focusedDay.year}';
                      },
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: todayInicio,
                    firstDay: DateTime.utc(2023, 02, 10),
                    lastDay: DateTime(
                        _nowDate.year + 1,
                        _nowDate.month,
                        _nowDate.day,
                        _nowDate.hour,
                        _nowDate.minute,
                        _nowDate.second),

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
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTime todayInicio = DateTime.now();

  void _onDaySelectedFInicio(
      DateTime day, DateTime focusedDay, BuildContext context) {
    ObjetivosProvider dataTarea =
        Provider.of<ObjetivosProvider>(context, listen: false);
    setState(() {
      todayInicio = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayInicio);
      print(formattedDateEnviar);
      dataTarea.setFechaInicioSelected(formattedDateEnviar);
    });
  }

  void _openBottomSheetFechaFinalizacion(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        DateTime _nowDate = DateTime.now();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(15),
              height: 500,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      width: 30,
                      height: 2, // Altura de la línea
                      color: const Color.fromARGB(
                          255, 161, 158, 158), // Color de la línea
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar fecha de finalización',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TableCalendar(
                    //onDaySelected: _onDaySelectedFInicio,
                    onDaySelected: (day, focusedDay) {
                      setState(() {
                        todayFin = day;
                      });
                      _onDaySelectedFin(day, focusedDay, context);
                    },

                    selectedDayPredicate: (day) => isSameDay(day, todayFin),
                    locale: 'es_ES',
                    rowHeight: 43,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      titleTextFormatter:
                          (DateTime focusedDay, dynamic format) {
                        final monthFormat = DateFormat('MMMM', 'es_ES');
                        final monthText = monthFormat.format(focusedDay);
                        final capitalizedMonth =
                            '${monthText[0].toUpperCase()}${monthText.substring(1)}';

                        return '$capitalizedMonth ${focusedDay.year}';
                      },
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: todayFin,
                    firstDay: DateTime.utc(2023, 02, 10),
                    lastDay: DateTime(
                        _nowDate.year + 1,
                        _nowDate.month,
                        _nowDate.day,
                        _nowDate.hour,
                        _nowDate.minute,
                        _nowDate.second),
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTime todayFin = DateTime.now();

  void _onDaySelectedFin(
      DateTime day, DateTime focusedDay, BuildContext context) {
    ObjetivosProvider dataTarea =
        Provider.of<ObjetivosProvider>(context, listen: false);
    setState(() {
      todayFin = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayFin);
      print(formattedDateEnviar);
      dataTarea.setFechaFinSelected(formattedDateEnviar);
    });
  }

  void _openBottomSheetParticipantes(ObjetivosProvider dataTareas,
      BuildContext context, List<ParticipanteTarea> listaParticipantes) {
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
                      Consumer<ObjetivosProvider>(
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
                        Provider.of<ObjetivosProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaParticipante(
                        listaParticipantes, query);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaPartici.text.isEmpty
                      ? Consumer<ObjetivosProvider>(
                          builder: (context, provider, child) {
                            final listaParticipantesss =
                                provider.getParticipantesObjetivo;
                            return ListView.builder(
                              itemCount: listaParticipantesss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final participante =
                                    listaParticipantesss[index];
                                final isSelected = provider
                                    .isSelectedMap(participante.encargadoId);

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
                                        participante.itemName);
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
                          : Consumer<ObjetivosProvider>(
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

  void _openBottomSheetTareasObjetivos(ObjetivosProvider dataTareas,
      BuildContext context, List<TareaObjetivo> listaTareas) {
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
                      Text('Tareas',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                      Consumer<ObjetivosProvider>(
                        builder: (context, dataTareas, child) {
                          return Text(
                              ' (${dataTareas.selectedTareasList.length})',
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
                  controller: controllerBusquedaTareas,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaTareas.clear();
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
                    hintText: 'Nombre de tarea',
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
                        Provider.of<ObjetivosProvider>(context, listen: false);
                    listaFiltradaProvider.filtrarListaTarea(listaTareas, query);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaTareas.text.isEmpty
                      ? Consumer<ObjetivosProvider>(
                          builder: (context, provider, child) {
                            final listaTareas = provider.tareaObjetivo;
                            return ListView.builder(
                              itemCount: listaTareas.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tarea = listaTareas[index];
                                final isSelected =
                                    provider.isSelectedTarea(tarea.tareaId);

                                return ListTile(
                                  leading: Icon(Iconsax.task),
                                  title: Text(
                                    tarea.tiruloTarea,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider
                                        .toggleSelectionTarea(tarea.tareaId);
                                  },
                                );
                              },
                            );
                          },
                        )
                      : dataTareas.listaFiltradaTarea.isEmpty
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
                          : Consumer<ObjetivosProvider>(
                              builder: (context, provider, child) {
                                final listaFiltradaTarea =
                                    provider.listaFiltradaTarea;
                                return ListView.builder(
                                  itemCount: listaFiltradaTarea.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final tarea = listaFiltradaTarea[index];
                                    final isSelected =
                                        provider.isSelectedTarea(tarea.tareaId);

                                    return ListTile(
                                      leading: Icon(Iconsax.task),
                                      title: Text(
                                        tarea.tiruloTarea,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Color.fromARGB(255, 99, 92, 255)
                                              : null,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(Icons.check,
                                              color: Color.fromARGB(
                                                  255, 99, 92, 255))
                                          : null,
                                      onTap: () {
                                        provider.toggleSelectionTarea(
                                          tarea.tareaId,
                                        );
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
                                      color: ColorPalet.grisesGray5,
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
                                        Color.fromARGB(255, 99, 92, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  'Quedarme aquí',
                                  style: TextStyle(
                                      color: ColorPalet.grisesGray5,
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

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 28, 149, 187),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10), // Ajusta el espacio izquierdo
              Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Text(
                textoMessage,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
              ),
              Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 10), // Ajusta el espacio derecho
            ],
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
