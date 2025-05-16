import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/models/company/company_model.dart';
import 'package:vet_sotf_app/presentation/screens/cuentas/widget/whatsapp_bussiness.dart';
import 'package:vet_sotf_app/presentation/widgets/textFormFieldsTypes_widget.dart';
import 'package:vet_sotf_app/providers/account/account_empleado_provider.dart';
import 'package:vet_sotf_app/providers/account/company_data_provider.dart';
import 'package:vet_sotf_app/providers/account/user_provider.dart';
import 'package:vet_sotf_app/providers/clinica/cirugia/cirugia_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/global/palet_colors.dart';

class GestionEmpScreen extends StatelessWidget {
  GestionEmpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmpProvider = context.read<UserEmpProvider>();
    return FutureBuilder(
      future: Future.wait([
        context.read<CompanyProvider>().obtainCompanyInfo(),
        userEmpProvider.obtieneTipoFicha(),
      ]),
      builder: (context, snapshot) {
        final companyInfoProvider = Provider.of<CompanyProvider>(context);
        final dataCompany = companyInfoProvider.company;
        final sizeScreen = MediaQuery.of(context).size;
        final dataEmpProvider = Provider.of<AccountEmpProvider>(context);
        final empresaUser = Provider.of<UserEmpProvider>(context);

        return SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 99, 92, 255),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sizeScreen.height * 0.03,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    height: sizeScreen.height * 0.925,
                    width: sizeScreen.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              const SizedBox(
                                width: 5,
                              ),
                              const Row(
                                children: [
                                  Text('Gestión de empresa',
                                      style: TextStyle(
                                          color: ColorPalet.grisesGray0,
                                          fontFamily: 'sans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ],
                              )
                            ],
                          ),
                          snapshot.connectionState != ConnectionState.waiting
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          "Información básica",
                                          style: TextStyle(
                                              fontFamily: 'inter',
                                              color: Color.fromARGB(
                                                  255, 139, 149, 166),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      _accountOptionProfilWidget(
                                          sizeScreen,
                                          () => _showModalEditNameBussines(
                                              context, sizeScreen),
                                          Iconsax.personalcard,
                                          '${dataCompany?.nameCompany.replaceRange(0, 1, dataCompany.nameCompany.substring(0, 1).toUpperCase())}',
                                          'Nombre de la empresa:'),
                                      _accountOptionProfilWidget(
                                          sizeScreen,
                                          () => print('datos de cuenta'),
                                          Iconsax.document_text,
                                          '${dataCompany?.licenses}',
                                          'Tipo de licencia:'),
                                      _firmaElectronicaWidgetSwitchButton(
                                          dataEmpProvider,
                                          context,
                                          dataEmpProvider
                                              .isSwitchedNotificationFacElectronica,
                                          1,
                                          sizeScreen,
                                          () =>
                                              _showModalFacturacionElectronicaCompany(
                                                  context,
                                                  sizeScreen,
                                                  companyInfoProvider),
                                          Iconsax.receipt_2_1,
                                          '${dataCompany?.nitFactura == 'sin numero' || dataCompany?.nitFactura == '' ? 'Sin número' : dataCompany?.nitFactura}',
                                          'Facturación eletrónica:'),
                                      _firmaElectronicaWidgetSwitchButton(
                                        dataEmpProvider,
                                        context,
                                        dataEmpProvider
                                            .isSwitchedNotificationPasarelaPagos,
                                        2,
                                        sizeScreen,
                                        () {
                                          print('datos de cuenta');
                                        },
                                        Iconsax.empty_wallet_change,
                                        '${dataCompany?.pasarelaPagos == 'sin numero' || dataCompany?.pasarelaPagos == '' ? 'Sin número' : dataCompany?.pasarelaPagos}',
                                        'Pasarela de pagos:',
                                      ),
                                      _firmaElectronicaWidgetSwitchButton(
                                          dataEmpProvider,
                                          context,
                                          dataEmpProvider
                                              .isSwitchedNotificationWhatsappBuss,
                                          3,
                                          sizeScreen,
                                          () => _showModalWhatsApp(context,
                                              sizeScreen, companyInfoProvider),
                                          Iconsax.call,
                                          '${dataCompany?.whatsapp == 'sin numero' || dataCompany?.whatsapp == '' ? 'Sin número' : dataCompany?.whatsapp}',
                                          'WhatsApp Bussiness:'),
                                      _firmaElectronicaWidgetSwitchButton(
                                        dataEmpProvider,
                                        context,
                                        dataEmpProvider
                                            .isSwitchedNotificationFirmaEmpresa,
                                        4,
                                        sizeScreen,
                                        () => _showModalSignatureCompany(
                                            context,
                                            sizeScreen,
                                            companyInfoProvider),
                                        Iconsax.path,
                                        'Firma electrónica',
                                        '',
                                      ),
                                      _accountOptionProfilWidget(sizeScreen,
                                          () {
                                        empresaUser.setTipoFichaRadio(
                                            empresaUser.fichaNormal
                                                ? 'parametrica'
                                                : 'normal');
                                        _openModalBottomFicha(context);
                                      },
                                          Iconsax.hospital,
                                          empresaUser.fichaNormal
                                              ? 'Ficha parametrizada'
                                              : 'Ficha clínica',
                                          'Ficha de clínica:'),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      top: sizeScreen.height * 0.3),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xFF635CFF))))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showModalEditNameBussines(BuildContext context, Size sizeScreen) {
  final TextEditingController nameEmpresaController = TextEditingController();

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
              SizedBox(height: 20.0),
              Text(
                'Cambiar nombre de la empresa',
                style: TextStyle(
                    color: ColorPalet.grisesGray0,
                    fontFamily: 'sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20.0),
              Text(
                'Nuevo nombre de la empresa',
                style: TextStyle(
                    color: ColorPalet.grisesGray1,
                    fontFamily: 'inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15.0),
              TextFormFieldConHint(
                  controller: nameEmpresaController,
                  hintText: 'Escriba aquí el nuevo nombre de la empresa',
                  colores: ColorPalet.secondaryLight),
              SizedBox(height: 20.0),
              SizedBox(
                height: sizeScreen.height * 0.05,
                width: sizeScreen.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final companyProvider =
                          Provider.of<CompanyProvider>(context, listen: false);
                      bool success = await companyProvider
                          .changeNameCompany(nameEmpresaController.text.trim());
                      Navigator.of(context).pop();
                      if (success) {
                        mostrarFichaCreada(context, 'Nombre actualizado.');
                      } else {
                        mostrarFichaCreada(
                            context, 'Error al actualizar el nombre.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 115, 92, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text(
                      'Guardar cambios',
                      style: TextStyle(
                          color: ColorPalet.grisesGray5,
                          fontFamily: 'inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 28, 149, 187),
                        fontFamily: 'inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showModalWhatsApp(BuildContext context, Size sizeScreen,
    CompanyProvider companyInfoProvider) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int idCliente = prefs.getInt('idCliente') ?? 0;
  print('id: $idCliente');
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        height:
            sizeScreen.height * 0.65, // Ajuste de altura al 70% de la pantalla
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Contenido del ModalBottomSheet
          child: CrmModal(keyStatus: idCliente.toString()),
        ),
      );
    },
    isScrollControlled: true, // Permite que el modal sea de tamaño completo
  );
}

void _showModalSignatureCompany(BuildContext context, Size sizeScreen,
    CompanyProvider companyInfoProvider) {
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
          child: FormularioSignature());
    },
  );
}

