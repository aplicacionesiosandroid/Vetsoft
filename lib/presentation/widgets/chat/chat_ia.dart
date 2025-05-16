import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

import '../../../models/chat/chat_model.dart';

class IaMessageBubble extends StatelessWidget {
  const IaMessageBubble({super.key, required this.message, required this.size});

  final Size size;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius:
                  20, // Ajusta el radio según el tamaño que desees para el avatar
              backgroundColor: ColorPalet.complementVerde2,
              child: Icon(
                Iconsax.message,
                color: ColorPalet.grisesGray5,
              ),
            ),
            Container(
              width: size.width * 0.79,
              margin: EdgeInsets.only(bottom: 5, left: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SelectableText(
                  message.text,
                  style: const TextStyle(
                      color: ColorPalet.grisesGray1,
                      fontFamily: 'inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
