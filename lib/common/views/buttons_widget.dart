import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final Color? overlayColor;
  final BorderSide? borderSide;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.textColor,
    this.overlayColor,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          overlayColor: overlayColor != null
              ? MaterialStateProperty.all(overlayColor)
              : null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: borderSide ??
                  BorderSide.none, // Aplica borde si se proporciona
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
