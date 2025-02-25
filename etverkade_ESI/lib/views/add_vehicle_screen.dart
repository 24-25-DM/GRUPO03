import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../controllers/vehicle_controller.dart';

class AddVehicleScreen extends StatefulWidget {
  final VehicleController controller;

  const AddVehicleScreen({super.key, required this.controller});

  @override
  AddVehicleScreenState createState() => AddVehicleScreenState();
}

class AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController letterController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String resticciones = '';
  String selectedColor = 'Blanco';
  bool isActive = false;
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text =
            '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: letterController,
                      maxLength: 3,
                      decoration: const InputDecoration(labelText: 'XXX'),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: numberController,
                      maxLength: 4,
                      decoration: const InputDecoration(labelText: 'NNNN'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Fabricación',
                    ),
                  ),
                ),
              ),
              DropdownButtonFormField(
                value: selectedColor,
                items: ['Blanco', 'Negro', 'Azul']
                    .map((color) =>
                        DropdownMenuItem(value: color, child: Text(color)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedColor = value as String;
                  });
                },
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: costController,
                decoration: const InputDecoration(labelText: 'Costo'),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Por favor selecciona una fecha.')),
                    );
                    return;
                  }
                  //ingreso vehiculos, valide que la placa tenga: formato XXX-NNNN,
                  //no iniciar con DFQÑ, No tener letras ni nuemros consegutivos, no tiene 0 si tiene O,
                  // mensaje cuales no cumple
                  if (letterController.text.indexOf('Ñ') == 0 ||
                      letterController.text.indexOf('D') == 0 ||
                      letterController.text.indexOf('F') == 0 ||
                      letterController.text.indexOf('Q') == 0) {
                    resticciones =
                        resticciones + 'Placa no puede empezar por Ñ, D, F, Q';
                  }
                  if (letterController.text.contains('O') &&
                      numberController.text.contains('0')) {
                    resticciones = resticciones +
                        '\nPlaca no puede empezar por O y 0 a la vez';
                  }
                  if (resticciones.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$resticciones')),
                    );
                    resticciones='';
                    return;
                  }
                  final plate =
                      '${letterController.text}-${numberController.text}';

                  final vehicle = Vehicle(
                    plate: plate,
                    brand: brandController.text,
                    manufactureDate: selectedDate!,
                    color: selectedColor,
                    cost: double.parse(costController.text),
                    isActive: isActive,
                  );
                  Navigator.pop(context, vehicle);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
