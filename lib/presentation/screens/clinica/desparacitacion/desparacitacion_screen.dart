import 'package:bottom_picker/bottom_picker.dart';
//import 'package:bottom_picker/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/common/formularios/formularios_widget.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/widgetFacturacion.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/clinica/buscarPacientes_model.dart';
import '../../../../providers/clinica/desparacitacion/desparacitacion_provider.dart';
import '../../../widgets/clinica/desparacitacion/radiobuttonDesparacitacion_widget.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/clinica/vacuna/radiobuttonVacuna_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class ButtonNuevoRegistroDesp extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonNuevoRegistroDesp({super.key, required this.listaPacientesBusq});

  final TextEditingController controllerBusquedaOProced =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Container(
              height: 80,
              child: ElevatedButton(
                onPressed: () async {
                  var vacunaProvider = Provider.of<DesparacitacionProvider>(
                      context,
                      listen: false);
                  vacunaProvider.setSelectSquareDesparacitacion(0);
                  vacunaProvider.resetearDatosForm();
                  await _modalConsultaNuevoRegistro(
                      context, listaPacientesBusq, sizeScreen);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.complementVerde2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                child: const Row(
                  children: [
                    Icon(
                      Iconsax.document_text_1,
                      color: ColorPalet.grisesGray5,
                      size: 35,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Nuevo registro',
                      style: TextStyle(
                          color: ColorPalet.grisesGray5,
                          fontSize: 19,
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<dynamic> _modalConsultaNuevoRegistro(
      context, listaPacientesBusq, Size sizeScreen) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(' ¿El paciente es nuevo o antiguo?',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 29, 34, 44),
                        fontSize: 16,
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700)),
                Divider()
              ],
            ),
            content: Container(
              width: sizeScreen.width,
              height: sizeScreen.height * 0.4,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Por favor, seleccione si este paciente ya ha sido registrado previamente en nuestra base de datos o si es un paciente nuevo.',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'inter',
                        color: Color.fromARGB(255, 72, 86, 109),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<DesparacitacionProvider>(context,
                                    listen: false)
                                .setSelectSquareDesparacitacion(1);
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<DesparacitacionProvider>(
                                                context)
                                            .selectedSquareDesparacitacion ==
                                        1
                                    ? Color.fromARGB(255, 1, 161, 197)
                                    : Color.fromARGB(255, 218, 223, 230),
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    IconlyLight.add_user,
                                    size: 35,
                                    color: Provider.of<DesparacitacionProvider>(
                                                    context)
                                                .selectedSquareDesparacitacion ==
                                            1
                                        ? Color.fromARGB(255, 1, 161, 197)
                                        : Color.fromARGB(255, 218, 223, 230),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Paciente nuevo',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'sans',
                                        color: Provider.of<DesparacitacionProvider>(
                                                        context)
                                                    .selectedSquareDesparacitacion ==
                                                1
                                            ? Color.fromARGB(255, 1, 161, 197)
                                            : Color.fromARGB(
                                                255, 218, 223, 230),
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: sizeScreen.width * 0.02),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<DesparacitacionProvider>(context,
                                listen: false)
                              ..setSelectSquareDesparacitacion(2)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<DesparacitacionProvider>(
                                                context)
                                            .selectedSquareDesparacitacion ==
                                        2
                                    ? Color.fromARGB(255, 1, 161, 197)
                                    : Color.fromARGB(255, 218, 223, 230),
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.user_search,
                                    size: 35,
                                    color: Provider.of<DesparacitacionProvider>(
                                                    context)
                                                .selectedSquareDesparacitacion ==
                                            2
                                        ? Color.fromARGB(255, 1, 161, 197)
                                        : Color.fromARGB(255, 218, 223, 230),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Paciente antiguo',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'sans',
                                        color: Provider.of<DesparacitacionProvider>(
                                                        context)
                                                    .selectedSquareDesparacitacion ==
                                                2
                                            ? Color.fromARGB(255, 1, 161, 197)
                                            : Color.fromARGB(
                                                255, 218, 223, 230),
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<DesparacitacionProvider>(context,
                                    listen: false)
                                .setSelectSquareDesparacitacion(0);
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 28, 149, 187)),
                        onPressed: () {
                          if (Provider.of<DesparacitacionProvider>(context,
                                      listen: false)
                                  .selectedSquareDesparacitacion ==
                              1) {
                            Navigator.of(context).pop();
                            _openModalBottomSheetDesparasitacion(context);
                          } else if (Provider.of<DesparacitacionProvider>(
                                      context,
                                      listen: false)
                                  .selectedSquareDesparacitacion ==
                              2) {
                            Navigator.of(context).pop();
                            _openAlertDialogBuscarPaciente(
                                context, listaPacientesBusq);
                          }
                        },
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'inter',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _openAlertDialogBuscarPaciente(
      BuildContext context, List<ResultBusPacientes> listaPacientesBusq) {
    final despProvider =
        Provider.of<DesparacitacionProvider>(context, listen: false);
    despProvider.filtrarLista(listaPacientesBusq, "");
    showDialog(
      context: context,
      builder: (context) {
        String? pacienteSeleccionado;
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar cliente o paciente',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 29, 34, 44),
                      fontSize: 16,
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w700)),
              Divider()
            ],
          ),
          content: SizedBox(
            height: 400,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (query) {
                    despProvider.filtrarLista(listaPacientesBusq, query);
                  },
                  controller: controllerBusquedaOProced,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaOProced.clear();
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 140, 228, 233),
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
                ),
                SizedBox(
                  height: 6,
                ),
                Flexible(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Consumer<DesparacitacionProvider>(
                        builder: (context, despProviderC, _) {
                      final listaFiltrada = despProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected =
                              index == despProviderC.selectedIndexPaciente;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 28, 149, 187),
                                      width: 1)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 2),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 28, 149, 187),
                                child: Text(
                                  busqPaciente.idPaciente.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ), // Mostrar el ID a la izquierda
                              title: Text(busqPaciente.nombrePropietario,
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 29, 34, 44),
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w600)),
                              subtitle: Row(children: [
                                Icon(
                                  Icons.pets,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Pac: ${busqPaciente.nombrePaciente}',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 72, 86, 109),
                                        fontSize: 14,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w500)),
                              ]),
                              onTap: () {
                                despProviderC.setSelectedIndexPaciente(index);
                                pacienteSeleccionado =
                                    busqPaciente.idPaciente.toString();
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            despProvider
                              ..setSelectSquareDesparacitacion(0)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (despProvider.selectedIndexPaciente != -1) {
                              despProvider.setSelectedIdPacienteAntiguo(
                                  pacienteSeleccionado.toString());
                              print(' aqui esta el id del paciente anitugo' +
                                  despProvider.selectedIdPacienteAntiguo);
                              Navigator.of(context).pop();
                              _openModalBottomSheetDesparasitacion(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 28, 149, 187),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Seleccionar',
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void _openModalBottomSheetDesparasitacion(BuildContext context) {
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
                child: FormularioDesparacitacion(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class ButtonProgramarCitaDesp extends StatelessWidget {
  const ButtonProgramarCitaDesp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 230, 242, 248),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                child: const Row(
                  children: [
                    Icon(
                      IconlyLight.calendar,
                      size: 35,
                      color: Color.fromARGB(255, 0, 122, 160),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Programar cita',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 122, 160),
                          fontSize: 19,
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class ButtonPacientesDesp extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonPacientesDesp({super.key, required this.listaPacientesBusq});

  final TextEditingController controllerBusqueda = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Container(
              height: 80,
              child: ElevatedButton(
                onPressed: () =>
                    _openAlertDialogBuscarPaciente(context, listaPacientesBusq),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                child: const Row(
                  children: [
                    Icon(
                      Iconsax.people,
                      size: 35,
                      color: Color.fromARGB(255, 0, 122, 160),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Pacientes',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 122, 160),
                          fontSize: 19,
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void _openAlertDialogBuscarPaciente(
      BuildContext context, List<ResultBusPacientes> listaPacientesBusq) {
    final despProvider =
        Provider.of<DesparacitacionProvider>(context, listen: false);
    despProvider.filtrarLista(listaPacientesBusq, "");

    showDialog(
      context: context,
      builder: (context) {
        String? pacienteSeleccionado;
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar cliente o paciente',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 29, 34, 44),
                      fontSize: 16,
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w700)),
              Divider()
            ],
          ),
          content: SizedBox(
            height: 400,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (query) {
                    despProvider.filtrarLista(listaPacientesBusq, query);
                  },
                  controller: controllerBusqueda,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusqueda.clear();
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 140, 228, 233),
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
                ),
                SizedBox(
                  height: 6,
                ),
                Flexible(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Consumer<DesparacitacionProvider>(
                        builder: (context, despProviderC, _) {
                      final listaFiltrada = despProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected =
                              index == despProviderC.selectedIndexPaciente;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 28, 149, 187),
                                      width: 1)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 2),
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 28, 149, 187),
                                child: Text(
                                  busqPaciente.idPaciente.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ), // Mostrar el ID a la izquierda
                              title: Text(busqPaciente.nombrePropietario,
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 29, 34, 44),
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w600)),
                              subtitle: Row(children: [
                                Icon(
                                  Icons.pets,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Pac: ${busqPaciente.nombrePaciente}',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 72, 86, 109),
                                        fontSize: 14,
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w500)),
                              ]),
                              onTap: () {
                                despProviderC.setSelectedIndexPaciente(index);
                                pacienteSeleccionado =
                                    busqPaciente.idPaciente.toString();
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            despProvider
                              ..setSelectSquareDesparacitacion(0)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 121, 177),
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (despProvider.selectedIndexPaciente != -1) {
                              despProvider
                                ..setSelectedIdPacienteAntiguo(
                                    pacienteSeleccionado.toString())
                                ..setSelectSquareDesparacitacion(2)
                                ..clearBusquedas();
                              Navigator.of(context).pop();
                              _openModalBottomSheetDesparasitacion(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Color.fromARGB(255, 28, 149, 187),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Seleccionar',
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormularioDesparacitacion extends StatefulWidget {
  @override
  _FormularioDesparacitacionState createState() =>
      _FormularioDesparacitacionState();
}

class _FormularioDesparacitacionState extends State<FormularioDesparacitacion> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoDesparacitacion = GlobalKey<FormState>();
  final _formkeyDatosPaciente = GlobalKey<FormState>();
  final _formKeyDesparacitacion = GlobalKey<FormState>();
  final _formkeyProximaVisita = GlobalKey<FormState>();
  final _formkeyFacturacion = GlobalKey<FormState>();
  //editing controller para datos del dueno
  TextEditingController controllerCiDueno = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //controllers para desparasitacion
  TextEditingController controllerProducto = TextEditingController();
  TextEditingController controllerPrincipioActivo = TextEditingController();
  TextEditingController controllerVia = TextEditingController();

  //controllers para datos de facrturacion
  TextEditingController controllerCIoNit = TextEditingController();
  TextEditingController controllerApellidoFactura = TextEditingController();
  TextEditingController controllerNombreFactura = TextEditingController();
  TextEditingController controllerMontoEfectivo = TextEditingController();
  TextEditingController controllerCodeDescuento = TextEditingController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages =
        Provider.of<DesparacitacionProvider>(context, listen: false)
                    .selectedSquareDesparacitacion ==
                2
            ? 2
            : 4;

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
    DesparacitacionProvider dataDesp =
        Provider.of<DesparacitacionProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataDesp.getEncargados;
    double valueLinearProgress =
        dataDesp.selectedSquareDesparacitacion == 2 ? 3 : 5;

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
                  dataDesp.selectedSquareDesparacitacion == 2
                      ? ' de 3'
                      : ' de 5',
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
                children: dataDesp.selectedSquareDesparacitacion == 2
                    ? [
                        _datosDesparacitacion(dataDesp, sizeScreenWidth),
                        _datosProximaVisita(
                            dataDesp, sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(
                            dataDesp, sizeScreenWidth, listaVeterinarios),
                      ]
                    : [
                        _datosDelDueno(dataDesp, sizeScreenWidth),
                        _datosPaciente(dataDesp, sizeScreenWidth),
                        _datosDesparacitacion(dataDesp, sizeScreenWidth),
                        _datosProximaVisita(
                            dataDesp, sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(
                            dataDesp, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(
      DesparacitacionProvider dataDesp, double sizeScreenWidth) {
    return datosDelDueno(
        formKey: _formKeyDuenoDesparacitacion,
        controllerCi: controllerCiDueno,
        controllerNombre: controllerNombre,
        controllerApellido: controllerApellido,
        controllerNumero: controllerNumero,
        controllerDireccion: controllerDireccion,
        sizeScreenWidth: sizeScreenWidth,
        onNext: () => _nextPage(),
        onCancel: () => _mostrarAlertaCancelar(context));
  }

  Widget _datosPaciente(
      DesparacitacionProvider dataDesp, double sizeScreenWidth) {
    return datosPaciente(
        sizeScreenWidth: sizeScreenWidth,
        formKey: _formkeyDatosPaciente,
        controllerNombrePaciente: controllerNombrePaciente,
        radioButtonsGenero: [
          const RadioButtonReutilizableGeneroDesp(
            gender: 'Macho intacto',
            valor: 'M',
          ),
          const RadioButtonReutilizableGeneroDesp(
            gender: 'Macho castrado',
            valor: 'MC',
          ),
          const RadioButtonReutilizableGeneroDesp(
            gender: 'Hembra intacta',
            valor: 'H',
          ),
          const RadioButtonReutilizableGeneroDesp(
            gender: 'Hembra esterilizada',
            valor: 'HC',
          ),
        ],
        generoProvider: dataDesp.selectedSexoPaciente,
        edadWidget: TextFormFieldNumberEdad(
          colores: const Color.fromARGB(255, 140, 228, 233),
          hintText: 'Edad',
          controller: controllerEdadPaciente,
          provider: dataDesp,
        ),
        especieWidget:
            Consumer<DesparacitacionProvider>(builder: (context, provider, _) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(220, 249, 249, 249),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              icon: const Icon(CupertinoIcons.chevron_down),
              isExpanded: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona una especie';
                }
                return null;
              },
              style: const TextStyle(
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
              hint: const Text(
                'Seleccionar',
                style: TextStyle(
                    color: Color.fromARGB(255, 139, 149, 166),
                    fontSize: 15,
                    fontFamily: 'inter'),
              ),
            ),
          );
        }),
        razaWidget: Consumer<DesparacitacionProvider>(
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
              const DropdownMenuItem<String>(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una raza';
                  }
                  return null;
                },
                style: const TextStyle(
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
                hint: const Text(
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
        tamanoWidget: CustomDropdownSize(
          value: dataDesp.dropTamanoMascota,
          options: const ['G', 'M', 'P'],
          onChanged: (value) {
            dataDesp.setDropTamanoMascota(value!);
          },
          hintText: 'Seleccionar...',
        ),
        temperamentoWidget: CustomDropdownTemperament(
          value: dataDesp.dropTemperamento,
          options: const ['S', 'C', 'A', 'M'],
          onChanged: (value) {
            dataDesp.setDropTemperamento(value!);
          },
          hintText: 'Seleccionar...',
        ),
        alimentacionWidget: CustomDropdownFood(
          value: dataDesp.dropAlimentacion,
          options: const ['C', 'M', 'B'],
          onChanged: (value) {
            dataDesp.setDropAlimentacion(value!);
          },
          hintText: 'Seleccionar...',
        ),
        imagenWidget: dataDesp.image != null
            ? getFotoPaciente(dataDesp)
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
                        dataDesp.addPhoto();
                      },
                      child: const Center(
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
        onNext: () => _nextPage(),
        onPrevious: () => _previousPage());
  }

  Widget _datosDesparacitacion(
      DesparacitacionProvider dataDesp, double sizeScreenWidth) {
    String nombreLegible = path.basename(dataDesp.fileArchivoDesparasitacion);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formKeyDesparacitacion,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _tituloForm('Datos de la desparasitación'),
            _separacionCampos(20),
            _NombreCampos('Tipo de desparasitación'),
            _separacionCampos(15),
            const RadioButtonTipoDeDesparacitacionDesp(
              intOext: 'Interna',
              valor: 'INTERNA',
            ),
            const RadioButtonTipoDeDesparacitacionDesp(
              intOext: 'Externa',
              valor: 'EXTERNA',
            ),
            _separacionCampos(20),
            _NombreCampos('Producto'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerProducto,
                hintText: 'Ej: Drontal Plus'),
            _separacionCampos(20),
            _NombreCampos('Principio activo'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerPrincipioActivo,
                hintText: 'Ej: Praziquantel'),
            _separacionCampos(20),
            _NombreCampos('Fecha de aplicación'),
            _separacionCampos(15),
            InkWell(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 3 * 365)),
                ).then((value) {
                  if (value != null) {
                    String formattedDateEnviar =
                        DateFormat("yyyy-MM-dd").format(value);
                    dataDesp.setFechadeAplicacion(formattedDateEnviar);
                  }
                });
              },
              child: Container(
                height: 60,
                width: sizeScreenWidth,
                //padding: EdgeInsets.only(top: 15, bottom: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 249, 249, 249)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.calendar_month,
                      color: const Color.fromARGB(255, 139, 149, 166),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Center(
                      child: Text(
                        dataDesp.selectedFechaAplicacion,
                        style: const TextStyle(
                          color: const Color.fromARGB(255, 139, 149, 166),
                          fontSize: 15,
                          fontFamily: 'inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MensajeValidadorSelecciones(
              validator: (_) => dataDesp.selectedFechaAplicacion == ''
                  ? 'Seleccione fecha de aplicación.'
                  : null,
            ),
            _separacionCampos(20),
            _NombreCampos('Vía'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerVia,
                hintText: 'Ej: Oral'),
            _separacionCampos(20),
            _NombreCampos('Agregar archivo'),
            _separacionCampos(15),
            dataDesp.fileArchivoDesparasitacion.isEmpty
                ? Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 218, 223, 230),
                            width: 2),
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

                        final fileName = await selectFile();
                        if (fileName != null) {
                          dataDesp.setArchivoDesparasitacion(fileName);
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 25,
                            color: Color.fromARGB(255, 139, 149, 166),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Añadir archivo',
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontFamily: 'sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      Future<String?> selectFile() async {
                        final result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final path = result.files.single.path;
                          return path;
                        }
                        return null;
                      }

                      final fileName = await selectFile();
                      if (fileName != null) {
                        dataDesp.setArchivoDesparasitacion(fileName);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: sizeScreenWidth,
                      //padding: EdgeInsets.only(top: 15, bottom: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 249, 249, 249)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Center(
                            child: Text(
                              nombreLegible,
                              style: const TextStyle(
                                color: const Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            _separacionCampos(4),
            MensajeValidadorSelecciones(
              validator: (_) => dataDesp.fileArchivoDesparasitacion == ''
                  ? 'Añade un archivo.'
                  : null,
            ),
            _separacionCampos(20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyDesparacitacion.currentState!.validate()) {
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
                          side: const BorderSide(
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

  Widget _datosProximaVisita(DesparacitacionProvider dataDesp,
      double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyProximaVisita,
          child: Column(
              //DATOS CLINICOS
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Próxima dosis'),
                _separacionCampos(20),
                _NombreCampos('Fecha de la desparasitación'),
                _separacionCampos(5),
                CalendarioFormulario(
                  focusedDay: today,
                  firstDay: DateTime.utc(2023, 02, 10),
                  lastDay: DateTime.utc(2030, 02, 10),
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                ),
                _separacionCampos(20),
                _NombreCampos('Hora'),
                _separacionCampos(15),
                InkWell(
                  onTap: () {
                    _openTimePicker(context, dataDesp);
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
                        dataDesp.horaSelected.isEmpty
                            ? Text(
                                'Seleccionar hora',
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(139, 149, 166, 1),
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                dataDesp.horaSelected,
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(139, 149, 166, 1),
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
                    if (dataDesp.horaSelected == '') {
                      return 'Por favor, seleccione una hora.';
                    }
                    return null;
                  },
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
                    dataDesp.inicialEncargado.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 47, 26, 125),
                              child: Text(
                                dataDesp.inicialEncargado,
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
                                    final veterinario =
                                        listaVeterinarios[index];
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
                                            context, veterinario, dataDesp);
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
                    if (dataDesp.idEncargadoSelected == '') {
                      return 'Por favor, seleccione un encargado.';
                    }
                    return null;
                  },
                ),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkeyProximaVisita.currentState!.validate()) {
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

  Widget _datosFacturacion(DesparacitacionProvider dataDesp,
      double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyFacturacion,
          child: Column(
              //DATOS CLINICOS
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Método de pago'),
                _separacionCampos(20),
                DatosFacturacion<DesparacitacionProvider>(
                  providerGenerico: dataDesp,
                  sizeScreenWidth: sizeScreenWidth,
                  radioButtons: const [
                    RadioButtonEfecTransacDesp(
                      efecTransac: 'Efectivo',
                      valor: 'EFECTIVO',
                    ),
                    RadioButtonEfecTransacDesp(
                      efecTransac: 'Transacción',
                      valor: 'TRANSACCION',
                    ),
                  ],
                  controllerCIoNit: controllerCIoNit,
                  controllerNombreFactura: controllerNombreFactura,
                  controllerApellidoFactura: controllerApellidoFactura,
                  controllerMontoEfectivo: controllerMontoEfectivo,
                  controllerCodeDescuento: controllerCodeDescuento,
                  tipoServicio: 'clinica',
                ),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (dataDesp.totalACobrarFacturacion.isEmpty) {
                          dataDesp.setTotalACobrarFacturacion =
                              controllerMontoEfectivo.text;
                        }
                        if (_formkeyFacturacion.currentState!.validate()) {
                          dataDesp.selectedSquareDesparacitacion == 2
                              ? dataDesp
                                  .enviarDatosAntiguo(
                                      //paciente
                                      dataDesp.selectedIdPacienteAntiguo,
                                      //desparacitacion
                                      dataDesp.selectedInternoExterno,
                                      controllerProducto.text,
                                      controllerPrincipioActivo.text,
                                      dataDesp.selectedFechaAplicacion,
                                      controllerVia.text,
                                      dataDesp.fileArchivoDesparasitacion,
                                      //proxima visita
                                      dataDesp.fechaVisitaSelected == ''
                                          ? DateFormat("yyyy-MM-dd")
                                              .format(today)
                                          : dataDesp.fechaVisitaSelected,
                                      dataDesp.horaSelected,
                                      dataDesp.idEncargadoSelected,
                                      //datos facturacion
                                      dataDesp.selectedEfectivoTransac,
                                      controllerCIoNit.text,
                                      controllerNombreFactura.text,
                                      controllerApellidoFactura.text,
                                      dataDesp.switchValueFacturacion,
                                      dataDesp.totalACobrarFacturacion)
                                  .then((_) async {
                                  if (dataDesp.OkpostDatosDesp) {
                                    _mostrarFichaCreada(context);
                                  }
                                })
                              : dataDesp
                                  .enviarDatos(
                                      //propietario
                                      controllerCiDueno.text,
                                      controllerNombre.text,
                                      controllerApellido.text,
                                      controllerNumero.text,
                                      controllerDireccion.text,
                                      //paciente
                                      controllerNombrePaciente.text,
                                      dataDesp.selectedSexoPaciente,
                                      controllerEdadPaciente.text,
                                      dataDesp.selectedIdEspecie!,
                                      dataDesp.selectedIdRaza!,
                                      dataDesp.dropTamanoMascota,
                                      dataDesp.dropTemperamento,
                                      dataDesp.dropAlimentacion,
                                      dataDesp.lastImage,
                                      //desparacitacion
                                      dataDesp.selectedInternoExterno,
                                      controllerProducto.text,
                                      controllerPrincipioActivo.text,
                                      dataDesp.selectedFechaAplicacion,
                                      controllerVia.text,
                                      dataDesp.fileArchivoDesparasitacion,
                                      //proxima visita
                                      dataDesp.fechaVisitaSelected == ''
                                          ? DateFormat("yyyy-MM-dd")
                                              .format(today)
                                          : dataDesp.fechaVisitaSelected,
                                      dataDesp.horaSelected,
                                      dataDesp.idEncargadoSelected,
                                      //datos facturacion
                                      dataDesp.selectedEfectivoTransac,
                                      controllerCIoNit.text,
                                      controllerNombreFactura.text,
                                      controllerApellidoFactura.text,
                                      dataDesp.switchValueFacturacion,
                                      dataDesp.totalACobrarFacturacion)
                                  .then((_) async {
                                  if (dataDesp.OkpostDatosDesp) {
                                    _mostrarFichaCreada(context);
                                  }
                                });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 28, 149, 187),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: dataDesp.loadingDatosDesp
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
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                            color: Color.fromARGB(255, 28, 149, 187),
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
                                  Provider.of<DesparacitacionProvider>(context,
                                          listen: false)
                                      .setSelectSquareDesparacitacion(0);
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
      barrierDismissible: true,
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
                  Image(
                      height: 220,
                      width: 200,
                      image: AssetImage('assets/img/done.png')),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Los datos del nuevo paciente y la información de la consulta se han guardado con éxito.',
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
      DesparacitacionProvider dataDesp) {
    print(
        'ID: ${encargadoVet.encargadoVeteId}, Inicial del nombre: ${encargadoVet.nombres[0].toUpperCase()}');

    dataDesp.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataDesp
        .setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    DesparacitacionProvider dataDesp =
        Provider.of<DesparacitacionProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataDesp.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, DesparacitacionProvider dataDesp) {
    final timePicker = TimePickerHelper<DesparacitacionProvider>(
      context: context,
      provider: dataDesp,
      getHoraSelected: () => dataDesp.horaSelected,
      setHoraSelected: dataDesp.setHoraSelected,
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

  Widget getFotoPaciente(DesparacitacionProvider dataDesp) {
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
            dataDesp.addPhoto();
          },
          child: Image.file(
            dataDesp.lastImage!,
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
