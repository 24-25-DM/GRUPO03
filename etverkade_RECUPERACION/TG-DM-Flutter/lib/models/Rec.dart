class Rec{
  final int id;
  final String accion;
  final String usr;
  final String fecha;

  Rec(this.id, this.accion, this.usr, this.fecha);

  @override
  String toString() {
    return 'Rec{id: $id, accion: $accion, usr: $usr, fecha: $fecha}';
  }
}