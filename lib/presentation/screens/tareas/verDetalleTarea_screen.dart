import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../config/global/palet_colors.dart';
import '../../../models/tareas/verTarea_model.dart';
import '../../../providers/tareas/tareas_provider.dart';

class VerDetalleTarea extends StatefulWidget {
  const VerDetalleTarea({super.key});

  @override
  State<VerDetalleTarea> createState() => _VerDetalleTareaState();
}

class _VerDetalleTareaState extends State<VerDetalleTarea> {
  //controller para los buscadores

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    TareasProvider dataTareas =
        Provider.of<TareasProvider>(context, listen: true);

    List<Tarea> detalleTarea = dataTareas.getVerTareaDetalle;
    //Subtareas subtareas = detalleTarea[0].subtareas;
    //List<Subtarea> listaSubtareas = subtareas.subtareas;
    //List<Subtarea> listaSubtareas = detalleTarea[0].subtareas.subtareas;

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
            'Detalle de la tarea',
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
                Icons.more_vert,
                color: Color.fromARGB(255, 29, 34, 44),
                size: 30,
              ),
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: _verTarea(dataTareas, sizeScreen, detalleTarea)));
  }

  Widget _verTarea(
      TareasProvider dataTareas, Size sizeScreen, List<Tarea> detalleTareaId) {
    return Container(
      height: sizeScreen.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NombreCampos(detalleTareaId[0].titulo, 18),
              _separacionCampos(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Estado: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    detalleTareaId[0].estado,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 29, 34, 44),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              detalleTareaId[0].subtareas.cantidad == 0
                  ? Container()
                  : Column(
                      children: [
                        _separacionCampos(20),
                        SizedBox(
                          width: sizeScreen.width,
                          child: Row(
                            children: [
                              Text(
                                '${detalleTareaId[0].subtareas.cantidad.toString()} Subtareas',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: ColorPalet.grisesGray2,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                              const Spacer(),
                              Text(
                                '${(detalleTareaId[0].subtareas.cantidadSubtareasAcabadas / detalleTareaId[0].subtareas.cantidad) * 100} %',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: ColorPalet.acentDefault,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        _separacionCampos(10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 12,
                            value: detalleTareaId[0].subtareas.cantidad != 0
                                ? double.parse(detalleTareaId[0]
                                        .subtareas
                                        .cantidadSubtareasAcabadas
                                        .toString()) /
                                    double.parse(detalleTareaId[0]
                                        .subtareas
                                        .cantidad
                                        .toString())
                                : 0,
                            backgroundColor:
                                const Color.fromARGB(255, 246, 248, 251),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorPalet.acentDefault),
                          ),
                        ),
                      ],
                    ),
              _separacionCampos(20),
              Row(
                children: [
                  SizedBox(
                    width: sizeScreen.width * 0.40,
                    child: _NombreCampos('Fecha de inicio', 16),
                  ),
                  const Spacer(), // Esto expandirá el espacio entre los dos Text
                  SizedBox(
                    width: sizeScreen.width * 0.40,
                    child: _NombreCampos('Fecha de finalización', 16),
                  ),
                ],
              ),
              _separacionCampos(10),
              Row(
                children: [
                  SizedBox(
                    width: sizeScreen.width * 0.40,
                    child: Text(
                      detalleTareaId[0].fechaInicio.toString().substring(0, 10),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 72, 86, 109),
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(), // Esto expandirá el espacio entre los dos Text
                  SizedBox(
                    width: sizeScreen.width * 0.40,
                    child: Text(
                      detalleTareaId[0].fechaFin.toString().substring(0, 10),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 72, 86, 109),
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              _separacionCampos(20),
              _NombreCampos('Descripción', 16),
              _separacionCampos(10),
              Text(
                detalleTareaId[0].descripcion,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 72, 86, 109),
                    fontFamily: 'inter',
                    fontWeight: FontWeight.w400),
              ),
              _separacionCampos(20),
              _NombreCampos('Subtareas', 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: detalleTareaId[0]
                      .subtareas
                      .subtareas
                      .length, // Número de elementos en tu lista
                  itemBuilder: (BuildContext context, int index) {
                    final subtarea =
                        detalleTareaId[0].subtareas.subtareas[index];
                    return Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Row(
                          children: [
                            Checkbox(
                              visualDensity:
                                  VisualDensity(vertical: 2, horizontal: 2),
                              side: BorderSide(
                                color: subtarea.estado == 'PENDIENTE'
                                    ? ColorPalet
                                        .secondaryDefault // Establece el color del borde a negro si es 'PENDIENTE'
                                    : Colors
                                        .transparent, // De lo contrario, no muestres el borde
                                width: 1.5, // Ancho del borde
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              checkColor: Colors.white,
                              activeColor: ColorPalet.secondaryDark,
                              value:
                                  subtarea.estado == 'PENDIENTE' ? false : true,
                              onChanged: (value) async {
                                final action = value! ? 'check' : 'retomar';
                                try {
                                  await dataTareas.toggleSubtarea(
                                      subtarea.subtareaId, action);
                                } catch (error) {
                                  print(
                                      'Error al actualizar la subtarea: $error');
                                }
                              },
                            ),
                            Expanded(
                              child: Text(
                                subtarea.descripcion,
                                style: TextStyle(
                                  decoration: subtarea.estado == 'PENDIENTE'
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Iconsax.trash,
                                color: ColorPalet.estadoNegative,
                              ), // Icono de eliminación
                              onPressed: () {
                                // Lógica para eliminar aquí
                              },
                            ),
                          ],
                        ));
                  },
                ),
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataTareas
                          .moverEstadoTarea(
                              detalleTareaId[0].tareaId, 'terminadas')
                          .then((value) async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 115, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.clipboard_tick),
                        SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Marcar como terminada',
                          style: TextStyle(
                              color: ColorPalet.grisesGray5,
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ),
            ]),
      ),
    );

    // Obteniendo fecha del table calendar fecha inicio
  }

  Text _NombreCampos(String texto, double tam) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Color.fromARGB(255, 29, 34, 44),
          fontSize: tam,
          fontWeight: FontWeight.w700),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }
}
