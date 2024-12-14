import 'package:flutter/material.dart';
import 'package:flutter_app/models/vehicle.dart';
import 'package:flutter_app/views/edit_vehicle_screen.dart';
import 'package:flutter_app/views/vehicle_list/widgets/vehicle_card.dart';
import '../../controllers/vehicle_controller.dart';
import '../add_vehicle_screen.dart';
import 'package:flutter_app/views/login_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  VehicleListScreenState createState() => VehicleListScreenState();
}

class VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleController _controller = VehicleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Colors.blue,
                Colors.pink,
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Lista de Vehículos',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: Colors.white, // El color final después de ShaderMask
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newVehicle = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehicleScreen(controller: _controller),
            ),
          );
          if (newVehicle != null) _controller.addVehicle(newVehicle);
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ValueListenableBuilder<List<Vehicle>>(
          valueListenable: _controller.vehicles,
          builder: (context, vehicles, _) {
            return ListView.builder(
              // controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Vehículos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                final vehicle = vehicles[index - 1];
                return VehicleCard(
                  key: ValueKey(vehicle.plate),
                  vehicle: vehicle,
                  onVehicleSelected: (vehicle) {
                    // TODO
                  },
                  onVehicleDeleted: (vehicle) {
                    _controller.removeVehicle(vehicle.plate);
                  },
                  onVehicleEdited: (vehicle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditVehicleScreen(
                          vehicle: vehicle,
                          onVehicleEdited: (editedVehicle) {
                            _controller.editVehicle(
                                editedVehicle,
                                vehicles.indexWhere(
                                    (v) => v.plate == vehicle.plate));
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
