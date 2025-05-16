
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/notificacion_model.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/dashboard/notifications_provider.dart';

import '../../../../../config/global/palet_colors.dart';

class Notify_card_widget extends StatelessWidget {
  const Notify_card_widget({
    super.key,
    required this.cardNotifyList,
  });

  final List<CardNotify> cardNotifyList;

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: cardNotifyList.isEmpty ?
          Center(
            child: Text(
              'No hay notificaciones',
              style:  TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ) : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cardNotifyList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 5),
              width: MediaQuery.of(context).size.width * 0.80,
              // margin: const EdgeInsets.only(right: 10.0),
              child: Stack(
                children: [
                  Card(
                    // margin: EdgeInsets.only(top: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: cardNotifyList[index].color,
                    child: Center(
                      child: ListTile(

                        leading: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:  FadeInImage.assetNetwork(
                            placeholder: 'assets/icon/logovs.png',
                            image: '$imagenUrlGlobal${cardNotifyList[index].img}',
                            fit: BoxFit.contain,
                            fadeInDuration: Duration(milliseconds: 200),
                            fadeInCurve: Curves.easeIn,
                            alignment: Alignment.topCenter,
                          ),
                        ), // Icono a la izquierda
                        // title: Text(
                        //   cardNotifyList[index].titulo,
                        //   style:  TextStyle(
                        //     color: index.isEven ? Colors.white : Colors.black,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        title: AutoSizeText(
                          cardNotifyList[index].descripcion,
                          style:  TextStyle(
                            color: cardNotifyList[index].id.isEven ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          maxLines: 4,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    right: 25,
                    child: Row(
                      children: [
                        Text(cardNotifyList[index].hora,
                          style:  TextStyle(
                            color: cardNotifyList[index].id.isEven ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 106, 85),
                              borderRadius: BorderRadius.circular(15)),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 13,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => _showModalAccitionsNotify(context,sizeScreen, cardNotifyList[index]),
                        child: Icon(
                          Iconsax.more,
                          color: cardNotifyList[index].id.isEven ? Colors.white : Colors.black,
                        ),
                      ),
                  )
                ]
              ),
            );
          }),
    );
  }
}

void _showModalAccitionsNotify(BuildContext context, Size sizeScreen, CardNotify cardNotify) {
  final userEmpProvider = context.read<NotificationsProvider>();

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Contenido del ModalBottomSheet
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: sizeScreen.width * 0.08,
                  height: 1.5,
                  color: ColorPalet.grisesGray2,
                ),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Row(
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/icon/logovs.png',
                        image: '$imagenUrlGlobal${cardNotify.img}',
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 200),
                        fadeInCurve: Curves.easeIn,
                        alignment: Alignment.topCenter,
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: sizeScreen.width*0.65,
                        child: AutoSizeText(
                          cardNotify.descripcion,
                          style: TextStyle(
                              color: ColorPalet.grisesGray1,
                              fontFamily: 'inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          maxLines: 3,
                        ),
                      )


                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Text(cardNotify.hora,
                          style:  TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 106, 85),
                              borderRadius: BorderRadius.circular(15)),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),
              SizedBox(
                height: sizeScreen.height * 0.05,
                width: sizeScreen.width,
                child: ElevatedButton(
                    onPressed: () async {
                      bool success = await userEmpProvider.marcarLeidoNotificacion(cardNotify.id);
                      Navigator.of(context).pop();
                      if (success) {
                        mostrarFichaCreada(context, 'La notificación ha sido eliminado.');
                      } else {
                        mostrarFichaCreada(context, 'Error al actualizar el nombre.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Row(
                      children: [
                        Icon(
                          Iconsax.trash,
                          color: ColorPalet.grisesGray0,
                        ),
                        SizedBox( width: 7),
                        Text(
                          'Eliminar esta notificación',
                          style: TextStyle(
                              color: ColorPalet.grisesGray0,
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                    ),
              ),
              SizedBox( height: 10),

              SizedBox(
                height: sizeScreen.height * 0.05,
                width: sizeScreen.width,
                child: ElevatedButton(
                    onPressed: () async {
                      bool success = await userEmpProvider.marcarLeidoNotificacion(cardNotify.id);
                      Navigator.of(context).pop();
                      if (success) {
                        mostrarFichaCreada(context, 'Notificación leida.');
                      } else {
                        mostrarFichaCreada(context, 'Error al actualizar la notificación.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child:  Row(
                      children: [
                        Icon(
                          Iconsax.notification_1,
                          color: ColorPalet.grisesGray0,
                        ),
                        SizedBox( width: 7),
                        Text(
                          'Marcar como vista',
                          style: TextStyle(
                              color: ColorPalet.grisesGray0,
                              fontFamily: 'inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}