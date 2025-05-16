import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

Widget calendarDetail(BuildContext context) {
  const List<String> dayTitle = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'];
  const List<String> dayTime = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'];
  Map<String, List<DateTimeRange>> daySchedule = {
    'Lunes': [
      DateTimeRange(start: DateTime(2023, 10, 23, 9, 0), end: DateTime(2023, 10, 23, 18, 0)),
    ],
    'Martes': [
      DateTimeRange(start: DateTime(2023, 10, 23, 9, 0), end: DateTime(2023, 10, 23, 18, 0)),
    ],
    'Miercoles': [
      DateTimeRange(start: DateTime(2023, 10, 24, 9, 0), end: DateTime(2023, 10, 24, 14, 30)),
    ],
    'Jueves': [],
    'Viernes': [
      DateTimeRange(start: DateTime(2023, 10, 26, 9, 0), end: DateTime(2023, 10, 26, 13, 0)),
      DateTimeRange(start: DateTime(2023, 10, 26, 17, 0), end: DateTime(2023, 10, 26, 19, 0)),
    ],
    'Sabado': [],
    'Domingo': [
      DateTimeRange(start: DateTime(2023, 10, 24, 9, 0), end: DateTime(2023, 10, 24, 14, 30)),
    ],
  };

  return SizedBox(
    width: double.infinity,
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var time in dayTime)
                  SizedBox(
                    height: 44,
                    child: Text(
                      time,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray2),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
            for (var day in dayTitle)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var time in dayTime)
                    SizedBox(
                      height: 44,
                      width: 20,
                      child: daySchedule[day]!.isEmpty ? const Text('') : _buildScheduleCell(daySchedule[day]!, time),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ),
        for (var time in dayTime)
          Positioned(
            top: (dayTime.indexOf(time) * 44.0) + 6,
            left: 75,
            right: 0,
            child: Row(
              children: List.generate(
                1000 ~/ 10,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : ColorPalet.grisesGray2.withOpacity(0.5),
                    height: 1,
                  ),
                ),
              ),
            ),
            // style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorPalet.grisesGray2.withOpacity(0.2))),
          ),
      ],
    ),
  );
}

Widget _buildScheduleCell(List<DateTimeRange> schedule, String time) {
  for (var range in schedule) {
    if (range.start.hour <= int.parse(time.split(':')[0]) && range.end.hour >= int.parse(time.split(':')[0])) {
      return Container(
        decoration: BoxDecoration(
          color: ColorPalet.grisesGray2.withOpacity(0.2),
          borderRadius: (range.end.hour == int.parse(time.split(':')[0]))
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
              : (range.start.hour == int.parse(time.split(':')[0]))
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )
                  : null,
        ),
      );
    }
  }
  return const Text('');
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
