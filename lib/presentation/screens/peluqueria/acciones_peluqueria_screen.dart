import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/models/clinica/buscarPacientes_model.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/widgetFacturacion.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/generales/time_picker_helper.dart';

import '../../../config/global/palet_colors.dart';
import '../../../models/peluqueria/encargadosPeluqueros.dart';
import '../../../models/peluqueria/peluqueria_update_form.dart';
import '../../../providers/peluqueria/peluqueria_provider.dart';
import '../../../providers/peluqueria/programarCitaPelu_provider.dart';
import '../../widgets/dropDown_widget.dart';
import '../../widgets/peluqueria/checkBoxReutilizablePeluqueria_widget.dart';
import '../../widgets/peluqueria/radiobuttonPeluqueria_widget.dart';
import '../../widgets/textFormFieldsTypes_widget.dart';
import 'programarCita/programarCitaPelu_screen.dart';

class ButtonNuevoRegistroPeluqueria extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonNuevoRegistroPeluqueria({super.key, required this.listaPacientesBusq});

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
                  final peluqeriaProvider =
                      Provider.of<PeluqueriaProvider>(context, listen: false);
                  peluqeriaProvider.setSelectSquarePeluqueria(0);
                  peluqeriaProvider.resetearDatos();
                  await _modalPeluqueriaNuevoRegistro(
                      context, listaPacientesBusq, sizeScreen);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.complementViolet3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                child: const Row(
                  children: [
                    Icon(
                      Iconsax.document_text_1,
                      size: 35,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Nuevo registro',
                      style: TextStyle(
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

  Future<dynamic> _modalPeluqueriaNuevoRegistro(
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
                            Provider.of<PeluqueriaProvider>(context,
                                    listen: false)
                                .setSelectSquarePeluqueria(1);
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<PeluqueriaProvider>(context)
                                            .selectedSquarePeluqueria ==
                                        1
                                    ? const Color.fromARGB(255, 99, 92, 255)
                                    : const Color.fromARGB(255, 218, 223, 230),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user_add,
                                  size: 35,
                                  color:
                                      Provider.of<PeluqueriaProvider>(context)
                                                  .selectedSquarePeluqueria ==
                                              1
                                          ? Color.fromARGB(255, 99, 92, 255)
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
                                      color: Provider.of<PeluqueriaProvider>(
                                                      context)
                                                  .selectedSquarePeluqueria ==
                                              1
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : Color.fromARGB(255, 218, 223, 230),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: sizeScreen.width * 0.02),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<PeluqueriaProvider>(context,
                                listen: false)
                              ..setSelectSquarePeluqueria(2)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<PeluqueriaProvider>(context)
                                            .selectedSquarePeluqueria ==
                                        2
                                    ? Color.fromARGB(255, 99, 92, 255)
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
                                  color:
                                      Provider.of<PeluqueriaProvider>(context)
                                                  .selectedSquarePeluqueria ==
                                              2
                                          ? Color.fromARGB(255, 99, 92, 255)
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
                                      color: Provider.of<PeluqueriaProvider>(
                                                      context)
                                                  .selectedSquarePeluqueria ==
                                              2
                                          ? Color.fromARGB(255, 99, 92, 255)
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
                            Provider.of<PeluqueriaProvider>(context,
                                    listen: false)
                                .setSelectSquarePeluqueria(0);
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 99, 92, 255),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255)),
                        onPressed: () {
                          if (Provider.of<PeluqueriaProvider>(context,
                                      listen: false)
                                  .selectedSquarePeluqueria ==
                              1) {
                            Navigator.of(context).pop();
                            _openModalBottomSheetOPeluqueria(context);
                          } else if (Provider.of<PeluqueriaProvider>(context,
                                      listen: false)
                                  .selectedSquarePeluqueria ==
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
    final peluqueriaProvider =
        Provider.of<PeluqueriaProvider>(context, listen: false);
    peluqueriaProvider.filtrarLista(listaPacientesBusq, "");
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
                    peluqueriaProvider.filtrarLista(listaPacientesBusq, query);
                  },
                  controller: controllerBusquedaOProced,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaOProced.clear();
                        peluqueriaProvider.filtrarLista(listaPacientesBusq, "");
                      },
                      child: const Icon(
                        Icons.clear_rounded,
                        color: Color.fromARGB(255, 99, 92, 255),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 99, 92, 255),
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
                    child: Consumer<PeluqueriaProvider>(
                        builder: (context, peluqeriaProviderC, _) {
                      final listaFiltrada = peluqeriaProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected =
                              index == peluqeriaProviderC.selectedIndexPaciente;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 99, 92, 255),
                                      width: 1)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 2),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 99, 92, 255),
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
                                peluqeriaProviderC
                                    .setSelectedIndexPaciente(index);
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
                            peluqueriaProvider
                              ..setSelectSquarePeluqueria(0)
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
                                color: Color.fromARGB(255, 99, 92, 255),
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
                            if (peluqueriaProvider.selectedIndexPaciente !=
                                -1) {
                              peluqueriaProvider.setSelectedIdPacienteAntiguo(
                                  pacienteSeleccionado.toString());
                              Navigator.of(context).pop();
                              _openModalBottomSheetOPeluqueria(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 99, 92, 255),
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

void _openModalBottomSheetOPeluqueria(BuildContext context) {
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
                child: FormularioPeluqueria(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class ButtonProgramarCitaPeluqueria extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonProgramarCitaPeluqueria({super.key, required this.listaPacientesBusq});

  final TextEditingController controllerBusquedaOProced =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
              height: 80,
              child: ElevatedButton(
                onPressed: () async {
                  Provider.of<ProgramarCitaPeluProvider>(context, listen: false)
                      .setSelectSquarePCitaPelu(0);
                  _modalPeluqueriaNuevoRegistro(
                      context, listaPacientesBusq, sizeScreen);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 230, 242, 248),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                child: const Row(
                  children: [
                    Icon(
                      Iconsax.calendar_edit,
                      size: 35,
                      color: Color.fromARGB(255, 49, 46, 128),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Programar cita',
                      style: TextStyle(
                          color: Color.fromARGB(255, 49, 46, 128),
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

  void _modalPeluqueriaNuevoRegistro(BuildContext context,
      List<ResultBusPacientes> listaPacientesBusq, sizeScreen) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¿El paciente es nuevo o antiguo?',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 29, 34, 44),
                      fontSize: 16,
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w600),
                ),
                Divider(),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<ProgramarCitaPeluProvider>(context,
                                    listen: false)
                                .setSelectSquarePCitaPelu(1);
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<ProgramarCitaPeluProvider>(
                                                context)
                                            .selectedSquarePCitaPelu ==
                                        1
                                    ? const Color.fromARGB(255, 99, 92, 255)
                                    : const Color.fromARGB(255, 218, 223, 230),
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.user_add,
                                    size: 35,
                                    color:
                                        Provider.of<ProgramarCitaPeluProvider>(
                                                        context)
                                                    .selectedSquarePCitaPelu ==
                                                1
                                            ? Color.fromARGB(255, 99, 92, 255)
                                            : Color.fromARGB(
                                                255, 218, 223, 230),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Paciente nuevo',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'sans',
                                        color: Provider.of<ProgramarCitaPeluProvider>(
                                                        context)
                                                    .selectedSquarePCitaPelu ==
                                                1
                                            ? Color.fromARGB(255, 99, 92, 255)
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
                            Provider.of<ProgramarCitaPeluProvider>(context,
                                listen: false)
                              ..setSelectSquarePCitaPelu(2)
                              ..setSelectedIndexPaciente(-1);
                            // ..clearBusquedas();
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<ProgramarCitaPeluProvider>(
                                                context)
                                            .selectedSquarePCitaPelu ==
                                        2
                                    ? Color.fromARGB(255, 99, 92, 255)
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
                                    color:
                                        Provider.of<ProgramarCitaPeluProvider>(
                                                        context)
                                                    .selectedSquarePCitaPelu ==
                                                2
                                            ? Color.fromARGB(255, 99, 92, 255)
                                            : Color.fromARGB(
                                                255, 218, 223, 230),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Paciente antiguo',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'sans',
                                        color: Provider.of<ProgramarCitaPeluProvider>(
                                                        context)
                                                    .selectedSquarePCitaPelu ==
                                                2
                                            ? Color.fromARGB(255, 99, 92, 255)
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
                            Provider.of<ProgramarCitaPeluProvider>(context,
                                    listen: false)
                                .setSelectSquarePCitaPelu(0);
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'inter',
                                color: Color.fromARGB(255, 99, 92, 255),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255)),
                        onPressed: () {
                          if (Provider.of<ProgramarCitaPeluProvider>(context,
                                      listen: false)
                                  .selectedSquarePCitaPelu ==
                              1) {
                            Navigator.of(context).pop();
                            openModalBottomSheetProgramarCitaPelu(context);
                          } else if (Provider.of<ProgramarCitaPeluProvider>(
                                      context,
                                      listen: false)
                                  .selectedSquarePCitaPelu ==
                              2) {
                            Navigator.of(context).pop();
                            _openAlertDialogBuscarPaciente(
                                context, listaPacientesBusq, sizeScreen);
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

  void _openAlertDialogBuscarPaciente(BuildContext context,
      List<ResultBusPacientes> listaPacientesBusq, Size sizeScreen) {
    final programaCitaPeluProvider =
        Provider.of<ProgramarCitaPeluProvider>(context, listen: false);
    programaCitaPeluProvider.filtrarLista(listaPacientesBusq, "");
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
            height: sizeScreen.height * 0.55,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (query) {
                    programaCitaPeluProvider.filtrarLista(
                        listaPacientesBusq, query);
                  },
                  controller: controllerBusquedaOProced,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaOProced.clear();
                        programaCitaPeluProvider.filtrarLista(
                            listaPacientesBusq, "");
                      },
                      child: const Icon(Icons.clear_rounded),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 99, 92, 255),
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
                    height: sizeScreen.height * 0.45,
                    width: sizeScreen.width * 0.60,
                    child: Consumer<ProgramarCitaPeluProvider>(
                        builder: (context, peluqueriaProviderC, _) {
                      final listaFiltrada = peluqueriaProviderC.listaFiltrada;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected = index ==
                              peluqueriaProviderC.selectedIndexPaciente;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 99, 92, 255),
                                      width: 1)
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 2),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 99, 92, 255),
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
                                peluqueriaProviderC
                                    .setSelectedIndexPaciente(index);
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
                            programaCitaPeluProvider
                              ..setSelectSquarePCitaPelu(0)
                              ..setSelectedIndexPaciente(-1);
                            // ..clearBusquedas();
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
                                color: Color.fromARGB(255, 99, 92, 255),
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
                            if (programaCitaPeluProvider
                                    .selectedIndexPaciente !=
                                -1) {
                              programaCitaPeluProvider
                                  .setSelectedIdPacienteAntiguo(
                                      pacienteSeleccionado.toString());
                              Navigator.of(context).pop();
                              openModalBottomSheetProgramarCitaPelu(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Color.fromARGB(255, 99, 92, 255),
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

void openModalBottomSheetProgramarCitaPelu(BuildContext context) {
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
                child: FormularioProgramarCitaPelu(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class ButtonPacientesPeluqueria extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  // Add the list of patients as a constructor parameter
  ButtonPacientesPeluqueria({super.key, required this.listaPacientesBusq});

  final TextEditingController controllerBusquedaOProced =
      TextEditingController();

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
                  // Call the _openAlertDialogBuscarPaciente function here
                  _openAlertDialogBuscarPaciente(context, listaPacientesBusq);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Iconsax.people,
                      size: 35,
                      color: Color.fromARGB(255, 49, 46, 128),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Pacientes',
                      style: TextStyle(
                          color: Color.fromARGB(255, 49, 46, 128),
                          fontSize: 19,
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _openAlertDialogBuscarPaciente(
      BuildContext context, List<ResultBusPacientes> listaPacientesBusq) {
    final listaFiltradaProvider =
        Provider.of<ProgramarCitaPeluProvider>(context, listen: false);

    listaFiltradaProvider.filtrarLista(listaPacientesBusq, "");

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
                    listaFiltradaProvider.filtrarLista(
                        listaPacientesBusq, query);
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
                    child: Consumer<ProgramarCitaPeluProvider>(
                        builder: (context, listaFiltradaProvider, _) {
                      final listaFiltrada = listaFiltradaProvider.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected = index ==
                              listaFiltradaProvider.selectedIndexPaciente;

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
                                    Color.fromARGB(255, 47, 26, 125),
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
                                listaFiltradaProvider
                                    .setSelectedIndexPaciente(index);
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
                            Provider.of<ProgramarCitaPeluProvider>(context,
                                listen: false)
                              ..setSelectSquarePCitaPelu(0)
                              ..setSelectedIndexPaciente(-1);
                            // ..clearBusquedas();
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
                            if (Provider.of<ProgramarCitaPeluProvider>(context,
                                        listen: false)
                                    .selectedIndexPaciente !=
                                -1) {
                              Provider.of<ProgramarCitaPeluProvider>(context,
                                      listen: false)
                                  .setSelectedIdPacienteAntiguo(
                                      pacienteSeleccionado.toString());
                              Navigator.of(context).pop();
                              openModalBottomSheetProgramarCitaPelu(context);
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

class FormularioPeluqueria extends StatefulWidget {
  @override
  _FormularioPeluqueriaState createState() => _FormularioPeluqueriaState();
}

class _FormularioPeluqueriaState extends State<FormularioPeluqueria> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoPeluqueria = GlobalKey<FormState>();
  final _formKeyPacientePeluqueria = GlobalKey<FormState>();
  final _formKeyServiciosEsteticos = GlobalKey<FormState>();
  final _formkeyIndicaciones = GlobalKey<FormState>();
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

  //editing para SERVICIOS ESTETICOS
  TextEditingController controllerPeinadosYExtras = TextEditingController();
  TextEditingController controllerTratamientoServEsteticos =
      TextEditingController();

  //controllers para INDICACIONES
  TextEditingController controllerIndicacionEspecial = TextEditingController();
  TextEditingController controllerMascDificilConsentimiento =
      TextEditingController();

  final SignatureController controllerFirma = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  //Editing controller para agendar proxima visita
  TextEditingController controllerCosto = TextEditingController();

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
    final numPages = Provider.of<PeluqueriaProvider>(context, listen: false)
                .selectedSquarePeluqueria ==
            2
        ? 4
        : 6;

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
    PeluqueriaProvider dataPeluqueria =
        Provider.of<PeluqueriaProvider>(context, listen: true);
    List<EncarPeluqueros> listaPeluquerosEncar =
        dataPeluqueria.getEncargadosPelu;
    double valueLinearProgress =
        dataPeluqueria.selectedSquarePeluqueria == 2 ? 4 : 6;

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
                      color: Color.fromARGB(255, 99, 92, 255),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  dataPeluqueria.selectedSquarePeluqueria == 2
                      ? ' de 4'
                      : ' de 6',
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
                    Color.fromARGB(255, 99, 92, 255)),
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
                children: dataPeluqueria.selectedSquarePeluqueria == 2
                    ? [
                        _datosServiciosEsteticos(
                            dataPeluqueria, sizeScreenWidth),
                        _datosIndicaciones(dataPeluqueria, sizeScreenWidth),
                        _datosProximaVisita(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar),
                        _datosFacturacion(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar)
                      ]
                    : [
                        _datosDelDueno(dataPeluqueria, sizeScreenWidth),
                        _datosPaciente(dataPeluqueria),
                        _datosServiciosEsteticos(
                            dataPeluqueria, sizeScreenWidth),
                        _datosIndicaciones(dataPeluqueria, sizeScreenWidth),
                        _datosProximaVisita(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar),
                        _datosFacturacion(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKeyDuenoPeluqueria,
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
                  colores: const Color.fromARGB(255, 177, 173, 255),
                  controller: controllerCiDueno,
                  hintText: 'Celula de identidad (Ej: 9958410)',
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
                        if (_formKeyDuenoPeluqueria.currentState!.validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
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
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosPaciente(PeluqueriaProvider dataPelu) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formKeyPacientePeluqueria,
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
                TextFormFieldConHintValidator(
                  colores: Color.fromARGB(255, 140, 228, 233),
                  controller: controllerNombrePaciente,
                  hintText: 'Bigotes',
                ),
                _separacionCampos(15),
                _NombreCampos('Sexo'),
                _separacionCampos(15),
                RadioButtonReutilizableGeneroPeluqueria(
                  gender: 'Macho intacto',
                  valor: 'M',
                ),
                RadioButtonReutilizableGeneroPeluqueria(
                  gender: 'Macho castrado',
                  valor: 'MC',
                ),
                RadioButtonReutilizableGeneroPeluqueria(
                  gender: 'Hembra intacta',
                  valor: 'H',
                ),
                RadioButtonReutilizableGeneroPeluqueria(
                  gender: 'Hembra esterilizada',
                  valor: 'HC',
                ),
                _separacionCampos(20),
                _NombreCampos('Edad'),
                _separacionCampos(5),
                TextFormFieldNumberEdad(
                  colores: const Color.fromARGB(255, 177, 173, 255),
                  hintText: 'Edad',
                  controller: controllerEdadPaciente,
                  provider: dataPelu,
                ),
                _separacionCampos(5),
                _NombreCampos('Especie'),
                _separacionCampos(15),
                Consumer<PeluqueriaProvider>(builder: (context, provider, _) {
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
                Consumer<PeluqueriaProvider>(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecciona una raza';
                          }
                          return null;
                        },
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
                  value: dataPelu.dropTamanoMascota,
                  options: const ['G', 'M', 'P'],
                  onChanged: (value) {
                    dataPelu.setDropTamanoMascota(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Temperamento'),
                _separacionCampos(15),
                CustomDropdownTemperament(
                  value: dataPelu.dropTemperamento,
                  options: const ['S', 'C', 'A', 'M'],
                  onChanged: (value) {
                    dataPelu.setDropTemperamento(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Alimentación'),
                _separacionCampos(15),
                CustomDropdownFood(
                  value: dataPelu.dropAlimentacion,
                  options: const ['C', 'M', 'B'],
                  onChanged: (value) {
                    dataPelu.setDropAlimentacion(value!);
                  },
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                dataPelu.image != null
                    ? getFotoPaciente(dataPelu)
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
                                dataPelu.addPhoto();
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
                                          color:
                                              Color.fromARGB(255, 94, 99, 102),
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
                        if (_formKeyPacientePeluqueria.currentState!
                            .validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
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
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosServiciosEsteticos(
      PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKeyServiciosEsteticos,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  'Servicios Estéticos',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 29, 34, 44),
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            _separacionCampos(20),
            ReusableCheckboxCortePelo(
              desc: 'Corte de pelo',
              onChanged: (newValue) {
                dataPelu.setCheckCortePelo(newValue!);
              },
              value: dataPelu.isCheckedCortePelo,
            ),
            dataPelu.isCheckedCortePelo
                ? Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableCheckboxCortePelo(
                          desc: '¿La mascota es dificíl?',
                          onChanged: (newValue) {
                            dataPelu.setCheckCortePeloMascDificil(newValue!);
                          },
                          value: dataPelu.isCheckedCortePeloMascDificil,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child:
                                _NombreCampos('Peinados especiales y extras')),
                        TextFormFieldMaxLinesConHint(
                          controller: controllerPeinadosYExtras,
                          hintText:
                              'Describa el tipo de peinado especial y extras que se requieran (E.j: Moños)',
                          maxLines: 6,
                          colores: Color.fromARGB(255, 177, 173, 255),
                          validar: true,
                        )
                      ],
                    ),
                  )
                : Container(),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Baño completo',
              onChanged: (newValue) {
                dataPelu.setCheckBanoCompleto(newValue!);
              },
              value: dataPelu.isCheckedBanoCompleto,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Limpieza de oídos',
              onChanged: (newValue) {
                dataPelu.setCheckLimpOidos(newValue!);
              },
              value: dataPelu.isCheckedLimpOidos,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Pedicura',
              onChanged: (newValue) {
                dataPelu.setCheckPedicura(newValue!);
              },
              value: dataPelu.isCheckedPedicura,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Limpieza dental',
              onChanged: (newValue) {
                dataPelu.setCheckLimpDental(newValue!);
              },
              value: dataPelu.isCheckedLimpDental,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Limpieza de glándulas',
              onChanged: (newValue) {
                dataPelu.setCheckLimpGlandulas(newValue!);
              },
              value: dataPelu.isCheckedLimpGlandulas,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Eliminación de pulgas',
              onChanged: (newValue) {
                dataPelu.setCheckElimPulgas(newValue!);
              },
              value: dataPelu.isCheckedElimPulgas,
            ),
            _separacionCampos(2),
            ReusableCheckboxCortePelo(
              desc: 'Otros tratamientos',
              onChanged: (newValue) {
                dataPelu.setCheckOtrosTrat(newValue!);
              },
              value: dataPelu.isCheckedOtrosTrat,
            ),
            _separacionCampos(5),
            dataPelu.isCheckedOtrosTrat
                ? Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: _NombreCampos('Tratamiento ')),
                        TextFormFieldMaxLinesConHint(
                          controller: controllerTratamientoServEsteticos,
                          hintText:
                              'Indica que las pruebas requeridas (Ej. radiografía, ecografía, tomografía)',
                          maxLines: 6,
                          colores: Color.fromARGB(255, 177, 173, 255),
                          validar: true,
                        )
                      ],
                    ),
                  )
                : Container(),
            MensajeValidadorSelecciones(
              validator: (_) {
                if (!dataPelu.isCheckedCortePelo &&
                    !dataPelu.isCheckedBanoCompleto &&
                    !dataPelu.isCheckedLimpOidos &&
                    !dataPelu.isCheckedPedicura &&
                    !dataPelu.isCheckedLimpDental &&
                    !dataPelu.isCheckedLimpGlandulas &&
                    !dataPelu.isCheckedElimPulgas &&
                    !dataPelu.isCheckedOtrosTrat) {
                  return 'Debe seleccionar al menos un servicio estético.';
                } else {
                  return null;
                }
              },
            ),
            _separacionCampos(20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyServiciosEsteticos.currentState!.validate()) {
                      _nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 99, 92, 255),
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
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 68, 0, 153),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    'Atrás',
                    style: TextStyle(
                        color: Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosIndicaciones(
      PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formkeyIndicaciones,
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
                      'Indicaciones',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 29, 34, 44),
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                _separacionCampos(20),
                _NombreCampos('Indicaciones especiales'),
                TextFormFieldMaxLinesConHint(
                  controller: controllerIndicacionEspecial,
                  hintText:
                      'Describa aquí las lesiones del paciente (Ej: cojera, raspones, cortes, etc.)',
                  maxLines: 6,
                  colores: Color.fromARGB(255, 177, 173, 255),
                ),
                _separacionCampos(15),
                _NombreCampos('Hora de entrega'),
                _separacionCampos(15),
                InkWell(
                  onTap: () {
                    _openTimePickerIndicaciones(context, dataPelu);
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
                        dataPelu.horaEntregaSelected.isEmpty
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
                                dataPelu.horaEntregaSelected,
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
                    if (dataPelu.horaEntregaSelected == '') {
                      return 'Por favor, seleccione una hora.';
                    }
                    return null;
                  },
                ),
                _separacionCampos(20),
                ReusableCheckboxCortePelo(
                  desc: '¿La mascota es difícil?',
                  onChanged: (newValue) {
                    dataPelu.setCheckIndicacionesMascDificil(newValue!);
                  },
                  value: dataPelu.isCheckedIndicacionesMascDificil,
                ),
                _separacionCampos(5),
                dataPelu.isCheckedIndicacionesMascDificil
                    ? Container(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: _NombreCampos('Consentimiento ')),
                            TextFormFieldMaxLinesConHintLlenadoAutomatico(
                              controller: controllerMascDificilConsentimiento,
                              hintText:
                                  'Yo ${controllerNombre.text} ${controllerApellido.text}, recibo información clara de los beneficios del proceso estetéticos que se llevaran a cabo en mi mascota como también los riesgos posibles que existen, como irritaciones y cortadas de la piel por exceso de pelo en malas condiciones, irritaciones de ojo por sensibilidad al shampoo, convulsión y ojos rojos por estrés, Conforme a la información que he leído y comprendo he podido preguntar y aclarar mis dudas, por eso he tomado consiente y literalmente la decisión de autorizar los procedimientos arriba señalados.',
                              maxLines: 15,
                              colores: Color.fromARGB(255, 177, 173, 255),
                            )
                          ],
                        ),
                      )
                    : Container(),
                _separacionCampos(20),
                _NombreCampos('Firma electrónica'),
                _separacionCampos(15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 200,
                  width: sizeScreenWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Signature(
                          controller: controllerFirma,
                          width: sizeScreenWidth,
                          height: 200,
                          backgroundColor: Color.fromARGB(255, 249, 249, 249),
                        ),
                        Positioned(
                            left: 5,
                            top: 5,
                            child: IconButton(
                                onPressed: () {
                                  controllerFirma.clear();
                                },
                                icon: Icon(Icons.clear)))
                      ],
                    ),
                  ),
                ),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkeyIndicaciones.currentState!.validate()) {
                          dataPelu.saveSignature(
                              controllerFirma, context, dataPelu);
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
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
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosProximaVisita(PeluqueriaProvider dataPelu,
      double sizeScreenWidth, List<EncarPeluqueros> listaPeluqueros) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyProximaVisita,
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
                CalendarioFormulario(
                  focusedDay: today,
                  firstDay: DateTime.utc(2023, 02, 10),
                  lastDay: DateTime.utc(2030, 02, 10),
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                ),
                _separacionCampos(20),
                _NombreCampos('Hora de la cita'),
                _separacionCampos(15),
                InkWell(
                  onTap: () {
                    _openTimePicker(context, dataPelu);
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
                        dataPelu.horaSelected.isEmpty
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
                                dataPelu.horaSelected,
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
                    if (dataPelu.horaSelected == '') {
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
                    dataPelu.inicialEncargado.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 47, 26, 125),
                              child: Text(
                                dataPelu.inicialEncargado,
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
                                  itemCount: listaPeluqueros.length,
                                  itemBuilder: (context, index) {
                                    final peluquero = listaPeluqueros[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.only(left: 2),
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 47, 26, 125),
                                        child: Text(
                                          peluquero.nombres[0],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ), // Mostrar el ID a la izquierda
                                      title: Text('${peluquero.nombres}',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 29, 34, 44),
                                              fontSize: 16,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400)),
                                      subtitle: Text('${peluquero.apellidos}',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 139, 149, 166),
                                              fontSize: 12,
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w400)),
                                      onTap: () {
                                        guardarIdVetEncargado(
                                            context, peluquero, dataPelu);
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
                    if (dataPelu.idEncargadoSelected == '') {
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
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
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
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosFacturacion(PeluqueriaProvider dataPeluqueria,
      double sizeScreenWidth, List<EncarPeluqueros> listaPeluqueros) {
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
                DatosFacturacion<PeluqueriaProvider>(
                  providerGenerico: dataPeluqueria,
                  sizeScreenWidth: sizeScreenWidth,
                  radioButtons: const [
                    RadioButtonEfecTransacPeluqueria(
                      efecTransac: 'Efectivo',
                      valor: 'EFECTIVO',
                    ),
                    RadioButtonEfecTransacPeluqueria(
                      efecTransac: 'Transacción',
                      valor: 'TRANSACCION',
                    ),
                  ],
                  controllerCIoNit: controllerCIoNit,
                  controllerNombreFactura: controllerNombreFactura,
                  controllerApellidoFactura: controllerApellidoFactura,
                  controllerMontoEfectivo: controllerMontoEfectivo,
                  controllerCodeDescuento: controllerCodeDescuento,
                  tipoServicio: 'peluqueria',
                ),
                _separacionCampos(20),
                // Row(
                //   children: [
                //     _NombreCampos('Aplicando descuento'),
                //     Spacer(),
                //     _NombreCampos('${dataPeluqueria.totalACobrarFacturacion} Bs.'),
                //   ],
                // ),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (dataPeluqueria.totalACobrarFacturacion.isEmpty) {
                          dataPeluqueria.setTotalACobrarFacturacion =
                              controllerMontoEfectivo.text;
                        }
                        if (_formkeyFacturacion.currentState!.validate()) {
                          Utilidades.imprimir('Imprimir entro a pagar' +
                              dataPeluqueria.selectedSquarePeluqueria
                                  .toString());
                          dataPeluqueria.selectedSquarePeluqueria == 2
                              ? {
                                  dataPeluqueria
                                      .enviarDatosAntiguo(
                                          //paciente
                                          dataPeluqueria
                                              .selectedIdPacienteAntiguo,

                                          //servicios esteticos
                                          controllerPeinadosYExtras.text,
                                          dataPeluqueria.isCheckedCortePelo
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria
                                                  .isCheckedCortePeloMascDificil
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedBanoCompleto
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpOidos
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedPedicura
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpDental
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpGlandulas
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedElimPulgas
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedOtrosTrat
                                              ? 'si'
                                              : 'no',
                                          controllerTratamientoServEsteticos
                                              .text,

                                          //indicaciones
                                          controllerIndicacionEspecial.text,
                                          dataPeluqueria.horaEntregaSelected,
                                          dataPeluqueria
                                                  .isCheckedIndicacionesMascDificil
                                              ? 'si'
                                              : 'no',
                                          controllerMascDificilConsentimiento
                                              .text,
                                          dataPeluqueria.signatureImageFirma,

                                          // prox Visita,
                                          dataPeluqueria.fechaVisitaSelected ==
                                                  ''
                                              ? DateFormat("yyyy-MM-dd")
                                                  .format(today)
                                              : dataPeluqueria
                                                  .fechaVisitaSelected,
                                          dataPeluqueria.horaSelected,
                                          dataPeluqueria.idEncargadoSelected,

                                          //datos facturacion
                                          dataPeluqueria
                                              .selectedEfectivoTransac,
                                          controllerCIoNit.text,
                                          controllerNombreFactura.text,
                                          controllerApellidoFactura.text,
                                          dataPeluqueria.switchValueFacturacion,
                                          dataPeluqueria
                                              .totalACobrarFacturacion)
                                      .then((_) async {
                                    if (dataPeluqueria.OkpostDatosPeluqueria) {
                                      _mostrarFichaCreada(context);
                                    }
                                  })
                                }
                              : {
                                  dataPeluqueria
                                      .enviarDatos(
                                          //propietario
                                          controllerCiDueno.text,
                                          controllerNombre.text,
                                          controllerApellido.text,
                                          controllerNumero.text,
                                          controllerDireccion.text,
                                          //paciente
                                          controllerNombrePaciente.text,
                                          dataPeluqueria.selectedSexoPaciente,
                                          controllerEdadPaciente.text,
                                          dataPeluqueria.selectedTypeAge,
                                          dataPeluqueria.selectedIdEspecie!,
                                          dataPeluqueria.selectedIdRaza!,
                                          dataPeluqueria.dropTamanoMascota,
                                          dataPeluqueria.dropTemperamento,
                                          dataPeluqueria.dropAlimentacion,
                                          dataPeluqueria.lastImage,

                                          //servicios esteticos
                                          controllerPeinadosYExtras.text,
                                          dataPeluqueria.isCheckedCortePelo
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria
                                                  .isCheckedCortePeloMascDificil
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedBanoCompleto
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpOidos
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedPedicura
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpDental
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedLimpGlandulas
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedElimPulgas
                                              ? 'si'
                                              : 'no',
                                          dataPeluqueria.isCheckedOtrosTrat
                                              ? 'si'
                                              : 'no',
                                          controllerTratamientoServEsteticos
                                              .text,

                                          //indicaciones
                                          controllerIndicacionEspecial.text,
                                          dataPeluqueria.horaEntregaSelected,
                                          dataPeluqueria
                                                  .isCheckedIndicacionesMascDificil
                                              ? 'si'
                                              : 'no',
                                          controllerMascDificilConsentimiento
                                                  .text =
                                              'Yo ${controllerNombre.text} ${controllerApellido.text}, recibo información clara de los beneficios del proceso estetéticos que se llevaran a cabo en mi mascota como también los riesgos posibles que existen, como irritaciones y cortadas de la piel por exceso de pelo en malas condiciones, irritaciones de ojo por sensibilidad al shampoo, convulsión y ojos rojos por estrés, Conforme a la información que he leído y comprendo he podido preguntar y aclarar mis dudas, por eso he tomado consiente y literalmente la decisión de autorizar los procedimientos arriba señalados.',
                                          dataPeluqueria.signatureImageFirma,

                                          // prox Visita,
                                          dataPeluqueria
                                                      .fechaVisitaSelected ==
                                                  ''
                                              ? DateFormat("yyyy-MM-dd")
                                                  .format(today)
                                              : dataPeluqueria
                                                  .fechaVisitaSelected,
                                          dataPeluqueria.horaSelected,
                                          dataPeluqueria.idEncargadoSelected,

                                          //datos facturacion
                                          dataPeluqueria
                                              .selectedEfectivoTransac,
                                          controllerCIoNit.text,
                                          controllerNombreFactura.text,
                                          controllerApellidoFactura.text,
                                          dataPeluqueria.switchValueFacturacion,
                                          dataPeluqueria
                                              .totalACobrarFacturacion)
                                      .then((_) async {
                                    if (dataPeluqueria.OkpostDatosPeluqueria) {
                                      _mostrarFichaCreada(context);
                                    }
                                  })
                                };
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: dataPeluqueria.loadingDatosPeluqueria
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
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 0, 153),
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
                                  Provider.of<PeluqueriaProvider>(context,
                                          listen: false)
                                      .setSelectSquarePeluqueria(0);
                                  Provider.of<PeluqueriaProvider>(context,
                                          listen: false)
                                      .resetearDatos();
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
                                        Color.fromARGB(255, 99, 92, 255),
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
                    '¡Listo! Tu nuevo registro ha sido creado con éxito.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<PeluqueriaProvider>(context,
                              listen: false)
                            ..setOKsendDatosPeluqueria(false)
                            ..setSelectSquarePeluqueria(0);
                          // Cerrar el AlertDialog
                          Navigator.of(context).pop();
                          //cierra bottomSheet
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255),
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

  void guardarIdVetEncargado(BuildContext context,
      EncarPeluqueros encargadoPelu, PeluqueriaProvider dataPelu) {
    dataPelu
        .setIdEncargadoSelected(encargadoPelu.encargadoPeluqueroId.toString());
    dataPelu
        .setInicialEncargado(encargadoPelu.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    PeluqueriaProvider dataPelu =
        Provider.of<PeluqueriaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataPelu.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, PeluqueriaProvider dataPelu) {
    final timePicker = TimePickerHelper<PeluqueriaProvider>(
      context: context,
      provider: dataPelu,
      getHoraSelected: () => dataPelu.horaSelected,
      setHoraSelected: dataPelu.setHoraSelected,
    );
    timePicker.openTimePicker();
  }

  ///Obteniendo hora para INDICACIONES
  void _openTimePickerIndicaciones(
      BuildContext context, PeluqueriaProvider dataPelu) {
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
        dataPelu.setHoraEntregaSelected(formattedTime);

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

  Widget getFotoPaciente(PeluqueriaProvider dataPelu) {
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
            dataPelu.addPhoto();
          },
          child: Image.file(
            dataPelu.lastImage!,
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

void openModalBottomSheetOPeluqueriaUpdate(
    BuildContext context, PeluqueriaUpdateForm dataPelu) {
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
                child: FormularioPeluqueriaUpdate(dataPelu),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class FormularioPeluqueriaUpdate extends StatefulWidget {
  final PeluqueriaUpdateForm dataPelu;
  const FormularioPeluqueriaUpdate(this.dataPelu, {Key? key}) : super(key: key);
  @override
  _FormularioPeluqueriaUpdateState createState() =>
      _FormularioPeluqueriaUpdateState();
}

class _FormularioPeluqueriaUpdateState
    extends State<FormularioPeluqueriaUpdate> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoPeluqueria = GlobalKey<FormState>();

  //editing controller para datos del dueno
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerNumero = TextEditingController();
  TextEditingController controllerDireccion = TextEditingController();

  //editing controller para datos del paciente
  TextEditingController controllerNombrePaciente = TextEditingController();
  TextEditingController controllerEdadPaciente = TextEditingController();

  //editing para SERVICIOS ESTETICOS
  TextEditingController controllerPeinadosYExtras = TextEditingController();
  TextEditingController controllerTratamientoServEsteticos =
      TextEditingController();

  //controllers para INDICACIONES
  TextEditingController controllerIndicacionEspecial = TextEditingController();
  TextEditingController controllerMascDificilConsentimiento =
      TextEditingController();

  final SignatureController controllerFirma = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  //Editing controller para agendar proxima visita
  TextEditingController controllerCosto = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controllerNombre.text = widget.dataPelu.data.propietario.nombres;
        controllerApellido.text = widget.dataPelu.data.propietario.apellidos;
        controllerNumero.text = widget.dataPelu.data.propietario.celular;
        controllerDireccion.text = widget.dataPelu.data.propietario.direccion;

        controllerNombrePaciente.text = widget.dataPelu.data.paciente.nombre;
        PeluqueriaProvider dataPeluqueria =
            Provider.of<PeluqueriaProvider>(context, listen: false);
        dataPeluqueria.setSelectedGender(widget.dataPelu.data.paciente.sexo);
        controllerEdadPaciente.text = widget.dataPelu.data.paciente.edad;
        dataPeluqueria.setSelectedIdEspecie(
            widget.dataPelu.data.paciente.especieId.toString());
        dataPeluqueria
            .setSelectedIdRaza(widget.dataPelu.data.paciente.razaId.toString());
        dataPeluqueria
            .setDropTamanoMascota(widget.dataPelu.data.paciente.tamao);
        dataPeluqueria
            .setDropTemperamento(widget.dataPelu.data.paciente.temperamento);
        dataPeluqueria
            .setDropAlimentacion(widget.dataPelu.data.paciente.alimentacion);

        dataPeluqueria.setCheckCortePelo(
            widget.dataPelu.data.serviciosEsteticos.cortePelo == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckCortePeloMascDificil(
            widget.dataPelu.data.serviciosEsteticos.mascotaDificil == 'SI'
                ? true
                : false);
        controllerPeinadosYExtras.text =
            widget.dataPelu.data.serviciosEsteticos.pedidosEspeciales;

        dataPeluqueria.setCheckBanoCompleto(
            widget.dataPelu.data.serviciosEsteticos.baoCompleto == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckLimpOidos(
            widget.dataPelu.data.serviciosEsteticos.limpiezaOidos == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckPedicura(
            widget.dataPelu.data.serviciosEsteticos.pedicura == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckLimpDental(
            widget.dataPelu.data.serviciosEsteticos.limpiezaDental == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckLimpGlandulas(
            widget.dataPelu.data.serviciosEsteticos.limpiezaGlandulas == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckElimPulgas(
            widget.dataPelu.data.serviciosEsteticos.eliminacionPulgas == 'SI'
                ? true
                : false);
        dataPeluqueria.setCheckOtrosTrat(
            widget.dataPelu.data.serviciosEsteticos.tratamiento == 'SI'
                ? true
                : false);
        controllerTratamientoServEsteticos.text =
            widget.dataPelu.data.serviciosEsteticos.tratamiento;
        controllerIndicacionEspecial.text =
            widget.dataPelu.data.serviciosEsteticos.indicacionesEspeciales;
        dataPeluqueria.setCheckIndicacionesMascDificil(
            widget.dataPelu.data.serviciosEsteticos.mascotaDificil == 'SI'
                ? true
                : false);
        controllerMascDificilConsentimiento.text =
            widget.dataPelu.data.serviciosEsteticos.consentimiento;

        dataPeluqueria.setHoraEntregaSelected(
            widget.dataPelu.data.serviciosEsteticos.horaEntrega);
        dataPeluqueria.setHoraSelected(
            widget.dataPelu.data.serviciosEsteticos.horaProximaVisita);
        dataPeluqueria.setIdEncargadoSelected(
            widget.dataPelu.data.serviciosEsteticos.encargadoId.toString());

        dataPeluqueria.setHoraEntregaSelected(
            widget.dataPelu.data.serviciosEsteticos.horaEntrega);

        _onDaySelected(
            widget.dataPelu.data.serviciosEsteticos.fechaProximaVisita,
            widget.dataPelu.data.serviciosEsteticos.fechaProximaVisita);

        List<EncarPeluqueros> listaPeluqueros =
            dataPeluqueria.getEncargadosPelu;
        // dataPeluqueria.setInicialEncargado(listaPeluqueros
        //     .firstWhere((element) => element.encargadoPeluqueroId == widget.dataPelu.data.serviciosEsteticos.encargadoId)
        //     .nombres[0]
        //     .toUpperCase()
        //     .toString());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final numPages = Provider.of<PeluqueriaProvider>(context, listen: false)
                .selectedSquarePeluqueria ==
            2
        ? 4
        : 6;

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
    PeluqueriaProvider dataPeluqueria =
        Provider.of<PeluqueriaProvider>(context, listen: true);
    List<EncarPeluqueros> listaPeluquerosEncar =
        dataPeluqueria.getEncargadosPelu;
    double valueLinearProgress =
        dataPeluqueria.selectedSquarePeluqueria == 2 ? 4 : 5;

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
            'Actualizar ficha',
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
                      color: Color.fromARGB(255, 99, 92, 255),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  dataPeluqueria.selectedSquarePeluqueria == 2
                      ? ' de 4'
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
                    Color.fromARGB(255, 99, 92, 255)),
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
                children: dataPeluqueria.selectedSquarePeluqueria == 2
                    ? [
                        _datosServiciosEsteticos(
                            dataPeluqueria, sizeScreenWidth),
                        _datosIndicaciones(dataPeluqueria, sizeScreenWidth),
                        _datosProximaVisita(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar)
                      ]
                    : [
                        _datosDelDueno(dataPeluqueria, sizeScreenWidth),
                        _datosPaciente(dataPeluqueria),
                        _datosServiciosEsteticos(
                            dataPeluqueria, sizeScreenWidth),
                        _datosIndicaciones(dataPeluqueria, sizeScreenWidth),
                        _datosProximaVisita(dataPeluqueria, sizeScreenWidth,
                            listaPeluquerosEncar)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKeyDuenoPeluqueria,
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
                        if (_formKeyDuenoPeluqueria.currentState!.validate()) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 99, 92, 255),
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
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 68, 0, 153),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 0, 153),
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

  Widget _datosPaciente(PeluqueriaProvider dataPelu) {
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
                colores: Color.fromARGB(255, 140, 228, 233),
                controller: controllerNombrePaciente,
                hintText: 'Bigotes',
              ),
              _separacionCampos(15),
              _NombreCampos('Sexo'),
              _separacionCampos(15),
              RadioButtonReutilizableGeneroPeluqueria(
                gender: 'Macho intacto',
                valor: 'M',
              ),
              RadioButtonReutilizableGeneroPeluqueria(
                gender: 'Macho castrado',
                valor: 'MC',
              ),
              RadioButtonReutilizableGeneroPeluqueria(
                gender: 'Hembra intacta',
                valor: 'H',
              ),
              RadioButtonReutilizableGeneroPeluqueria(
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
                provider: dataPelu,
              ),
              _separacionCampos(15),
              _NombreCampos('Especie'),
              _separacionCampos(15),
              Consumer<PeluqueriaProvider>(builder: (context, provider, _) {
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
              Consumer<PeluqueriaProvider>(
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
                value: dataPelu.dropTamanoMascota,
                options: const ['G', 'M', 'P'],
                onChanged: (value) {
                  dataPelu.setDropTamanoMascota(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Temperamento'),
              _separacionCampos(15),
              CustomDropdownTemperament(
                value: dataPelu.dropTemperamento,
                options: const ['S', 'C', 'A', 'M'],
                onChanged: (value) {
                  dataPelu.setDropTemperamento(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              _NombreCampos('Alimentación'),
              _separacionCampos(15),
              CustomDropdownFood(
                value: dataPelu.dropAlimentacion,
                options: const ['C', 'M', 'B'],
                onChanged: (value) {
                  dataPelu.setDropAlimentacion(value!);
                },
                hintText: 'Seleccionar...',
              ),
              _separacionCampos(15),
              dataPelu.image != null
                  ? getFotoPaciente(dataPelu)
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
                              dataPelu.addPhoto();
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
                        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
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
                                color: Color.fromARGB(255, 68, 0, 153),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 0, 153),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosServiciosEsteticos(
      PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
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
                    'Servicios Estéticos',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 34, 44),
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              _separacionCampos(20),
              ReusableCheckboxCortePelo(
                desc: 'Corte de pelo',
                onChanged: (newValue) {
                  dataPelu.setCheckCortePelo(newValue!);
                },
                value: dataPelu.isCheckedCortePelo,
              ),
              dataPelu.isCheckedCortePelo
                  ? Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableCheckboxCortePelo(
                            desc: '¿La mascota es dificíl?',
                            onChanged: (newValue) {
                              dataPelu.setCheckCortePeloMascDificil(newValue!);
                            },
                            value: dataPelu.isCheckedCortePeloMascDificil,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: _NombreCampos(
                                  'Peinados especiales y extras')),
                          TextFormFieldMaxLinesConHint(
                            controller: controllerPeinadosYExtras,
                            hintText:
                                'Describa el tipo de peinado especial y extras que se requieran (E.j: Moños)',
                            maxLines: 6,
                            colores: Color.fromARGB(255, 177, 173, 255),
                          )
                        ],
                      ),
                    )
                  : Container(),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Baño completo',
                onChanged: (newValue) {
                  dataPelu.setCheckBanoCompleto(newValue!);
                },
                value: dataPelu.isCheckedBanoCompleto,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Limpieza de oídos',
                onChanged: (newValue) {
                  dataPelu.setCheckLimpOidos(newValue!);
                },
                value: dataPelu.isCheckedLimpOidos,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Pedicura',
                onChanged: (newValue) {
                  dataPelu.setCheckPedicura(newValue!);
                },
                value: dataPelu.isCheckedPedicura,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Limpieza dental',
                onChanged: (newValue) {
                  dataPelu.setCheckLimpDental(newValue!);
                },
                value: dataPelu.isCheckedLimpDental,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Limpieza de glándulas',
                onChanged: (newValue) {
                  dataPelu.setCheckLimpGlandulas(newValue!);
                },
                value: dataPelu.isCheckedLimpGlandulas,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Eliminación de pulgas',
                onChanged: (newValue) {
                  dataPelu.setCheckElimPulgas(newValue!);
                },
                value: dataPelu.isCheckedElimPulgas,
              ),
              _separacionCampos(2),
              ReusableCheckboxCortePelo(
                desc: 'Otros tratamientos',
                onChanged: (newValue) {
                  dataPelu.setCheckOtrosTrat(newValue!);
                },
                value: dataPelu.isCheckedOtrosTrat,
              ),
              _separacionCampos(5),
              dataPelu.isCheckedOtrosTrat
                  ? Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: _NombreCampos('Tratamiento ')),
                          TextFormFieldMaxLinesConHint(
                            controller: controllerTratamientoServEsteticos,
                            hintText:
                                'Indica que las pruebas requeridas (Ej. radiografía, ecografía, tomografía)',
                            maxLines: 6,
                            colores: Color.fromARGB(255, 177, 173, 255),
                          )
                        ],
                      ),
                    )
                  : Container(),
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
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 68, 0, 153),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 0, 153),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosIndicaciones(
      PeluqueriaProvider dataPelu, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
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
                    'Indicaciones',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 34, 44),
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              _separacionCampos(20),
              _NombreCampos('Indicaciones especiales'),
              TextFormFieldMaxLinesConHint(
                controller: controllerIndicacionEspecial,
                hintText:
                    'Describa aquí las lesiones del paciente (Ej: cojera, raspones, cortes, etc.)',
                maxLines: 6,
                colores: Color.fromARGB(255, 177, 173, 255),
              ),
              _separacionCampos(15),
              _NombreCampos('Hora de entrega'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePickerIndicaciones(context, dataPelu);
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
                      dataPelu.horaEntregaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1),
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataPelu.horaEntregaSelected,
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
              ReusableCheckboxCortePelo(
                desc: '¿La mascota es difícil?',
                onChanged: (newValue) {
                  dataPelu.setCheckIndicacionesMascDificil(newValue!);
                },
                value: dataPelu.isCheckedIndicacionesMascDificil,
              ),
              _separacionCampos(5),
              dataPelu.isCheckedIndicacionesMascDificil
                  ? Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: _NombreCampos('Consentimiento ')),
                          TextFormFieldMaxLinesConHintLlenadoAutomatico(
                            controller: controllerMascDificilConsentimiento,
                            hintText:
                                'Yo ${controllerNombre.text} ${controllerApellido.text}, recibo información clara de los beneficios del proceso estetéticos que se llevaran a cabo en mi mascota como también los riesgos posibles que existen, como irritaciones y cortadas de la piel por exceso de pelo en malas condiciones, irritaciones de ojo por sensibilidad al shampoo, convulsión y ojos rojos por estrés, Conforme a la información que he leído y comprendo he podido preguntar y aclarar mis dudas, por eso he tomado consiente y literalmente la decisión de autorizar los procedimientos arriba señalados.',
                            maxLines: 15,
                            colores: Color.fromARGB(255, 177, 173, 255),
                          )
                        ],
                      ),
                    )
                  : Container(),
              _separacionCampos(20),
              _NombreCampos('Firma electrónica'),
              _separacionCampos(15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                width: sizeScreenWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Signature(
                        controller: controllerFirma,
                        width: sizeScreenWidth,
                        height: 200,
                        backgroundColor: Color.fromARGB(255, 249, 249, 249),
                      ),
                      Positioned(
                          left: 5,
                          top: 5,
                          child: IconButton(
                              onPressed: () {
                                controllerFirma.clear();
                              },
                              icon: Icon(Icons.clear)))
                    ],
                  ),
                ),
              ),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      dataPelu.saveSignature(
                          controllerFirma, context, dataPelu);
                      _nextPage();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
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
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 68, 0, 153),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 0, 153),
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ]),
      ),
    );
  }

  Widget _datosProximaVisita(PeluqueriaProvider dataPelu,
      double sizeScreenWidth, List<EncarPeluqueros> listaPeluqueros) {
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
                lastDay: DateTime.utc(2030, 02, 10),
                // Resto de las propiedades y personalización del TableCalendar
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Colors.transparent,
                        /*  shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2)
                        ) , */
                        //borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            color: const Color.fromARGB(255, 136, 64, 255),
                            width: 2)),
                    selectedTextStyle: TextStyle(
                        color: const Color.fromARGB(255, 136, 64, 255))),
              ),
              _separacionCampos(20),
              _NombreCampos('Hora de la cita'),
              _separacionCampos(15),
              InkWell(
                onTap: () {
                  _openTimePicker(context, dataPelu);
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
                      dataPelu.horaSelected.isEmpty
                          ? Text(
                              'Seleccionar hora',
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 149, 166, 1),
                                  fontSize: 14,
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              dataPelu.horaSelected,
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
                  dataPelu.inicialEncargado.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 47, 26, 125),
                            child: Text(
                              dataPelu.inicialEncargado,
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
                                itemCount: listaPeluqueros.length,
                                itemBuilder: (context, index) {
                                  final peluquero = listaPeluqueros[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 2),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 47, 26, 125),
                                      child: Text(
                                        peluquero.nombres[0],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ), // Mostrar el ID a la izquierda
                                    title: Text('${peluquero.nombres}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 29, 34, 44),
                                            fontSize: 16,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    subtitle: Text('${peluquero.apellidos}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 139, 149, 166),
                                            fontSize: 12,
                                            fontFamily: 'inter',
                                            fontWeight: FontWeight.w400)),
                                    onTap: () {
                                      guardarIdVetEncargado(
                                          context, peluquero, dataPelu);
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
              // const Row(
              //   children: [
              //     Icon(
              //       IconlyLight.more_square,
              //       color: Color.fromARGB(255, 29, 34, 44),
              //       size: 30,
              //     ),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Text(
              //       'Método de pago',
              //       style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 72, 86, 109), fontFamily: 'sans', fontWeight: FontWeight.w700),
              //     ),
              //   ],
              // ),
              // _separacionCampos(20),
              // _NombreCampos('Costo'),
              // _separacionCampos(15),
              // Row(
              //   children: [
              //     Container(
              //       height: 60,
              //       width: sizeScreenWidth * 0.3,
              //       padding: EdgeInsets.all(8),
              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 249, 249, 249)),
              //       child: Row(
              //         children: [
              //           Image(
              //             image: AssetImage(
              //               'assets/img/bolivia.png',
              //             ),
              //             width: 35,
              //           ),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Text(
              //             'BOL',
              //             style: TextStyle(fontFamily: 'inter', fontSize: 14, color: const Color.fromARGB(255, 139, 149, 166)),
              //           ),
              //           Icon(Icons.keyboard_arrow_down_outlined, color: const Color.fromARGB(255, 139, 149, 166))
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Expanded(
              //       child: Container(child: TextFormFieldConHint(colores: Color.fromARGB(255, 140, 228, 233), hintText: 'Bs. 0.00')),
              //     )
              //   ],
              // ),
              // RadioButtonEfecTransacOProcedimi(
              //   efecTransac: 'Efectivo',
              //   valor: 'EFECTIVO',
              // ),
              // RadioButtonEfecTransacOProcedimi(
              //   efecTransac: 'Transacción',
              //   valor: 'TRANSACCION',
              // ),
              // _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      dataPelu
                          .actualizarDatos(
                              //propietario
                              controllerNombre.text,
                              controllerApellido.text,
                              controllerNumero.text,
                              controllerDireccion.text,
                              //paciente
                              controllerNombrePaciente.text,
                              dataPelu.selectedSexoPaciente,
                              controllerEdadPaciente.text,
                              dataPelu.selectedIdEspecie!,
                              dataPelu.selectedIdRaza!,
                              dataPelu.dropTamanoMascota,
                              dataPelu.dropTemperamento,
                              dataPelu.dropAlimentacion,
                              dataPelu.lastImage!,

                              //servicios esteticos
                              controllerPeinadosYExtras.text,
                              dataPelu.isCheckedCortePelo ? 'si' : 'no',
                              dataPelu.isCheckedCortePeloMascDificil
                                  ? 'si'
                                  : 'no',
                              dataPelu.isCheckedBanoCompleto ? 'si' : 'no',
                              dataPelu.isCheckedLimpOidos ? 'si' : 'no',
                              dataPelu.isCheckedPedicura ? 'si' : 'no',
                              dataPelu.isCheckedLimpDental ? 'si' : 'no',
                              dataPelu.isCheckedLimpGlandulas ? 'si' : 'no',
                              dataPelu.isCheckedElimPulgas ? 'si' : 'no',
                              dataPelu.isCheckedOtrosTrat ? 'si' : 'no',
                              controllerTratamientoServEsteticos.text,

                              //indicaciones
                              controllerIndicacionEspecial.text,
                              dataPelu.horaEntregaSelected,
                              dataPelu.isCheckedIndicacionesMascDificil
                                  ? 'si'
                                  : 'no',
                              controllerMascDificilConsentimiento.text =
                                  'Yo ${controllerNombre.text} ${controllerApellido.text}, recibo información clara de los beneficios del proceso estetéticos que se llevaran a cabo en mi mascota como también los riesgos posibles que existen, como irritaciones y cortadas de la piel por exceso de pelo en malas condiciones, irritaciones de ojo por sensibilidad al shampoo, convulsión y ojos rojos por estrés, Conforme a la información que he leído y comprendo he podido preguntar y aclarar mis dudas, por eso he tomado consiente y literalmente la decisión de autorizar los procedimientos arriba señalados.',
                              dataPelu.signatureImageFirma,

                              // prox Visita,

                              dataPelu.fechaVisitaSelected,
                              dataPelu.horaSelected,
                              dataPelu.idEncargadoSelected)
                          .then((_) async {
                        if (dataPelu.OkpostDatosPeluqueria) {
                          _mostrarFichaCreada(context);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 99, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: dataPelu.loadingDatosPeluqueria
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
                                color: Color.fromARGB(255, 68, 0, 153),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 68, 0, 153),
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
                                  Provider.of<PeluqueriaProvider>(context,
                                          listen: false)
                                      .setSelectSquarePeluqueria(0);
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
                                        Color.fromARGB(255, 99, 92, 255),
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
                    '¡Listo! Tu registro ha sido actualizado con éxito.',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 72, 86, 109),
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<PeluqueriaProvider>(context,
                              listen: false)
                            ..setOKsendDatosPeluqueria(false)
                            ..setSelectSquarePeluqueria(0);
                          // Cerrar el AlertDialog
                          Navigator.of(context).pop();
                          //cierra bottomSheet
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 99, 92, 255),
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

  void guardarIdVetEncargado(BuildContext context,
      EncarPeluqueros encargadoPelu, PeluqueriaProvider dataPelu) {
    dataPelu
        .setIdEncargadoSelected(encargadoPelu.encargadoPeluqueroId.toString());
    dataPelu
        .setInicialEncargado(encargadoPelu.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    PeluqueriaProvider dataPelu =
        Provider.of<PeluqueriaProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataPelu.setFechaVisitaSelected(formattedDateEnviar);
    });
  }

  ///Obteniendo hora
  void _openTimePicker(BuildContext context, PeluqueriaProvider dataPelu) {
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
        dataPelu.setHoraSelected(formattedTime);

        //print(index);
      },
      onClose: () {
        print('Picker closed');
      },
      //bottomPickerTheme: BottomPickerTheme.orange,
      use24hFormat: false,
    ).show(context);
  }

  ///Obteniendo hora para INDICACIONES
  void _openTimePickerIndicaciones(
      BuildContext context, PeluqueriaProvider dataPelu) {
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
        dataPelu.setHoraEntregaSelected(formattedTime);

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

  Widget getFotoPaciente(PeluqueriaProvider dataPelu) {
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
            dataPelu.addPhoto();
          },
          child: Image.file(
            dataPelu.lastImage!,
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
