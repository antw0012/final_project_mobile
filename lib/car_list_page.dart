import 'package:flutter/material.dart';
import 'car_details_page.dart';
import 'database_helper.dart';

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> carList = [];

  @override
  void initState() {
    super.initState();

    // Add two default cars (for demo purposes)
    carList.addAll([
      {
        'brand': 'Toyota',
        'model': 'Corolla',
        'passengers': 5,
      },
      {
        'brand': 'Honda',
        'model': 'Civic',
        'passengers': 4,
      },
    ]);

    print(carList);
    loadCars();
  }

  Future<void> loadCars() async {
    final cars = await dbHelper.getCars();
    if (cars.isNotEmpty) {
      setState(() {
        carList = cars;
      });
    }
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Car'),
        content: Text('Are you sure you want to delete this car?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                carList.removeAt(index);
                // TODO: Also delete from database using dbHelper if connected
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Car deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text(
                    'Use the button below to add new cars.\nTap a car to view details.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: carList.length,
        itemBuilder: (context, index) {
          final car = carList[index];
          return ListTile(
            title: Text('${car['brand']} ${car['model']}'),
            subtitle: Text('${car['passengers']} passengers'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updatedCar = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailsPage(car: car),
                      ),
                    );
                    if (updatedCar != null) {
                      setState(() {
                        carList[index] = updatedCar;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Car updated')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, index),
                ),
              ],
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailsPage(car: car),
                ),
              );
              loadCars();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCar = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarDetailsPage()),
          );
          if (newCar != null) {
            setState(() {
              carList.add(newCar);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Car added')),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
