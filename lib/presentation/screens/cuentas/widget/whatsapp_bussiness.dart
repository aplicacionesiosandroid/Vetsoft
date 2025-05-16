import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:vet_sotf_app/config/global/palet_colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CrmModal extends StatefulWidget {
  final String keyStatus;

  const CrmModal({Key? key, required this.keyStatus}) : super(key: key);

  @override
  _CrmModalState createState() => _CrmModalState();
}

class _CrmModalState extends State<CrmModal> {
  late WebSocketChannel channel;
  String modalContent = '';
  Widget? modalWidget;

  @override
  void initState() {
    super.initState();
    if (widget.keyStatus.isNotEmpty) {
      initCrm();
    } else {
      _showAlertDialog('No se puede proceder con la solicitud.');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void initCrm() {
    // waitModal();
    print('ws://62.72.11.94:8447/qr?key=${widget.keyStatus}');
    channel = WebSocketChannel.connect(
      Uri.parse('ws://62.72.11.94:8447/qr?key=${widget.keyStatus}'),
    );
    print('WebSocket iniciando.');

    channel.stream.listen((message) {
      print('Mensaje recibido: $message');
      var dataserver = jsonDecode(message);
      setState(() {
        switch (dataserver['status']) {
          case -1:
            modalContent = 'Ocurrió un error en la solicitud.';
            modalWidget = _buildErrorContent(dataserver['message']  == null ? 'Mensaje de error no definido': dataserver['message']);
            break;
          case 0:
            modalContent = '¿Desea habilitar el servicio Whatsapp CRM?';
            modalWidget = _buildEnableServiceContent();
            break;
          case 1:
            if (dataserver['idw'] > 0 && dataserver['statuscrm'] != 'CONNECTED') {
              modalContent = '¡Usuario habilitado!';
              modalWidget = _buildUserEnabledContent();
            } else if (dataserver['idw'] > 0 && dataserver['statuscrm'] == 'CONNECTED') {
              modalContent = '¡Usuario conectado!';
              modalWidget = _buildUserConnectedContent();
            } else {
              _showAlertDialog('Ocurrió un error no controlado, vuelva a iniciar el proceso.');
              channel.sink.close();
            }
            break;
          case 2:
            modalContent = 'Generando QR.';
            modalWidget = _buildGeneratingQRContent();
            break;
          case 3:
            modalContent = 'Lee el código QR para empezar la sesión.';
            modalWidget = _buildQRCodeContent(dataserver['message']);
            break;
          case 4:
            modalContent = '¡Usuario conectado con éxito!';
            modalWidget = _buildSuccessContent();
            break;
        }
      });
    }, onDone: () {
      print('Conexión WebSocket cerrada.');
      channel.sink.close().then((value) => Navigator.pop(context));
    }, onError: (error) {
      print('Error en WebSocket: $error');
    });
  }

  void waitModal() {
    setState(() {
      modalContent = 'Procesando solicitud...';
      modalWidget = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              modalContent,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Color(0xFF635CFF)),
          ],
        ),
      );
    });
  }

  Widget _buildErrorContent(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 15,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              waitModal();
              channel.sink.close();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero, // Ajusta el padding del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent, // Hace transparente el color de fondo del botón
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorPalet.gradientBottomCompany,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta el padding interno del contenido del botón
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnableServiceContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),
        textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              waitModal();
              channel.sink.add('1');
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero, // Ajusta el padding del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent, // Hace transparente el color de fondo del botón
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorPalet.gradientBottomCompany,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta el padding interno del contenido del botón
                  child: Text(
                    'Proceder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                channel.sink.close();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: const Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )
          ),
        ),

      ],
    );
  }

  Widget _buildUserEnabledContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),        ),
        SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              waitModal();
              channel.sink.add('2');
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero, // Ajusta el padding del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent, // Hace transparente el color de fondo del botón
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorPalet.gradientBottomCompany,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta el padding interno del contenido del botón
                  child: Text(
                    'Generar QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                channel.sink.close();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: const Color.fromARGB(255, 28, 149, 187),
                    fontFamily: 'inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )
          ),
        ),
      ],
    );
  }

  Widget _buildUserConnectedContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            waitModal();
            channel.sink.add('3');
          },
          child: Text('Desvincular'),
        ),
        ElevatedButton(
          onPressed: () {
            channel.sink.close();
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildGeneratingQRContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),        ),
        SizedBox(height: 10),
        CircularProgressIndicator(color: Color(0xFF635CFF)),
        ElevatedButton(
          onPressed: () {
            channel.sink.close();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }

  Widget _buildQRCodeContent(String data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),        ),
        SizedBox(height: 10),
        QrImage(
          data: data,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modalContent,
          style: const TextStyle(
            color: Color.fromARGB(255, 29, 34, 44),
            fontSize: 18,
            fontFamily: 'sans',
            fontWeight: FontWeight.w700,
          ),        ),
        SizedBox(height: 10),
        Icon(Icons.check_circle, color: Colors.green, size: 50),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              channel.sink.close();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero, // Ajusta el padding del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent, // Hace transparente el color de fondo del botón
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorPalet.gradientBottomCompany,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta el padding interno del contenido del botón
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Advertencia'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 123,
        height: 370,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   modalContent,
            //   style: const TextStyle(
            //     color: Color.fromARGB(255, 29, 34, 44),
            //     fontSize: 18,
            //     fontFamily: 'sans',
            //     fontWeight: FontWeight.w700,
            //   ),            ),
            SizedBox(height: 10),
            modalWidget ?? CircularProgressIndicator(color: Color(0xFF635CFF)),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   channel.sink.close(status.goingAway);
  //   super.dispose();
  // }
}
