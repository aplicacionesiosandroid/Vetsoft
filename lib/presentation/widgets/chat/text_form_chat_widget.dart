import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/chat_provider.dart';

class MessagefieldBox extends StatefulWidget {
  final ValueChanged<String> onValue;

  MessagefieldBox({super.key, required this.onValue});

  @override
  _MessagefieldBoxState createState() => _MessagefieldBoxState();
}

class _MessagefieldBoxState extends State<MessagefieldBox> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    super.initState();
    textController = TextEditingController(text: chatProvider.chat);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
        if (chatProvider.imageChatBot != null && chatProvider.imageChatBot!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(chatProvider.imageChatBot!),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      chatProvider.clearImage();
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  Future<String?> selectFile() async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      final path = result.files.single.path;
                      return path;
                    }
                    return null;
                  }

                  final filePath = await selectFile();
                  if (filePath != null) {
                    chatProvider.setImageChatBot(filePath);
                  }
                },
                icon: const Icon(Iconsax.gallery),
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null, // Importante para permitir múltiples líneas
                  keyboardType: TextInputType.multiline, // Habilitar el salto de línea en el teclado
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí tu consulta...',
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onChanged: (value) {
                    chatProvider.setChat(textController.text);
                    // Puedes decidir si quieres hacer algo cada vez que cambia el texto
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  final textValue = textController.value.text;
                  if (textValue.isNotEmpty || chatProvider.imageChatBot != null) {
                    textController.clear();
                    chatProvider.setChat(textController.text);
                    widget.onValue(textValue);
                    FocusScope.of(context).unfocus(); // Opcionalmente desenfocar después de enviar
                  }
                },
                icon: const Icon(Iconsax.send_1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}