
import 'package:persistencia/controllers/login_controller.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class RegisterController {
  final LoginController _loginController = LoginController();

 
  String _encryptPassword(String lastName) {
    final bytes = utf8.encode(lastName);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  
  bool registerUser(String firstName, String lastName) {
    if (firstName.isEmpty || lastName.isEmpty) {
      return false;
    }

    
    if (_loginController.users.any((user) => user.firstName == firstName)) {
      return false;
    }

    
    final encryptedLastName = _encryptPassword(lastName);
    _loginController.users
        .add(User(firstName: firstName, lastName: encryptedLastName));
    return true;
  }

 
}
