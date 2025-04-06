import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPreferencesHelper {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveLastCar(Map<String, dynamic> car) async {
    await _storage.write(key: 'last_car_brand', value: car['brand']);
    await _storage.write(key: 'last_car_model', value: car['model']);
    await _storage.write(key: 'last_car_passengers', value: car['passengers'].toString());
    await _storage.write(key: 'last_car_fuelCapacity', value: car['fuelCapacity'].toString());  // Corrected key
  }

  Future<Map<String, dynamic>?> getLastCar() async {
    final brand = await _storage.read(key: 'last_car_brand');
    final model = await _storage.read(key: 'last_car_model');
    final passengers = await _storage.read(key: 'last_car_passengers');
    final fuelCapacity = await _storage.read(key: 'last_car_fuelCapacity');  // Corrected key

    if (brand == null || model == null || passengers == null || fuelCapacity == null) {
      return null;
    }

    return {
      'brand': brand,
      'model': model,
      'passengers': int.parse(passengers),
      'fuelCapacity': double.parse(fuelCapacity),  // Corrected key
    };
  }

}
