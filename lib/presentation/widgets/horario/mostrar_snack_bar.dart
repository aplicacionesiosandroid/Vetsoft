//ACA ESTA EL CODIGO PARA EL SNACKBAR , MENSAJE DE CONFIRMACION
import 'package:flutter/material.dart';

void mostrarSnackBar(BuildContext context, String textoMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromARGB(255, 28, 149, 187),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      content: SizedBox(
        // height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10), // Ajusta el espacio izquierdo
            const Icon(
              Icons.check_circle_outline,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                textoMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                maxLines: 3,
                textAlign: TextAlign.justify,
              ),
            ),
            const Icon(
              Icons.close,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 10), // Ajusta el espacio derecho
          ],
        ),
      ),
    ),
  );
}
