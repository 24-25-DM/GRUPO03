import 'package:xml/xml.dart';
class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});

  // Método para convertir un objeto User a JSON 
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  // Método para convertir un JSON a un User

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }


  // Convertir un User a XML
  String toXml() {
    final builder = XmlBuilder();
    builder.element('user', nest: () {
      builder.element('firstName', nest: firstName);
      builder.element('lastName', nest: lastName);
    });
    return builder.buildDocument().toString();
  }

  // Convertir el XML en User
  factory User.fromXml(XmlElement xmlElement) {
    final firstName = xmlElement.findElements('firstName').first.text;
    final lastName = xmlElement.findElements('lastName').first.text;
    return User(firstName: firstName, lastName: lastName);
  }
}
