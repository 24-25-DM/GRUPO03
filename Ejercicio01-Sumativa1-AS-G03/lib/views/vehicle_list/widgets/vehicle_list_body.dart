import 'package:flutter/material.dart';
import 'package:flutter_app/models/vehicle.dart';
import 'package:flutter_app/views/vehicle_list/widgets/vehicle_card.dart';

class VehicleListBody extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Function(Vehicle) onVehicleSelected;
  final Function(Vehicle) onVehicleDeleted;
  final Function(Vehicle) onVehicleEdited;

  const VehicleListBody({
    super.key,
    required this.vehicles,
    required this.onVehicleSelected,
    required this.onVehicleDeleted,
    required this.onVehicleEdited,
  });

  @override
  Widget build(BuildContext context) {
    if (vehicles.isEmpty) {
      return const Center(
        child: Text(
          'No hay vehículos registrados.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];

        return VehicleCard(
          vehicle: vehicle,
          onVehicleSelected: onVehicleSelected,
          onVehicleDeleted: onVehicleDeleted,
          onVehicleEdited: onVehicleEdited,
        );
      },
    );
  }
}
