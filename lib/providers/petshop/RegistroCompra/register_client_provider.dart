import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/models/petshop/registroCompra/client_model.dart';
import 'package:http/http.dart' as http;

import '../../../config/global/global_variables.dart';

class RegistroClienteProvider extends StatelessWidget {
  final Widget child;

  RegistroClienteProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegistroClienteModel(),
      child: child,
    );
  }

 
  static RegistroClienteModel of(BuildContext context) {
    return context.watch<RegistroClienteModel>();
  }
}
