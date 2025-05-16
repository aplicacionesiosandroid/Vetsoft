class Horario {
  String nombreHorario;
  String tipoHorario;
  DateTime fechaInicio;
  DateTime fechaFin;

  Horario({
    required this.nombreHorario,
    required this.tipoHorario,
    required this.fechaInicio,
    required this.fechaFin,
  });

  static List<Map<String, List<Map<String, String>>>> transformDias(Jornada jornada) {
    List<Map<String, List<Map<String, String>>>> result = [];

    jornada.dias.forEach((key, value) {
      var day = key.toLowerCase();
      var timeRanges = value;
      List<Map<String, String>> timeRangesList = [];
      for (var element in timeRanges) {
        timeRangesList.add({
          'hora_inicio': element.startTime,
          'hora_fin': element.endTime,
        });
      }
      result.add({
        day: timeRangesList,
      });
    });
    return result;
  }
}

class HorarioFijo extends Horario {
  Map<String, TimeRange> dias;

  HorarioFijo({
    required String nombreHorario,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required this.dias,
  }) : super(
          nombreHorario: nombreHorario,
          tipoHorario: 'horario fijo',
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
}

class HorarioFlexible extends Horario {
  Map<String, int> horas;

  HorarioFlexible({
    required String nombreHorario,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required this.horas,
    required Map<String, List<TimeRange>> dias,
  }) : super(
          nombreHorario: nombreHorario,
          tipoHorario: 'horario flexible',
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
}

class Jornada extends Horario {
  Map<String, List<TimeRange>> dias;

  Jornada({
    required String nombreHorario,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required this.dias,
  }) : super(
          nombreHorario: nombreHorario,
          tipoHorario: 'jornada',
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
}

class TimeRange {
  String startTime;
  String endTime;

  TimeRange({required this.startTime, required this.endTime});
}