class FormularioSignature extends StatefulWidget {
  @override
  _FormularioSignatureState createState() => _FormularioSignatureState();
}

class _FormularioSignatureState extends State<FormularioSignature> {
  CompanyProvider?
      _companyProvider; // Variable para almacenar una referencia a CompanyProvider
  String urlSignature = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guarda una referencia a CompanyProvider
    _companyProvider ??= Provider.of<CompanyProvider>(context, listen: false);
    urlSignature = _companyProvider?.signature?.signature ?? "";
  }

  @override
  void dispose() {
    // Utiliza la referencia a CompanyProvider guardada para llamar a setearDatosSignature()
    _companyProvider?.setearDatosSignature();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.read<CompanyProvider>();

    return companyProvider.loadingSignature
        ? FutureBuilder(
            future: companyProvider.ObtieneNameSignature(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se espera
                return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()));
              } else {
                if (snapshot.hasError) {
                  // Manejar el caso de error
                  return Center(child: Text('Error al cargar la firma'));
                } else {
                  // Continúa construyendo el resto del formulario
                  urlSignature = _companyProvider?.signature?.signature ?? "";
                  return _buildFormulario();
                }
              }
            },
          )
        : _buildFormulario();
  }

  Widget _buildFormulario() {
    final sizeScreen = MediaQuery.of(context).size;
    final SignatureController controllerFirma = SignatureController(
        penStrokeWidth: 3,
        penColor: Colors.black,
        exportBackgroundColor: Colors.transparent);
    final companyProvider = Provider.of<CompanyProvider>(context);
    final sigantureInfo = companyProvider.signature;
    String nombreLegible = path.basename(companyProvider.fileNameStamp);
    bool success = false;
    return Container(
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
          SizedBox(height: 20.0),
          Text(
            'Editar firma electrónica',
            style: TextStyle(
                color: ColorPalet.grisesGray0,
                fontFamily: 'sans',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20.0),
          Text(
            'Firma electrónica',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorPalet.grisesGray6,
              ),
              height: 150,
              width: sizeScreen.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    urlSignature == ''
                        ? Signature(
                            controller: controllerFirma,
                            width: sizeScreen.width,
                            height: 150,
                            backgroundColor: ColorPalet.grisesGray6,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/icon/logovs.png',
                            image:
                                '$imagenUrlGlobal${sigantureInfo?.signature}',
                            fit: BoxFit.contain,
                            fadeInDuration: Duration(milliseconds: 200),
                            fadeInCurve: Curves.easeIn,
                            alignment: Alignment.topCenter,
                            width: sizeScreen.width,
                            height: 150,
                          ),
                    Positioned(
                        left: 5,
                        top: 5,
                        child: IconButton(
                            onPressed: () {
                              controllerFirma.clear();
                              setState(() {
                                urlSignature = "";
                              });
                            },
                            icon: Icon(Icons.clear)))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: sizeScreen.height * 0.10,
            width: sizeScreen.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorPalet.grisesGray6,
                  ),
                  width: sizeScreen.width * 0.2,
                  height: sizeScreen.height * 0.2,
                  child: sigantureInfo?.stamp != ''
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image: '$imagenUrlGlobal${sigantureInfo?.stamp}',
                          fit: BoxFit.contain,
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeInCurve: Curves.easeIn,
                          alignment: Alignment.center,
                          width: sizeScreen.width * 0.2,
                          height: sizeScreen.height * 0.2,
                        )
                      : SvgPicture.asset(
                          'assets/icon/fondo_img_gallery.svg', // Reemplaza 'assets/your_image.svg' con la ruta de tu imagen SVG
                          width: sizeScreen.width * 0.01,
                          height: sizeScreen.height * 0.01,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sello',
                        style: TextStyle(
                            color: ColorPalet.grisesGray1,
                            fontFamily: 'inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 45,
                        width: sizeScreen.width * 0.65,
                        decoration: BoxDecoration(
                            color: ColorPalet.grisesGray6,
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () async {
                            Future<String?> selectFile() async {
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                final path = result.files.single.path;
                                return path;
                              }
                              return null;
                            }

                            final fileName = await selectFile();
                            if (fileName != null) {
                              companyProvider.setfileNameStamp(fileName);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: sizeScreen.width * 0.45,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      nombreLegible == ''
                                          ? 'Seleccionar imagen'
                                          : '' + nombreLegible,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 139, 149, 166),
                                          fontFamily: 'sans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Iconsax.document_download,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: ColorPalet.gradientBottomCompany,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            height: sizeScreen.height * 0.05,
            width: sizeScreen.width,
            child: ElevatedButton(
                onPressed: () async {
                  final companyProvider =
                      Provider.of<CompanyProvider>(context, listen: false);
                  bool saveSignature = false;

                  if (controllerFirma.isNotEmpty) {
                    saveSignature = await companyProvider.saveSignature(
                        controllerFirma, sizeScreen);
                    if (saveSignature) {
                      success = await companyProvider.uploadImagesSignature();
                      if (success) {
                        // Navigator.of(context).pop();
                        // mostrarFichaCreada(context, 'Se actualizó correctamente.');
                        BotToast.showText(text: "Se actualizó correctamente");
                      } else {
                        // mostrarFichaCreada(context, 'No se actualizó correctamente.');
                        BotToast.showText(
                            text: 'No se actualizó correctamente.');
                      }
                    }
                  } else {
                    success = await companyProvider.uploadImagesSignature();
                    if (success) {
                      // Navigator.of(context).pop();
                      BotToast.showText(text: "Se actualizó correctamente");
                    } else {
                      BotToast.showText(text: 'No se actualizó correctamente.');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                      color: ColorPalet.grisesGray5,
                      fontFamily: 'inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                )),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(
                    color: const Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showModalFacturacionElectronicaCompany(BuildContext context,
    Size sizeScreen, CompanyProvider companyInfoProvider) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        height:
            sizeScreen.height * 0.9, // Ajuste de altura al 70% de la pantalla
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Contenido del ModalBottomSheet
          child: FormularioFirmaElectronica(),
        ),
      );
    },
    isScrollControlled: true, // Permite que el modal sea de tamaño completo
  );
}

class FormularioFirmaElectronica extends StatefulWidget {
  @override
  _FormularioFirmaElectronica createState() => _FormularioFirmaElectronica();
}

class _FormularioFirmaElectronica extends State<FormularioFirmaElectronica> {
  CompanyProvider? _companyProvider;
  late TaxpayerInfo facturacionElectronicaModel;

  // String urlSignature = "";
  // Declare the controllers at the class level
  late TextEditingController numeroNit;
  late TextEditingController contribuyente;
  late TextEditingController domicilioTributario;
  late TextEditingController granActividad;
  late TextEditingController actividadPrincipal;
  late TextEditingController tipoContribuyente;

  @override
  void initState() {
    // final companyProvider = Provider.of<CompanyProvider>(context, listen:false);
    // final facturacionElectronica = companyProvider.datosfacturacion;
    // numeroNit = TextEditingController(text: facturacionElectronica?.numeroNit ?? '');
    // contribuyente = TextEditingController(text: facturacionElectronica?.contribuyente ?? '');
    // domicilioTributario = TextEditingController(text: facturacionElectronica?.domicilioTributario ?? '');
    // granActividad = TextEditingController(text: facturacionElectronica?.granActividad ?? '');
    // actividadPrincipal = TextEditingController(text: facturacionElectronica?.actividadPrincipal ?? '');
    // tipoContribuyente = TextEditingController(text: facturacionElectronica?.tipoContribuyente ?? '');

    // Initialize the controllers with empty strings or desired default values
    numeroNit = TextEditingController();
    contribuyente = TextEditingController();
    domicilioTributario = TextEditingController();
    granActividad = TextEditingController();
    actividadPrincipal = TextEditingController();
    tipoContribuyente = TextEditingController();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Guarda una referencia a CompanyProvider
  //   _companyProvider ??= Provider.of<CompanyProvider>(context, listen: false);
  //   urlSignature = _companyProvider?.signature?.signature ?? "";
  // }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    numeroNit.dispose();
    contribuyente.dispose();
    domicilioTributario.dispose();
    granActividad.dispose();
    actividadPrincipal.dispose();
    tipoContribuyente.dispose();

    _companyProvider?.setearDatosSignature();
    _companyProvider?.loadingFacturacion = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.read<CompanyProvider>();
    // final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    // late TaxpayerInfo facturacionElectronicaModel;
    // late TextEditingController numeroNit;
    // late TextEditingController contribuyente;
    // late TextEditingController domicilioTributario;
    // late TextEditingController granActividad ;
    // late TextEditingController actividadPrincipal;
    // late TextEditingController tipoContribuyente;

    return FutureBuilder(
      future: companyProvider.ObtieneFirmaElectronica(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          // Manejar el caso de error
          return Center(child: Text('Error al cargar la firma'));
        } else {
          // Continúa construyendo el resto del formulario
          // urlSignature = _companyProvider?.signature?.signature ?? "";

          return _buildFormulario();
        }
      },
    );
  }

  Widget _buildFormulario() {
    final sizeScreen = MediaQuery.of(context).size;
    // final companyProvider = Provider.of<CompanyProvider>(context);
    final companyProvider = context.read<CompanyProvider>();

    final facturacionElectronica = companyProvider.datosfacturacion;
    // var facturacionElectronica = companyProvider.datosfacturacion;
    numeroNit.text = facturacionElectronica?.numeroNit ?? '';
    contribuyente.text = facturacionElectronica?.contribuyente ?? '';
    domicilioTributario.text =
        facturacionElectronica?.domicilioTributario ?? '';
    granActividad.text = facturacionElectronica?.granActividad ?? '';
    actividadPrincipal.text = facturacionElectronica?.actividadPrincipal ?? '';
    tipoContribuyente.text = facturacionElectronica?.tipoContribuyente ?? '';

    String nombreLegible = path.basename(companyProvider.fileNameStamp);
    bool success = false;
    return Container(
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
          SizedBox(height: 20.0),
          Text(
            'Editar facturación electrónica',
            style: TextStyle(
                color: ColorPalet.grisesGray0,
                fontFamily: 'sans',
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20.0),
          Text(
            'Número de NIT',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: numeroNit,
              hintText: 'Escriba aquí el número de NIT',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Contribuyente',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: contribuyente,
              hintText: 'Escriba aquí el nombre del contribuyente',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Domicilio tributario',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: domicilioTributario,
              hintText: 'Escriba aquí el domicilio tributario',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Gran actividad',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: granActividad,
              hintText: 'Escriba aquí....',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Actividad principal',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: actividadPrincipal,
              hintText: 'Escriba aquí....',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Tipo contribuyente',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          TextFormFieldConHint(
              controller: tipoContribuyente,
              hintText: 'Escriba aquí....',
              colores: ColorPalet.grisesGray4),
          SizedBox(height: 20.0),
          Text(
            'Firma electrónica',
            style: TextStyle(
                color: ColorPalet.grisesGray1,
                fontFamily: 'inter',
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.0),
          Container(
            height: sizeScreen.height * 0.10,
            width: sizeScreen.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorPalet.grisesGray6,
                  ),
                  width: sizeScreen.width * 0.2,
                  height: sizeScreen.height * 0.2,
                  child: facturacionElectronica?.imagen != ''
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/icon/logovs.png',
                          image:
                              '$imagenUrlGlobal${facturacionElectronica?.imagen}',
                          // image: '${facturacionElectronica?.imagen}',
                          fit: BoxFit.contain,
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeInCurve: Curves.easeIn,
                          alignment: Alignment.center,
                          width: sizeScreen.width * 0.2,
                          height: sizeScreen.height * 0.2,
                        )
                      : SvgPicture.asset(
                          'assets/icon/fondo_img_gallery.svg', // Reemplaza 'assets/your_image.svg' con la ruta de tu imagen SVG
                          width: sizeScreen.width * 0.01,
                          height: sizeScreen.height * 0.01,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto del contribuyente',
                        style: TextStyle(
                            color: ColorPalet.grisesGray1,
                            fontFamily: 'inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 45,
                        width: sizeScreen.width * 0.65,
                        decoration: BoxDecoration(
                            color: ColorPalet.grisesGray6,
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () async {
                            Future<String?> selectFile() async {
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                final path = result.files.single.path;
                                return path;
                              }
                              return null;
                            }

                            final fileName = await selectFile();
                            if (fileName != null) {
                              companyProvider
                                  .setfileNameContribuyente(fileName);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: sizeScreen.width * 0.45,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      nombreLegible == ''
                                          ? 'Seleccionar imagen'
                                          : '' + nombreLegible,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 139, 149, 166),
                                          fontFamily: 'sans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Iconsax.document_download,
                                  size: 25,
                                  color: Color.fromARGB(255, 139, 149, 166),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: ColorPalet.gradientBottomCompany,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            height: sizeScreen.height * 0.05,
            width: sizeScreen.width,
            child: ElevatedButton(
                onPressed: () async {
                  final companyProvider =
                      Provider.of<CompanyProvider>(context, listen: false);
                  facturacionElectronicaModel = new TaxpayerInfo(
                      numeroNit: numeroNit.text,
                      contribuyente: contribuyente.text,
                      domicilioTributario: domicilioTributario.text,
                      granActividad: granActividad.text,
                      actividadPrincipal: actividadPrincipal.text,
                      tipoContribuyente: tipoContribuyente.text,
                      imagen: '');
                  // facturacionElectronicaModel.numeroNit = numeroNit.text;
                  // facturacionElectronicaModel.contribuyente = contribuyente.text;
                  // facturacionElectronicaModel.domicilioTributario = domicilioTributario.text;
                  // facturacionElectronicaModel.granActividad = granActividad.text;
                  // facturacionElectronicaModel.actividadPrincipal = actividadPrincipal.text;
                  // facturacionElectronicaModel.tipoContribuyente = tipoContribuyente.text;

                  success = await companyProvider
                      .uploadDatosFacturacion(facturacionElectronicaModel);
                  if (success) {
                    // Navigator.of(context).pop();
                    // mostrarFichaCreada(context, 'Se actualizó correctamente.');
                    BotToast.showText(text: "Se actualizó correctamente");
                  } else {
                    // mostrarFichaCreada(context, 'No se actualizó correctamente.');
                    BotToast.showText(text: 'No se actualizó correctamente.');
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                      color: ColorPalet.grisesGray5,
                      fontFamily: 'inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                )),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(
                    color: const Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _openModalBottomFicha(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      final userProvider = Provider.of<UserEmpProvider>(context);
      final sizeScreen = MediaQuery.of(context).size;

      return FractionallySizedBox(
        heightFactor: 0.65,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Scaffold(
                  body: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: sizeScreen.width * 0.10,
                            height: 1.5,
                            color: ColorPalet.grisesGray2,
                            margin: EdgeInsets.only(bottom: 15),
                          ),
                        ),
                        Text(
                          'Seleccionar ficha clínica',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 29, 34, 44),
                              fontFamily: 'sans',
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  activeColor: Color.fromARGB(255, 99, 92, 255),
                                  //fillColor:
                                  //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
                                  value: "normal",
                                  onChanged: (newValue) {
                                    userProvider.setTipoFichaRadio(newValue!);
                                  },
                                  groupValue: userProvider.tipoFicha,
                                ),
                                Text(
                                  "Ficha clínica",
                                  style: TextStyle(
                                      color: Color(0xff1D222C),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'inter',
                                      fontSize: 14),
                                )
                              ],
                            ),
                            Text(
                              "Formulario tradicional con casillas para llenar los problemas y diagnósticos, sin un registro detallado de la anamnesis. EI médico veterinario realiza las preguntas según su criterio.",
                              style: TextStyle(
                                  color: Color(0xff8B95A6),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'inter',
                                  fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: Color.fromARGB(255, 99, 92, 255),
                                  //fillColor:
                                  //    MaterialStatePropertyAll(Color.fromARGB(255, 26, 202, 212)),
                                  value: "parametrica",
                                  onChanged: (newValue) {
                                    userProvider.setTipoFichaRadio(newValue!);
                                  },
                                  groupValue: userProvider.tipoFicha,
                                ),
                                Text(
                                  "Ficha parametrizada",
                                  style: TextStyle(
                                      color: Color(0xff1D222C),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'inter',
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              "Formulario diseñado para cubrir requerimientos específicos en una consulta veterinaria, con preguntas estandarizadas que permiten un diagnóstico más preciso y completo.",
                              style: TextStyle(
                                  color: Color(0xff8B95A6),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'inter',
                                  fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                  bottomNavigationBar: SizedBox(
                    height: 100, // Altura deseada del bottomNavigationBar
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await userProvider.cambiarTipoFichaDato();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff635CFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: userProvider.isloading
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
                                  : const Text(
                                      'Guardar cambios',
                                      style: TextStyle(
                                          fontFamily: 'inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 28, 149, 187),
                                    fontFamily: 'inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

InkWell _accountOptionProfilWidget(Size sizeScreen, VoidCallback funcion,
    IconData icono, String? nombre, String titulo) {
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
          const SizedBox(
            width: 10,
          ),
          Icon(
            icono,
            size: 30,
            color: ColorPalet.secondaryLight,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titulo != ''
                  ? Text(
                      titulo,
                      style: const TextStyle(
                          fontFamily: 'inter',
                          color: ColorPalet.grisesGray2,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  : Container(),
              Text(
                nombre == 'null' ? '-' : nombre ?? '-',
                style: const TextStyle(
                    fontFamily: 'inter',
                    color: ColorPalet.grisesGray0,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: ColorPalet.grisesGray1,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}

InkWell _firmaElectronicaWidgetSwitchButton(
    AccountEmpProvider dataEmp,
    context,
    bool value,
    int switchValue,
    Size sizeScreen,
    funcion,
    IconData icono,
    String nombre,
    String titulo) {
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Function toggleSwitch;

  switchValue == 1
      ? toggleSwitch = dataEmp.toggleSwitchNotificationFacElectronica
      : switchValue == 2
          ? toggleSwitch = dataEmp.toggleSwitchNotificationPasarelaPagos
          : switchValue == 3
              ? toggleSwitch = dataEmp.toggleSwitchNotificationWhatsappBuss
              : toggleSwitch = dataEmp.toggleSwitchNotificationFirmaEmpresa;

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
          Switch(
            activeColor: ColorPalet.primaryDefault,
            thumbIcon: thumbIcon,
            value: value,
            onChanged: (value) {
              toggleSwitch();
            },
          ),
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
