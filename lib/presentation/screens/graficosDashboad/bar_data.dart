import 'package:vet_sotf_app/presentation/screens/graficosDashboad/individual_bar.dart';

class BarData {
  final double? sunAmount;
  final double? monAmount;
  final double? tueAmount;
  final double? wedAmount;
  final double? thurAmount;
  final double? friAmount;
  final double? satAmount;

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
    required this.satAmount,
  });

  List<IndividualBar> barData = [];

  void initializedBarData() {
    barData = [
      IndividualBar(x: 1, y: sunAmount??0),
      IndividualBar(x: 1, y: monAmount??0),
      IndividualBar(x: 1, y: tueAmount??0),
      IndividualBar(x: 1, y: wedAmount??0),
      IndividualBar(x: 1, y: thurAmount??0),
      IndividualBar(x: 1, y: friAmount??0),
      IndividualBar(x: 1, y: satAmount??0),
    ];
  }
}
