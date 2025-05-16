import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget employeeFile(
  BuildContext context,
  String profilePicture,
  String name,
  String rol,
  String status,
  String time,
  String message,
  String entranceFile,
  String exitFile,
  String assignedSchedule,
  Color color,
  Color colorText,
  double percentage, {
  bool clientButton = true,
  bool isExpanded = false,
  VoidCallback? onTap,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width, // 352.0, according to figma
    child: Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 28.0,
          bottom: 10.0,
          left: 28.0,
          right: 28.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: ClipOval(
                    child: Image.network(
                      profilePicture,
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
                const SizedBox(width: 20.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorText,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      rol,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorPalet.grisesGray2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                      color: ColorPalet.grisesGray2,
                      size: 24,
                    )),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorPalet.grisesGray2,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorPalet.grisesGray1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            LinearPercentIndicator(
              padding: const EdgeInsets.all(0),
              lineHeight: 10.0,
              percent: percentage,
              backgroundColor: color,
              progressColor: ColorPalet.grisesGray2,
              barRadius: const Radius.circular(16),
            ),
            const SizedBox(height: 20.0),
            if (isExpanded)
              Column(
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorPalet.grisesGray2,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Fichaje de entrada:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray2,
                        ),
                      ),
                      Text(
                        (entranceFile == '') ? 'Pendiente' : entranceFile,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Fichaje de salida:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray2,
                        ),
                      ),
                      Text(
                        (exitFile == '') ? 'Pendiente' : exitFile,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Horario asignado:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray2,
                        ),
                      ),
                      Text(
                        (assignedSchedule == '') ? 'Pendiente' : assignedSchedule,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalet.grisesGray1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20.0),
            if (clientButton)
              Container(
                height: 34,
                width: 128,
                decoration: BoxDecoration(
                  color: ColorPalet.grisesGray4,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: TextButton(
                  // TODO ADD BUTTON FUNCTIONALITY
                  onPressed: () {},
                  child: const Text(
                    'Pausar conteo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorPalet.secondaryDefault,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
