
import 'package:flutter_app/models/User.dart';

class LoginController {
  final List<User> users = [
    User(firstName: 'Emil', lastName: 'Verkade'),
    User(firstName: 'Kevin', lastName: 'Andrade'),
    User(firstName: 'Jhon', lastName: 'Arteaga'),
    User(firstName: 'Augusto', lastName: 'Salazar'),
  ];

  bool authenticate(String firstName, String lastName) {
    return users.any((user) =>
    user.firstName == firstName && user.lastName == lastName);
  }
}
