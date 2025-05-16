import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:vet_sotf_app/common/views/buttons_widget.dart';
import 'package:vet_sotf_app/common/views/modals_widget.dart';
import 'package:vet_sotf_app/presentation/screens/clinica/widget/WidgetCalendario.dart';

import '../../../config/global/palet_colors.dart';

import '../../../models/petshop/registroCompra/registration_pay_model.dart';
import '../../../providers/productos/productos_provider.dart';
import '../textFormFieldsTypes_widget.dart';
import 'category_card.dart';

class FormStepTwoWidget extends StatefulWidget {
  FormStepTwoWidget({
    super.key,
    required this.registroModel,
    required this.controllerNombreProducto,
    required this.controllerAbreviatura,
    required this.controllerNombreUnidad,
  });

  final RegistroModel registroModel;
  final TextEditingController controllerNombreProducto;
  final TextEditingController controllerAbreviatura;
  final TextEditingController controllerNombreUnidad;

  @override
  State<FormStepTwoWidget> createState() => _FormStepTwoWidgetState();
}

class _FormStepTwoWidgetState extends State<FormStepTwoWidget> {
  final _formKeyNewUnidad = GlobalKey<FormState>();
  final _formKeyDatosProducto = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dataProductos = Provider.of<ProductosProvider>(context);

    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKeyDatosProducto,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "Nombre",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 5),
          TextFormFieldConHintValidator(
              controller: widget.controllerNombreProducto,
              hintText: 'Alimento',
              colores: ColorPalet.secondaryLight),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Seleccionar Categoría",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Category_card_widget(dataProductos: dataProductos, size: size),
          const SizedBox(height: 30),
          const Text(
            "Seleccionar Subcategoría",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<ProductosProvider>(
            builder: (context, provider, child) {
              return Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 249, 249, 249),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  isExpanded: false,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 139, 149, 166),
                    fontSize: 15,
                    fontFamily: 'inter',
                  ),
                  items: [
                    ...provider.subgruposSeleccionados.map((subGrupo) {
                      return DropdownMenuItem<String>(
                        value: subGrupo.subGrupoId.toString(),
                        child: Text(subGrupo.nombre),
                      );
                    }).toList(),
                    const DropdownMenuItem<String>(
                        value: 'nuevo',
                        child: Text(
                          'Añadir nueva subcategoría...',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                  value: provider.selectedSubGroupId?.toString(),
                  onChanged: (String? selectedSubGroupId) {
                    if (selectedSubGroupId == 'nuevo') {
                      setState(() {
                        provider.selectedSubGroupId == null;
                      });
                      if (!(provider.selectedGrupoIndex > -1)) {
                        BotToast.showText(
                            text: "Debe seleccionar una categoría");
                      } else {
                        dialogAddSubcategory(
                            context, provider, provider.selectedGroupId);
                      }
                    } else {
                      provider.updateSelectedGroupAndSubGroup(
                        provider.selectedGroupId,
                        int.parse(selectedSubGroupId!),
                      );
                    }
                  },
                  hint: Text(
                    provider.selectedGroupId == null
                        ? 'Seleccionar Categoría'
                        : 'Seleccionar',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 139, 149, 166),
                      fontSize: 15,
                      fontFamily: 'inter',
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          const Text(
            "Seleccionar Marca",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<ProductosProvider>(
            builder: (context, provider, child) {
              return Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 249, 249, 249),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<int>(
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  isExpanded: false,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 139, 149, 166),
                      fontSize: 15,
                      fontFamily: 'inter'),
                  value: provider.selectedMarcaId,
                  items: [
                    ...provider.marcas.map((marca) {
                      return DropdownMenuItem<int>(
                        value: marca.marcaId,
                        child: Text(marca.nombre),
                      );
                    }).toList(),
                    const DropdownMenuItem<int>(
                      value: -1,
                      child: Text('Añadir nueva marca...',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                  onChanged: (int? selectedMarcaId) {
                    if (selectedMarcaId == -1) {
                      dialogAddMarca(context, provider);
                      setState(() {
                        provider.selectedMarcaId = null;
                      });
                    } else {
                      provider.selectedMarcaId = selectedMarcaId;
                    }
                  },
                  hint: const Text(
                    'Seleccionar',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          const Text(
            "Seleccionar Unidad de Medida",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: Consumer<ProductosProvider>(
              builder: (context, provider, child) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: provider.unidadesMedida.map((unidad) {
                    return RadioListTile<int>(
                      activeColor: ColorPalet.secondaryDefault,
                      title: Text(unidad.unidad),
                      value: unidad.unidadId,
                      groupValue: provider.selectedUnidadMedidaId,
                      onChanged: (int? selectedValue) {
                        // Actualizar el valor seleccionado en el proveedor
                        provider.updateSelectedUnidadMedida(selectedValue);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          TextButton.icon(
              onPressed: () {
                _openBottomSheetRegistrarUnidad(context, size, dataProductos);
              },
              icon: const Icon(
                Icons.add,
                color: ColorPalet.secondaryDefault,
              ),
              label: const Text(
                "Nuevo",
                style: TextStyle(
                  color: ColorPalet.secondaryDefault,
                ),
              )),
          const SizedBox(height: 30),
          Row(
            children: [
              Switch(
                value: dataProductos.switchValueAgreeFVencimiento,
                onChanged: (value) {
                  dataProductos.setSwitchValueAgreeFVencimiento = value;
                },
                activeColor: ColorPalet.secondaryDefault,
              ),
              const SizedBox(
                width: 10,
              ),
              _NombreCampos('Agregar fecha de vencimiento'),
            ],
          ),
          dataProductos.switchValueAgreeFVencimiento
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.07,
                  child: InkWell(
                    onTap: () {
                      _openBottomSheetFechaVencimiento(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorPalet.grisesGray4,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              dataProductos.fechaVencimiento.isEmpty
                                  ? 'DD/MM/AA'
                                  : dataProductos.fechaVencimiento,
                              style: const TextStyle(
                                  color: ColorPalet.grisesGray2,
                                  fontFamily: 'inter',
                                  fontSize: 16),
                            ),
                            const Spacer(),
                            const Icon(
                              Iconsax.calendar_1,
                              color: ColorPalet.grisesGray2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              if (_formKeyDatosProducto.currentState!.validate())
                widget.registroModel.goToNextForm();
            },
            text: "Siguiente",
            height: 40,
            width: size.width,
            backgroundColor: ColorPalet.secondaryDefault,
            textColor: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomButton(
            onPressed: () {
              widget.registroModel.goToPreviousForm();
            },
            text: "Anterior",
            height: 40,
            width: size.width,
            backgroundColor: ColorPalet.grisesGray5,
            textColor: ColorPalet.secondaryDefault,
            overlayColor: ColorPalet.secondaryDefault.withAlpha(50),
            borderSide: const BorderSide(color: ColorPalet.secondaryDefault),
          ),
        ],
      ),
    );
  }

  Future<void> dialogAddSubcategory(BuildContext context,
      ProductosProvider productosProvider, int? idCategory) async {
    // Restablecer el valor del controlador
    TextEditingController controllerNombre = TextEditingController();
    controllerNombre.text = '';
    bool isLoading = false; // Mueve esta declaración a nivel de estado
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Añadiendo subcategoría'),
              content: TextFormFieldConHintValidator(
                colores: ColorPalet.secondaryDefault,
                controller: controllerNombre,
                hintText: 'Nueva subcategoría...',
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (controllerNombre.text == '') {
                      setState(() {
                        isLoading = false;
                      });
                      CustomToast.showToast(
                          "El campo de subcategoría no puede estar vacío");
                    } else {
                      CustomToast.showToast("Se añadió la nueva subcategoría");
                      await productosProvider.setNewSubcategory(
                          idCategory, controllerNombre.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.secondaryDefault,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Añadir',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: ColorPalet.secondaryDefault, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: ColorPalet.secondaryDefault,
                      fontFamily: 'inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> dialogAddMarca(
      BuildContext context, ProductosProvider productosProvider) async {
    // Restablecer el valor del controlador
    TextEditingController controllerNombre = TextEditingController();
    controllerNombre.text = '';
    bool isLoading = false; // Mueve esta declaración a nivel de estado
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              title: const Text('Añadiendo marca'),
              content: TextFormFieldConHintValidator(
                colores: ColorPalet.secondaryDefault,
                controller: controllerNombre,
                hintText: 'Nueva marca...',
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (controllerNombre.text == "") {
                      setState(() {
                        isLoading = false;
                      });
                      CustomToast.showToast(
                          "El campo de marca no puede estar vacío");
                    } else {
                      CustomToast.showToast("Se añadió la nueva marca");
                      await productosProvider
                          .setNewMarca(controllerNombre.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.secondaryDefault,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Añadir',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: ColorPalet.secondaryDefault, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: ColorPalet.secondaryDefault,
                      fontFamily: 'inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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

  void _openBottomSheetRegistrarUnidad(
      BuildContext context, Size size, ProductosProvider dataProductos) {
    CustomBottomSheetModal(context, StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Ajuste dinámico con el teclado
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar nueva unidad de medida',
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 34, 44),
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKeyNewUnidad,
                    child: Column(
                      children: [
                        TextFormFieldConHintValidator(
                            controller: widget.controllerNombreUnidad,
                            hintText: 'Nombre',
                            colores: ColorPalet.secondaryDefault),
                        TextFormFieldConHintValidator(
                            controller: widget.controllerAbreviatura,
                            hintText: 'Abreviatura',
                            colores: ColorPalet.secondaryDefault),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorPalet.secondaryDefault),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKeyNewUnidad.currentState!.validate()) {
                                dataProductos.updateSelectedUnidadMedida(null);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Agregar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            ColorPalet.secondaryDefault.withAlpha(50)),
                        backgroundColor:
                            MaterialStateProperty.all(ColorPalet.grisesGray5),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: const BorderSide(
                                color: ColorPalet.secondaryDefault),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.controllerNombreUnidad.clear();
                        widget.controllerAbreviatura.clear();
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: ColorPalet.secondaryDefault),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  void _openBottomSheetFechaVencimiento(BuildContext context) {
    CustomBottomSheetModal(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccionar fecha de vencimiento',
                      style: TextStyle(
                        color: Color.fromARGB(255, 29, 34, 44),
                        fontFamily: 'sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CalendarioFormulario(
                  focusedDay: todayVencimiento,
                  firstDay: DateTime.utc(2023, 02, 10),
                  lastDay: DateTime.utc(2030, 02, 10),
                  onDaySelected: (day, focusedDay) {
                    setState(() {
                      todayVencimiento = day;
                    });
                    _onDaySelectedFVencimiento(day, focusedDay, context);
                  },
                  selectedDayPredicate: (day) =>
                      isSameDay(day, todayVencimiento),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DateTime todayVencimiento = DateTime.now();

  void _onDaySelectedFVencimiento(
      DateTime day, DateTime focusedDay, BuildContext context) {
    ProductosProvider dataProductos =
        Provider.of<ProductosProvider>(context, listen: false);
    setState(() {
      todayVencimiento = day;
      String formattedDateEnviar =
          DateFormat("yyyy-MM-dd").format(todayVencimiento);
      print(formattedDateEnviar);
      dataProductos.setFechaVencimiento(formattedDateEnviar);
    });
  }
}
