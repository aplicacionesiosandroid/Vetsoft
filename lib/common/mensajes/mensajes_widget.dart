import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void mensajeInferior(BuildContext context, String textoMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromARGB(255, 28, 149, 187),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      content: Container(
        height: 50,
        child: Row(
          children: [
            const SizedBox(width: 5),
            const Icon(
              Icons.check_circle_outline,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AutoSizeText(
                textoMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.close,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    ),
  );
}
