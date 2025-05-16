import 'package:flutter/material.dart';

class ImageWidgetURL extends StatelessWidget {
  final String imageUrl;
  final String placeholderImage;
  final double width;
  final double height;

  const ImageWidgetURL({
    Key? key,
    required this.imageUrl,
    required this.placeholderImage,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: FadeInImage.assetNetwork(
        placeholder: placeholderImage,
        image: imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration(milliseconds: 200),
        fadeInCurve: Curves.easeIn,
        alignment: Alignment.topCenter,
        width: width,
        height: height,
      ),
    );
  }
}
