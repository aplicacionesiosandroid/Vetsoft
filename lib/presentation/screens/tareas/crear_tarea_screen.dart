import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/tareas/etiquetas_tareas_model.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';

import '../../../config/global/palet_colors.dart';
import '../../../providers/tareas/tareas_provider.dart';
import '../../widgets/dropDown_widget.dart';
import '../../widgets/tareas/checkboxReutilizable_widget.dart';
import '../../widgets/textFormFieldsTypes_widget.dart';

class FormularioCrearTarea extends StatefulWidget {
  const FormularioCrearTarea({super.key});

  @override
  State<FormularioCrearTarea> createState() => _FormularioCrearTareaState();
}

class _FormularioCrearTareaState extends State<FormularioCrearTarea> {
  //controller para los buscadores

  final TextEditingController controllerBusquedaPartici =
      TextEditingController();
  final TextEditingController controllerBusquedaEtiquetas =
      TextEditingController();

//controller para los demas

  TextEditingController controllerTituloTarea = TextEditingController();
  TextEditingController controllerDescTarea = TextEditingController();

  TextEditingController controllerNombreEtiqueta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    TareasProvider dataTareas = Provider.of<TareasProvider>(context, listen: true);
    List<ParticipanteTarea> listaParticipantes = dataTareas.getParticipantesTarea;
    List<EtiquetaTarea> listaEtiquetas = dataTareas.getEtiquetasTarea;

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
            'Crear tarea',
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
            child: _crearTarea(dataTareas, sizeScreenWidth, listaParticipantes, listaEtiquetas)
        )
    );
  }

  Widget _crearTarea(
      TareasProvider dataTareas,
      double sizeScreenWidth,
      List<ParticipanteTarea> listaParticipantes,
      List<EtiquetaTarea> listaEtiquetas) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _separacionCampos(20),
              _NombreCampos('Título de las tarea'),
              _separacionCampos(15),
              TextFormFieldConHintValidator(
                controller: controllerTituloTarea,
                colores: const Color.fromARGB(255, 177, 173, 255),
                hintText: 'Título',
              ),
              _separacionCampos(20),
              _NombreCampos('Estado'),
              _separacionCampos(15),
              CustomDropdown(
                value: dataTareas.dropEstadoTarea,
                options: const ['PENDIENTE', 'EN PROCESO', 'REALIZADO'],
                onChanged: (value) {
                  dataTareas.setDropEstadoTarea(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(20),
              _NombreCampos('Etiquetas'),
              _separacionCampos(15),
              SizedBox(
                width: dataTareas.selectedEtiquetasMap.isEmpty
                    ? 80
                    : sizeScreenWidth,
                child: Row(
                  children: [
                    const Icon(
                      IconlyLight.ticket,
                      color: Color.fromARGB(255, 139, 149, 166),
                      size: 28,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: dataTareas.selectedEtiquetasMap.isNotEmpty
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: dataTareas.selectedEtiquetasMap.values
                                  .map((nombre) {
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 240, 230, 254),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    nombre,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 99, 30, 191),
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(),
                    ),
                    SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        openBottomSheetEtiquetasTareas(
                            dataTareas, context, listaEtiquetas);
                        dataTareas.getEtiquetasTareas();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Color.fromARGB(255, 218, 223, 230),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: const Color.fromARGB(255, 139, 149, 166),
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
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
                  dataTareas.selectedParticipantsMap.isNotEmpty
                      ? Flexible(
                          child: Stack(
                            children: [
                              SizedBox(
                                width:
                                    dataTareas.selectedParticipantsMap.length >
                                            2
                                        ? 129
                                        : dataTareas.selectedParticipantsMap
                                                    .length ==
                                                2
                                            ? 86
                                            : 43,
                                height: 45,
                              ),
                              if (dataTareas.selectedParticipantsMap.length >=
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
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/icon/logovs.png',
                                      image: '$imagenUrlGlobal${dataTareas.selectedParticipantsMap.values.elementAt(0)}',
                                      fit: BoxFit.cover,
                                      fadeInDuration: Duration(milliseconds: 200),
                                      fadeInCurve: Curves.easeIn,
                                    ),
                                    // CircleAvatar(
                                    //   backgroundImage: AssetImage(
                                    //       'assets/img/${dataTareas.selectedParticipantsMap.values.elementAt(0).toLowerCase()}.png'),
                                    //   radius: 30,
                                    // ),
                                  ),
                                ),
                              if (dataTareas.selectedParticipantsMap.length >= 2)
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
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/icon/logovs.png',
                                      image: '$imagenUrlGlobal${dataTareas.selectedParticipantsMap.values.elementAt(1)}',
                                      fit: BoxFit.cover,
                                      fadeInDuration: Duration(milliseconds: 200),
                                      fadeInCurve: Curves.easeIn,
                                    ),
                                    // CircleAvatar(
                                    //   backgroundImage: AssetImage(
                                    //       'assets/img/${dataTareas.selectedParticipantsMap.values.elementAt(1).toLowerCase()}.png'),
                                    //   radius: 30,
                                    // ),
                                  ),
                                ),
                              if (dataTareas.selectedParticipantsMap.length > 2)
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
                                        '+${dataTareas.selectedParticipantsMap.length}',
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
                      dataTareas.getParticipantesTareas();
                      openBottomSheetParticipantesTareas(dataTareas, context, listaParticipantes);
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
              ReusableCheckboxFechaIniFin(
                desc: 'Fecha de inicio y finalización',
                onChanged: (newValue) {
                  dataTareas.setCheckFechaIniFin(newValue!);
                },
                value: dataTareas.isCheckedFechaIniFin,
              ),
              _separacionCampos(15),
              dataTareas.isCheckedFechaIniFin
                  ? Row(
                      children: [
                        SizedBox(
                          width: sizeScreenWidth * 0.40,
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
                        Spacer(), // Esto expandirá el espacio entre los dos Text
                        SizedBox(
                          width: sizeScreenWidth * 0.40,
                          child: Text(
                            'Fecha de finalización',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromARGB(255, 29, 34, 44),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              dataTareas.isCheckedFechaIniFin
                  ? Container(
                      margin: EdgeInsets.only(top: 0),
                      child: SizedBox(
                        height: 90,
                        width: sizeScreenWidth,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _openBottomSheetFechaInicio(context);
                              },
                              child: Container(
                                width: sizeScreenWidth * 0.42,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 249, 249, 249),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 25,
                                      color: Color.fromARGB(255, 139, 149, 166),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        dataTareas.fechaInicioSelected,
                                        style: TextStyle(
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                _openBottomSheetFechaFinalizacion(context);
                              },
                              child: Container(
                                width: sizeScreenWidth * 0.42,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 249, 249, 249),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 25,
                                      color: Color.fromARGB(255, 139, 149, 166),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        dataTareas.fechaFinSelected,
                                        style: TextStyle(
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              _NombreCampos('Descripción'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                controller: controllerDescTarea,
                hintText: 'Descripción',
                maxLines: 6,
                colores: const Color.fromARGB(255, 177, 173, 255),
              ),
              _separacionCampos(20),
              SizedBox(
                width: sizeScreenWidth,
                child: Row(
                  children: [
                    const Text("Subtareas",
                        style: TextStyle(
                          fontFamily: 'sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        dataTareas.agregarSubTareas();
                      },
                      child: const Row(
                        children: [
                          Text("Agregar subtarea",
                              style: TextStyle(
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Icon(
                            Icons.add_box_outlined,
                            color: Color.fromARGB(255, 0, 121, 177),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _separacionCampos(15),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataTareas.controllersSubtareas.length,
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
                                  Icons.check_box_outline_blank,
                                  color:
                                      const Color.fromARGB(255, 139, 149, 166),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: TextFormFieldConHint(
                                  colores:
                                      const Color.fromARGB(255, 177, 173, 255),
                                  controller:
                                      dataTareas.controllersSubtareas[index],
                                  hintText: 'Subtarea ${index + 1}',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                dataTareas.eliminarSubTarea(index);
                              },
                              icon: const Icon(
                                Iconsax.trash,
                                color: Color.fromARGB(255, 255, 85, 1),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  );
                },
              ),
              _separacionCampos(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataTareas
                          .enviarDatosCrearTarea(
                              controllerTituloTarea.text,
                              dataTareas.dropEstadoTarea,
                              dataTareas.selectedEtiquetasList,
                              dataTareas.selectedParticipantsList,
                              dataTareas.fechaInicioSelected,
                              dataTareas.fechaFinSelected,
                              controllerDescTarea.text,
                              dataTareas.controllersSubtareas)
                          .then((_) async {
                        if (dataTareas.okpostDatosCrearTarea) {
                          Navigator.of(context).pop();
                          _mostrarFichaCreada(
                              context, '¡Registro creado con éxito!');
                          dataTareas.getActRecienteTareas();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 115, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: dataTareas.loadingDatosCrearTarea
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
                            'Crear tarea',
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

  late StateSetter _setStateHexa;
  void openBottomSheetCrearEtiquetaTarea(
      BuildContext context, TareasProvider dataTareas) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext currentContext, StateSetter setState) {
                _setStateHexa = setState;

                String valorHexadecimal =
                    dataTareas.almacenColorEtiqueta.isEmpty
                        ? 'FFFFFF'
                        : dataTareas.almacenColorEtiqueta;

                return Container(
                  padding: EdgeInsets.all(15),
                  height: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Crear nueva etiqueta',
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      _separacionCampos(20),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(int.parse('0xFF$valorHexadecimal'))
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: Center(
                          child: Text(
                            controllerNombreEtiqueta.text,
                            style: TextStyle(
                                color:
                                    Color(int.parse('0xFF$valorHexadecimal')),
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      _separacionCampos(15),
                      _NombreCampos('Nombre de la etiqueta'),
                      _separacionCampos(15),
                      TextFormFieldConHintValidator(
                        controller: controllerNombreEtiqueta,
                        hintText: 'Nombre de la etiqueta (Ej: “Prioridad”)',
                        colores: const Color.fromARGB(255, 177, 173, 255),
                      ),
                      _separacionCampos(20),
                      _NombreCampos('Elige un color'),
                      _separacionCampos(15),
                      Wrap(
                        spacing:
                            10.0, // Espacio horizontal entre los contenedores
                        runSpacing:
                            8.0, // Espacio vertical entre las filas de contenedores
                        children: <Widget>[
                          _cuadroTicketColor(
                              currentContext, Color(0xFFF368E0), 'F368E0'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFFDA176F), 'DA176F'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFFEE5353), 'EE5353'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFFFF9F43), 'FF9F43'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFFFEE357), 'FEE357'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFF00D2D3), '00D2D3'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFF00A3A4), '00A3A4'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFF0ABDE3), '0ABDE3'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFF2E86DE), '2E86DE'),
                          _cuadroTicketColor(
                              currentContext, Color(0xFF735CFF), '735CFF'),
                        ],
                      ),
                      _separacionCampos(20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            dataTareas
                                .enviarDatosCrearEtiqueta(
                              controllerNombreEtiqueta.text,
                              dataTareas.almacenColorEtiqueta,
                            )
                                .then((_) async {
                              if (dataTareas.OkpostDatosCrearEtiqueta) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                _mostrarFichaCreada(
                                    context, '¡Etiqueta creada!');
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 115, 92, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: dataTareas.loadingDatosCrearTarea
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
                                  'Crear etiqueta',
                                  style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  InkWell _cuadroTicketColor(
      BuildContext context, Color hexaColor, String hexaString) {
    return InkWell(
      onTap: () {
        _setStateHexa(() {
          Provider.of<TareasProvider>(context, listen: false)
              .setalmacenColorEtiqueta(hexaString);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: hexaColor, borderRadius: BorderRadius.circular(10)),
        width: 60,
        height: 42,
      ),
    );
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
    TareasProvider dataTarea =
        Provider.of<TareasProvider>(context, listen: false);
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
    TareasProvider dataTarea =
        Provider.of<TareasProvider>(context, listen: false);
    setState(() {
      todayFin = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(todayFin);
      print(formattedDateEnviar);
      dataTarea.setFechaFinSelected(formattedDateEnviar);
    });
  }

  void openBottomSheetParticipantesTareas(TareasProvider dataTareas, BuildContext context, List<ParticipanteTarea> listaParticipantes) {
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
                                  leading: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icon/logovs.png',
                                    image: '$imagenUrlGlobal${participante.imgUser}',
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(milliseconds: 200),
                                    fadeInCurve: Curves.easeIn,
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

  void openBottomSheetEtiquetasTareas(TareasProvider dataTareas,
      BuildContext context, List<EtiquetaTarea> listaEtiquetas) {
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
          heightFactor: 0.8,
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
                      Text('Etiquetas',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 29, 34, 44),
                              fontSize: 16,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700)),
                      Consumer<TareasProvider>(
                        builder: (context, dataTareas, child) {
                          return Text(
                              ' (${dataTareas.selectedEtiquetasMap.length})',
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
                  controller: controllerBusquedaEtiquetas,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaEtiquetas.clear();
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
                    hintText: 'Busca una etiqueta',
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
                    listaFiltradaProvider.filtrarListaEtiqueta(
                        listaEtiquetas, query);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: controllerBusquedaEtiquetas.text.isEmpty
                      ? Consumer<TareasProvider>(
                          builder: (context, provider, child) {
                            final listaEtiquetasss = provider.getEtiquetasTarea;
                            return ListView.builder(
                              itemCount: listaEtiquetasss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final etiqueta = listaEtiquetasss[index];
                                final isSelected = provider
                                    .isSelectedEtiquetaMap(etiqueta.etiquetaId);

                                return ListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  leading: isSelected
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: const Color.fromARGB(
                                              255, 65, 0, 152),
                                        )
                                      : Icon(
                                          Icons.radio_button_off,
                                          color: const Color.fromARGB(
                                              255, 65, 0, 152),
                                        ),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 240, 230, 254),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        etiqueta.nombre,
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 99, 30, 191),
                                          fontSize: 12,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(Icons.edit,
                                      color:
                                          Color.fromARGB(255, 139, 149, 166)),
                                  onTap: () {
                                    provider.toggleSelectionEtiquetaMap(
                                        etiqueta.etiquetaId, etiqueta.nombre);
                                  },
                                );
                              },
                            );
                          },
                        )
                      : dataTareas.listaFiltradaEtiquetas.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                Image.asset('assets/img/noresults.png'),
                                const Text(
                                  'No encontramos ninguna etiqueta que coincida con tu búsqueda.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans',
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 29, 34, 44)),
                                ),
                                const Expanded(
                                  child: Text(
                                    'No te preocupes, Puedes crear una nueva etiqueta haciendo clic en el botón "Crear etiqueta" y agregarla a tu tarea para mantener todo organizado.',
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
                                final listaFiltradaEtiqueta =
                                    provider.listaFiltradaEtiquetas;
                                return ListView.builder(
                                  itemCount: listaFiltradaEtiqueta.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final etiqueta =
                                        listaFiltradaEtiqueta[index];
                                    final isSelected =
                                        provider.isSelectedEtiquetaMap(
                                            etiqueta.etiquetaId);

                                    return ListTile(
                                      contentPadding: EdgeInsets.only(left: 0),
                                      leading: isSelected
                                          ? Icon(
                                              Icons.radio_button_checked,
                                              color: const Color.fromARGB(
                                                  255, 65, 0, 152),
                                            )
                                          : Icon(
                                              Icons.radio_button_off,
                                              color: const Color.fromARGB(
                                                  255, 65, 0, 152),
                                            ),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 240, 230, 254),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            etiqueta.nombre,
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 99, 30, 191),
                                              fontSize: 12,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      trailing: Icon(Icons.edit,
                                          color: Color.fromARGB(
                                              255, 139, 149, 166)),
                                      onTap: () {
                                        provider.toggleSelectionEtiquetaMap(
                                            etiqueta.etiquetaId,
                                            etiqueta.nombre);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                ),
                ElevatedButton(
                  onPressed: () {
                    openBottomSheetCrearEtiquetaTarea(context, dataTareas);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 115, 92, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: dataTareas.loadingDatosCrearTarea
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
                      : const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconlyLight.ticket,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 28,
                              ),
                              Text(
                                'Crear nueva etiqueta',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                )
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
