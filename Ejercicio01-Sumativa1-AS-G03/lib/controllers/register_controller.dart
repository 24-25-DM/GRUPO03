import 'package:flutter_app/controllers/login_controller.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../controllers/login_controller.dart';

class LoginController {
  List<User> users = [];

  LoginController();
}

class RegisterController {
  final LoginController _loginController;

  RegisterController(this._loginController);

  bool registerUser(String firstName, String lastName, String password) {
    if (firstName.isEmpty || lastName.isEmpty) {
      return false;
    }

    if (_loginController.users.any((user) => user.firstName == firstName)) {
      return false;
    }

    if (!isValidPassword(password)) {
      print('La contraseña no cumple con los requisitos.');
      return false;
    }

    final encryptedLastName = _encryptLastName(lastName);
    _loginController.users
        .add(User(firstName: firstName, lastName: encryptedLastName));
    return true;
  }

  bool isValidPassword(String password) {
    if (password.length != 8) {
      print('La contraseña debe tener exactamente 8 caracteres.');
      return false;
    }

    int upperCaseCount = 0;
    int lowerCaseCount = 0;
    int digitCount = 0;
    bool endsWithSpecialChar = false;

    for (int i = 0; i < password.length; i++) {
      if (RegExp(r'[A-Z]').hasMatch(password[i])) upperCaseCount++;
      if (RegExp(r'[a-z]').hasMatch(password[i])) lowerCaseCount++;
      if (RegExp(r'[0-9]').hasMatch(password[i])) digitCount++;
    }

    if (RegExp(r'[#@_!]$').hasMatch(password)) {
      endsWithSpecialChar = true;
    }

    if (upperCaseCount < 2) {
      print('La contraseña debe contener al menos 2 letras mayúsculas.');
      return false;
    }

    if (lowerCaseCount > 3) {
      print('La contraseña debe contener como máximo 3 letras minúsculas.');
      return false;
    }

    if (digitCount != 3) {
      print('La contraseña debe contener exactamente 3 números.');
      return false;
    }

    if (!endsWithSpecialChar) {
      print(
          'La contraseña debe terminar con uno de los siguientes caracteres especiales: #@_!');
      return false;
    }

    return true;
  }

  String _encryptLastName(String lastName) {
    final bytes = utf8.encode(lastName);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }
}
