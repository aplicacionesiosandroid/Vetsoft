import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../config/global/palet_colors.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';

class ChatShowScreen extends StatelessWidget {
  const ChatShowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final historialDetallado = chatProvider.historialDetallado;
    Size sizeScreen = MediaQuery.of(context).size;
    print('Construyendo ChatShowScreen con historial detallado: $historialDetallado');

    return Scaffold(
      backgroundColor: const Color(0xFF007AA2), // Hace que la pantalla sea transparente
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // Ajusta la altura de la cabecera
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF007AA2), // Color de la cabecera
          leading: InkWell(
            onTap: () => Navigator.pop(context), // Agrega InkWell para manejar el toque
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Icon(
                Iconsax.arrow_left,
                color: ColorPalet.grisesGray5,
              ),
            ),
          ),
          title: const Padding(
            padding:  EdgeInsets.only(top: 30.0), // Agrega un margen superior
            child:  Text(
              'Detalle del Historial',
              style: TextStyle(
                color: ColorPalet.grisesGray5,
                fontSize: 20,
                fontFamily: 'sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          centerTitle: true, // Centra el título
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30), // Ajusta el radio para la curvatura deseada
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 250, 250, 250), // Color del cuerpo de la pantalla
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30), // Ajusta el radio para la curvatura deseada
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: historialDetallado.length,
                    itemBuilder: (context, index) {
                      final item = historialDetallado[index];
                      final pregunta = item['pregunta'] as String?;
                      final respuestaChatgpt = item['respuesta_chatgpt'] as String?;
                      final imagenChatgpt = item['imagen_chat'] as String;
                      final isUserMessage = pregunta != null;

                      return Column(
                        crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (pregunta != null) ...[
                            MessageBubble(
                              text: pregunta,
                              isUserMessage: true,
                              imagen: imagenChatgpt,
                            ),
                          ],
                          if (respuestaChatgpt != null) ...[
                            MessageBubble(
                              text: respuestaChatgpt,
                              isUserMessage: false,
                              imagen: '',
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final String imagen;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUserMessage,
    required this.imagen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: isUserMessage ? ColorPalet.complementVerde2 : Colors.grey[300],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              text,
              style: TextStyle(color: isUserMessage ? ColorPalet.grisesGray5 : Colors.black87, fontSize: 18),
            ),
          ),
        ),
        if (imagen != '')
          Align(
            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: isUserMessage ? ColorPalet.complementVerde2 : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/icon/logovs.png',
                  image: '$imagenUrlGlobal${imagen}',
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 200),
                  fadeInCurve: Curves.easeIn,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          )
      ],
    );
  }
}
