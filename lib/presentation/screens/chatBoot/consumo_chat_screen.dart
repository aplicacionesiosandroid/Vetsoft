import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/global/palet_colors.dart';

class ConsumoChatBootScreen extends StatelessWidget {
  const ConsumoChatBootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF007AA2),
        body: SizedBox(
          height: sizeScreen.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: sizeScreen.height * 0.03,
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                height: sizeScreen.height * 0.929,
                width: sizeScreen.width,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: IconButton(
                                iconSize: 35,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Iconsax.arrow_left))),
                        SizedBox(
                          width: sizeScreen.width * 0.2,
                        ),
                        Text('Consumos',
                            style: TextStyle(
                                color: ColorPalet.grisesGray0,
                                fontFamily: 'sans',
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          height: 164,
                          width: sizeScreen.width * 0.43,
                          decoration: BoxDecoration(
                            color: Color(0xFF006788),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF0085AF),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: Icon(Iconsax.chart_21),
                                    color: ColorPalet.grisesGray5,
                                    onPressed: () {},
                                  )),
                              const Text(
                                '\$15,34',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                'Esta semana',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          height: 164,
                          width: sizeScreen.width * 0.43,
                          decoration: BoxDecoration(
                            color: Color(0xFF1C95BB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF21A3CC),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: Icon(Iconsax.chart_21),
                                    color: ColorPalet.grisesGray5,
                                    onPressed: () {},
                                  )),
                              const Text(
                                '\$234,43',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                'Este mes',
                                style: TextStyle(
                                    color: ColorPalet.grisesGray5,
                                    fontFamily: 'inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Esta semana',
                        style: TextStyle(
                            color: ColorPalet.grisesGray1,
                            fontFamily: 'sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Text(
                            'Día',
                            style: TextStyle(
                                color: ColorPalet.grisesGray2,
                                fontFamily: 'inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            'Consumo',
                            style: TextStyle(
                                color: ColorPalet.grisesGray2,
                                fontFamily: 'inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: 200,
                      child: ListView(
                        children: [
                          listConsumoWidget(
                              '9 de mayo, 2022', '10:35 PM', '\$0,55'),
                          Divider(),
                          listConsumoWidget(
                              '4 de septiembre, 2021', '09:35 AM', '\$0,85'),
                          Divider(),
                          listConsumoWidget(
                              '16 de julio, 2023', '11:39 PM', '\$0,65'),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding listConsumoWidget(String fecha, String hora, String monto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fecha,
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontFamily: 'inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                hora,
                style: TextStyle(
                    color: ColorPalet.grisesGray2,
                    fontFamily: 'inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Spacer(),
          Text(
            monto,
            style: TextStyle(
                color: ColorPalet.grisesGray0,
                fontFamily: 'sans',
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  InkWell _accountOptionProfilWidget(Size sizeScreen, VoidCallback funcion,
      IconData icono, String nombre, String titulo) {
    return InkWell(
      onTap: funcion,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: sizeScreen.height * 0.1,
        width: sizeScreen.width,
        decoration: BoxDecoration(
            color: ColorPalet.backGroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: ColorPalet.grisesGray3)),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icono,
              size: 30,
              color: ColorPalet.secondaryLight,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titulo != ''
                    ? Text(
                        titulo,
                        style: TextStyle(
                            fontFamily: 'inter',
                            color: ColorPalet.grisesGray2,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    : Container(),
                Text(
                  nombre,
                  style: TextStyle(
                      fontFamily: 'inter',
                      color: ColorPalet.grisesGray0,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: ColorPalet.grisesGray1,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
