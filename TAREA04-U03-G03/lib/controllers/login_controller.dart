import '../models/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class LoginController {
  LoginController._singleton();
  static final LoginController _mismaInstancia = LoginController._singleton();
  factory LoginController() => _mismaInstancia;

  final List<User> users = [
    User(
        firstName: 'Emil',
        lastName:
            '651682a417b65991d6d0b7e55bf6eb1a67ea35e74295c075dada8c67e6695e4402011f3ed3dfc4e503ed7843177a9c9d34cd22722eacba94d45334d0ad7d3a9c'),
    User(
        firstName: 'Kevin',
        lastName:
            '4a8d708913dbf3745c9769f9a5c1b3a65b68a3ad390f8019a4c6298b328b6adcbdba54be92d591fad42f63cd643b99f80e5c53ceb43c58eb57ded7847ca9f9eb'),
    User(
        firstName: 'Jhon',
        lastName:
            'f04ab399ef59f5d7fe15e67d95020101c10ab976fa033cddfbecbb88ce10710e3fa5c231eef5c4440362011d6bb2bbdaf7032ba20d220684e7d22d8202d8085e'),
    User(
        firstName: 'Augusto',
        lastName:
            '89be58831b2778569e2327034092572ddfd10ef89860fb4492939920bd44e509fb35efd0b0eafa3925fae8a1bc430288f9c20546c5f3dbf5d82db2aac99d8591'),
  ];

  // Método para autenticar usando nombre y apellido
  bool authenticate(String firstName, String lastName) {
    // Encriptar el apellido ingresado para comparación
    final encryptedInputLastName = _encryptLastName(lastName);
    //print('probando123 encrytado');
    //printUsers(); // Verificacion del usuario con el nombre y el apellido encriptado
    _saveJsonToFile(jsonEncode(users.map((user) => user.toJson()).toList()));
    
    return users.any((user) =>
        user.firstName == firstName && user.lastName == encryptedInputLastName);
  }

  String _encryptLastName(String lastName) {
    final bytes = utf8.encode(lastName);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  //ver si se modifica la lista
  void printUsers() {
    for (var user in users) {
      print(
          'Nombre: ${user.firstName}, Apellido (encriptado): ${user.lastName}');
    }
  }

  void printUsersAsJson() {
    final jsonString = jsonEncode(users.map((user) => user.toJson()).toList());
    print(jsonString);
  }

  Future<void> _saveJsonToFile(String jsonString) async {
    if (Platform.isAndroid) {
      if (await _checkPermissions()) {
        try {
          // ruta en general de donde se guardara el archivo
          final directory = Directory('/storage/emulated/0/Download');
          final file = File('${directory.path}/users.json');
          await file.writeAsString(jsonString);
          print('Archivo guardado en: ${file.path}');
        } catch (e) {
          print('Error al guardar el archivo: $e');
        }
      } else {
        print('Permiso de almacenamiento denegado');
      }
    } else if (Platform.isWindows) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final file = File('$path/users.json');
        await file.writeAsString(jsonString);
        print('Archivo guardado en: $path/users.json');
      } catch (e) {
        print('Error al guardar el archivo: $e');
      }
    } else {
      print('Plataforma no soportada');
    }


    
  }
  //necesario para pedir permisooos 
   Future<bool> _checkPermissions() async {
    final status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      return await Permission.manageExternalStorage.request().isGranted;
    }
    return status.isGranted;
  }
}
