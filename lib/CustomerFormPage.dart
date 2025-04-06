import 'package:flutter/material.dart';
import 'Customer.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;

  const CustomerFormPage({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController birthdayController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.customer?.firstName ?? '');
    lastNameController = TextEditingController(text: widget.customer?.lastName ?? '');
    addressController = TextEditingController(text: widget.customer?.address ?? '');
    birthdayController = TextEditingController(
        text: widget.customer?.birthday.toString().split(' ')[0] ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final parsedDate = DateTime.parse(birthdayController.text);
        final customer = Customer(
          widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch,
          firstNameController.text,
          lastNameController.text,
          addressController.text,
          parsedDate,
        );
        Navigator.pop(context, customer);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Date'),
            content: const Text('Please enter a valid date in the format YYYY-MM-DD.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Enter first name' : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              TextFormField(
                controller: birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter birthday';
                  }
                  final dateRegEx = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegEx.hasMatch(value)) {
                    return 'Enter a valid date in YYYY-MM-DD format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
