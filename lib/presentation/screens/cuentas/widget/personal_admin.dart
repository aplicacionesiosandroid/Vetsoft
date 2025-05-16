import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/widget/crear_personal_admin.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../config/global/global_variables.dart';
import '../../../../models/tareas/participantes_tareas_model.dart';
import '../../../../providers/tareas/tareas_provider.dart';

void openBottomSheetPersonalAdmin(TareasProvider dataTareas, BuildContext context, List<ParticipanteTarea> listaParticipantes) {
  final TextEditingController controllerBusquedaPartici = TextEditingController();
  Map<int, bool> isLoadingMap = {};

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }

  final sizeWidth = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                      height: 2,
                      color: const Color.fromARGB(255, 161, 158, 158),
                    ),
                  ),
                  SizedBox(
                    width: sizeWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Personal',
                                style: const TextStyle(
                                    color:  Color.fromARGB(255, 29, 34, 44),
                                    fontSize: 16,
                                    fontFamily: 'sans',
                                    fontWeight: FontWeight.w700)),
                            Consumer<TareasProvider>(
                              builder: (context, dataTareas, child) {
                                return Text(
                                    ' (${listaParticipantes.length})',
                                    style: TextStyle(
                                        color: const Color.fromARGB(255, 177, 173, 255),
                                        fontSize: 16,
                                        fontFamily: 'sans',
                                        fontWeight: FontWeight.w700));
                              },
                            ),
                          ],
                        ),
                        Container(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                openBottomCreatePersonal(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Color(0xFF6B64FF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'Crear',
                                style: TextStyle(color: ColorPalet.grisesGray5, fontFamily: 'inter', fontSize: 15, fontWeight: FontWeight.w600),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  _separacionCampos(10),
                  TextFormField(
                    controller: controllerBusquedaPartici,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
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
                      dataTareas.filtrarListaParticipante(listaParticipantes, query);
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: controllerBusquedaPartici.text.isEmpty
                        ? Consumer<TareasProvider>(
                      builder: (context, provider, child) {
                        final listaParticipantesss = provider.getParticipantesTarea;
                        return ListView.builder(
                          itemCount: listaParticipantesss.length,
                          itemBuilder: (BuildContext context, int index) {
                            final participante = listaParticipantesss[index];
                            final isSelected = provider.isSelectedMap(participante.encargadoId);
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                  width: 50.0, // Ajusta el tamaño según tus necesidades
                                  height: 50.0, // Ajusta el tamaño según tus necesidades
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icon/logovs.png',
                                    image: '$imagenUrlGlobal${participante.imgUser}',
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(milliseconds: 200),
                                    fadeInCurve: Curves.easeIn,
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
                              onTap: isLoadingMap[index] == true ? null : () async {
                                setState(() {
                                  isLoadingMap[index] = true;
                                });

                                print('ID del Participante: ${participante.encargadoId}');
                                final userEmpProvider = Provider.of<UserEmpProvider>(context, listen: false);
                                userEmpProvider.setIdPersonalUpdate(participante.encargadoId);
                                try {
                                  await userEmpProvider.fetchUserDataPersonal(participante.encargadoId);
                                  Navigator.pushNamed(context, '/infoPersonal', arguments: userEmpProvider.userPersonal);
                                } catch (error) {
                                  print('Error in fetchUserData: $error');
                                } finally {
                                  setState(() {
                                    isLoadingMap[index] = false;
                                  });
                                }
                              },
                              trailing: isLoadingMap[index] == true ? CircularProgressIndicator() :  IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  eliminarPersonal(context,participante);                                },
                              ),
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
                                    color: Color.fromARGB(255, 139, 149, 166)),
                              ),
                            )
                          ],
                        ))
                        : Consumer<TareasProvider>(
                      builder: (context, provider, child) {
                        final listaFiltradaParticipante = provider.listaFiltradaParticipante;
                        return ListView.builder(
                          itemCount: listaFiltradaParticipante.length,
                          itemBuilder: (BuildContext context, int index) {
                            final participante = listaFiltradaParticipante[index];
                            final isSelected = provider.isSelectedMap(participante.encargadoId);
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                  width: 50.0, // Ajusta el tamaño según tus necesidades
                                  height: 50.0, // Ajusta el tamaño según tus necesidades
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icon/logovs.png',
                                    image: '$imagenUrlGlobal${participante.imgUser}',
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(milliseconds: 200),
                                    fadeInCurve: Curves.easeIn,
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
                              onTap: isLoadingMap[index] == true ? null : () async {
                                setState(() {
                                  isLoadingMap[index] = true;
                                });

                                print('ID del Participante: ${participante.encargadoId}');
                                final userEmpProvider = Provider.of<UserEmpProvider>(context, listen: false);
                                userEmpProvider.setIdPersonalUpdate(participante.encargadoId);
                                try {
                                  await userEmpProvider.fetchUserDataPersonal(participante.encargadoId);
                                  Navigator.pushNamed(context, '/infoPersonal', arguments: userEmpProvider.userPersonal);
                                } catch (error) {
                                  print('Error in fetchUserData: $error');
                                } finally {
                                  setState(() {
                                    isLoadingMap[index] = false;
                                  });
                                }
                              },
                              trailing: isLoadingMap[index] == true ? CircularProgressIndicator() : null,
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
    },
  );
}

Future<void> dataTimeFechaNacimiento(BuildContext context, UserEmpProvider dataEmpleado, double sizeScreenWidth) async {
  DateTime today = DateTime.now(); // Define la fecha actual

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 26, 202, 212), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != today) {
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(picked);
      dataEmpleado.setFechanNacimiento(formattedDateEnviar);
    }
  }

  await _selectDate(context);
}

