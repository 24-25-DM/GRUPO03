class Vehicle {
  String plate;

  String brand;

  DateTime manufactureDate;

  String color;

  double cost;

  bool isActive;

  Vehicle({
    required this.plate,
    required this.brand,
    required this.manufactureDate,
    required this.color,
    required this.cost,
    required this.isActive,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      plate: json['plate'],
      brand: json['brand'],
      manufactureDate: DateTime.parse(json['manufactureDate']),
      color: json['color'],
      cost: json['cost'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'brand': brand,
      'manufactureDate': manufactureDate.toIso8601String(),
      'color': color,
      'cost': cost,
      'isActive': isActive,
    };
  }
}
