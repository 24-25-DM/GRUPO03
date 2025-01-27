import 'package:flutter/material.dart';
import 'package:persistencia/controllers/login_controller.dart';
import 'package:persistencia/controllers/vehicle_controller.dart';
import 'package:persistencia/life_cycle_manager.dart';
import 'package:persistencia/views/login_screen.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  // Solicita el permiso al iniciar la aplicación
  await LoginController().checkPermissions();
   // Carga los datos desde el archivo JSON
  await LoginController().loadJsonFromFile();
  await VehicleController().loadVehiclesFromFile();
  runApp(
     LifecycleManager(
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehículos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
     
    );
  }
}
