import 'package:flutter_app/controllers/login_controller.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class RegisterController {
  final LoginController _loginController = LoginController();

  // Función para validar la contraseña
  bool _validateLastname(String lastName) {
    if (lastName.length < 8) {
      return false; // Longitud mínima
    }
    if (lastName.endsWith("#")==false) {
      return false; // Longitud mínima
    }
    

    //int upperCaseCount = 0;
    //int lowerCaseCount = 0;

    
    //for (var char in lastName.split('')) {
    //  if (char.toUpperCase() == char) {
    //    upperCaseCount++;
    //  } else if (char.toLowerCase() == char) {
     //   lowerCaseCount++;
    //  }
    //}

   
    //bool hasValidUpperCase = upperCaseCount >= 2;
    //bool hasValidLowerCase = lowerCaseCount <= 3;
    //bool endsWithValidCharacter = lastName.endsWith("a");

    //return hasValidUpperCase && hasValidLowerCase && endsWithValidCharacter;
    return true;
  }

  // Encriptación de la contraseña
  String _encryptPassword(String lastName) {
    final bytes = utf8.encode(lastName);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  // Registro de usuario
  bool registerUser(String firstName, String lastName) {
    // Validación de campos vacíos
    if (firstName.isEmpty || lastName.isEmpty ) {
      return false;
    }

    
   

    
    if (_loginController.users.any((user) => user.firstName == firstName)) {
      return false;
    }

    if (_loginController.users.any((user) => user.lastName == lastName)) {
      return false;
    }
    if (!_validateLastname(lastName)) {
      return false;
    }
   
    final encryptedLastName = _encryptPassword(lastName);

    // Agregamos el nuevo usuario
    _loginController.users
        .add(User(firstName: firstName, lastName: encryptedLastName));
    
    return true;
  }
}





