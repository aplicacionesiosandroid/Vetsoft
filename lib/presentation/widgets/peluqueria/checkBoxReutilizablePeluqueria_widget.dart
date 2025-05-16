import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/peluqueria/peluqueria_provider.dart';

class ReusableCheckboxCortePelo extends StatelessWidget {
  final String desc;
  final bool value;
  final Function(bool?) onChanged;

  const ReusableCheckboxCortePelo(
      {super.key,
      required this.desc,
      required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Consumer<PeluqueriaProvider>(
      builder: (context, checkboxModel, child) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.5),
              ),
              side: BorderSide(
                  color: Color.fromARGB(255, 99, 92, 255), width: 2),
              activeColor: Color.fromARGB(255, 99, 92, 255),
              value: value,
              onChanged: onChanged,

            ),
            Text(
              desc,
              style: const TextStyle(
                  fontFamily: 'inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 29, 39, 44)),
            )
          ],
        );
      },
    );
  }
}
