import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/common/formularios/formularios_widget.dart';
import 'package:vet_sotf_app/models/clinica/buscarPacientes_model.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/widget/date_and_time.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/widget/files_analisis_estudios.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/hospitalizacion/widget/text_form_field.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/widgetFacturacion.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/FormularioWidgetsConsulta.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/hospitalizacion/radiobuttonHospitalizacion_widget.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../widgets/dropDown_widget.dart';
import '../../../widgets/textFormFieldsTypes_widget.dart';
import '../programarCita/programarCita_screen.dart';

class ButtonNuevoRegistroHospitalizacion extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonNuevoRegistroHospitalizacion(
      {super.key, required this.listaPacientesBusq});

  final TextEditingController controllerBusquedaHospitalizacion =
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
                  var hospitalizacionProvider =
                      Provider.of<HospitalizacionProvider>(context,
                          listen: false);
                  hospitalizacionProvider.setSelectSquareHospitalizacion(0);
                  hospitalizacionProvider.resetearDatosForm();
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
                Text('¿El paciente es nuevo o antiguo?',
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
                            Provider.of<HospitalizacionProvider>(context,
                                    listen: false)
                                .setSelectSquareHospitalizacion(1);
                            Provider.of<HospitalizacionProvider>(context,
                                    listen: false)
                                .setFichaId(null);
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<HospitalizacionProvider>(
                                                context)
                                            .selectedSquareHospitalizacion ==
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
                                    color: Provider.of<HospitalizacionProvider>(
                                                    context)
                                                .selectedSquareHospitalizacion ==
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
                                        color: Provider.of<HospitalizacionProvider>(
                                                        context)
                                                    .selectedSquareHospitalizacion ==
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
                            Provider.of<HospitalizacionProvider>(context,
                                listen: false)
                              ..setSelectSquareHospitalizacion(2)
                              ..setSelectedIndexPaciente(-1)
                              ..clearBusquedas();
                          },
                          child: Container(
                            height: sizeScreen.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Provider.of<HospitalizacionProvider>(
                                                context)
                                            .selectedSquareHospitalizacion ==
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
                                    color: Provider.of<HospitalizacionProvider>(
                                                    context)
                                                .selectedSquareHospitalizacion ==
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
                                        color: Provider.of<HospitalizacionProvider>(
                                                        context)
                                                    .selectedSquareHospitalizacion ==
                                                2
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
                            Provider.of<HospitalizacionProvider>(context,
                                    listen: false)
                                .setSelectSquareHospitalizacion(0);
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
                          if (Provider.of<HospitalizacionProvider>(context,
                                      listen: false)
                                  .selectedSquareHospitalizacion ==
                              1) {
                            Navigator.of(context).pop();
                            _openModalBottomSheetHospitalizacion(context);
                          } else if (Provider.of<HospitalizacionProvider>(
                                      context,
                                      listen: false)
                                  .selectedSquareHospitalizacion ==
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
    final hospitalizacionProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
    hospitalizacionProvider.filtrarLista(listaPacientesBusq, "");
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
                    final listaFiltradaProvider =
                        Provider.of<HospitalizacionProvider>(context,
                            listen: false);
                    listaFiltradaProvider.filtrarLista(
                        listaPacientesBusq, query);
                  },
                  controller: controllerBusquedaHospitalizacion,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controllerBusquedaHospitalizacion.clear();
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
                    child: Consumer<HospitalizacionProvider>(
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
                            hospitalizacionProvider
                              ..setSelectSquareHospitalizacion(0)
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
                            if (hospitalizacionProvider.selectedIndexPaciente !=
                                -1) {
                              hospitalizacionProvider
                                  .setSelectedIdPacienteAntiguo(
                                      pacienteSeleccionado.toString());
                              print(' aqui esta el id del paciente anitugo' +
                                  hospitalizacionProvider
                                      .selectedIdPacienteAntiguo);
                              Navigator.of(context).pop();
                              _openModalBottomSheetHospitalizacion(context);
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

void _openModalBottomSheetHospitalizacion(BuildContext context) {
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
                child: FormularioHospitalizacion(
                  clinicaUpdate: null,
                ),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

void openModalBottomSheetProgramarCita(BuildContext context) {
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
                child: FormularioProgramarCita(),
              ),
            ]),
          ),
        ),
      );
    },
  );
}

class ButtonPacientesHospitalizacion extends StatelessWidget {
  final List<ResultBusPacientes> listaPacientesBusq;

