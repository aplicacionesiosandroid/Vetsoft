import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';


class FaceAnimationPage extends StatefulWidget {
  const FaceAnimationPage({super.key});

  @override
  _FaceAnimationPageState createState() => _FaceAnimationPageState();
}

class _FaceAnimationPageState extends State<FaceAnimationPage>
    with SingleTickerProviderStateMixin {
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

    _timer = Timer.periodic(Duration(seconds: 3),
        (Timer t) => toggleExpression()); // Paso 2: Configura el Timer
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel(); // Paso 3: Cancela el Timer
    super.dispose();
  }

  void toggleExpression() {
    if (expressionIndex < 3) {
      expressionIndex++;
    } else {
      expressionIndex = 0;
    }
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FacePainter(
        blinkValue: _blinkAnimation.value,
        expressionIndex: 0, // Asumiendo que quieres una expresión fija
      ),
      child: SizedBox(
        width: 50, // Ancho de la animación
        height: 50, // Altura de la animación
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

    // Dibujar los ojos
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);

    final eyelidPaint = Paint()
      ..color = Color(0xFF007AA2)
      ..style = PaintingStyle.fill;

    // Variables para la animación de parpadeo
    final double blinkTop = blinkValue * eyeRadius;
    final double blinkBottom = eyeRadius - blinkTop;

    // Dibujar párpados en función de la expresión
    switch (expressionIndex) {
      case 0: // Ojos completamente abiertos
        // No se dibuja el párpado
        break;
      case 1: // Ojos cerrándose hacia el centro
        // Dibujar párpados superior e inferior que se mueven hacia el centro
        canvas.drawRect(Rect.fromLTWH(leftEyeCenter.dx - eyeRadius, leftEyeCenter.dy - eyeRadius, eyeRadius * 2, blinkTop), eyelidPaint);
        canvas.drawRect(Rect.fromLTWH(leftEyeCenter.dx - eyeRadius, leftEyeCenter.dy + eyeRadius - blinkTop, eyeRadius * 2, blinkBottom), eyelidPaint);
        canvas.drawRect(Rect.fromLTWH(rightEyeCenter.dx - eyeRadius, rightEyeCenter.dy - eyeRadius, eyeRadius * 2, blinkTop), eyelidPaint);
        canvas.drawRect(Rect.fromLTWH(rightEyeCenter.dx - eyeRadius, rightEyeCenter.dy + eyeRadius - blinkTop, eyeRadius * 2, blinkBottom), eyelidPaint);
        break;
      case 2: // Ojos semiabiertos
        // Dibujar párpado superior solo
        canvas.drawArc(Rect.fromCircle(center: leftEyeCenter, radius: eyeRadius), 0, math.pi, false, eyelidPaint);
        canvas.drawArc(Rect.fromCircle(center: rightEyeCenter, radius: eyeRadius), 0, math.pi, false, eyelidPaint);
        break;
      case 3: // Un ojo completamente cerrado y el otro medio cerrado
        // Dibujar párpado superior en un ojo y párpado inferior en otro
        canvas.drawRect(Rect.fromLTWH(leftEyeCenter.dx - eyeRadius, leftEyeCenter.dy - eyeRadius, eyeRadius * 2, eyeRadius * 2), eyelidPaint); // Ojo izquierdo cerrado
        canvas.drawRect(Rect.fromLTWH(rightEyeCenter.dx - eyeRadius, rightEyeCenter.dy, eyeRadius * 2, blinkBottom), eyelidPaint); // Párpado inferior en el ojo derecho
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
