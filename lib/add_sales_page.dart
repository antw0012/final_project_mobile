import 'package:flutter/material.dart';
import 'database_helper2.dart';

class AddSalesPage extends StatefulWidget {
  const AddSalesPage({Key? key}) : super(key: key);

  @override
  _AddSalesPageState createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _carIdController = TextEditingController();
  final _dealershipIdController = TextEditingController();
  final _dateController = TextEditingController();

  Future<void> _addSale(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final sale = {
        'customerId': int.parse(_customerIdController.text),
        'carId': int.parse(_carIdController.text),
        'dealershipId': int.parse(_dealershipIdController.text),
        'date': _dateController.text,
      };

      try {
        await DatabaseHelper2.instance.insertSale(sale);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sales record added successfully')),
        );
        Navigator.pop(context, true); // Return true on success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding sale: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sales Record')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _carIdController,
                decoration: const InputDecoration(labelText: 'Car ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dealershipIdController,
                decoration: const InputDecoration(labelText: 'Dealership ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addSale(context),
                child: const Text('Add Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
