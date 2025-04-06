class Car {
  int? id;
  String brand;
  String model;
  int passengers;
  double fuelCapacity;

  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.passengers,
    required this.fuelCapacity,
  });

  // Convert a Car into a Map. The keys must correspond to the column names in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'passengers': passengers,
      'fuelCapacity': fuelCapacity,
    };
  }

  // Extract a Car object from a Map
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      passengers: map['passengers'],
      fuelCapacity: map['fuelCapacity'],
    );
  }

  // copyWith method to create a new instance with some properties changed
  Car copyWith({
    int? id,
    String? brand,
    String? model,
    int? passengers,
    double? fuelCapacity,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      passengers: passengers ?? this.passengers,
      fuelCapacity: fuelCapacity ?? this.fuelCapacity,
    );
  }
}
