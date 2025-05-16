import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

void CustomBottomSheetModal(BuildContext context, Widget content) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajuste dinámico de altura
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              content, // Contenido dinámico
            ],
          ),
        ),
      );
    },
  );
}

class CustomToast {
  static showToast(String message,
      {Duration duration = const Duration(seconds: 2),
      Color backgroundColor = ColorPalet.secondaryDefault,
      Color textColor = Colors.white,
      double fontZise = 14}) {
    BotToast.showText(
      text: message,
      duration: duration,
      contentColor: backgroundColor,
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: fontZise,
      ),
    );
  }
}
