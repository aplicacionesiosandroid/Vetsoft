import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget avanceEmpleado(
  BuildContext context,
  String fotoEmpleado,
  String nombre,
  int porcentaje,
) {
  return Container(
    margin: const EdgeInsets.only(left: 30),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorPalet.grisesGray3,
              width: 2,
            ),
            color: ColorPalet.grisesGray3,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 26,
            child: ClipOval(
              child: Image.network(
                fotoEmpleado,
                width: 26,
                height: 26,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        _buildPercentage(context, porcentaje),
      ],
    ),
  );
}

Widget _buildPercentage(BuildContext context, int porcentaje) {
  return Container(
    width: 25,
    height: 350 * porcentaje / 100 + 10,
    decoration: BoxDecoration(
      color: ColorPalet.grisesGray3,
      borderRadius: BorderRadius.circular(25),
    ),
    child: FractionallySizedBox(
      heightFactor: porcentaje / 100,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalet.grisesGray3,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  );
}
