import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;
  final String? hintText;
  final bool? validar;

  CustomDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
    this.validar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(220, 249, 249, 249),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if(validar == null || validar == true){
            if (value == null || value.isEmpty) {
              return 'Selecciona una opción';
            }
          }
          return null;
        },
        icon: Icon(CupertinoIcons.chevron_down),
        isExpanded: false,
        style: TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        hint: Text(
          hintText!,
          style: TextStyle(
              color: Color.fromARGB(255, 139, 149, 166),
              fontSize: 15,
              fontFamily: 'inter'),
        ),
      ),
    );
  }
}

class CustomDropdownSize extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;
  final String? hintText;

  CustomDropdownSize({
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(220, 249, 249, 249),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Seleccione un tamaño';
          }
          return null;
        },
        icon: Icon(CupertinoIcons.chevron_down),
        isExpanded: false,
        style: TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option == "G" ? "Grande" : option == "M" ? "Mediano" : "Pequeño",
            ),
          );
        }).toList(),
        hint: Text(
          hintText!,
          style: TextStyle(
              color: Color.fromARGB(255, 139, 149, 166),
              fontSize: 15,
              fontFamily: 'inter'),
        ),
      ),
    );
  }
}

class CustomDropdownTemperament extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;
  final String? hintText;

  CustomDropdownTemperament({
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(220, 249, 249, 249),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Selecciona un temperamento';
          }
          return null;
        },
        icon: Icon(CupertinoIcons.chevron_down),
        isExpanded: false,
        style: TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option == "S" ? "Sociable" : option == "C" ? "Complicado" : option == "A" ? "Agresivo" : "Maltratado",
            ),
          );
        }).toList(),
        hint: Text(
          hintText!,
          style: TextStyle(
              color: Color.fromARGB(255, 139, 149, 166),
              fontSize: 15,
              fontFamily: 'inter'),
        ),
      ),
    );
  }
}

class CustomDropdownFood extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;
  final String? hintText;

  CustomDropdownFood({
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(220, 249, 249, 249),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Selecciona un tipo de comida';
          }
          return null;
        },
        icon: Icon(CupertinoIcons.chevron_down),
        isExpanded: false,
        style: TextStyle(
            color: Color.fromARGB(255, 139, 149, 166),
            fontSize: 15,
            fontFamily: 'inter'),
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option == "C" ? "Casera" : option == "M" ? "Mixta" : "Balanceada",
            ),
          );
        }).toList(),
        hint: Text(
          hintText!,
          style: TextStyle(
              color: Color.fromARGB(255, 139, 149, 166),
              fontSize: 15,
              fontFamily: 'inter'),
        ),
      ),
    );
  }
}
