import 'package:bottom_picker/bottom_picker.dart';
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
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/common/formularios/formularios_widget.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/widgetFacturacion.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../../models/clinica/buscarPacientes_model.dart';
import '../../../../providers/clinica/vacuna/vacuna_provider.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/clinica/vacuna/radiobuttonVacuna_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';

class ButtonNuevoRegistroVacuna extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonNuevoRegistroVacuna({super.key, required this.listaPacientesBusq});

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
                  var vacunaProvider =
                      Provider.of<VacunaProvider>(context, listen: false);
                  vacunaProvider.setSelectSquareVacuna(0);
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
                            Provider.of<VacunaProvider>(context, listen: false)
                                .setSelectSquareVacuna(1);
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<VacunaProvider>(context)
                                            .selectedSquareVacuna ==
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
                                    color: Provider.of<VacunaProvider>(context)
                                                .selectedSquareVacuna ==
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
                                        color: Provider.of<VacunaProvider>(
                                                        context)
                                                    .selectedSquareVacuna ==
                                                1
                                            ? Color.fromARGB(255, 1, 161, 197)
                                            : Color.fromARGB(
                                                255, 218, 223, 230),
                                        fontWeight: FontWeight.w500),
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
                            Provider.of<VacunaProvider>(context, listen: false)
                              ..setSelectSquareVacuna(2)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<VacunaProvider>(context)
                                            .selectedSquareVacuna ==
                                        2
                                    ? Color.fromARGB(255, 1, 161, 197)
                                    : Color.fromARGB(255, 218, 223, 230),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user_search,
                                  size: 35,
                                  color: Provider.of<VacunaProvider>(context)
                                              .selectedSquareVacuna ==
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
                                      color: Provider.of<VacunaProvider>(
                                                      context)
                                                  .selectedSquareVacuna ==
                                              2
                                          ? Color.fromARGB(255, 1, 161, 197)
                                          : Color.fromARGB(255, 218, 223, 230),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
                            Provider.of<VacunaProvider>(context, listen: false)
                                .setSelectSquareVacuna(0);
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
                            //shape: const CircleBorder(),
                            //minimumSize: const Size(50, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 28, 149, 187)),
                        onPressed: () {
                          if (Provider.of<VacunaProvider>(context,
                                      listen: false)
                                  .selectedSquareVacuna ==
                              1) {
                            Navigator.of(context).pop();
                            _openModalBottomSheetVacuna(context);
                          } else if (Provider.of<VacunaProvider>(context,
                                      listen: false)
                                  .selectedSquareVacuna ==
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
    final vacunaProvider = Provider.of<VacunaProvider>(context, listen: false);
    vacunaProvider.filtrarLista(listaPacientesBusq, "");
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
                    vacunaProvider.filtrarLista(listaPacientesBusq, query);
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
                    child: Consumer<VacunaProvider>(
                        builder: (context, vacunaProviderC, _) {
                      final listaFiltrada = vacunaProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected =
                              index == vacunaProviderC.selectedIndexPaciente;

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
                                vacunaProviderC.setSelectedIndexPaciente(index);
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
                            Provider.of<VacunaProvider>(context, listen: false)
                              ..setSelectSquareVacuna(0)
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
                            if (vacunaProvider.selectedIndexPaciente != -1) {
                              vacunaProvider.setSelectedIdPacienteAntiguo(
                                  pacienteSeleccionado.toString());
                              print(' aqui esta el id del paciente anitugo' +
                                  vacunaProvider.selectedIdPacienteAntiguo);
                              Navigator.of(context).pop();
                              _openModalBottomSheetVacuna(context);
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

void _openModalBottomSheetVacuna(BuildContext context) {
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
                child: FormularioVacuna(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class ButtonProgramarCitaVacuna extends StatelessWidget {
  const ButtonProgramarCitaVacuna({super.key});

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

class ButtonPacientesVacuna extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonPacientesVacuna({super.key, required this.listaPacientesBusq});

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
                onPressed: () {
                  _openAlertDialogBuscarPaciente(context, listaPacientesBusq);
                },
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
    final vacunaProvider = Provider.of<VacunaProvider>(context, listen: false);
    vacunaProvider.filtrarLista(listaPacientesBusq, "");

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
                    vacunaProvider.filtrarLista(listaPacientesBusq, query);
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
                    child: Consumer<VacunaProvider>(
                        builder: (context, vacunaProviderC, _) {
                      final listaFiltrada = vacunaProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected =
                              index == vacunaProviderC.selectedIndexPaciente;

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
                                vacunaProviderC.setSelectedIndexPaciente(index);
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
                            Provider.of<VacunaProvider>(context, listen: false)
                              ..setSelectSquareVacuna(0)
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
                            if (vacunaProvider.selectedIndexPaciente != -1) {
                              vacunaProvider
                                ..setSelectedIdPacienteAntiguo(
                                    pacienteSeleccionado.toString())
                                ..setSelectSquareVacuna(2)
                                ..clearBusquedas();
                              Navigator.of(context).pop();
                              _openModalBottomSheetVacuna(context);
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormularioVacuna extends StatefulWidget {
  @override
  _FormularioVacunaState createState() => _FormularioVacunaState();
}

class _FormularioVacunaState extends State<FormularioVacuna> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoVacuna = GlobalKey<FormState>();
  final _formkeyDatosPaciente = GlobalKey<FormState>();
  final _formkeyDatosVacuna = GlobalKey<FormState>();
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

  //controllers para CIRUGIA
  TextEditingController controllerContraQue = TextEditingController();
  TextEditingController controllerLaboratorio = TextEditingController();
  TextEditingController controllerSerie = TextEditingController();
  TextEditingController controllerProcedencia = TextEditingController();

  //Editing controller para agendar proxima visita
  final SignatureController controllerFirma = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

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
    final numPages = Provider.of<VacunaProvider>(context, listen: false)
                .selectedSquareVacuna ==
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
    VacunaProvider dataVacuna =
        Provider.of<VacunaProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataVacuna.getEncargados;
    double valueLinearProgress = dataVacuna.selectedSquareVacuna == 2 ? 3 : 5;

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
                  dataVacuna.selectedSquareVacuna == 2 ? ' de 3' : ' de 5',
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
                children: dataVacuna.selectedSquareVacuna == 2
                    ? [
                        _datosVacuna(dataVacuna, sizeScreenWidth),
                        _datosProximaVisita(
                            dataVacuna, sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(
                            dataVacuna, sizeScreenWidth, listaVeterinarios),
                      ]
                    : [
                        _datosDelDueno(dataVacuna, sizeScreenWidth),
                        _datosPaciente(dataVacuna, sizeScreenWidth),
                        _datosVacuna(dataVacuna, sizeScreenWidth),
                        _datosProximaVisita(
                            dataVacuna, sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(
                            dataVacuna, sizeScreenWidth, listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(VacunaProvider dataVacuna, double sizeScreenWidth) {
    return datosDelDueno(
        formKey: _formKeyDuenoVacuna,
        controllerCi: controllerCiDueno,
        controllerNombre: controllerNombre,
        controllerApellido: controllerApellido,
        controllerNumero: controllerNumero,
        controllerDireccion: controllerDireccion,
        sizeScreenWidth: sizeScreenWidth,
        onNext: () => _nextPage(),
        onCancel: () => _mostrarAlertaCancelar(context));
  }

  Widget _datosPaciente(VacunaProvider dataVacuna, double sizeScreenWidth) {
    return datosPaciente(
        sizeScreenWidth: sizeScreenWidth,
        formKey: _formkeyDatosPaciente,
        controllerNombrePaciente: controllerNombrePaciente,
        radioButtonsGenero: [
          const RadioButtonReutilizableGeneroVacuna(
            gender: 'Macho intacto',
            valor: 'M',
          ),
          const RadioButtonReutilizableGeneroVacuna(
            gender: 'Macho castrado',
            valor: 'MC',
          ),
          const RadioButtonReutilizableGeneroVacuna(
            gender: 'Hembra intacta',
            valor: 'H',
          ),
          const RadioButtonReutilizableGeneroVacuna(
            gender: 'Hembra esterilizada',
            valor: 'HC',
          ),
        ],
        generoProvider: dataVacuna.selectedSexoPaciente,
        edadWidget: TextFormFieldNumberEdad(
          colores: const Color.fromARGB(255, 140, 228, 233),
          hintText: 'Edad',
          controller: controllerEdadPaciente,
          provider: dataVacuna,
        ),
        especieWidget:
            Consumer<VacunaProvider>(builder: (context, provider, _) {
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
        razaWidget: Consumer<VacunaProvider>(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una raza';
                  }
                  return null;
                },
                isExpanded: false,
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
          value: dataVacuna.dropTamanoMascota,
          options: const ['G', 'M', 'P'],
          onChanged: (value) {
            dataVacuna.setDropTamanoMascota(value!);
          },
          hintText: 'Seleccionar...',
        ),
        temperamentoWidget: CustomDropdownTemperament(
          value: dataVacuna.dropTemperamento,
          options: const ['S', 'C', 'A', 'M'],
          onChanged: (value) {
            dataVacuna.setDropTemperamento(value!);
          },
          hintText: 'Seleccionar...',
        ),
        alimentacionWidget: CustomDropdownFood(
          value: dataVacuna.dropAlimentacion,
          options: const ['C', 'M', 'B'],
          onChanged: (value) {
            dataVacuna.setDropAlimentacion(value!);
          },
          hintText: 'Seleccionar...',
        ),
        imagenWidget: dataVacuna.image != null
            ? getFotoPaciente(dataVacuna)
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
                        dataVacuna.addPhoto();
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

  Widget _datosVacuna(VacunaProvider dataVacuna, double sizeScreenWidth) {
    String nombreLegible = path.basename(dataVacuna.fileArchivoVacuna);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyDatosVacuna,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _tituloForm('Datos de la vacuna'),
            _separacionCampos(20),
            _NombreCampos('Contra'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerContraQue,
                hintText: 'Ej: Parvovirus'),
            _separacionCampos(20),
            _NombreCampos('Laboratorio'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerLaboratorio,
                hintText: 'Ej:'),
            _separacionCampos(20),
            _NombreCampos('Serie'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerSerie,
                hintText: 'Ej: 001'),
            _separacionCampos(20),
            _NombreCampos('Procedencia'),
            _separacionCampos(15),
            TextFormFieldConHint(
                colores: const Color.fromARGB(255, 140, 228, 233),
                controller: controllerProcedencia,
                hintText: 'Ej: Farmacia La Paz'),
            _separacionCampos(20),
            _NombreCampos('Expiración'),
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
                    dataVacuna.setFechaExpiracion(formattedDateEnviar);
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
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: const Color.fromARGB(255, 139, 149, 166),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Center(
                      child: Text(
                        dataVacuna.fechaExpiracion,
                        style: TextStyle(
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
              validator: (_) => dataVacuna.fechaExpiracion == ''
                  ? 'Seleccione fecha expiración.'
                  : null,
            ),
            _separacionCampos(15),
            _NombreCampos('Agregar archivo'),
            _separacionCampos(15),
            dataVacuna.fileArchivoVacuna.isEmpty
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
                          //fileProvider.addFileCoprologia(fileName);
                          dataVacuna.setArchivoVacuna(fileName);
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
                        //fileProvider.addFileCoprologia(fileName);
                        dataVacuna.setArchivoVacuna(fileName);
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
                          SizedBox(
                            width: 8,
                          ),
                          Center(
                            child: Text(
                              nombreLegible,
                              style: TextStyle(
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
              validator: (_) => dataVacuna.fileArchivoVacuna == ''
                  ? 'Añade un archivo.'
                  : null,
            ),
            _separacionCampos(15),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formkeyDatosVacuna.currentState!.validate()) {
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

  Widget _datosProximaVisita(VacunaProvider dataVacuna, double sizeScreenWidth,
      List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyProximaVisita,
          child: Column(
              //DATOS CLINICOS
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Próxima vacuna'),
                _separacionCampos(20),
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
                    _openTimePicker(context, dataVacuna);
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
                        Container(
                          child: const Icon(
                            Icons.access_time,
                            color: Color.fromARGB(255, 139, 149, 166),
                            size: 28,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        dataVacuna.horaSelected.isEmpty
                            ? const Text(
                                'Seleccionar hora',
                                style: TextStyle(
                                    color: Color.fromRGBO(139, 149, 166, 1),
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                dataVacuna.horaSelected,
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
                MensajeValidadorSelecciones(
                  validator: (value) {
                    if (dataVacuna.horaSelected == '') {
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
                        child: const Icon(IconlyLight.user_1,
                            color: Color.fromARGB(255, 139, 149, 166),
                            size: 28)),
                    const SizedBox(
                      width: 15,
                    ),
                    dataVacuna.inicialEncargado.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 47, 26, 125),
                              child: Text(
                                dataVacuna.inicialEncargado,
                                style: const TextStyle(
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
                              title: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Encargados',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 29, 34, 44),
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
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ), // Mostrar el ID a la izquierda
                                      title: Text('${veterinario.nombres}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 29, 34, 44),
                                              fontSize: 16,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400)),
                                      subtitle: Text('${veterinario.apellidos}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 139, 149, 166),
                                              fontSize: 12,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400)),
                                      onTap: () {
                                        guardarIdVetEncargado(
                                            context, veterinario, dataVacuna);
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
                          child: const Icon(Icons.add,
                              color: Color.fromARGB(255, 139, 149, 166),
                              size: 20)),
                    ),
                  ],
                ),
                MensajeValidadorSelecciones(
                  validator: (value) {
                    if (dataVacuna.idEncargadoSelected == '') {
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

  Widget _datosFacturacion(VacunaProvider dataVacuna, double sizeScreenWidth,
      List<EncargadosVete> listaVeterinarios) {
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
                DatosFacturacion<VacunaProvider>(
                  providerGenerico: dataVacuna,
                  sizeScreenWidth: sizeScreenWidth,
                  radioButtons: const [
                    RadioButtonEfecTransacVacuna(
                      efecTransac: 'Efectivo',
                      valor: 'EFECTIVO',
                    ),
                    RadioButtonEfecTransacVacuna(
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
                // Row(
                //   children: [
                //     _NombreCampos('Aplicando descuento'),
                //     Spacer(),
                //     _NombreCampos('${dataVacuna.totalACobrarFacturacion} Bs.'),
                //   ],
                // ),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (dataVacuna.totalACobrarFacturacion.isEmpty) {
                          dataVacuna.setTotalACobrarFacturacion =
                              controllerMontoEfectivo.text;
                        }
                        if (_formkeyFacturacion.currentState!.validate()) {
                          dataVacuna.selectedSquareVacuna == 2
                              ? dataVacuna
                                  .enviarDatosAntiguo(
                                      //paciente
                                      dataVacuna.selectedIdPacienteAntiguo,
                                      //vacuna
                                      controllerContraQue.text,
                                      controllerLaboratorio.text,
                                      controllerSerie.text,
                                      controllerProcedencia.text,
                                      dataVacuna.fechaExpiracion,
                                      dataVacuna.fileArchivoVacuna,
                                      //proxima visita
                                      dataVacuna.fechaVisitaSelected == ''
                                          ? DateFormat("yyyy-MM-dd")
                                              .format(today)
                                          : dataVacuna.fechaVisitaSelected,
                                      dataVacuna.horaSelected,
                                      dataVacuna.idEncargadoSelected,
                                      //datos facturacion
                                      dataVacuna.selectedEfectivoTransac,
                                      controllerCIoNit.text,
                                      controllerNombreFactura.text,
                                      controllerApellidoFactura.text,
                                      dataVacuna.switchValueFacturacion,
                                      dataVacuna.totalACobrarFacturacion)
                                  .then((_) async {
                                  if (dataVacuna.OkpostDatosVacuna) {
                                    _mostrarFichaCreada(context);
                                  }
                                })
                              : dataVacuna
                                  .enviarDatos(
                                      //propietario
                                      controllerCiDueno.text,
                                      controllerNombre.text,
                                      controllerApellido.text,
                                      controllerNumero.text,
                                      controllerDireccion.text,
                                      //paciente
                                      controllerNombrePaciente.text,
                                      dataVacuna.selectedSexoPaciente,
                                      controllerEdadPaciente.text,
                                      dataVacuna.selectedIdEspecie,
                                      dataVacuna.selectedIdRaza!,
                                      dataVacuna.dropTamanoMascota,
                                      dataVacuna.dropTemperamento,
                                      dataVacuna.dropAlimentacion,
                                      dataVacuna.lastImage,

                                      //vacuna
                                      controllerContraQue.text,
                                      controllerLaboratorio.text,
                                      controllerSerie.text,
                                      controllerProcedencia.text,
                                      dataVacuna.fechaExpiracion,
                                      dataVacuna.fileArchivoVacuna,

                                      //proxima visita
                                      dataVacuna.fechaVisitaSelected == ''
                                          ? DateFormat("yyyy-MM-dd")
                                              .format(today)
                                          : dataVacuna.fechaVisitaSelected,
                                      dataVacuna.horaSelected,
                                      dataVacuna.idEncargadoSelected,

                                      //datos facturacion
                                      dataVacuna.selectedEfectivoTransac,
                                      controllerCIoNit.text,
                                      controllerNombreFactura.text,
                                      controllerApellidoFactura.text,
                                      dataVacuna.switchValueFacturacion,
                                      dataVacuna.totalACobrarFacturacion)
                                  .then((_) async {
                                  if (dataVacuna.OkpostDatosVacuna) {
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
                      child: dataVacuna.loadingDatosVacuna
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
                              side: const BorderSide(
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
                                  Provider.of<VacunaProvider>(context,
                                          listen: false)
                                      .setSelectSquareVacuna(0);
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
      VacunaProvider dataVacuna) {
    dataVacuna.setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataVacuna
        .setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    VacunaProvider dataVacuna =
        Provider.of<VacunaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataVacuna.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, VacunaProvider dataVacuna) {
    final timePicker = TimePickerHelper<VacunaProvider>(
      context: context,
      provider: dataVacuna,
      getHoraSelected: () => dataVacuna.horaSelected,
      setHoraSelected: dataVacuna.setHoraSelected,
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

  Widget getFotoPaciente(VacunaProvider dataVacuna) {
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
            dataVacuna.addPhoto();
          },
          child: Image.file(
            dataVacuna.lastImage!,
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
