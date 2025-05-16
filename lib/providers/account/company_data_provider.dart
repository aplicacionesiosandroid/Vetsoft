import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:signature/signature.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/company/company_model.dart';

import '../../config/global/global_variables.dart';

class CompanyProvider extends ChangeNotifier {

  Company? _company;
  Company? get company => _company;

  Future<bool> obtainCompanyInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    final url = Uri.parse('${apiUrlGlobal}cuenta/informacion-empresa');

    try {

      final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'});


      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['error'] == false && jsonData['data'] != null) {
          // Actualiza la información del usuario en el provider
          final data = jsonData['data'];
          final companyInfo = CompanyInfo.fromRawJson(response.body);
          _company = companyInfo.data;
          notifyListeners();
          return true;
        } else {
          print('Error al obtener datos: ${response.body}');
          return false;
        }
      } else {
        print('Error en la solicitud POST. Código de estado: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error al intentar actualizar la información personal: $error');
      return false;
    }
  }

  //cambio de nombre empresa
  Future<bool> changeNameCompany(String name) async {
    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-nombre-empresa');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json',},
        body: jsonEncode({
          'nombre_empresa': name,
        }),
      );

      final jsonData = json.decode(response.body);
      print(response.body);
      if (jsonData['error'] == false && jsonData['data'] != null) {
        _company?.nameCompany = name;
        notifyListeners();
        return true;
      } else {
        print('Error al cambiar el nombre empresa: ${jsonData['message']}');
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar el nombre empresa: $e');
      return false;
    }
  }
  //Cargando archivo sello
  String _fileNameStamp = '';
  String get fileNameStamp => _fileNameStamp;

  void setfileNameStamp(String fileName) {
    _fileNameStamp = fileName;
    notifyListeners();
  }

  //Almacenando firma digital
  String _signatureImage = '';
  String get signatureImageFirma => _signatureImage;

  void setSignatureImageFirma(String image) {
    _signatureImage = image;
    notifyListeners();
  }



  SignatureInfo? _signature;
  SignatureInfo? get signature => _signature;

  bool _loadingSignature = true;
  bool get loadingSignature => _loadingSignature;
  set loadingSignature(bool value) => _loadingSignature = value;


  //obtiene imagenes firma
  Future<bool> ObtieneNameSignature() async {

    final url = Uri.parse('${apiUrlGlobal}cuenta/get-firma');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'});


      final jsonData = json.decode(response.body);
      print(response.body);
      if (jsonData['error'] == false && jsonData['data'] != null) {
        final companyInfoSignature = ApiResponse.fromRawJson(response.body);
        _signature = companyInfoSignature.data;
        loadingSignature = false;
        notifyListeners();
        return true;
      } else {
        print('Error al cambiar el nombre empresa: ${jsonData['message']}');
        loadingSignature = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar el nombre empresa: $e');
      loadingSignature = false;
      notifyListeners();
      return false;
    }
  }

  void setearDatosSignature(){

    // Eliminar la imagen del caché si existe
    if (_fileNameStamp.isNotEmpty) {
      File imageFile = File(_fileNameStamp);
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
    if (_signatureImage.isNotEmpty) {
      File imageFile = File(_signatureImage);
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
    _fileNameStamp = '';
    _signatureImage = '';
    loadingSignature = true;

  }

  //Cargando archivo foto contribuyente
  String _fileNameContribuyente = '';
  String get fileNameContribuyente => _fileNameContribuyente;

  void setfileNameContribuyente(String fileName) {
    _fileNameStamp = fileName;
    notifyListeners();
  }

  TaxpayerInfo? _datosfacturacion;
  TaxpayerInfo? get datosfacturacion => _datosfacturacion;

  bool _loadingFacturacion = true;
  bool get loadingFacturacion => _loadingFacturacion;
  set loadingFacturacion(bool value) => _loadingFacturacion = value;

  //obtiene facturacion electronica
  Future<bool> ObtieneFirmaElectronica() async {

    final url = Uri.parse('${apiUrlGlobal}cuenta/get-datos-facturacion');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'});


      final jsonData = json.decode(response.body);
      print("datos response facturacio ${response.body}");
      if (jsonData['error'] == false && jsonData['data'] != null) {
        TaxpayerApiResponse responses = TaxpayerApiResponse.fromRawJson(response.body);

        _datosfacturacion = responses.data;
        loadingFacturacion = false;
        notifyListeners();
        return true;
      } else {
        print('Error al cambiar el nombre empresa: ${jsonData['message']}');
        loadingFacturacion = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar el nombre empresa: $e');
      loadingFacturacion = false;
      notifyListeners();
      return false;
    }
  }



  Future<bool> saveSignature(SignatureController controller, Size sizedImg) async {
    if (controller.isNotEmpty) {
      final signature = await controller.toImage(width: sizedImg.width.toInt(), height: 200);

      final directory = await Directory.systemTemp;
      final imagePath = '${directory.path}/${DateTime.now().millisecond}/signature.png';

      final file = File(imagePath);
      final byteData = await signature!.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      /* if (await file.exists()) {
        await file.delete();
      } */
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      // Actualiza el estado de la firma en el provider
      setSignatureImageFirma(imagePath);
      return true;
    }
    return false;
  }

  bool loadingUpload = false;

  Future<bool> uploadImagesSignature() async {
    loadingUpload = true;
    // Lista para almacenar las rutas de las imágenes disponibles
    List<String> firmaPaths = [];
    List<String> selloPaths = [];

    //Token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    // Verificar si hay al menos una imagen disponible
      // Crear una nueva solicitud multipart
    var request = http.MultipartRequest('post',Uri.parse('${apiUrlGlobal}cuenta/post-firma'));
    request.headers.addAll(headers);


    // Verificar si hay una imagen de sello disponible
    if (fileNameStamp != null && fileNameStamp.isNotEmpty) {
      selloPaths.add(fileNameStamp);
      // Agregar las imágenes de sello a la solicitud
      for (String path in selloPaths) {
        File imageFile = File(path);
        if (await imageFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'archivo[sello][]',
              imageFile.path,
            ),
          );
        }
      }

    }

    // Verificar si hay una firma disponible
    if (signatureImageFirma != null && signatureImageFirma.isNotEmpty) {
      firmaPaths.add(signatureImageFirma);
      // Agregar las imágenes de firma a la solicitud
      for (String path in firmaPaths) {
        File imageFile = File(path);
        if (await imageFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'archivo[firma][]',
              imageFile.path,
            ),
          );
        }
      }
    }

    // Enviar la solicitud
    var response = await request.send();

    // Manejar la respuesta
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      // Verificar si la respuesta contiene la información esperada
      if (jsonResponse.containsKey('data')) {
        var data = jsonResponse['data'];
        _signature?.signature = data['firma'];
        _signature?.stamp = data['sello'];
      }
      notifyListeners();
      loadingUpload = false;
      return true;
    } else {
      print('Error al enviar imágenes: ${response.reasonPhrase}');
    }
    loadingUpload = false;
    return false;
  }

  Future<bool> uploadDatosFacturacion(TaxpayerInfo facturacionElectronicaModel) async {
    //Token
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    // Crear una nueva solicitud multipart
    var request = http.MultipartRequest('post',Uri.parse('${apiUrlGlobal}cuenta/actualizar-datos-facturacion'));
    request.headers.addAll(headers);


    // Verificar si hay una imagen de sello disponible
    if (fileNameStamp.isNotEmpty) {
      // Agregar las imágenes de sello a la solicitud
        File imageFile = File(fileNameStamp);
        if (await imageFile.exists()) {
            request.files.add(await http.MultipartFile.fromPath('imagen', imageFile.path,),);
        }
    }

    request.fields['numero_nit'] = facturacionElectronicaModel.numeroNit;
    request.fields['contribuyente'] = facturacionElectronicaModel.tipoContribuyente;
    request.fields['domicilio_tributario'] = facturacionElectronicaModel.domicilioTributario;
    request.fields['gran_actividad'] = facturacionElectronicaModel.granActividad;
    request.fields['actividad_principal'] = facturacionElectronicaModel.actividadPrincipal;
    request.fields['tipo_contribuyente'] = facturacionElectronicaModel.tipoContribuyente;


    // Enviar la solicitud
    var response = await request.send();

    // Manejar la respuesta
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      // Verificar si la respuesta contiene la información esperada
      if (jsonResponse.containsKey('data')) {
        var data = jsonResponse['data'];
        print("actualizacion facturacion $data");
      }
      notifyListeners();
      return true;
    } else {
      print('Error al enviar imágenes: ${response.reasonPhrase}');
    }
    return false;
  }
}