  ButtonPacientesHospitalizacion({super.key, required this.listaPacientesBusq});

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
    final hospitalizacionProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
    hospitalizacionProvider.filtrarLista(listaPacientesBusq, "");
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
                    hospitalizacionProvider.filtrarLista(
                        listaPacientesBusq, query);
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
                    child: Consumer<HospitalizacionProvider>(
                        builder: (context, hospitalizacionProviderC, _) {
                      final listaFiltrada =
                          hospitalizacionProviderC.listaFiltrada;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaFiltrada.length,
                        itemBuilder: (context, index) {
                          final busqPaciente = listaFiltrada[index];
                          bool isSelected = index ==
                              hospitalizacionProviderC.selectedIndexPaciente;

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
                                hospitalizacionProviderC
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
                            hospitalizacionProvider
                              ..setSelectSquareHospitalizacion(0)
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
                            if (hospitalizacionProvider.selectedIndexPaciente !=
                                -1) {
                              hospitalizacionProvider
                                ..setSelectedIdPacienteAntiguo(
                                    pacienteSeleccionado.toString())
                                ..setSelectSquareHospitalizacion(2)
                                ..clearBusquedas();
                              Navigator.of(context).pop();
                              _openModalBottomSheetHospitalizacion(context);
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

class FormularioHospitalizacion extends StatefulWidget {
  final ClinicaUpdateModel? clinicaUpdate;
  final bool? habilitarEdicion;
  const FormularioHospitalizacion(
      {Key? key, required this.clinicaUpdate, this.habilitarEdicion})
      : super(key: key);
  @override
  _FormularioHospitalizacionState createState() =>
      _FormularioHospitalizacionState();
}

class _FormularioHospitalizacionState extends State<FormularioHospitalizacion> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  //formnKey para datos del dueno
  final _formKeyDuenoHospitalizacion = GlobalKey<FormState>();
  final _formkeyDatosPaciente = GlobalKey<FormState>();
  final _formkeyDatosClinicos = GlobalKey<FormState>();
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

  //editing controller para datos clinicos
  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerTemperatura = TextEditingController();
  TextEditingController controllerFrecuenciaCar = TextEditingController();
  TextEditingController controllerFrecuenciaRes = TextEditingController();
  TextEditingController controllerLesiones = TextEditingController();
  TextEditingController controllerDesdeCuandoTieneMascota =
      TextEditingController();
  TextEditingController controllerDondeAdquirioMascota =
      TextEditingController();
  TextEditingController controllerEnfermedadesPadece = TextEditingController();
  TextEditingController controllerExpuestoEnfermedades =
      TextEditingController();
  TextEditingController controllerReaccionAlergica = TextEditingController();

  //editing controller para datos de diagnostico
  TextEditingController controllerListaProblemas = TextEditingController();
  TextEditingController controllerDiagnostico = TextEditingController();
  TextEditingController controllerDiagnosticoDiferencial =
      TextEditingController();

  //editing controller para datos de peticion de muestras y pruebas
  TextEditingController controllerMuestrasRequeridas = TextEditingController();
  TextEditingController controllerPruebasRequeridas = TextEditingController();

  //Editing controller para tratamiento
  TextEditingController controllerRecomendaciones = TextEditingController();
  TextEditingController controllerAlimentacion = TextEditingController();

  //Editing controller para agendar proxima visita
  final SignatureController controllerFirma = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);
  TextEditingController controllerIntervalorHospitalizacion =
      TextEditingController();

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
        Provider.of<HospitalizacionProvider>(context, listen: false)
                    .selectedSquareHospitalizacion ==
                2
            ? 6
            : 8;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var clinicaUpdate = widget.clinicaUpdate;
        var data = clinicaUpdate?.data;

        if (data != null) {
          // Datos del dueño
          controllerCiDueno.text = data.propietario.ci.toString();
          controllerNombre.text = data.propietario.nombres;
          controllerApellido.text = data.propietario.apellidos;
          controllerNumero.text = data.propietario.celular;
          controllerDireccion.text = data.propietario.direccion;
          // Datos del paciente
          controllerNombrePaciente.text = data.paciente.nombre;
          controllerEdadPaciente.text = data.paciente.edad.toString();

          // Datos clínicos
          controllerPeso.text = data.datosClinicos!.peso.toString();
          controllerTemperatura.text =
              data.datosClinicos!.temperatura.toString();
          controllerFrecuenciaCar.text =
              data.datosClinicos!.frecuenciaCardiaca.toString();
          controllerFrecuenciaRes.text =
              data.datosClinicos!.frecuenciaRespiratoria.toString();
          controllerLesiones.text = data.datosClinicos!.lesiones;
          controllerDesdeCuandoTieneMascota.text =
              data.datosClinicos!.tiempoTenencia;
          controllerDondeAdquirioMascota.text =
              data.datosClinicos!.origenMascota;
          controllerEnfermedadesPadece.text =
              data.datosClinicos!.enfermedadesPadecidas;
          controllerExpuestoEnfermedades.text =
              data.datosClinicos!.enfermedadesRecientes;
          controllerReaccionAlergica.text =
              data.datosClinicos!.reaccionAlergica;

          // Datos de diagnóstico
          controllerListaProblemas.text = data.diagnostico!.listaProblemas;
          controllerDiagnostico.text = data.diagnostico!.diagnostico;
          controllerDiagnosticoDiferencial.text =
              data.diagnostico!.diagnosticoDiferencial;

          // Datos de petición de muestras y pruebas
          controllerMuestrasRequeridas.text =
              data.peticionesMuestras!.muestrasRequeridas;
          controllerPruebasRequeridas.text =
              data.peticionesMuestras!.pruebasRequeridas;

          HospitalizacionProvider dataHospitalizacion =
              Provider.of<HospitalizacionProvider>(context, listen: false);
          dataHospitalizacion.setSelectedGender(data.paciente.sexo);
          controllerEdadPaciente.text = data.paciente.edad.toString();
          dataHospitalizacion
              .setSelectedIdEspecie(data.paciente.especieId.toString());
          dataHospitalizacion
              .setSelectedIdRaza(data.paciente.razaId.toString());
          dataHospitalizacion.setDropTamanoMascota(data.paciente.tamao);
          dataHospitalizacion.setDropTemperamento(data.paciente.temperamento);
          dataHospitalizacion.setDropAlimentacion(data.paciente.alimentacion);

          dataHospitalizacion.setIdEncargadoSelected(
              data.proximaVisita.encargadoId.toString());

          // Configurar la fecha y la hora de inicio de la hospitalización
          if (data.hospitalizacion != null) {
            DateTime inicio = data.hospitalizacion!.inicio;
            String fechaInicio =
                "${inicio.year}-${inicio.month.toString().padLeft(2, '0')}-${inicio.day.toString().padLeft(2, '0')}";
            String horaInicio =
                "${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}";
            dataHospitalizacion.setFechaInicioSlected(fechaInicio);
            dataHospitalizacion.setHoraInicioSelected(horaInicio);

            DateTime fin = data.hospitalizacion!.fin;
            String fechaFin =
                "${fin.year}-${inicio.month.toString().padLeft(2, '0')}-${fin.day.toString().padLeft(2, '0')}";
            String horaFin =
                "${fin.hour.toString().padLeft(2, '0')}:${fin.minute.toString().padLeft(2, '0')}";
            dataHospitalizacion.setFechaFinSlected(fechaFin);
            dataHospitalizacion.setHoraFinSelected(horaFin);
          }
          dataHospitalizacion.setselectedInterval(
              data.hospitalizacion!.intervalo.toString().toLowerCase());
          controllerIntervalorHospitalizacion.text =
              data.hospitalizacion!.intervalo.toString();
          controllerAlimentacion.text = data.hospitalizacion!.alimentacion;
          dataHospitalizacion.setDropMucosas(data.datosClinicos!.mucosas);
          dataHospitalizacion
              .setDropHidratacion(data.datosClinicos!.hidratacion);
          dataHospitalizacion
              .setDropGanglios(data.datosClinicos!.gangliosLinfaticos);
          dataHospitalizacion
              .setSelectedExisteAnimal(data.datosClinicos!.otroAnimal);
          dataHospitalizacion.setSelectedAplicadoTratamiento(
              data.datosClinicos!.enferemedadTratamiento);
          dataHospitalizacion.setSelectedVacunasAlDia(
              data.datosClinicos!.enferemedadTratamiento);

          // // Datos de tratamiento
          // data.tratamientos!.forEach((element) {
          //   dataHospitalizacion.setControllersTratamiento(element.descripcion);
          // });
          //
          // if (data.archivo != null) {
          //   for (var archivo in data.archivo!) {
          //     if (archivo.fotoPaciente != null) {
          //       dataHospitalizacion.getFromUrl(archivo.fotoPaciente!);
          //     }
          //   }
          // }

          // _onDaySelected(data.proximaVisita.fecha, data.proximaVisita.fecha);
          // dataHospitalizacion.setHoraInicioSelected(data.proximaVisita.hora);
          //List<EncargadosVete> listaVeterinarios = dataConsulta.getEncargados;
          // dataConsulta.setInicialEncargado(listaVeterinarios
          //     .firstWhere((element) => element.encargadoVeteId == widget.clinicaUpdate.data.proximaVisita.encargadoId)
          //     .nombres[0]
          //     .toUpperCase()
          //     .toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreenWidth = MediaQuery.of(context).size.width;
    HospitalizacionProvider dataHospitalizacion =
        Provider.of<HospitalizacionProvider>(context, listen: true);
    List<EncargadosVete> listaVeterinarios = dataHospitalizacion.getEncargados;
    double valueLinearProgress =
        dataHospitalizacion.selectedSquareHospitalizacion == 2 ? 6 : 8;

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
                  dataHospitalizacion.selectedSquareHospitalizacion == 2
                      ? ' de 6'
                      : ' de 8',
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
                children: dataHospitalizacion.selectedSquareHospitalizacion == 2
                    ? [
                        _datosClinicos(dataHospitalizacion, sizeScreenWidth),
                        _datosDiagnostico(dataHospitalizacion),
                        _datosPeticionPruebasMuestras(
                            dataHospitalizacion, sizeScreenWidth),
                        _datosTratamiento(dataHospitalizacion, sizeScreenWidth),
                        _datosProximaVisita(dataHospitalizacion,
                            sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(dataHospitalizacion, sizeScreenWidth,
                            listaVeterinarios)
                      ]
                    : [
                        _datosDelDueno(dataHospitalizacion, sizeScreenWidth),
                        _datosPaciente(dataHospitalizacion, sizeScreenWidth),
                        _datosClinicos(dataHospitalizacion, sizeScreenWidth),
                        _datosDiagnostico(dataHospitalizacion),
                        _datosPeticionPruebasMuestras(
                            dataHospitalizacion, sizeScreenWidth),
                        _datosTratamiento(dataHospitalizacion, sizeScreenWidth),
                        _datosProximaVisita(dataHospitalizacion,
                            sizeScreenWidth, listaVeterinarios),
                        _datosFacturacion(dataHospitalizacion, sizeScreenWidth,
                            listaVeterinarios)
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datosDelDueno(
      HospitalizacionProvider dataHospitalizacion, double sizeScreenWidth) {
    return datosDelDueno(
        formKey: _formKeyDuenoHospitalizacion,
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
      HospitalizacionProvider dataHospitalizacion, double sizeScreenWidth) {
    return datosPaciente(
        sizeScreenWidth: sizeScreenWidth,
        formKey: _formkeyDatosPaciente,
        controllerNombrePaciente: controllerNombrePaciente,
        radioButtonsGenero: [
          const RadioButtonReutilizableGeneroHospitalizacion(
            gender: 'Macho intacto',
            valor: 'M',
          ),
          const RadioButtonReutilizableGeneroHospitalizacion(
            gender: 'Macho castrado',
            valor: 'MC',
          ),
          const RadioButtonReutilizableGeneroHospitalizacion(
            gender: 'Hembra intacta',
            valor: 'H',
          ),
          const RadioButtonReutilizableGeneroHospitalizacion(
            gender: 'Hembra esterilizada',
            valor: 'HC',
          ),
        ],
        generoProvider: dataHospitalizacion.selectedSexoPaciente,
        edadWidget: TextFormFieldNumberEdad(
          colores: const Color.fromARGB(255, 140, 228, 233),
          hintText: 'Edad',
          controller: controllerEdadPaciente,
          provider: dataHospitalizacion,
        ),
        especieWidget:
            Consumer<HospitalizacionProvider>(builder: (context, provider, _) {
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
        razaWidget: Consumer<HospitalizacionProvider>(
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
          value: dataHospitalizacion.dropTamanoMascota,
          options: const ['G', 'M', 'P'],
          onChanged: (value) {
            dataHospitalizacion.setDropTamanoMascota(value!);
          },
          hintText: 'Seleccionar...',
        ),
        temperamentoWidget: CustomDropdownTemperament(
          value: dataHospitalizacion.dropTemperamento,
          options: const ['S', 'C', 'A', 'M'],
          onChanged: (value) {
            dataHospitalizacion.setDropTemperamento(value!);
          },
          hintText: 'Seleccionar...',
        ),
        alimentacionWidget: CustomDropdownFood(
          value: dataHospitalizacion.dropAlimentacion,
          options: const ['C', 'M', 'B'],
          onChanged: (value) {
            dataHospitalizacion.setDropAlimentacion(value!);
          },
          hintText: 'Seleccionar...',
        ),
        imagenWidget: dataHospitalizacion.image != null
            ? getFotoPaciente(dataHospitalizacion)
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
                        dataHospitalizacion.addPhoto();
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

  Widget _datosClinicos(
      HospitalizacionProvider dataHospitalizacion, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyDatosClinicos,
          child: Column(
              //DATOS CLINICOS
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tituloForm('Datos clínicos'),
                _separacionCampos(
                  20,
                ),
                _separacionCampos(15),
                _NombreCampos('Mucosas'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataHospitalizacion.dropMucosas,
                  options: const [
                    'NORMALES',
                    'ANEMICOS',
                    'CIANOTICAS',
                    'ICTERIAS'
                  ],
                  onChanged: (value) {
                    dataHospitalizacion.setDropMucosas(value!);
                  },
                  validar: false,
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Peso'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerPeso,
                    hintText: 'Peso (Ej: 10,7)'),
                _separacionCampos(15),
                _NombreCampos('Temperatura'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerTemperatura,
                    hintText: 'Temperatura del paciente (Ej: ºC 37)'),
                _separacionCampos(15),
                _NombreCampos('Frecuencia cardíaca'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerFrecuenciaCar,
                    hintText: 'Frecuencia cardíaca del paciente'),
                _separacionCampos(15),
                _NombreCampos('Frecuencia respiratoria'),
                _separacionCampos(15),
                TextFormFieldNumberConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerFrecuenciaRes,
                    hintText: 'Frecuencia respiratoria del paciente'),
                _separacionCampos(15),
                _NombreCampos('Nivel de hidratación'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataHospitalizacion.dropHidratacion,
                  options: const ['HIDRATADO', 'SEMIHIDRATO', 'DESHIDRATADO'],
                  onChanged: (value) {
                    dataHospitalizacion.setDropHidratacion(value.toString());
                  },
                  validar: false,
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Ganglios linfáticos'),
                _separacionCampos(15),
                CustomDropdown(
                  value: dataHospitalizacion.dropGanglios,
                  options: const ['NORMALES', 'INFLAMADOS'],
                  onChanged: (value) {
                    dataHospitalizacion.setDropGanglios(value!);
                  },
                  validar: false,
                  hintText: 'Seleccionar...',
                ),
                _separacionCampos(15),
                _NombreCampos('Lesiones'),
                _separacionCampos(15),
                Container(
                  width: double.infinity,
                  child: TextFormFieldMaxLinesConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerLesiones,
                    hintText:
                        'Describa aquí las lesiones (Ej: Cojera, raspones, cortes, etc.)',
                    maxLines: 5,
                  ),
                ),
                _separacionCampos(20),
                _NombreCampos('¿Desde cuando tiene a la mascota?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDesdeCuandoTieneMascota,
                    hintText: 'Ej. 2 años'),
                _separacionCampos(10),
                Row(
                  children: [
                    Expanded(
                      child: _NombreCampos('¿Existe algun animal en casa?'),
                    ),
                    Container(
                      width: 70,
                      child:
                          const RadioButtonReutiExisteAlgunAnimalHospitalizacion(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child:
                          const RadioButtonReutiExisteAlgunAnimalHospitalizacion(
                        siOno: 'No',
                        valor: 'NO',
                      ),
                    ),
                  ],
                ),
                MensajeValidadorSelecciones(
                  validator: (_) =>
                      dataHospitalizacion.selectedExisteAnimalEnCasa == ''
                          ? 'Por favor, seleccione una opción.'
                          : null,
                ),
                _separacionCampos(20),
                _NombreCampos('¿En donde adquirió la mascota?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerDondeAdquirioMascota,
                    hintText: 'Ej. Refugio de animales'),
                _separacionCampos(20),
                _NombreCampos('¿Qué enfermedades ha padecido?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerEnfermedadesPadece,
                    hintText: 'Ej. Moquillo'),
                _separacionCampos(20),
                _NombreCampos(
                    '¿Ha estado expuesto recientemente a enfermedades infectocontagiosas?'),
                _separacionCampos(15),
                TextFormFieldConHint(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerExpuestoEnfermedades,
                    hintText: '¿Cual?'),
                _separacionCampos(20),
                Row(
                  children: [
                    Expanded(
                      child: _NombreCampos(
                          '¿Se le ha aplicado algún tratamiento para la enfermedad actual?'),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiAplicadoTratamientoHospitalizacion(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child: RadioButtonReutiAplicadoTratamientoHospitalizacion(
                        siOno: 'No',
                        valor: 'NO',
                      ),
                    ),
                  ],
                ),
                _separacionCampos(20),
                Row(
                  children: [
                    Expanded(
                      child: _NombreCampos('¿Tiene las vacunas al día?'),
                    ),
                    Container(
                      width: 70,
                      child: const RadioButtonReutiVacunasAlDiaHospitalizacion(
                        siOno: 'Si',
                        valor: 'SI',
                      ),
                    ),
                    Container(
                      width: 70,
                      child: const RadioButtonReutiVacunasAlDiaHospitalizacion(
                        siOno: 'No',
                        valor: 'NO',
                      ),
                    ),
                  ],
                ),
                MensajeValidadorSelecciones(
                  validator: (_) =>
                      dataHospitalizacion.selectedVacunasAlDia == ''
                          ? 'Por favor, seleccione una opción.'
                          : null,
                ),
                _separacionCampos(20),
                _NombreCampos(
                    '¿Alguna reacción alérgica a medicamento o vacuna?'),
                _separacionCampos(15),
                TextFormFieldConHintValidator(
                    colores: const Color.fromARGB(255, 140, 228, 233),
                    controller: controllerReaccionAlergica,
                    hintText: 'Ej: Vacuna antirrabica'),
                _separacionCampos(20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkeyDatosClinicos.currentState!.validate()) {
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

  Widget _datosDiagnostico(HospitalizacionProvider dataHospitalizacion) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            //DATOS CLINICOS

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloForm('Diagnóstico'),
              _separacionCampos(20),
              _NombreCampos('Lista de problemas'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerListaProblemas,
                  hintText:
                      'Describa los síntomas o problemas de salud actuales de su mascota (Ejemplo. dolor en las articulaciones, tos persistente, pérdida de apetito)',
                  maxLines: 6),
              _separacionCampos(20),
              _NombreCampos('Diagnóstico'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerDiagnostico,
                  hintText:
                      'Escriba aqui el diagnostico definitivo del paciente',
                  maxLines: 5),
              _separacionCampos(20),
              _NombreCampos('Diagnóstico diferencial'),
              _separacionCampos(15),
              TextFormFieldMaxLinesConHint(
                  colores: const Color.fromARGB(255, 140, 228, 233),
                  controller: controllerDiagnosticoDiferencial,
                  hintText:
                      'Escriba aquí el diagnóstico diferencial por cada problema',
                  maxLines: 5),
              _separacionCampos(20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _nextPage();
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
    );
  }

  Widget _datosPeticionPruebasMuestras(
      HospitalizacionProvider dataHospitalizacion, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _tituloForm('Petición de muestras y pruebas'),
          _separacionCampos(20),
          _NombreCampos('Muestras requeridas'),
          _separacionCampos(15),
          TextFormFieldMaxLinesConHint(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerMuestrasRequeridas,
              hintText:
                  'Indica aqui las muestras requeridas (Ej: Analisis de sangre, examen de orina)',
              maxLines: 7),
          _separacionCampos(20),
          _NombreCampos('Pruebas requeridas'),
          _separacionCampos(15),
          TextFormFieldMaxLinesConHint(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerPruebasRequeridas,
              hintText:
                  'Indica aqui las pruebas requeridas (Ej: radiografía, ecografía, tomografía)',
              maxLines: 7),
          _separacionCampos(20),
          _tituloForm('Añadir análisis y estudios'),
          _separacionCampos(20),
          _NombreCampos('Hemograma'),
          _separacionCampos(15),
          dataHospitalizacion.fileHemograma.isEmpty
              ? addFileHemogramaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosHemograma(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileHemograma(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Química sanguínea'),
          _separacionCampos(15),
          dataHospitalizacion.fileQuimSanguinea.isEmpty
              ? addFileQuimicaSanguineaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosQuimicaSanguinea(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileQuimicaSanguinea(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Antibiograma'),
          _separacionCampos(15),
          dataHospitalizacion.fileAntibiograma.isEmpty
              ? addFileAntibiogramaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosAntibiograma(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileAntibiograma(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Radiografías'),
          _separacionCampos(15),
          dataHospitalizacion.fileRadiografia.isEmpty
              ? addFileRadiografiaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosRadiografia(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileRadiografia(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Ecografías'),
          _separacionCampos(15),
          dataHospitalizacion.fileEcografia.isEmpty
              ? addFileEcografiaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosEcografia(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileEcografia(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Coprología'),
          _separacionCampos(15),
          dataHospitalizacion.fileCoprologia.isEmpty
              ? addFileCoprologiaIsEmpty(context)
              : Row(
                  children: [
                    ArchivosCoprologia(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileCoprologia(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Raspado cutáneo'),
          _separacionCampos(15),
          dataHospitalizacion.fileCoprologia.isEmpty
              ? addFileRaspadoCutaneoIsEmpty(context)
              : Row(
                  children: [
                    ArchivosRaspadoCutaneo(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileRaspadoCutaneo(),
                  ],
                ),
          _separacionCampos(20),
          _NombreCampos('Citológico'),
          _separacionCampos(15),
          dataHospitalizacion.fileCoprologia.isEmpty
              ? addFileCitologicoIsEmpty(context)
              : Row(
                  children: [
                    ArchivosCitologico(
                      sizeScreen: sizeScreenWidth,
                    ),
                    AddFileCitologico(),
                  ],
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
    );
  }

  Widget _datosTratamiento(
      HospitalizacionProvider dataHospitalizacion, double sizeScreenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _tituloForm('Tratamiento'),
          _separacionCampos(20),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataHospitalizacion.controllersTratamiento.length,
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
                              Icons.message_outlined,
                              color: const Color.fromARGB(255, 139, 149, 166),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            child: TextFormFieldConHint(
                              colores: const Color.fromARGB(255, 140, 228, 233),
                              controller: dataHospitalizacion
                                  .controllersTratamiento[index],
                              hintText: 'Tratamiento ${index + 1}',
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              );
            },
          ),
          _separacionCampos(15),
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 218, 223, 230), width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: () {
                dataHospitalizacion.agregarTratamiento();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.add_square,
                    size: 25,
                    color: Color.fromARGB(255, 139, 149, 166),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Agregar tratamiento',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontFamily: 'sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          _separacionCampos(20),
          Row(
            children: [
              Checkbox(
                value: dataHospitalizacion.enviarReceta,
                onChanged: (bool? value) {
                  setState(() {
                    dataHospitalizacion.enviarReceta = value ?? false;
                  });
                },
              ),
              Text('¿Enviar receta al finalizar la ficha?'),
            ],
          ),
          _separacionCampos(15),
          _NombreCampos('Recomendaciones'),
          _separacionCampos(15),
          TextFormFieldMaxLinesConHint(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerRecomendaciones,
              hintText:
                  'Escriba aqui el recomendaciones adicionales para el cuidado de la mascota (Ej. Dieta blanca)',
              maxLines: 5),
          _separacionCampos(20),
          _NombreCampos('Alimentación'),
          _separacionCampos(15),
          TextFormFieldMaxLinesConHint(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerAlimentacion,
              hintText:
                  'Escriba aqui el tipo de alimentación de la mascota (Ej. Dieta blanca)',
              maxLines: 5),
          _separacionCampos(20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _nextPage();
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
    );
  }

  Widget _datosProximaVisita(HospitalizacionProvider dataHospitalizacion,
      double sizeScreenWidth, List<EncargadosVete> listaVeterinarios) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formkeyProximaVisita,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _tituloForm('Tiempo de Hospitalización'),
            _separacionCampos(20),
            _NombreCampos('Inicio'),
            _separacionCampos(15),
            InkWell(
              onTap: () {
                dataTimeInicioHospitalizacion(
                    context, dataHospitalizacion, sizeScreenWidth);
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
                        Icons.calendar_month_outlined,
                        color: Color.fromARGB(255, 139, 149, 166),
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    dataHospitalizacion.horaInicioSelected.isEmpty ||
                            dataHospitalizacion.fechaInicioSelected.isEmpty
                        ? Text(
                            'Seleccionar fecha y hora',
                            style: TextStyle(
                                color: const Color.fromRGBO(139, 149, 166, 1),
                                fontSize: 14,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            "${dataHospitalizacion.fechaInicioSelected.replaceAll("-", "/")}   ${dataHospitalizacion.horaInicioSelected}",
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
            MensajeValidadorSelecciones(
              validator: (_) => dataHospitalizacion.fechaInicioSelected == ''
                  ? 'Añadir fecha inicio de hospitalización.'
                  : null,
            ),
            _separacionCampos(20),
            _NombreCampos('Fin'),
            _separacionCampos(15),
            InkWell(
              onTap: () {
                dataTimeFinHospitalizacion(
                    context, dataHospitalizacion, sizeScreenWidth);
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
                        Icons.calendar_month_outlined,
                        color: Color.fromARGB(255, 139, 149, 166),
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    dataHospitalizacion.horaFinSelected.isEmpty ||
                            dataHospitalizacion.fechaFinSelected.isEmpty
                        ? Text(
                            'Seleccionar fecha y hora',
                            style: TextStyle(
                                color: const Color.fromRGBO(139, 149, 166, 1),
                                fontSize: 14,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            "${dataHospitalizacion.fechaFinSelected.replaceAll("-", "/")}   ${dataHospitalizacion.horaFinSelected}",
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
            MensajeValidadorSelecciones(
              validator: (_) => dataHospitalizacion.fechaFinSelected == ''
                  ? 'Añadir fecha fin de hospitalización.'
                  : null,
            ),
            _separacionCampos(20),
            _NombreCampos('Encargados'),
            _separacionCampos(15),
            Row(
              children: [
                Container(
                    child: const Icon(IconlyLight.user_1,
                        color: Color.fromARGB(255, 139, 149, 166), size: 28)),
                SizedBox(
                  width: 15,
                ),
                dataHospitalizacion.inicialEncargado.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 47, 26, 125),
                          child: Text(
                            dataHospitalizacion.inicialEncargado,
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
                                          const Color.fromARGB(255, 29, 34, 44),
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
                                final veterinario = listaVeterinarios[index];
                                return ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 2),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 47, 26, 125),
                                    child: Text(
                                      veterinario.nombres[0],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ), // Mostrar el ID a la izquierda
                                  title: Text('${veterinario.nombres}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 29, 34, 44),
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
                                    guardarIdVetEncargado(context, veterinario,
                                        dataHospitalizacion);
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
                          color: Color.fromARGB(255, 139, 149, 166), size: 20)),
                ),
              ],
            ),
            MensajeValidadorSelecciones(
              validator: (value) {
                if (dataHospitalizacion.idEncargadoSelected == '') {
                  return 'Por favor, seleccione un encargado.';
                }
                return null;
              },
            ),
            _separacionCampos(20),
            _NombreCampos('Intervalo'),
            TextFormFieldNumberIntervalo(
              colores: const Color.fromARGB(255, 26, 202, 212),
              hintText: 'Ingrese el intervalo de tiempo',
              controller: controllerIntervalorHospitalizacion,
              provider: dataHospitalizacion,
            ),
            _separacionCampos(20),
            _tituloForm('Firma eletrónica'),
            _separacionCampos(15),
            _NombreCampos('Firma eletrónica'),
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
                      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
                    ),
                    Positioned(
                        left: 5,
                        top: 5,
                        child: IconButton(
                            onPressed: () {
                              controllerFirma.clear();
                            },
                            icon: const Icon(Icons.clear)))
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formkeyProximaVisita.currentState!.validate()) {
                      dataHospitalizacion.saveSignature(
                          controllerFirma, context, dataHospitalizacion);
                      _nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 28, 149, 187),
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

  Widget _datosFacturacion(HospitalizacionProvider dataHospitalizacion,
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
                DatosFacturacion<HospitalizacionProvider>(
                  providerGenerico: dataHospitalizacion,
                  sizeScreenWidth: sizeScreenWidth,
                  radioButtons: const [
                    RadioButtonEfecTransacHospitalizacion(
                      efecTransac: 'Efectivo',
                      valor: 'EFECTIVO',
                    ),
                    RadioButtonEfecTransacHospitalizacion(
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
                        if (dataHospitalizacion
                            .totalACobrarFacturacion.isEmpty) {
                          dataHospitalizacion.setTotalACobrarFacturacion =
                              controllerMontoEfectivo.text;
                        }
                        if (_formkeyFacturacion.currentState!.validate()) {
                          dataHospitalizacion.selectedSquareHospitalizacion == 2
                              ? dataHospitalizacion
                                  .enviarDatos(
                                  //pacienteID
                                  dataHospitalizacion.selectedIdPacienteAntiguo,
                                  false,
                                  //propietario
                                  controllerCiDueno.text,
                                  controllerNombre.text,
                                  controllerApellido.text,
                                  controllerNumero.text,
                                  controllerDireccion.text,
                                  //paciente
                                  controllerNombrePaciente.text,
                                  dataHospitalizacion.selectedSexoPaciente,
                                  controllerEdadPaciente.text,
                                  dataHospitalizacion.selectedTypeAge,
                                  dataHospitalizacion.selectedIdEspecie,
                                  dataHospitalizacion.selectedIdRaza,
                                  dataHospitalizacion.dropTamanoMascota,
                                  dataHospitalizacion.dropTemperamento,
                                  dataHospitalizacion.dropAlimentacion,
                                  dataHospitalizacion.lastImage,
                                  //datos clinicos
                                  dataHospitalizacion.dropMucosas,
                                  controllerPeso.text,
                                  controllerTemperatura.text,
                                  controllerFrecuenciaCar.text,
                                  controllerFrecuenciaRes.text,
                                  dataHospitalizacion.dropHidratacion,
                                  dataHospitalizacion.dropGanglios,
                                  controllerLesiones.text,
                                  controllerDesdeCuandoTieneMascota.text,
                                  dataHospitalizacion
                                      .selectedExisteAnimalEnCasa,
                                  controllerDondeAdquirioMascota.text,
                                  controllerEnfermedadesPadece.text,
                                  dataHospitalizacion
                                      .selectedExpuestoAEnfermedad,
                                  dataHospitalizacion
                                      .selectedAplicadoTratamiento,
                                  dataHospitalizacion.selectedVacunasAlDia,
                                  controllerReaccionAlergica.text,

                                  //diagnostico
                                  controllerListaProblemas.text,
                                  controllerDiagnostico.text,
                                  controllerDiagnosticoDiferencial.text,

                                  //peticiones de pruebas y muestras
                                  controllerMuestrasRequeridas.text,
                                  controllerPruebasRequeridas.text,
                                  dataHospitalizacion.fileHemograma,
                                  dataHospitalizacion.fileQuimSanguinea,
                                  dataHospitalizacion.fileAntibiograma,
                                  dataHospitalizacion.fileRadiografia,
                                  dataHospitalizacion.fileEcografia,
                                  dataHospitalizacion.fileCoprologia,
                                  dataHospitalizacion.fileRaspadoCutaneo,
                                  dataHospitalizacion.fileCitologico,

                                  //tratamientos
                                  dataHospitalizacion.controllersTratamiento,
                                  dataHospitalizacion.enviarReceta,
                                  controllerRecomendaciones.text,

                                  //hospitalizacion
                                  controllerAlimentacion.text,
                                  dataHospitalizacion.fechaInicioSelected,
                                  dataHospitalizacion.horaInicioSelected,
                                  dataHospitalizacion.fechaFinSelected,
                                  dataHospitalizacion.horaFinSelected,
                                  controllerIntervalorHospitalizacion.text,
                                  dataHospitalizacion.selectedTypeInterval,
                                  dataHospitalizacion.idEncargadoSelected,
                                  dataHospitalizacion.signatureImageFirma,

                                  //datos facturacion
                                  dataHospitalizacion.selectedEfectivoTransac,
                                  controllerCIoNit.text,
                                  controllerNombreFactura.text,
                                  controllerApellidoFactura.text,
                                  dataHospitalizacion.switchValueFacturacion,
                                  dataHospitalizacion.totalACobrarFacturacion,

                                  //hospitalizacion
                                )
                                  .then((_) async {
                                  if (dataHospitalizacion
                                      .OkpostDatosHospitalizacion) {
                                    _mostrarFichaCreada(context);
                                  }
                                })
                              : dataHospitalizacion
                                  .enviarDatos(
                                      //pacienteID
                                      dataHospitalizacion.fichaId.toString(),
                                      widget.clinicaUpdate != null
                                          ? true
                                          : false,
                                      //propietario
                                      controllerCiDueno.text,
                                      controllerNombre.text,
                                      controllerApellido.text,
                                      controllerNumero.text,
                                      controllerDireccion.text,
                                      //paciente
                                      controllerNombrePaciente.text,
                                      dataHospitalizacion.selectedSexoPaciente,
                                      controllerEdadPaciente.text,
                                      dataHospitalizacion.selectedTypeAge,
                                      dataHospitalizacion.selectedIdEspecie,
                                      dataHospitalizacion.selectedIdRaza,
                                      dataHospitalizacion.dropTamanoMascota,
                                      dataHospitalizacion.dropTemperamento,
                                      dataHospitalizacion.dropAlimentacion,
                                      dataHospitalizacion.lastImage,
                                      //datos clinicos
                                      dataHospitalizacion.dropMucosas,
                                      controllerPeso.text,
                                      controllerTemperatura.text,
                                      controllerFrecuenciaCar.text,
                                      controllerFrecuenciaRes.text,
                                      dataHospitalizacion.dropHidratacion,
                                      dataHospitalizacion.dropGanglios,
                                      controllerLesiones.text,
                                      controllerDesdeCuandoTieneMascota.text,
                                      dataHospitalizacion
                                          .selectedExisteAnimalEnCasa,
                                      controllerDondeAdquirioMascota.text,
                                      controllerEnfermedadesPadece.text,
                                      dataHospitalizacion
                                          .selectedExpuestoAEnfermedad,
                                      dataHospitalizacion
                                          .selectedAplicadoTratamiento,
                                      dataHospitalizacion.selectedVacunasAlDia,
                                      controllerReaccionAlergica.text,

                                      //diagnostico
                                      controllerListaProblemas.text,
                                      controllerDiagnostico.text,
                                      controllerDiagnosticoDiferencial.text,

                                      //peticiones de pruebas y muestras
                                      controllerMuestrasRequeridas.text,
                                      controllerPruebasRequeridas.text,
                                      dataHospitalizacion.fileHemograma,
                                      dataHospitalizacion.fileQuimSanguinea,
                                      dataHospitalizacion.fileAntibiograma,
                                      dataHospitalizacion.fileRadiografia,
                                      dataHospitalizacion.fileEcografia,
                                      dataHospitalizacion.fileCoprologia,
                                      dataHospitalizacion.fileRaspadoCutaneo,
                                      dataHospitalizacion.fileCitologico,

                                      //tratamientos
                                      dataHospitalizacion
                                          .controllersTratamiento,
                                      dataHospitalizacion.enviarReceta,
                                      controllerRecomendaciones.text,

                                      //hospitalizacion
                                      controllerAlimentacion.text,
                                      dataHospitalizacion.fechaInicioSelected,
                                      dataHospitalizacion.horaInicioSelected,
                                      dataHospitalizacion.fechaFinSelected,
                                      dataHospitalizacion.horaFinSelected,
                                      controllerIntervalorHospitalizacion.text,
                                      dataHospitalizacion.selectedTypeInterval,
                                      dataHospitalizacion.idEncargadoSelected,
                                      dataHospitalizacion.signatureImageFirma,

                                      //datos facturacion
                                      dataHospitalizacion
                                          .selectedEfectivoTransac,
                                      controllerCIoNit.text,
                                      controllerNombreFactura.text,
                                      controllerApellidoFactura.text,
                                      dataHospitalizacion
                                          .switchValueFacturacion,
                                      dataHospitalizacion
                                          .totalACobrarFacturacion)
                                  .then((_) async {
                                  if (dataHospitalizacion
                                      .OkpostDatosHospitalizacion) {
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
                      child: dataHospitalizacion.loadingDatosHospitalizacion
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
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
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
                                  Provider.of<HospitalizacionProvider>(context,
                                          listen: false)
                                      .setSelectSquareHospitalizacion(0);
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
                  const Image(
                      height: 220,
                      width: 200,
                      image: AssetImage('assets/img/done.png')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '¡Genial! La cita ha sido programada correctamente. Se enviará un recordatorio un día antes de la visita.',
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
                          Provider.of<HospitalizacionProvider>(context,
                              listen: false)
                            ..setOKsendDatosHospitalizacion(false)
                            ..setSelectSquareHospitalizacion(0);
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
      HospitalizacionProvider dataHospitalizacion) {
    dataHospitalizacion
        .setIdEncargadoSelected(encargadoVet.encargadoVeteId.toString());
    dataHospitalizacion
        .setInicialEncargado(encargadoVet.nombres[0].toUpperCase().toString());

    // Cerrar el AlertDialog
    Navigator.pop(context);
  }

  // Obteniendo fecha del table calendar
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    HospitalizacionProvider dataHospitalizacion =
        Provider.of<HospitalizacionProvider>(context, listen: false);
    setState(() {
      today = day;
      String formattedDateEnviar = DateFormat("yyyy-MM-dd").format(today);
      dataHospitalizacion.setFechaInicioSlected(formattedDateEnviar);
    });
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

  Widget getFotoPaciente(HospitalizacionProvider dataHospitalizacion) {
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
            dataHospitalizacion.addPhoto();
          },
          child: Image.file(
            dataHospitalizacion.lastImage!,
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
