import 'dart:io';

import 'package:flutter/material.dart';

import '../../../config/global/palet_colors.dart';
import '../../../models/chat/chat_model.dart';

class MyMessageBubble extends StatelessWidget {
  final Message message;
  final Size size;
  const MyMessageBubble({super.key, required this.message, required this.size});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width:size.width * 0.60 ,
              margin: EdgeInsets.only(top: 12, right: 10),
              decoration: BoxDecoration(
                  color: ColorPalet.complementVerde2 ,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20) , topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SelectableText(
                  message.text,
                   style: const TextStyle(
                      color: ColorPalet.grisesGray5,
                      fontFamily: 'inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            CircleAvatar(
              radius: 20, // Ajusta el radio según el tamaño que desees para el avatar
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/img/user.png'),

            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        if (message.imagen != '')
          Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width:size.width * 0.60 ,
              margin: EdgeInsets.only(top: 12, right: 10),
              decoration: BoxDecoration(
                  color: ColorPalet.complementVerde2 ,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20) , topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(message.imagen),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 20, // Ajusta el radio según el tamaño que desees para el avatar
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/img/user.png'),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
