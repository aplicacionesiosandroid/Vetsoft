import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/chat/chat_ia.dart';

import '../../../config/global/palet_colors.dart';
import '../../../models/chat/chat_model.dart';
import 'package:vet_sotf_app/providers/chat_provider.dart';
import '../../widgets/chat/chat_widget.dart';
import '../../widgets/chat/text_form_chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.resetChat();
    chatProvider.iniciarChat();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF007AA2),
        leading: Padding(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Iconsax.arrow_left,
                  color: ColorPalet.grisesGray5,
                ))),
        title: const Text('Asistente virtual',
            style: TextStyle(
                color: ColorPalet.grisesGray5,
                fontSize: 20,
                fontFamily: 'sans',
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: _ChatView(sizeScreen),
    );
  }
}


class _ChatView extends StatelessWidget {
  _ChatView(this.sizeScreen);

  final Size sizeScreen;

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            Container(
              width: sizeScreen.width,
              color: Color(0xFF007AA2),
              height: 100,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  FaceAnimationPage(),
                  SizedBox(width: sizeScreen.width * 0.015),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vet.y',
                        style: TextStyle(
                            color: ColorPalet.grisesGray5,
                            fontFamily: 'sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          CircleAvatar(radius: 5, backgroundColor: ColorPalet.primaryDefault),
                          SizedBox(width: 5),
                          Text(
                            'Siempre online',
                            style: TextStyle(
                                color: ColorPalet.grisesGray3,
                                fontFamily: 'inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                          color: Color(0xFF0085AF),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(35),
                      child: IconButton(
                        icon: Icon(Iconsax.clock),
                        color: ColorPalet.grisesGray5,
                        onPressed: () {
                          Navigator.pushNamed(context, '/historialChatbotScreen');
                        },
                      )),
                  
                ],
              ),
            ),
            Container(
              color: Color(0xFF007AA2),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: ColorPalet.backGroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35))),
              ),
            ),
            Expanded(
            child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length + (chatProvider.isBotWriting ? 1 : 0),
              itemBuilder: (context, index) {
                if (chatProvider.isBotWriting && index == chatProvider.messageList.length) {
                  // Mostrar la animación cuando el bot está escribiendo
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TypingDotsAnimation(), // Widget de animación
                    ),
                  );
                }
                final message = chatProvider.messageList[index];
                return (message.fromWho == FromWho.ia)
                    ? IaMessageBubble(message: message, size: sizeScreen)
                    : MyMessageBubble(message: message, size: sizeScreen);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MessagefieldBox(
                onValue: (value) => chatProvider.sendMessage(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceAnimationPage extends StatefulWidget {
  @override
  _FaceAnimationPageState createState() => _FaceAnimationPageState();
}

class _FaceAnimationPageState extends State<FaceAnimationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blinkAnimation;
  int expressionIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _blinkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true); // Esto hará que la animación se repita indefinidamente
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) => toggleExpression());
  }

  void toggleExpression() {
    setState(() {
      expressionIndex++;
      if (expressionIndex > 3) {
        expressionIndex = 0;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF007AA2),// Color de fondo verde esmeralda
        borderRadius: BorderRadius.circular(20), // Borde redondeado
      ),
      width: 100, // Ancho para la animación
      height: 100, // Alto para la animación
      child: CustomPaint(
        painter: FacePainter(
          blinkValue: _blinkAnimation.value,
          expressionIndex: expressionIndex,
        ),
      ),
    );
  }
}


class FacePainter extends CustomPainter {
  final double blinkValue;
  final int expressionIndex;

  FacePainter({required this.blinkValue, required this.expressionIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyeRadius = size.width * 0.15;
    final leftEyeCenter = Offset(size.width * 0.3, size.height * 0.5);
    final rightEyeCenter = Offset(size.width * 0.7, size.height * 0.5);

    // Dibuja los ojos
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);

    final eyelidPaint = Paint()
      ..color = Color(0xFF007AA2)
      ..style = PaintingStyle.fill;

    final double blinkTop = blinkValue * eyeRadius;
    final double blinkBottom = eyeRadius - blinkTop;

    // Gestiona la animación de parpadeo
    switch (expressionIndex) {
      case 0: // Ojos completamente abiertos
        // No se dibuja el párpado
        break;
      case 1: // Ojos cerrándose hacia el centro
        canvas.drawRect(
          Rect.fromLTWH(leftEyeCenter.dx - eyeRadius,
              leftEyeCenter.dy - eyeRadius, eyeRadius * 2, blinkTop),
          eyelidPaint,
        );
        canvas.drawRect(
          Rect.fromLTWH(rightEyeCenter.dx - eyeRadius,
              rightEyeCenter.dy - eyeRadius, eyeRadius * 2, blinkTop),
          eyelidPaint,
        );

        break;
      case 2: // Ojos semiabiertos como en la imagen proporcionada
        // Párpado superior del ojo izquierdo
        canvas.drawArc(
          Rect.fromCircle(center: leftEyeCenter, radius: eyeRadius),
          0, // Inicio en la parte superior del círculo
          math.pi, // Dibuja medio círculo
          false,
          eyelidPaint,
        );
        // Párpado superior del ojo derecho
        canvas.drawArc(
          Rect.fromCircle(center: rightEyeCenter, radius: eyeRadius),
          0, // Inicio en la parte superior del círculo
          math.pi, // Dibuja medio círculo
          false,
          eyelidPaint,
        );
        break;

      case 3: // Un ojo completamente cerrado y el otro medio cerrado

        // Ojo derecho medio cerrado
        canvas.drawRect(
          Rect.fromLTWH(rightEyeCenter.dx - eyeRadius,
              rightEyeCenter.dy - eyeRadius, eyeRadius * 2, blinkTop),
          eyelidPaint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TypingDotsAnimation extends StatefulWidget {
  @override
  _TypingDotsAnimationState createState() => _TypingDotsAnimationState();
}

class _TypingDotsAnimationState extends State<TypingDotsAnimation> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: false);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Esto alinea los puntos a la izquierda
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == (_animation!.value * 3).floor() % 3 ? Color(0xFF007AA2) : Color(0xFF007AA2).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
