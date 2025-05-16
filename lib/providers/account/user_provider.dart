import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:vet_sotf_app/models/cuenta/user.dart';

class UserEmpProvider extends ChangeNotifier {

  //verificar si es personal o no
  int? _idPersonalUpdate = null;
  int? get idPersonalUpdate => _idPersonalUpdate;
  void setIdPersonalUpdate(int? value) {
    _idPersonalUpdate = value;
    notifyListeners();
  }

  //Almacenar fecha fin
  String _fechaNacimiento = '';
  String get fechaNacimiento => _fechaNacimiento;
  void setFechanNacimiento(String value) {
    _fechaNacimiento = value;
    notifyListeners();
  }

  XFile? image;
  File? lastImageProfile;

  Future addPhoto() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      lastImageProfile = File(image!.path);
      notifyListeners();
    }
  }

  //Radio Buttons
  String _selectedSexoGenero = '';

  String get selectedGenero => _selectedSexoGenero;

  void setSelectedGender(String gender) {
    _selectedSexoGenero = gender;
    notifyListeners();
  }

  //Radio Buttons
  String _selectedEstadoCivil = '';

  String get selectedEstadoCivil => _selectedEstadoCivil;

  void setSelectedEstadoCivil(String gender) {
    _selectedEstadoCivil = gender;
    notifyListeners();
  }

  //Cargando archivo sello
  String _fileCV = '';
  String get fileCV => _fileCV;

  void setfileCV(String fileName) {
    _fileCV = fileName;
    notifyListeners();
  }

  //Cargando archivo foto empleado
  String _imageEmpleado = '';
  String get imageEmpelado => _imageEmpleado;

  void setImageEmpelado(String fileName) {
    _imageEmpleado = fileName;
    notifyListeners();
  }

  //Cargando archivos para antibiograma
  List<String> _fileTitulosDiplomas = [];

  List<String> get fileTitulosDiplomas => _fileTitulosDiplomas;

  void addFileTitulosDiplomas(String fileName) {
    _fileTitulosDiplomas = [];
    _fileTitulosDiplomas.add(fileName);
    notifyListeners();
  }
  void addFilesTitulosDiplomas(List<String> filesNames) {
    _fileTitulosDiplomas = filesNames;
    notifyListeners();
  }
  void clearFileTitulosDiplomas() {
    _fileTitulosDiplomas.clear();
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isloading => _isLoading;
  void setIsloading(bool isloading){
    _isLoading = isloading;
    notifyListeners();
  }

  late bool fichaParametrica = false;
  late bool fichaNormal = false;
  void setTipoFicha(bool _fichaParametrica, bool _fichaNormal) {
    fichaParametrica = _fichaParametrica;
    fichaNormal = _fichaNormal;
    notifyListeners();
  }

  late String _tipoFicha = "";
  String get tipoFicha => _tipoFicha;
  void setTipoFichaRadio(String tipoFicha) {
    _tipoFicha = tipoFicha;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  void setUserData(User? user) {
    _user = user;
    notifyListeners();
  }

  User? _userPersonal;
  User? get userPersonal => _userPersonal;
  void setUseruserPersonal(User? user) {
    _userPersonal = user;
    notifyListeners();
  }

  bool _isLoadingFicha = false;
  bool get isLoadingFicha => _isLoadingFicha;
  void setisLoadingFicha(bool isloading){
    _isLoadingFicha = isloading;
  }

  Future<void> obtieneTipoFicha() async {
    setisLoadingFicha(true);
    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-tipo-ficha');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {

      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['error'] == false && jsonData['data'] != null && jsonData['data'].isNotEmpty) {

          final fichaData = jsonData['data'];
          print('User data from array: $fichaData \n');
          var tipo = fichaData['ficha_parametrica'] == "NO" ? true : false;
          var tipoDato = tipo ? "normal" : "parametrica";

          setTipoFicha(tipo, !tipo);
          setTipoFichaRadio(tipoDato);
          setisLoadingFicha(false);

        } else {

          print('Data array is empty or not in expected format \n');
          setisLoadingFicha(false);

        }
      } else {

        print(
            'Failed to load user data. Status code: ${response.statusCode} \n');
        setisLoadingFicha(false);

      }
    } catch (error) {

      print('Error fetching user data: $error \n');
      setisLoadingFicha(false);

    }
  }

  Future<void> cambiarTipoFichaDato() async {
    setIsloading(true);
    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-tipo-ficha?tipo=$tipoFicha');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response =
      await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON data tipo ficha: $jsonData \n');
        if (jsonData['error'] == false && jsonData['data'] != null && jsonData['data'].isNotEmpty) {

          final fichaData = jsonData['data'];
          print('User data from array: $fichaData \n');
          var tipo = fichaData['ficha_parametrica'] == "NO" ? true : false;

          setTipoFicha(tipo, !tipo);
        } else {
          print('Data array is empty or not in expected format \n');
        }
      } else {
        print( 'Failed to load user data. Status code: ${response.statusCode} \n');
      }
    } catch (error) {
      print('Error fetching user data: $error \n');
    } finally {
      setIsloading(false);
    }
  }

  //cambio del nombre empresa
  Future<bool> changeNameEmpresa(String newName) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('myToken') ?? '';
    //
    // final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-email');
    //
    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Authorization': 'Bearer $token',
    //       'Content-Type': 'application/json',
    //     },
    //     body: jsonEncode({
    //       'email': newName,
    //     }),
    //   );
    //
    //   final responseData = json.decode(response.body);
    //
    //   if (response.statusCode == 200 && responseData['error'] == false) {
    //     print('Email cambiado con éxito');
    //     // Aquí podrías actualizar el email del usuario en el estado de tu aplicación si es necesario
    //     _user?.informacionPersonal.email = newName; // Asegúrate de que esta línea refleje cómo se almacena el email en tu clase User
    //     notifyListeners();
    //     return true;
    //   } else {
    //     print('Error al cambiar el email: ${responseData['message']}');
    //     return false;
    //   }
    // } catch (e) {
    //   print('Excepción al cambiar el email: $e');
    return false;
    // }
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('${apiUrlGlobal}cuenta/informacion-personal');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON data formacion: $jsonData \n');

        if (jsonData['error'] == false &&
            jsonData['data'] != null &&
            jsonData['data'].isNotEmpty) {
          final userData = jsonData['data'][0];
          print('User data from array info personal: $userData \n');

          final user = User.fromJson(userData);

          setUserData(user);
        } else {
          print('Data array is empty or not in expected format \n');
        }
      } else {
        print(
            'Failed to load user data. Status code: ${response.statusCode} \n');
      }
    } catch (error) {
      print('Error fetching user data: $error \n');
    }
  }

  Future<void> fetchUserDataPersonal(int idEmpleado) async {
    final url = Uri.parse('${apiUrlGlobal}cuenta/informacion-personal-planta/$idEmpleado');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON data info planta: $jsonData \n');

        if (jsonData['error'] == false &&
            jsonData['data'] != null &&
            jsonData['data'].isNotEmpty) {
          final userData = jsonData['data'][0];
          print('User data from array: $userData \n');

          final user = User.fromJson(userData);

          setUseruserPersonal(user);
        } else {
          print('Data array is empty or not in expected format \n');
        }
      } else {
        print(
            'Failed to load user data. Status code: ${response.statusCode} \n');
      }
    } catch (error) {
      print('Error fetching user data: $error \n');
    }
  }
  //cambio del password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    // Crear la URL de la solicitud para cambiar la contraseña
    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-password');

    try {
      // Enviar la solicitud POST para cambiar la contraseña
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['error'] == false) {
        print('Contraseña cambiada con éxito');
        return true;
      } else {
        print('Error al cambiar la contraseña: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      // Si ocurre un error al enviar la solicitud
      print('Excepción al cambiar la contraseña: $e');
      return false;
    }
  }

  //cambio del email
  Future<bool> changeEmail(String password, String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-email');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': password,
          'email': newEmail,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['error'] == false) {
        print('Email cambiado con éxito');
        // Aquí podrías actualizar el email del usuario en el estado de tu aplicación si es necesario
        _user?.informacionPersonal.email = newEmail; // Asegúrate de que esta línea refleje cómo se almacena el email en tu clase User
        notifyListeners();
        return true;
      } else {
        print('Error al cambiar el email: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar el email: $e');
      return false;
    }
  }

  //cambio de numero
  Future<bool> changePhoneNumber(String password, String newPhoneNumber) async {
    final url = Uri.parse('${apiUrlGlobal}cuenta/cambiar-numero');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    print('Token: $token');

    try {
      print('Enviando solicitud para cambiar número de teléfono: password: $password, numero_tele: $newPhoneNumber');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': password,
          'numero_tele': newPhoneNumber,
        }),
      );

      final responseData = json.decode(response.body);
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 && responseData['error'] == false) {
        print('Número de teléfono cambiado con éxito');
        _user?.informacionPersonal.telefono = newPhoneNumber;
        notifyListeners();
        return true;
      } else {
        print('Error al cambiar el número de teléfono: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar el número de teléfono: $e');
      return false;
    }
  }



  String informacionPersonalToJson(InformacionPersonal data) {
    final Map<String, dynamic> dataMap = {
      "nombres": data.nombres,
      "apellidos": data.apellidos,
      "telefono": data.telefono,
      "fecha_nacimiento": data.fechaNacimiento,
      "pais_nacimiento": data.paisNacimiento,
      "ciudad_nacimiento": data.ciudadNacimiento,
      "num_identificacion": data.numIdentificacion,
      "sexo": data.sexo,
      "estado_civil": data.estadoCivil,
      "direccion": data.direccion,
      "altura": data.altura,
      "pais_residencia": data.paisResidencia,
      "ciudad_residencia": data.ciudadResidencia,
    };
    return json.encode(dataMap);
  }

  Future<bool> updatePersonalInformation(InformacionPersonal updatedInfo) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    String urlFinal = '${apiUrlGlobal}cuenta/informacion-personal-update?tipo=datos';
    if(idPersonalUpdate != null){
      urlFinal = '${apiUrlGlobal}cuenta/informacion-personal-update?tipo=datos&encargado_id=$idPersonalUpdate';
    }
    final url = Uri.parse(urlFinal);
    String body = informacionPersonalToJson(updatedInfo);

    try {
      print('Enviando información personal al servidor...');
      print('URL: $url');
      print('Body: $body');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Respuesta del servidor: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON: $jsonData');

        if (jsonData['error'] == false && jsonData['data'] != null) {
          // Actualiza la información del usuario en el provider
          if(idPersonalUpdate == null) {
            User? user1 = _user;
            user1?.informacionPersonal = updatedInfo;
            setUserData(user1);
          }
          return true;
        } else {
          print('Error al actualizar la información personal: ${jsonData['message']}');
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



  Future<bool> updatePersonalInformationAdicional(InformacionAdicional updatedInfo ) async {
    String urlFinal = '${apiUrlGlobal}cuenta/informacion-personal-update?tipo=adicional';

    if(idPersonalUpdate != null){
      urlFinal = '${apiUrlGlobal}cuenta/informacion-personal-update?tipo=adicional&encargado_id=$idPersonalUpdate';
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DE ENVIO
    request.fields['grupo_sanguineo'] = updatedInfo.grupoSanguineo;
    request.fields['alergias'] = updatedInfo.alergias;
    request.fields['ref_emergencia[nombres]'] = updatedInfo.referenciaEmergencia.nombres;
    request.fields['ref_emergencia[apellidos]'] = updatedInfo.referenciaEmergencia.apellidos;
    request.fields['ref_emergencia[celuar]'] = updatedInfo.referenciaEmergencia.celular;
    request.fields['ref_emergencia[parentesco]'] = updatedInfo.referenciaEmergencia.parentesco;

    // Verificar y agregar archivo CV
    if (updatedInfo.formacion != null) {
      if (isFile(updatedInfo.formacion!.cv)) {
        final fileCV = File(updatedInfo.formacion!.cv);
        request.files.add(await http.MultipartFile.fromPath('formacion[cv]', fileCV.path));
      }
    }

    // Verificar y agregar archivos de títulos y diplomas
    for (final fileName in updatedInfo.formacion?.titulosDiplomas ?? []) {
      if (isFile(fileName)) {
        final file = File(fileName);
        request.files.add(await http.MultipartFile.fromPath('formacion[titulos_diplomas][]', file.path));
      }
    }
    //AQUI YA SE ESTA ENVIANDO TODO
    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 && responseData['data'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');
        // Actualiza la información del usuario en el provider
        if(idPersonalUpdate == null) {
          User? user1 = _user;
          user1?.informacionAdicional = updatedInfo;
          setUserData(user1);
        }
        notifyListeners();
        return true;
      } else {
        print('Error en la solicitud: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('error Consulta $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> createPersonal(
      String nombres,
      String apellidos,
      String correo,
      String password,
      String accesoEmpleado,
      String? fotoEmpleado,
      ) async {
    String urlFinal = '${apiUrlGlobal}cuenta/crear-cuenta';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DE ENVIO
    request.fields['nombres'] = nombres;
    request.fields['apellidos'] = apellidos;
    request.fields['email'] = correo;
    request.fields['password'] = password;
    request.fields['acceso_empleado'] = accesoEmpleado;

    // Verificar y agregar archivo CV
    if (fotoEmpleado != "") {
        final foto = File(fotoEmpleado!);
        request.files.add(await http.MultipartFile.fromPath('imagen', foto.path));
    }
    try {
      //AQUI YA SE ESTA ENVIANDO TODO
      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var responseData = jsonDecode(responseStream);
      print("Respuesta de crear un personal: "+responseStream);
      if (responseData['code'] == 200 && responseData['data'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');
        notifyListeners();
        return true;
      } else {
        print('Error en la solicitud: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');
        notifyListeners();
        return false;
      }
    } catch (e, stacktrace) {
      print('error al enviar datos crear cuenta $e');
      print(stacktrace);
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarEmpleado(int id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final url = Uri.parse('${apiUrlGlobal}cuenta/eliminar-personal/$id');
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al eliminar empleado: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud DELETE: $e');
      return false;
    }
  }
// Función auxiliar para verificar si la ruta es un archivo local
  bool isFile(String path) {
    return File(path).existsSync();
  }
}
