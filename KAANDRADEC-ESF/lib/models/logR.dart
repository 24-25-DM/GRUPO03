class LogR {
  int id;
  String accion;
  DateTime fecha;
  String usuarioNombre;

  LogR({
    required this.id,
    required this.accion,
    required this.fecha,
    required this.usuarioNombre,
  });

  factory LogR.fromJson(Map<String, dynamic> json) {
    return LogR(
      id: json['id'],
      accion: json['accion'],
      fecha: DateTime.parse(json['fecha']),
      usuarioNombre: json['usuarioNombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accion': accion,
      'fecha': fecha.toIso8601String(),
      'usuarioNombre': usuarioNombre,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accion': accion,
      'fecha': fecha.toIso8601String(),
      'usuarioNombre': usuarioNombre,
    };
  }
}