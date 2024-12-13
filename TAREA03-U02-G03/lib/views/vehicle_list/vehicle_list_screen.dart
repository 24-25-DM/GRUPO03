import 'package:flutter/material.dart';
import 'package:flutter_app/models/vehicle.dart';
import 'package:flutter_app/views/edit_vehicle_screen.dart';
import 'package:flutter_app/views/vehicle_list/widgets/vehicle_list_body.dart';
import '../../controllers/vehicle_controller.dart';
import '../add_vehicle_screen.dart';
import 'package:flutter_app/views/login_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen>
    with SingleTickerProviderStateMixin {
  final VehicleController _controller = VehicleController();
  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    // Configuración de la animación del degradado
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _gradientAnimation = _animationController.drive(
      ColorTween(
        begin: Colors.blue,
        end: Colors.purple,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    _gradientAnimation.value ?? Colors.blue,
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
            );
          },
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

          if (newVehicle != null) {
            _controller.addVehicle(newVehicle);
          }
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
            return VehicleListBody(
              vehicles: vehicles,
              onVehicleSelected: (vehicle) {
                print("Vehículo seleccionado: ${vehicle.plate}");
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
                            vehicles
                                .indexWhere((v) => v.plate == vehicle.plate));
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
