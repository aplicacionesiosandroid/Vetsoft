import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/clinica/hospitalizacion/hospitalizacion_provider.dart';
import 'package:path/path.dart' as path;

//Clases para agregar archivos varios HEMOGRAMA
Container addFileHemogramaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileHemograma(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar hemográma',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileHemograma extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileHemograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosHemograma extends StatelessWidget {
  final double sizeScreen;
  ArchivosHemograma({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileHemograma.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileHemograma.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios QUIMICA SANGUINEA

Container addFileQuimicaSanguineaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider = Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileQuimSanguinea(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar análisis',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileQuimicaSanguinea extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileHemograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosQuimicaSanguinea extends StatelessWidget {
  final double sizeScreen;
  ArchivosQuimicaSanguinea({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileQuimSanguinea.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileQuimSanguinea.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios ANTIBIOGRAMA

Container addFileAntibiogramaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileAntibiograma(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar antibiograma',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileAntibiograma extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileAntibiograma(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosAntibiograma extends StatelessWidget {
  final double sizeScreen;
  ArchivosAntibiograma({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileAntibiograma.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileAntibiograma.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios RADIOGRAFIA

Container addFileRadiografiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileRadiografia(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar radiografía',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileRadiografia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileRadiografia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosRadiografia extends StatelessWidget {
  final double sizeScreen;
  ArchivosRadiografia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileRadiografia.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileRadiografia.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios ECOGRAFIA

Container addFileEcografiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileEcografia(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar ecografía',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileEcografia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileEcografia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosEcografia extends StatelessWidget {
  final double sizeScreen;
  ArchivosEcografia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileEcografia.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileEcografia.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios COPROLOGIA

Container addFileCoprologiaIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider =
        Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileCoprologia(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar coprología',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileCoprologia extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider =
            Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileCoprologia(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosCoprologia extends StatelessWidget {
  final double sizeScreen;
  ArchivosCoprologia({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileCoprologia.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileCoprologia.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios RASPADO CUTANEO
Container addFileRaspadoCutaneoIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider = Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileRaspadoCutaneo(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar coprología',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileRaspadoCutaneo extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider = Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileRaspadoCutaneo(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosRaspadoCutaneo extends StatelessWidget {
  final double sizeScreen;
  ArchivosRaspadoCutaneo({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileRaspadoCutaneo.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileRaspadoCutaneo.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

//Clases para agregar archivos varios CITOLOGICO
Container addFileCitologicoIsEmpty(context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 218, 223, 230), width: 2),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () async {
        Future<String?> selectFile() async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final path = result.files.single.path;
            return path;
          }
          return null;
        }

        final fileProvider = Provider.of<HospitalizacionProvider>(context, listen: false);
        final fileName = await selectFile();
        if (fileName != null) {
          fileProvider.addFileCitologico(fileName);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add_square,
            size: 25,
            color: Color.fromARGB(255, 139, 149, 166),
          ),
          SizedBox(
            width: 8,
          ),
          const Text(
            'Agregar coprología',
            style: TextStyle(
                color: const Color.fromARGB(255, 139, 149, 166),
                fontFamily: 'sans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

class AddFileCitologico extends StatelessWidget {
  Future<String?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final path = result.files.single.path;
      return path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 72, 86, 109), width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
          onPressed: () async {
            final fileProvider = Provider.of<HospitalizacionProvider>(context, listen: false);
            final fileName = await selectFile();
            if (fileName != null) {
              fileProvider.addFileCitologico(fileName);
            }
          },
          icon: Icon(
            Icons.add,
            size: 20,
            color: Color.fromARGB(255, 72, 86, 109),
          )),
    );
  }
}

class ArchivosCitologico extends StatelessWidget {
  final double sizeScreen;
  ArchivosCitologico({required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    final provFiles = Provider.of<HospitalizacionProvider>(context);
    return provFiles.fileCitologico.isEmpty
        ? Container(
      margin: EdgeInsets.only(right: 5),
      height: 60,
      width: sizeScreen * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(220, 249, 249, 249),
      ),
      child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 139, 149, 166),
                        fontSize: 15,
                        fontFamily: 'inter')),
              ),
            ],
          )),
    )
        : Consumer<HospitalizacionProvider>(
      builder: (context, fileProvider, _) {
        return Column(
          children: fileProvider.fileCitologico.map((fileName) {
            String nombreLegible = path.basename(fileName);
            return Container(
              margin: EdgeInsets.only(right: 5, top: 3, bottom: 3),
              padding: EdgeInsets.only(right: 5),
              height: 60,
              width: sizeScreen * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(220, 249, 249, 249),
              ),
              child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(nombreLegible,
                            style: TextStyle(
                                color: Color.fromARGB(255, 139, 149, 166),
                                fontSize: 15,
                                fontFamily: 'inter')),
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}

