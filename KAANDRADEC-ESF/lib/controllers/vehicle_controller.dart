import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistencia/controllers/currentUser.dart';
import 'package:persistencia/models/Vehicle.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistencia/services/Cloudinary.dart';

import '../models/logR.dart';
import 'database_controller.dart';

class VehicleController extends ChangeNotifier {
  VehicleController._singleton();

  static final VehicleController _mismaInstancia =
      VehicleController._singleton();
  static final DatabaseController _databaseController = DatabaseController();
  static final CurrentUserController _currentUserController = CurrentUserController();

  factory VehicleController() => _mismaInstancia;

  ValueNotifier<List<Vehicle>> vehicles = ValueNotifier<List<Vehicle>>([]);

  // Hacer que loadDB() se ejecute al inicial la app

  void addVehicle(Vehicle vehicle) {
    vehicles.value = [...vehicles.value, vehicle];
    saveVehiclesToFile();

    //DB
    _databaseController.insertVehicle(vehicle);

    var log = LogR(
      id: 0,
      accion: 'INSERT vehicle',
      fecha: DateTime.now(),
      usuarioNombre: _currentUserController.getUsuarioNombre(),
    );

    insertLog(log);

    vehicles.notifyListeners();
  }

  // insert log async

  void insertLog(LogR log) async {
    await _databaseController.insertLogR(log);
  }

  List<Vehicle> getVehicles() {
    var log = LogR(
      id: 0,
      accion: 'GET vehicles',
      fecha: DateTime.now(),
      usuarioNombre: _currentUserController.getUsuarioNombre()
    );

    insertLog(log);
    return vehicles.value;
  }

  void removeVehicle(String plate) {
    vehicles.value = vehicles.value.where((v) => v.plate != plate).toList();
    saveVehiclesToFile();

    //DB
    var log = LogR(
      id: 0,
      accion: 'DELETE vehicle',
      fecha: DateTime.now(),
      usuarioNombre: _currentUserController.getUsuarioNombre()
    );

    insertLog(log);
    _databaseController.deleteVehicle(plate);
    vehicles.notifyListeners();
  }

  void editVehicle(Vehicle updatedVehicle, int index, String oldPlate) {
    vehicles.value[index] = updatedVehicle;
    saveVehiclesToFile();
    // vehicles.notifyListeners();

    //DB

    var log = LogR(
      id: 0,
      accion: 'UPDATE vehicle',
      fecha: DateTime.now(),
      usuarioNombre: _currentUserController.getUsuarioNombre()
    );

    insertLog(log);
    _databaseController.updateVehicle(updatedVehicle, oldPlate);
    //loadDB();
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
          vehicles.value.clear();
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

  Future<void> loadDB() async {
    vehicles.value = [];
    final List<Vehicle> fetchedVehicles =
        (await _databaseController.getVehicles());
    //DB
    vehicles.value = fetchedVehicles;
  }

  Future<void> saveDB() async {
    final List<Vehicle> fetchedVehicles =
        (await _databaseController.getVehicles());
    for (Vehicle vehi in fetchedVehicles) {
      if (!fetchedVehicles.any((u) => u.plate == vehi.plate)) {
        await _databaseController.insertVehicle(vehi);
      }
    }
  }

  void saveDataOnExit() {
    saveDB();
    saveVehiclesToFile();
    print('Datos guardados al salir.');
  }

  // Nuevo método para imprimir el JSON de los vehículos
  void printVehiclesJson() {
    String jsonString =
        jsonEncode(vehicles.value.map((v) => v.toJson()).toList());
    print('JSON de vehículos: $jsonString');
  }

  Future<String?> capturePhotoAndSave(Vehicle vehicle) async {
    try {
      // Captura la foto y guarda la ruta
      String? savedPath = await capturePhoto();

      if (savedPath != null) {
        // Asigna la ruta a vehicle.imagePath solo después de copiar exitosamente.

        // Guarda los cambios.
        saveVehiclesToFile();
        // Subir la imagen a Cloudinary
        var res = uploadImageToCloudinary(savedPath);
        vehicle.imageUrl = res as String?;
        // Guardar en la DB
        _databaseController.updateVehicle(vehicle, vehicle.plate);
        vehicles.notifyListeners();
        return savedPath;
      }
    } catch (e) {
      // Manejo de errores en caso de fallo.
      print('Error al guardar la foto: $e');
    }

    return null; // Retorna null si no se capturó una foto.
  }

  Future<String?> capturePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      try {
        final directory = Directory('/storage/emulated/0/Download');

        // Crea el directorio si no existe.
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath = '${directory.path}/$fileName';
        final file = File(photo.path);

        // Copia el archivo al nuevo destino.
        await file.copy(savedPath);

        return savedPath;
      } catch (e) {
        // Manejo de errores en caso de fallo.
        print('Error al guardar la foto: $e');
        return null;
      }
    }

    return null; // Retorna null si no se capturó una foto.
  }
}
