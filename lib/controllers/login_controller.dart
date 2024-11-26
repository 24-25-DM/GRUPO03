import '../models/User.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginController {
  final List<User> users = [
    User(firstName: 'Emil', lastName: 'Verkade'),
    User(firstName: 'Kevin', lastName: 'Andrade'),
    User(firstName: 'Jhon', lastName: 'Arteaga'),
    User(firstName: 'Augusto', lastName: 'Salazar'),
  ];

  // Método para autenticar usando nombre y apellido
  bool authenticate(String firstName, String lastName) {
    // Encriptar el apellido ingresado para comparación
    final encryptedInputLastName = _encryptLastName(lastName);
    //print(encryptedInputLastName.toString());
    

    // comparación del usuario con el nombre y el apellido encriptado
    return users.any((user) =>
        user.firstName == firstName &&
        user.encryptedLastName == encryptedInputLastName);
  }

  // Método de encriptacion de apellido ingresado
  String _encryptLastName(String lastNameInput) {
    final bytes = utf8.encode(lastNameInput);
    final digest = sha512.convert(bytes);
    //print('Apellido ingresado'+digest.toString());
    return digest.toString();
  }
}
