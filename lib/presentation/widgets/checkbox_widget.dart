import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/clinica/consulta/consulta_provider.dart';

/* 
class CheckboxReutilizable extends StatelessWidget {

  final String title;
  
  const CheckboxReutilizable({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    
    final checkboxProvider = Provider.of<ConsultaProvider>(context);

    return Container(
      
      width: double.infinity,
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color.fromARGB(255, 26, 202, 212),
            fillColor: MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            ),
            value: checkboxProvider.valueClinicacBoxUno,
            onChanged: (newValue) {
              checkboxProvider.setClinicacboxUno();
            },
              
          ),
          GestureDetector(
            onTap: (){
              checkboxProvider.setClinicacboxUno();
            },
            child: Text(title,
              style: TextStyle(
                color: !checkboxProvider.valueClinicacBoxUno ? Color.fromARGB(255, 72, 86, 109) : Color.fromARGB(255, 29, 34, 44),
                fontWeight: !checkboxProvider.valueClinicacBoxUno ? FontWeight.w400 : FontWeight.w500,
                fontFamily: 'inter',
                fontSize: 14
              ),
            )
          )
        ],
      ),
    );
  }
}
 */