class ArchivosTitulosDiplomas extends StatelessWidget {
  final double sizeScreen;
  ArchivosTitulosDiplomas({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<UserEmpProvider>(context);
    return provFiles.fileTitulosDiplomas.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.7,
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
                child: Text('', style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontSize: 15, fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<UserEmpProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileTitulosDiplomas.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.77,
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
                        child: Text(nombreLegible, style: TextStyle(color: Color.fromARGB(255, 139, 149, 166), fontSize: 15, fontFamily: 'inter')),
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

class AddFileTitulosDiplomas extends StatelessWidget {
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
      decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2), borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider = Provider.of<UserEmpProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileTitulosDiplomas(fileName);
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

void eliminarPersonal(BuildContext context, ParticipanteTarea Empleado) {
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
            '¿Estás seguro/a de querer eliminar a ${Empleado.nombres}?',
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
                    'Esta acción no tiene vuelta atrás.',
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
                                // Provider.of<ConsultaProvider>(context,
                                //     listen: false)
                                //     .setSelectSquareConsulta(0);
                                // // Cerrar el AlertDialog
                                // Navigator.of(context).pop();
                                // //cierra bottomSheet
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
                              onPressed: () async {
                                // Cerrar el AlertDialog
                                final userEmpleado = Provider.of<UserEmpProvider>(context, listen: false);
                                bool succes = await userEmpleado.eliminarEmpleado(Empleado.encargadoId);
                                if (succes) {
                                  Navigator.of(context).pop();
                                  BotToast.showText(text: "Empleado eliminado exitosamente.");
                                  Navigator.of(context).pop();
                                  TareasProvider dataTareas = Provider.of<TareasProvider>(context, listen: false);
                                  dataTareas.getParticipantesTareas();
                                  List<ParticipanteTarea> listaParticipantes = dataTareas.getParticipantesTarea;
                                  openBottomSheetPersonalAdmin(dataTareas, context, listaParticipantes);
                                } else {
                                  BotToast.showText(text: "No se pudo eliminar al empleado.");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                  Color.fromARGB(255, 28, 149, 187),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12))),
                              child: const Text(
                                'Aceptar',
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
