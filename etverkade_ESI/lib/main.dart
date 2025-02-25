import 'package:flutter/material.dart';
import 'package:flutter_app/views/login_screen.dart';
import 'package:flutter_app/views/vehicle_list/vehicle_list_screen.dart';

void main() {
  runApp(const MyApp());
}
// nuevos ususarios tenga max 8 char, 2 mayusculas max 3 min, temine con #@_!, mensaje cuales no cumple
//ingreso vehiculos, valide que la placa tenga: formato XXX-NNNN, no iniciar con DFQÑ, No tener letras ni nuemros consegutivos, no tiene 0 si tiene O, mensaje cuales no cumple

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehículos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: LoginScreen(),
      home: const VehicleListScreen(),
    );
  }
}
