import 'package:flutter/material.dart';
import 'package:tarea03_u02_g03/models/Vehicle.dart';

class VehicleController {
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
  }

  List<Vehicle> getVehicles() {
    return vehicles.value;
  }
}
