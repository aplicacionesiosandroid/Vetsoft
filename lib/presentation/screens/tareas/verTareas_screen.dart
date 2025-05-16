import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/tareas/tareas_fecha_model.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verDetalleTarea_screen.dart';

import '../../../config/global/palet_colors.dart';
import '../../../providers/tareas/tareas_provider.dart';
import '../optionsDrawer/tareas_screen.dart';

class FormularioVerTareas extends StatefulWidget {
  const FormularioVerTareas({super.key});

  @override
  State<FormularioVerTareas> createState() => _FormularioVerTareasState();
}

class _FormularioVerTareasState extends State<FormularioVerTareas> {
  //controller para los buscadores

  final TextEditingController controllerBusquedaPartici =
      TextEditingController();
  final TextEditingController controllerBusquedaEtiquetas =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    TareasProvider dataTareas =
        Provider.of<TareasProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              IconlyLight.arrow_left,
              color: Color.fromARGB(255, 29, 34, 44),
              size: 30,
            ),
          ),
          title: const Text(
            'Tareas',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 29, 34, 44),
                fontFamily: 'sans',
                fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
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
            padding: const EdgeInsets.all(15.0),
            child: _verTarea(dataTareas, sizeScreen)));
  }

  Widget _verTarea(
    TareasProvider dataTareas,
    Size sizeScreen,
  ) {
    final listatareas = dataTareas.getTareasPorFecha;

    final listafistradaTareaFecha = dataTareas.listaFiltradaTareaFechas;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                child: EasyDateTimeLine(
                  headerProps: const EasyHeaderProps(
                      showSelectedDate: true,
                      selectedDateFormat:
                          SelectedDateFormat.fullDateMonthAsStrDY,
                      monthPickerType: MonthPickerType.switcher),
                  dayProps: EasyDayProps(
                    inactiveBorderRadius: 35,
                    dayStructure: DayStructure.dayStrDayNum,
                    height: 90,
                    width: 45,
                    activeDayDecoration: BoxDecoration(
                        color: const Color.fromARGB(255, 65, 0, 152),
                        borderRadius: BorderRadius.circular(35)),
                  ),
                  activeColor: const Color.fromARGB(255, 65, 0, 152),
                  locale: 'es_ES',
                  initialDate: DateTime.now(),
                  onDateChange: (selectedDate) {
                    final fechaSeleccionada =
                        DateFormat("yyyy-MM-dd").format(selectedDate);
                    dataTareas.getTareasFecha(fechaSeleccionada);
                  },
                ),
              ),
              Container(
                //margin: EdgeInsets.symmetric(vertical: 5),
                //padding: EdgeInsets.all(5),
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                color: dataTareas.selectedButtonIndex != index
                                    ? ColorPalet.complementViolet2
                                    : Color(0xFF7328D6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor:
                                dataTareas.selectedButtonIndex == index
                                    ? ColorPalet.acentDefault
                                    : ColorPalet.complementViolet2),
                        onPressed: () {
                          dataTareas.setSelectButton(index);

                          // Realiza la lógica correspondiente al botón presionado aquí
                          switch (index) {
                            case 0:
                              String query = 'TODAS';
                              dataTareas.filtrarListaTareasFecha(
                                  listatareas, query);
                              break;
                            case 1:
                              String query = 'PENDIENTE';
                              dataTareas.filtrarListaTareasFecha(
                                  listatareas, query);
                              break;
                            case 2:
                              String query = 'EN PROCESO';
                              dataTareas.filtrarListaTareasFecha(
                                  listatareas, query);
                              break;
                            case 3:
                              String query = 'REALIZADO';
                              dataTareas.filtrarListaTareasFecha(
                                  listatareas, query);
                              break;
                          }
                        },
                        child: Text(
                          index == 0
                              ? 'Todas'
                              : index == 1
                                  ? 'Por hacer'
                                  : index == 2
                                      ? 'En progreso'
                                      : 'Terminadas',
                          style: TextStyle(
                              color: dataTareas.selectedButtonIndex == index
                                  ? Colors.white
                                  : ColorPalet.secondaryDefault),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: sizeScreen.width,
                child: Row(
                  children: [
                    const Text("Tareas del día",
                        style: TextStyle(
                          fontFamily: 'sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        openModalBottomSheetCrearTarea(context);
                      },
                      child: const Row(
                        children: [
                          Text("Crear tarea",
                              style: TextStyle(
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Icon(
                            Iconsax.add_square,
                            color: Color.fromARGB(255, 0, 121, 177),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 400,
                child: dataTareas.loadingBusqueda
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorPalet.acentDefault,
                        ),
                      )
                    : dataTareas.getTareasPorFecha.isEmpty ||
                            dataTareas.listaFiltradaTareaFechas.isEmpty
                        ? Center(
                            child: Text('No hay tareas para este día'),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: listafistradaTareaFecha.length,
                            itemBuilder: (context, index) {
                              final tarea = listafistradaTareaFecha[index];
                              return InkWell(
                                onTap: () {
                                  dataTareas
                                      .getVerTareaID(tarea.tareaId)
                                      .then((_) async {
                                    if (dataTareas
                                        .loadingDatosParaDetalleTarea) {
                                      openModalBottomSheetVerDetalleTarea(
                                          context, dataTareas);
                                      dataTareas
                                          .setLoadingDatosParaDetalleTarea(
                                              false);
                                    }
                                  });
                                },
                                child: Container(
                                  width: sizeScreen.width,
                                  height: 150,
                                  margin: EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 246, 239, 255),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 224, 76, 55),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width: 4,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8, top: 5, bottom: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tarea.titulo,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 29, 34, 44),
                                                  fontFamily: 'sans',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Estado: ',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 139, 149, 166),
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  tarea.estado,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 29, 34, 44),
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Iconsax.calendar_2,
                                                  color: Color.fromARGB(
                                                      255, 139, 149, 166),
                                                ),
                                                Text(
                                                  tarea.fechaInicio
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 29, 34, 44),
                                                      fontFamily: 'inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _bottomSheetOptionsTareas(
                                                    context, sizeScreen, tarea);
                                              },
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color:
                                                    ColorPalet.secondaryLight,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ]),
      ),
    );

    // Obteniendo fecha del table calendar fecha inicio
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
}

