import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final String firstName;
  final String lastName;
  final String encryptedLastName;
//genera un hash al apellido con el metodo estatico
  User({required this.firstName, required this.lastName})
      : encryptedLastName = _generateHash(lastName);

  // Método estático para generar el hash del apellido
  static String _generateHash(String lastNameSystem) {
    final bytes = utf8.encode(lastNameSystem); // Convertir el valor a bytes
    final digest = sha512.convert(bytes); // Generar el hash SHA-512
    return digest.toString(); // Retornar el hash como String
  }
}
