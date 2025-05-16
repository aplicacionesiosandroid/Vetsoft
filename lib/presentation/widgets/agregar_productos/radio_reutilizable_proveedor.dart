//Para saber el genero de la mascota con checkbox

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/productos/productos_provider.dart';

import '../../../models/agregar_productos/productos/proveedores_model.dart';

class RadioButtonReutilizableProveedor extends StatelessWidget {
  final String gender;
  final String valor;

  RadioButtonReutilizableProveedor(
      {super.key, required this.gender, required this.valor});

  final TextEditingController controllerBusquedaProv = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final radioButtonProvider = Provider.of<ProductosProvider>(context);
    final dataProductos = Provider.of<ProductosProvider>(context);
    final listaProveedor = dataProductos.proveedor;

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Radio(
            activeColor: Color.fromARGB(255, 99, 92, 255),
            value: valor,
            onChanged: (newValue) {
              if (valor == 'false') {
                _openBottomSheetProveedores(
                    dataProductos, context, listaProveedor);
                radioButtonProvider.setSelectedProveedor(newValue.toString());
              } else if (valor == 'true') {
                radioButtonProvider.setSelectedProveedor(newValue.toString());
                dataProductos.setNombreproveedor(null);
              }
            },
            groupValue: radioButtonProvider.selectedProveedor,
          ),
          Text(
            gender,
            style: TextStyle(
                color: Color.fromARGB(255, 72, 86, 109),
                fontWeight: FontWeight.w400,
                fontFamily: 'inter',
                fontSize: 14),
          )
        ],
      ),
    );
  }

  void _openBottomSheetProveedores(ProductosProvider dataProductos,
      BuildContext context, List<Proveedor> listaProveedor) {
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
                  child: Text('Proveedores',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 29, 34, 44),
                          fontSize: 16,
                          fontFamily: 'sans',
                          fontWeight: FontWeight.w700)),
                ),
                _separacionCampos(10),
                SizedBox(height: 10),
                Expanded(child: Consumer<ProductosProvider>(
                  builder: (context, provider, child) {
                    final listaProveedores = provider.proveedor;
                    return ListView.builder(
                      itemCount: listaProveedores.length,
                      itemBuilder: (BuildContext context, int index) {
                        final proveedor = listaProveedores[index];
                        final isSelected = provider
                            .esProveedorSeleccionado(proveedor.provedorId);

                        return ListTile(
                          leading: Icon(Iconsax.task),
                          title: Text(
                            proveedor.nombreProvedor,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Color.fromARGB(255, 99, 92, 255)
                                  : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check,
                                  color: Color.fromARGB(255, 99, 92, 255))
                              : null,
                          onTap: () {
                            provider.setProveedorSeleccionado(
                                proveedor.provedorId, proveedor.nombreProvedor);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  _separacionCampos(double num) {
    return SizedBox(
      height: num,
    );
  }
}
