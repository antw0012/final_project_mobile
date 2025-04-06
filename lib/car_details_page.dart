import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'shared_preferences_helper.dart';

class CarDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? car;

  CarDetailsPage({this.car});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _passengersController = TextEditingController();
  final _tankSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _brandController.text = widget.car!['brand'];
      _modelController.text = widget.car!['model'];
      _passengersController.text = widget.car!['passengers'].toString();
      _tankSizeController.text = widget.car!['tank_size'].toString();
    } else {
      loadLastCar();
    }
  }

  Future<void> loadLastCar() async {
    final lastCar = await preferencesHelper.getLastCar();
    if (lastCar != null) {
      _brandController.text = lastCar['brand'];
      _modelController.text = lastCar['model'];
      _passengersController.text = lastCar['passengers'].toString();
      _tankSizeController.text = lastCar['tank_size'].toString();
    }
  }

  Future<void> saveCar() async {
    if (_brandController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _passengersController.text.isEmpty ||
        _tankSizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    final car = {
      'brand': _brandController.text,
      'model': _modelController.text,
      'passengers': int.parse(_passengersController.text),
      'fuelCapacity': double.parse(_tankSizeController.text), // Corrected key
    };


    if (widget.car == null) {
      await dbHelper.insertCar(car);
    } else {
      await dbHelper.updateCar(car, widget.car!['id']);
    }

    await preferencesHelper.saveLastCar(car);

    Navigator.pop(context);
  }

  Future<void> deleteCar() async {
    if (widget.car != null) {
      await dbHelper.deleteCar(widget.car!['id']);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _passengersController,
              decoration: InputDecoration(labelText: 'Passengers'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tankSizeController,
              decoration: InputDecoration(labelText: 'Tank Size (litres/kWh)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveCar,
                  child: Text(widget.car == null ? 'Save' : 'Update'),
                ),
                if (widget.car != null)
                  ElevatedButton(
                    onPressed: deleteCar,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
