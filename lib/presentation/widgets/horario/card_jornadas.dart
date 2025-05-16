import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget cardJornadas({
  required String name,
  required String role,
  required String scheduleType,
  required String dateRange,
  required String imageUrl,
  Color color = ColorPalet.grisesGray5,
  Color lineColor = Colors.red,
}) {
  return Card(
    margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 24.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 3, color: lineColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorPalet.grisesGray0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorPalet.grisesGray2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tipo de horario: $scheduleType',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorPalet.grisesGray2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.calendar_2,
                        size: 16,
                        color: ColorPalet.grisesGray2,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        dateRange,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 32,
                  height: 32,
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
          Positioned(
            top: -15,
            right: 0,
            child: Theme(
              data: ThemeData(
                popupMenuTheme: PopupMenuThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 1) {
                    print("Editar jornada laboral seleccionado");
                  } else if (value == 2) {
                    print("Eliminar jornada laboral seleccionado");
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 0,
                    enabled: false,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 3, color: lineColor),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Iconsax.edit),
                        SizedBox(width: 8.0),
                        Text('Editar jornada laboral'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Iconsax.trash),
                        SizedBox(width: 8.0),
                        Text('Eliminar jornada laboral'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
