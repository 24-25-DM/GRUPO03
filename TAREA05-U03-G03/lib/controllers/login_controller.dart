import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistencia/controllers/database_controller.dart';
import 'package:xml/xml.dart';

import '../models/User.dart';

class LoginController {
  LoginController._singleton();

  static final LoginController _mismaInstancia = LoginController._singleton();
  static final DatabaseController _databaseController = DatabaseController();

  factory LoginController() => _mismaInstancia;

  ValueNotifier<List<User>> users = ValueNotifier<List<User>>([
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
  ]);

  // Método para autenticar usando nombre y apellido
  // Future<bool>
  bool authenticate(String firstName, String lastName) {
    // Encriptar el apellido ingresado para comparación
    // final encryptedInputLastName = _encryptLastName(lastName);

        final encryptedLastName =
        sha512.convert(utf8.encode(lastName)).toString();
    // printUsers(); // Verificacion del usuario con el nombre y el apellido encriptado
    // print(encryptedInputLastName);

    return users.value.any((user) =>
        user.firstName == firstName && user.lastName == encryptedLastName);
  }

  // Future<bool> authenticate(String firstName, String lastName) async {
  //   try {
  //     // Encriptar el apellido ingresado
  //     final encryptedLastName =
  //     sha512.convert(utf8.encode(lastName)).toString();
  //
  //     // Obtener todos los usuarios
  //     List<User> users = await _databaseController.getUsers();
  //
  //     // Verificar las credenciales
  //     for (User user in users) {
  //       print('Comparando con usuario: ${user.toJson()}');
  //       if (user.firstName == firstName && user.lastName == encryptedLastName) {
  //         print('Inicio de sesión exitoso');
  //         return true;
  //       }
  //     }
  //     print('Credenciales incorrectas');
  //     return false;
  //   } catch (e) {
  //     print('Error al iniciar sesión: $e');
  //     return false;
  //   }
  // }

  String _encryptLastName(String lastName) {
    final bytes = utf8.encode(lastName);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  //ver si se modifica la lista
  void printUsers() {
    for (var user in users.value) {
      print(
          'Nombre: ${user.firstName}, Apellido (encriptado): ${user.lastName}');
    }
  }

  // PARA JSON

  Future<void> saveJsonToFile() async {
    String jsonString =
        jsonEncode(users.value.map((user) => user.toJson()).toList());
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

  Future<void> loadDB() async {
    // final fetchedUsers = await _databaseController.getUsers();
    // for (var fusr in fetchedUsers) {
    //   users.value.add(fusr);
    // }

    final List<User> fetchedUsers = (await _databaseController.getUsers());
    //DB
    users.value = fetchedUsers;

    // users = fetchedUsers;
  }

  Future<void> saveDB() async {
    final existingUsers = await _databaseController.getUsers();
    for (var user in users.value) {
      if (!existingUsers.any((u) => u.firstName == user.firstName)) {
        await _databaseController.insertUser(user);
      }
    }
  }

  Future<void> loadJsonFromFile() async {
    try {
      if (Platform.isAndroid || Platform.isWindows) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/users.json');

        if (await file.exists()) {
          final jsonString = await file.readAsString();
          final List<dynamic> jsonList = jsonDecode(jsonString);
          users.value.clear();
          users.value
              .addAll(jsonList.map((json) => User.fromJson(json)).toList());

          print('Datos cargados exitosamente desde el archivo.');
        } else {
          print('El archivo no existe, se usará la lista predeterminada.');
        }
      } else {
        print('Plataforma no soportada para leer datos.');
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

//PARA XML

  // Convertir toda la lista de user a formato XML y guardar
  Future<void> saveXmlToFile() async {
    try {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('users', nest: () {
        for (var user in users.value) {
          builder.xml(user.toXml());
        }
      });
      final xmlString = builder.buildDocument().toString();

      if (Platform.isAndroid) {
        if (await _checkPermissions()) {
          final directory = Directory('/storage/emulated/0/Download');
          final file = File('${directory.path}/users.xml');
          await file.writeAsString(xmlString);
          print('Archivo XML guardado en: ${file.path}');
        } else {
          print('Permiso de almacenamiento denegado.');
        }
      } else if (Platform.isWindows) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/users.xml');
        await file.writeAsString(xmlString);
        print('Archivo XML guardado en: ${directory.path}/users.xml');
      } else {
        print('Plataforma no soportada.');
      }
    } catch (e) {
      print('Error al guardar el archivo XML: $e');
    }
  }

  Future<void> loadXmlFromFile() async {
    try {
      if (Platform.isAndroid || Platform.isWindows) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/users.xml');

        if (await file.exists()) {
          final xmlString = await file.readAsString();
          final document = XmlDocument.parse(xmlString);
          final userElements = document.findAllElements('user');

          users.value.clear();
          users.value.addAll(userElements.map((element) {
            final firstName = element.findElements('firstName').first.text;
            final lastName = element.findElements('lastName').first.text;
            return User(firstName: firstName, lastName: lastName);
          }));

          print('Datos cargados exitosamente desde el archivo XML.');
        } else {
          print('El archivo XML no existe, se usará la lista predeterminada.');
        }
      } else {
        print('Plataforma no soportada para leer datos.');
      }
    } catch (e) {
      print('Error al cargar los datos desde XML: $e');
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

  //un guardado general de los datos users
  void saveDataOnExit() {
    saveDB();
    saveJsonToFile();
    saveXmlToFile();
    print('Datos guardados al salir.');
  }
}
