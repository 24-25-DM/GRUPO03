import 'package:flutter/material.dart';
import 'package:flutter_app/models/Vehicle.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onVehicleSelected,
  });

  final Vehicle vehicle;
  final Function(Vehicle p1) onVehicleSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => onVehicleSelected(vehicle),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vehicle.plate,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Badge(
                      label: Text(vehicle.isActive ? 'Activo' : 'Inactivo'),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      backgroundColor: vehicle.isActive
                          ? Colors.lightGreen
                          : Colors.redAccent,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    AtributeRow(atribute: 'Marca', value: vehicle.brand),
                    AtributeRow(
                        atribute: 'Fabricación',
                        value: vehicle.manufactureDate.year.toString()),
                    AtributeRow(
                        atribute: 'Costo', value: vehicle.cost.toString()),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 32,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class AtributeRow extends StatelessWidget {
  const AtributeRow({
    super.key,
    required this.atribute,
    required this.value,
  });

  final String atribute;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$atribute:  ',
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ],
    );
  }
}
