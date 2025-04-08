import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper1.dart';

class AddDealershipPage extends StatefulWidget {
  final Map<String, dynamic>? dealership;

  const AddDealershipPage({Key? key, this.dealership}) : super(key: key);

  @override
  _AddDealershipPageState createState() => _AddDealershipPageState();
}

class _AddDealershipPageState extends State<AddDealershipPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.dealership != null) {
      // Editing an existing dealership
      _nameController.text = widget.dealership!['name'] ?? '';
      _addressController.text = widget.dealership!['address'] ?? '';
      _cityController.text = widget.dealership!['city'] ?? '';
      _postalCodeController.text = widget.dealership!['postalCode'] ?? '';
    } else {
      // Adding a new dealership
      _loadLastEnteredData();
    }
  }

  Future<void> _loadLastEnteredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _cityController.text = prefs.getString('city') ?? '';
      _postalCodeController.text = prefs.getString('postalCode') ?? '';
    });
  }

  Future<void> _saveLastEnteredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('postalCode', _postalCodeController.text);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final dealership = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
      };

      try {
        if (widget.dealership == null) {
          // Insert a new dealership
          await DatabaseHelper1.instance.insertDealership(dealership);
          await _saveLastEnteredData(); // Save last-entered data for convenience

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dealership added successfully')),
          );
        } else {
          // Update existing dealership
          dealership['id'] = widget.dealership!['id'];
          await DatabaseHelper1.instance.updateDealership(dealership);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dealership updated successfully')),
          );
        }

        // Pop back to the list page, returning `true` so that it refreshes
        Navigator.pop(context, true);

      } catch (e) {
        // If there's a DB error or something unexpected, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.dealership != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Dealership' : 'Add Dealership'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Street Address'),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Postal Code'),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEditing ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
