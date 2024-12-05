import 'package:flutter/material.dart';
import 'package:tarea03_u02_g03/models/Vehicle.dart';
import '../controllers/vehicle_controller.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatelessWidget {
  final VehicleController _controller = VehicleController();

  VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Vehículos')),
      body: ValueListenableBuilder<List<Vehicle>>(
        valueListenable: _controller.vehicles,
        builder: (context, vehicles, _) {
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                title: Text('${vehicle.brand} - ${vehicle.plate}'),
                subtitle: Text(
                    'Costo: \$${vehicle.cost} - Activo: ${vehicle.isActive ? "Sí" : "No"}'),
              );
            },
          );
        },
      ),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
