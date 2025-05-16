import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:vet_sotf_app/presentation/widgets/clinica/consulta/radiobuttonConsulta_widget.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';

Widget datosDelDueno({
  required GlobalKey<FormState> formKey,
  required TextEditingController controllerCi,
  required TextEditingController controllerNombre,
  required TextEditingController controllerApellido,
  required TextEditingController controllerNumero,
  required TextEditingController controllerDireccion,
  required double sizeScreenWidth,
  required VoidCallback onNext,
  required VoidCallback onCancel,
  Color colorInput = const Color.fromARGB(255, 140, 228, 233),
}) {
  return SingleChildScrollView(
    child: Container(
      width: double.infinity,
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloForm('Datos del dueño'),
            _separacionCampos(20),
            _NombreCampos('C.I.'),
            _separacionCampos(15),
            TextFormFieldConHintValidator(
              colores: colorInput,
              controller: controllerCi,
              hintText: 'Celula de Identidad (Ej: 123456)',
            ),
            _separacionCampos(20),
            _NombreCampos('Nombre'),
            _separacionCampos(15),
            TextFormFieldConHintValidator(
              colores: colorInput,
              controller: controllerNombre,
              hintText: 'Nombre (Ej: Miguel)',
            ),
            _separacionCampos(20),
            _NombreCampos('Apellidos'),
            _separacionCampos(20),
            TextFormFieldConHintValidator(
              colores: colorInput,
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 249, 249, 249),
                  ),
                  child: const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/img/bolivia.png'),
                        width: 35,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '+591',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14,
                          color: Color.fromARGB(255, 139, 149, 166),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Color.fromARGB(255, 139, 149, 166),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextFormFieldNumberConHintValidator(
                    colores: colorInput,
                    controller: controllerNumero,
                    hintText: 'Número (Ej: 67778786)',
                  ),
                ),
              ],
            ),
            _separacionCampos(15),
            _NombreCampos('Dirección'),
            _separacionCampos(15),
            TextFormFieldConHint(
              colores: colorInput,
              controller: controllerDireccion,
              hintText: 'Dirección (Ceja)',
            ),
            _separacionCampos(5),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onNext();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorPalet.complementVerde2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 28, 149, 187),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget datosPaciente({
  required double sizeScreenWidth,
  required GlobalKey<FormState> formKey,
  required TextEditingController controllerNombrePaciente,
  required List<Widget> radioButtonsGenero,
  required String generoProvider,
  required Widget edadWidget,
  required Widget especieWidget,
  required Widget razaWidget,
  required Widget tamanoWidget,
  required Widget temperamentoWidget,
  required Widget alimentacionWidget,
  required Widget imagenWidget,
  required VoidCallback onNext,
  required VoidCallback onPrevious,
}) {
  return SingleChildScrollView(
    child: Container(
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloForm('Datos del paciente'),
            _separacionCampos(20),
            _NombreCampos('Nombre del paciente'),
            _separacionCampos(15),
            TextFormFieldConHintValidator(
              colores: const Color.fromARGB(255, 140, 228, 233),
              controller: controllerNombrePaciente,
              hintText: 'Bigotes',
            ),
            _separacionCampos(15),
            _NombreCampos('Sexo'),
            _separacionCampos(15),
            // Radio buttons reutilizables
            ...radioButtonsGenero,
            MensajeValidadorSelecciones(
              validator: (_) =>
                  generoProvider == '' ? 'Seleccione una opción.' : null,
            ),
            _separacionCampos(20),
            _NombreCampos('Edad'),
            _separacionCampos(15),
            edadWidget,
            _separacionCampos(15),
            _NombreCampos('Especie'),
            _separacionCampos(15),
            especieWidget, // Dropdown de especie
            _separacionCampos(15),
            _NombreCampos('Raza'),
            _separacionCampos(15),
            razaWidget, // Dropdown de raza
            _separacionCampos(15),
            _NombreCampos('Tamaño de la mascota'),
            _separacionCampos(15),
            tamanoWidget,
            _separacionCampos(15),
            _NombreCampos('Temperamento'),
            _separacionCampos(15),
            temperamentoWidget,
            _separacionCampos(15),
            _NombreCampos('Alimentación'),
            _separacionCampos(15),
            alimentacionWidget,
            _separacionCampos(15),
            imagenWidget,
            _separacionCampos(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onNext();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 28, 149, 187),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPrevious,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 28, 149, 187),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Atrás',
                  style: TextStyle(
                    color: Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Row _tituloForm(String titulo) {
  return Row(
    children: [
      const Icon(
        Iconsax.firstline,
        color: Color.fromARGB(255, 29, 34, 44),
        size: 30,
      ),
      const SizedBox(
        width: 8,
      ),
      Text(
        titulo,
        style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 72, 86, 109),
            fontFamily: 'sans',
            fontWeight: FontWeight.w700),
      ),
    ],
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
