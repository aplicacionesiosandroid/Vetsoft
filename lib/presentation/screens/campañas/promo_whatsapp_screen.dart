import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';

import '../../../../config/global/palet_colors.dart';
import '../../../providers/campanas/campain_provider.dart';
import '../../widgets/campain/radio_button__campain.dart';

class PromoWhatsappScreen extends StatelessWidget {
  PromoWhatsappScreen({super.key});

  TextEditingController contactosSearch = TextEditingController();
  TextEditingController controlletMensajePromoWsp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final campanaProvider = Provider.of<CampainProvider>(context);

    return Scaffold(
        //bottomNavigationBar: const BottomNavigationBarWidget(),
        body: ListView(children: [
      Container(
        height: size.height * 0.03,
        decoration: const BoxDecoration(
          color: ColorPalet.complementViolet3,
        ),
      ),
      Container(
        color: ColorPalet.complementViolet3,
        child: Container(
          height: size.height * 0.15,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/img/darksecondaryback.png'), // Ruta de la imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
            //color: ColorPalet.complementVerde1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enviar Promoción por WhatsApp',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                'Crear mensaje de Promoción',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'sans',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
      Container(
        color: ColorPalet.secondaryDark,
        child: Container(
          padding: EdgeInsets.all(15),
          height: size.height * 0.8,
          width: size.width,
          decoration: const BoxDecoration(color: ColorPalet.backGroundColor),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _separacionCampos(20),
                _NombreCampos('Enviar'),
                _separacionCampos(14),
                RadioButtonReutilizableContactosPromoWhatsapp(
                  text: 'Enviar a todos los contactos',
                  valor: '1',
                ),
                RadioButtonReutilizableContactosPromoWhatsapp(
                  text: 'Seleccionar contactos',
                  valor: '2',
                ),
                _separacionCampos(20),
                campanaProvider.selectedContactos == '2'
                    ? TextFormField(
                        controller: contactosSearch,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.search_normal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 177, 173, 255),
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Buscar registros',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 139, 149, 166),
                              fontSize: 15,
                              fontFamily: 'inter'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(220, 249, 249, 249),
                          filled: true,
                        ),
                        onChanged: (query) {
                          final listaFiltradaProvider =
                              Provider.of<CampainProvider>(context,
                                  listen: false);
                          listaFiltradaProvider.filtrarListaContacts(
                              campanaProvider.getcontactos, query);
                        },
                      )
                    : Container(),
                campanaProvider.listaDeContactosFilter.isNotEmpty &&
                        campanaProvider.mostrarLista
                    ? Container(
                        height: 300,
                        child: Consumer<CampainProvider>(
                          builder: (context, provider, child) {
                            final listaContactos =
                                provider.listaDeContactosFilter;
                            return ListView.builder(
                              itemCount: listaContactos.length,
                              itemBuilder: (BuildContext context, int index) {
                                final contacto = listaContactos[index];
                                final isSelected = provider
                                    .isSelectedContact(contacto.contactoId);

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/img/user.png'),
                                  ),
                                  title: Text(
                                    contacto.nombres,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Color.fromARGB(255, 99, 92, 255)
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    contacto.nombres +
                                        contacto.apellidos.toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w400,
                                      color: isSelected
                                          ? Color.fromARGB(255, 139, 149, 166)
                                          : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color:
                                              Color.fromARGB(255, 99, 92, 255))
                                      : null,
                                  onTap: () {
                                    provider.toggleSelectionContact(
                                        contacto.contactoId);

                                    print(provider.selectedContactList.length);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
                _separacionCampos(20),
                _NombreCampos('Crear mensaje'),
                _separacionCampos(20),
                TextFormFieldMaxLinesConHint(
                    hintText: 'Mensaje',
                    controller: controlletMensajePromoWsp,
                    maxLines: 6,
                    colores: ColorPalet.secondaryLight),
                _separacionCampos(20),
                ElevatedButton(
                  onPressed: () async {
                    campanaProvider.openGalleryImgWsp();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPalet.secondaryLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: 40,
                    child: Row(
                      children: [
                        Icon(Iconsax.image),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          campanaProvider.selectedNombreImagen == ''
                              ? 'Cargar imagen'
                              : campanaProvider.selectedNombreImagen,
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _separacionCampos(25),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      campanaProvider
                          .enviarDatosCrearPromoWsp(
                              campanaProvider.selectedContactList,
                              controlletMensajePromoWsp.text,
                              campanaProvider.selectedFilePath)
                          .then((_) async {
                        if (campanaProvider.OkpostDatosCrearpromoWsp) {
                          _mostrarFichaCreada(context, '¡Promoción creada!');
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorPalet.acentDefault,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: campanaProvider.loadingDatosPromoWsp
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Enviar',
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }

  Text _NombreCampos(String texto) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: ColorPalet.grisesGray0,
          fontSize: 15,
          fontWeight: FontWeight.w500),
    );
  }

  Widget _separacionCampos(double valor) {
    return SizedBox(
      height: valor,
    );
  }

  void _mostrarFichaCreada(BuildContext context, String textoMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 28, 149, 187),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        content: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10), // Ajusta el espacio izquierdo
              Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              Text(
                textoMessage,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
              ),
              Icon(
                Icons.close,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 10), // Ajusta el espacio derecho
            ],
          ),
        ),
      ),
    );
  }
}
