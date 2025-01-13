import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VehicleController extends ChangeNotifier {
  ValueNotifier<List<Vehicle>> vehicles = ValueNotifier<List<Vehicle>>([
    Vehicle(
      plate: 'AAA-123',
      brand: 'Toyota',
      manufactureDate: DateTime(2020, 5, 20),
      color: 'Blanco',
      cost: 15000,
      isActive: true,
    ),
    Vehicle(
      plate: 'BBB-456',
      brand: 'Honda',
      manufactureDate: DateTime(2018, 11, 10),
      color: 'Negro',
      cost: 12000,
      isActive: false,
    ),
    Vehicle(
      plate: 'CCC-789',
      brand: 'Ford',
      manufactureDate: DateTime(2021, 7, 15),
      color: 'Azul',
      cost: 18000,
      isActive: true,
    ),
  ]);

  void addVehicle(Vehicle vehicle) {
    vehicles.value = [...vehicles.value, vehicle];
    saveVehiclesToFile();
    vehicles.notifyListeners();
  }

  List<Vehicle> getVehicles() {
    return vehicles.value;
  }

  void removeVehicle(String plate) {
    vehicles.value = vehicles.value.where((v) => v.plate != plate).toList();
    saveVehiclesToFile();
    vehicles.notifyListeners();
  }

  void editVehicle(Vehicle updatedVehicle, int index) {
    vehicles.value[index] = updatedVehicle;
    saveVehiclesToFile();
    vehicles.notifyListeners();
  }

  Future<void> saveVehiclesToFile() async {
    String jsonString =
        jsonEncode(vehicles.value.map((v) => v.toJson()).toList());
    if (Platform.isAndroid) {
      if (await _checkPermissions()) {
        try {
          final directory = Directory('/storage/emulated/0/Download');
          final file = File('${directory.path}/vehicles.json');
          await file.writeAsString(jsonString);
          print('Archivo guardado en: ${file.path}');
        } catch (e) {
          print('Error al guardar el archivo: $e');
        }
      } else {
        print('Permiso de almacenamiento denegado');
      }
    } else if (Platform.isWindows) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/vehicles.json');
        await file.writeAsString(jsonString);
        print('Archivo guardado en: ${file.path}/vehicles.json');
      } catch (e) {
        print('Error al guardar el archivo: $e');
      }
    } else {
      print('Plataforma no soportada');
    }
  }

  Future<void> loadVehiclesFromFile() async {
    try {
      if (Platform.isAndroid || Platform.isWindows) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/vehicles.json');

        if (await file.exists()) {
          final jsonString = await file.readAsString();
          final List<dynamic> jsonList = jsonDecode(jsonString);
          vehicles.value =
              jsonList.map((json) => Vehicle.fromJson(json)).toList();
          vehicles.notifyListeners();
          print('Vehículos cargados exitosamente desde el archivo.');
        } else {
          print('El archivo no existe, se usará la lista predeterminada.');
        }
      } else {
        print('Plataforma no soportada para leer datos.');
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  Future<bool> _checkPermissions() async {
    final status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      return await Permission.manageExternalStorage.request().isGranted;
    }
    return status.isGranted;
  }

  void saveDataOnExit() {
    saveVehiclesToFile();
    print('Datos guardados al salir.');
  }

  // Nuevo método para imprimir el JSON de los vehículos
  void printVehiclesJson() {
    String jsonString =
        jsonEncode(vehicles.value.map((v) => v.toJson()).toList());
    print('JSON de vehículos: $jsonString');
  }
}
