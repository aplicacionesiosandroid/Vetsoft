import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/models/tareas/tareas_fecha_model.dart';
import 'package:vet_sotf_app/presentation/screens/tareas/verDetalleTarea_screen.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/tareas/objetivos/tablero_objetivos_model.dart';
import '../../../../providers/tareas/objetivos_provider.dart';
import '../../optionsDrawer/tareas_screen.dart';

class FormularioVerobjetivos extends StatefulWidget {
  const FormularioVerobjetivos({super.key});

  @override
  State<FormularioVerobjetivos> createState() => _FormularioVerobjetivosState();
}

class _FormularioVerobjetivosState extends State<FormularioVerobjetivos> {
  //controller para los buscadores

  final TextEditingController controllerBusquedaPartici =
      TextEditingController();
  final TextEditingController controllerBusquedaEtiquetas =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    ObjetivosProvider dataObjetivos =
        Provider.of<ObjetivosProvider>(context, listen: true);

    final listTableroObj = dataObjetivos.tableroObjetivosList;

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
            'Objetivos',
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
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: _verTarea(dataObjetivos, sizeScreen, listTableroObj)));
  }

  Widget _verTarea(ObjetivosProvider dataObjetivos, Size sizeScreen,
      List<Objetivos> listTabObjetivo) {
    final listFiltradaObjetivos = dataObjetivos.listaFiltradaTabObjetivo;
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          //margin: EdgeInsets.symmetric(vertical: 5),
          //padding: EdgeInsets.all(5),
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 1,
                          color: dataObjetivos.selectedButtonObjIndex != index
                              ? ColorPalet.complementViolet2
                              : Color(0xFF7328D6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor:
                          dataObjetivos.selectedButtonObjIndex == index
                              ? ColorPalet.acentDefault
                              : ColorPalet.complementViolet2),
                  onPressed: () {
                    dataObjetivos.setSelectObjButton(index);

                    // Realiza la lógica correspondiente al botón presionado aquí
                    switch (index) {
                      case 0:
                        String query = 'TODOS';
                        dataObjetivos.filtrarListaTableroObjetivo(
                                  listTabObjetivo, query);
                        break;
                      case 1:
                        String query = 'EN PROCESO';
                        dataObjetivos.filtrarListaTableroObjetivo(
                                  listTabObjetivo, query);
                        break;
                      case 2:
                        String query = 'REALIZADO';
                        dataObjetivos.filtrarListaTableroObjetivo(
                                  listTabObjetivo, query);
                        break;
                      case 3:
                        String query = 'VENCIDO';
                        dataObjetivos.filtrarListaTableroObjetivo(
                                  listTabObjetivo, query);
                        break;
                    }
                  },
                  child: Text(
                    index == 0
                        ? 'Todos'
                        : index == 1
                            ? 'En progreso'
                            : index == 2
                                ? 'Completados'
                                : 'Vencidos',
                    style: TextStyle(
                        color: dataObjetivos.selectedButtonObjIndex == index
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
              const Text("Tablero de objetivos",
                  style: TextStyle(
                    fontFamily: 'sans',
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  openModalBottomSheetCrearObjetivo(context);
                },
                child: const Row(
                  children: [
                    Text("Crear objetivo",
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
        Expanded(
          child: RefreshIndicator(
            onRefresh: dataObjetivos.getTableroObjetivosList,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: dataObjetivos.selectedButtonObjIndex == 0 ? listTabObjetivo.length : listFiltradaObjetivos.length,
              itemBuilder: (BuildContext context, int index) {
                final objetivo =dataObjetivos.selectedButtonObjIndex == 0 ? listTabObjetivo[index] : listFiltradaObjetivos[index];
                  
                int cantidadTareas =
                    objetivo.medicion.tipoMedicion == TipoMedicion.TAREAS
                        ? objetivo.medicion.cantidadTareas ?? 0
                        : objetivo.medicion.tipoMedicion == TipoMedicion.NUMERICO
                            ? objetivo.medicion.objetivo ?? 0
                            : 0;
                  
                int cantidadTareasAcabadas =
                    objetivo.medicion.tipoMedicion == TipoMedicion.TAREAS
                        ? objetivo.medicion.cantidadTareasAcabadas ?? 0
                        : objetivo.medicion.tipoMedicion == TipoMedicion.NUMERICO
                            ? objetivo.medicion.actual ?? 0
                            : 0;
                  
                double progreso = cantidadTareas == 0
                    ? 0
                    : cantidadTareasAcabadas / cantidadTareas;
                int porcentaje =
                    cantidadTareas == 0 ? 0 : (progreso * 100).round();
                  
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: sizeScreen.width,
                  height: sizeScreen.height * 0.23,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 1, color: ColorPalet.grisesGray3)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(objetivo.titulo,
                              style: TextStyle(
                                fontFamily: 'sans',
                                color: ColorPalet.grisesGray0,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              )),
                          Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_horiz,
                                  color: ColorPalet.secondaryLight))
                        ],
                      ),
                      Row(
                        children: [
                          Text("Estado: ",
                              style: TextStyle(
                                fontFamily: 'inter',
                                color: ColorPalet.grisesGray2,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                          Text(objetivo.estado,
                              style: TextStyle(
                                fontFamily: 'inter',
                                color: ColorPalet.grisesGray1,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          objetivo.estado == 'EN PROCESO'
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: sizeScreen.width * 0.12,
                                      height: sizeScreen.width * 0.12,
                                      child: CircularProgressIndicator(
                                          color: ColorPalet.secondaryDefault,
                                          strokeWidth: 5,
                                          value: progreso,
                                          backgroundColor:
                                              ColorPalet.grisesGray3),
                                    ),
                                    Text(
                                      '$porcentaje%',
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: ColorPalet.secondaryDark,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(objetivo.descripcion,
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  color: ColorPalet.grisesGray1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            color: ColorPalet.grisesGray2,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${objetivo.fechaInicio.toString().substring(0, 10)} - ${objetivo.fechaFin.toString().substring(0, 10)}",
                              style: TextStyle(
                                fontFamily: 'inter',
                                color: ColorPalet.grisesGray2,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                            Spacer(),
                            SizedBox(
                              height: 50,
                              width: sizeScreen.width * 0.2,
                              child: Center(
                                    child: Stack(
                                      children: [
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
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.purple,
                                              child: Text(
                                                objetivo.participantes[0].nombres.substring(0, 1),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        objetivo.participantes.length > 1
                                        ? Positioned(
                                          left: 30,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4.0,
                                              ),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                objetivo.participantes[1].nombres.substring(0, 1),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ): Container(),
                                        objetivo.participantes.length > 2
                                        ? Positioned(
                                          left: 60,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4.0,
                                              ),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: ColorPalet.acentDefault,
                                              child: Text(
                                                 '+${objetivo.participantes.length - 2}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ): Container(),
                                      ],
                                    ),
                                  ),
                                ),                  
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ]),
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
                                    Provider.of<ObjetivosProvider>(context,
                                            listen: false)
                                        .moverEstadoTarea(
                                            tareafecha.tareaId, 'terminadas')
                                        .then((value) async {
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
                                Provider.of<ObjetivosProvider>(context,
                                        listen: false)
                                    .eliminarTarea(idTarea)
                                    .then((value) async {
                                  Provider.of<ObjetivosProvider>(context,
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

void openModalBottomSheetVerDetalleObjetivo(
    BuildContext context, ObjetivosProvider dataTareas) {
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
