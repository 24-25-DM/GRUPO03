class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});

  // Método para convertir un objeto User a JSON aunque no se porque guarda en corchetes xd
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}