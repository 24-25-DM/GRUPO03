import 'package:flutter/material.dart';
import 'package:tarea03_u02_g03/models/Vehicle.dart';
import 'package:tarea03_u02_g03/views/vehicle_list/widgets/vehicle_list_body.dart';
import '../../controllers/vehicle_controller.dart';
import '../add_vehicle_screen.dart';

class VehicleListScreen extends StatelessWidget {
  final VehicleController _controller = VehicleController();

  VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Lista de Vehículos',
              style: TextStyle(fontWeight: FontWeight.normal))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newVehicle = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehicleScreen(controller: _controller),
            ),
          );

          if (newVehicle != null) {
            _controller.addVehicle(newVehicle);
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: ValueListenableBuilder<List<Vehicle>>(
        valueListenable: _controller.vehicles,
        builder: (context, vehicles, _) {
          return VehicleListBody(
            vehicles: vehicles,
            onVehicleSelected: (vehicle) {
              print("Vehículo seleccionado: ${vehicle.plate}");
            },
          );
        },
      ),
    );
  }
}
