import 'package:flutter/material.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Horario'),
    );
  }
}