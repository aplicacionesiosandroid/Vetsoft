import 'package:flutter/material.dart';

class PetshopScreen extends StatefulWidget {
  const PetshopScreen({super.key});

  @override
  State<PetshopScreen> createState() => _PetshopScreenState();
}

class _PetshopScreenState extends State<PetshopScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Petshop'),
    );
  }
}