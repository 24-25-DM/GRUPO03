import 'package:flutter/material.dart';
import 'package:persistencia/controllers/database_controller.dart';
import 'package:persistencia/controllers/vehicle_controller.dart';
import 'package:persistencia/models/Vehicle.dart';
import 'package:persistencia/views/add_vehicle_screen.dart';
import 'package:persistencia/views/edit_vehicle_screen.dart';

class VehicleTableScreen extends StatefulWidget {
  @override
  _VehicleTableScreenState createState() => _VehicleTableScreenState();
}

class _VehicleTableScreenState extends State<VehicleTableScreen> {
  // Lista para almacenar los vehículos
  List<Vehicle> vehicles = [];
  final VehicleController _controller = VehicleController();

  @override
  void initState() {
    super.initState();
    // Cargar vehículos desde la base de datos cuando la pantalla se inicializa
    _loadVehicles();
  }

  // Cargar vehículos desde la base de datos
  Future<void> _loadVehicles() async {
    List<Vehicle> loadedVehicles = await DatabaseController().getVehicles();
    setState(() {
      vehicles = loadedVehicles;
    });
  }

  // // Método para agregar un vehículo
  Future<void> _addVehicle() async {
    // Vehicle newVehicle = Vehicle(
    //   plate: 'NEW123',
    //   brand: 'Chevrolet',
    //   manufactureDate: DateTime(2023, 3, 15),
    //   color: 'Green',
    //   cost: 18000.00,
    //   isActive: true,
    // );

    // Guardar en la base de datos
    // await DatabaseController().insertVehicle(newVehicle);

    final newVehicle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVehicleScreen(controller: _controller),
      ),
    );
    if (newVehicle != null) _controller.addVehicle(newVehicle);

    // Actualizar la tabla después de agregar el vehículo
    _loadVehicles();
  }

  Future<void> _editVehicle(Vehicle vehicle) async {
    final editedVehicle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditVehicleScreen(
          vehicle: vehicle,
          onVehicleEdited: (editedVehicle) {
            _controller.editVehicle(
              editedVehicle,
              vehicles.indexWhere((v) => v.plate == vehicle.plate),
              vehicle.plate,
            );
          },
        ),
      ),
    );
    _loadVehicles();
  }

  // Método para eliminar un vehículo
  void _deleteVehicle(String plate) {
    _controller.removeVehicle(plate);
    _loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Vehículos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addVehicle,
              child: Text('Agregar Vehículo'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Placa')),
                      DataColumn(label: Text('Marca')),
                      DataColumn(label: Text('Fecha de Fabricación')),
                      DataColumn(label: Text('Color')),
                      DataColumn(label: Text('Costo')),
                      DataColumn(label: Text('Activo')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: vehicles.map((vehicle) {
                      return DataRow(
                        cells: [
                          DataCell(Text(vehicle.plate)),
                          DataCell(Text(vehicle.brand)),
                          DataCell(Text('${vehicle.manufactureDate.toLocal()}'
                              .split(' ')[0])),
                          DataCell(Text(vehicle.color)),
                          DataCell(
                              Text('\$${vehicle.cost.toStringAsFixed(2)}')),
                          DataCell(Text(vehicle.isActive ? 'Sí' : 'No')),
                          DataCell(
                            PopupMenuButton<String>(
                              onSelected: (String result) {
                                if (result == 'edit') {
                                  _editVehicle(vehicle);
                                } else if (result == 'delete') {
                                  _deleteVehicle(vehicle.plate);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Editar'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Borrar'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