Future<dynamic> _bottomSheetOptionsTareas(
    BuildContext context, Size sizeScreen, Tareafecha tareafecha) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    child: Divider(
                      // Línea superior
                      color: ColorPalet.grisesGray3,
                      thickness: 3.0,
                    ),
                  ),
                ],
              ),
              Container(
                width: sizeScreen.width,
                height: 100,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: ColorPalet.grisesGray4, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 224, 76, 55),
                          borderRadius: BorderRadius.circular(8)),
                      width: 4,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tareafecha.titulo,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 29, 34, 44),
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Estado: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                tareafecha.estado,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 29, 34, 44),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      Iconsax.edit,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Editar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Iconsax.arrow_left,
                                            color: ColorPalet.grisesGray0),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Marcar como',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'sans',
                                          fontWeight: FontWeight.w700,
                                          color: ColorPalet.grisesGray0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                /* InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.recovery_convert,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'En espera',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), */
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    Provider.of<TareasProvider>(context, listen: false)
                                          .moverEstadoTarea( tareafecha.tareaId, 'terminadas').then((value) async {
                                      
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();       
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clipboard_text,
                                        color: Color.fromARGB(255, 72, 86, 109),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Terminado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 72, 86, 109),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.recovery_convert,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Mover a',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _mostrarAlertaEliminarCita(context, tareafecha.tareaId);
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.trash,
                      color: Color.fromARGB(255, 72, 86, 109),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Eliminar cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 72, 86, 109),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ]),
      );
    },
  );
}

void _mostrarAlertaEliminarCita(BuildContext context, int idTarea) {
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
            '¿Estás seguro/a de que quieres eliminar esta tarea?',
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
                    'Si eliminas esta tarea, no podrás recuperarla más tarde.',
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
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 85, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'No, cancelar',
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
                                Provider.of<TareasProvider>(context,
                                        listen: false)
                                    .eliminarTarea(idTarea)
                                    .then((value) async {
                                  Provider.of<TareasProvider>(context,
                                          listen: false)
                                      .setOKsendEliminarTarea(false);
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: ColorPalet.secondaryDefault,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'Sí, eliminar',
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

void openModalBottomSheetVerDetalleTarea(
    BuildContext context, TareasProvider dataTareas) {
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
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(
              child: dataTareas.getVerTareaDetalle.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : VerDetalleTarea(),
            ),
          ]),
        ),
      );
    },
  );
}
