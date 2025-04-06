import 'package:flutter/material.dart';
import 'Customer.dart';
import 'CustomerDatabase.dart';
import 'CustomerDAO.dart';
import 'CustomerFormPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CustomerListPage(title: 'Customer List'),
      supportedLocales: [
        Locale('en', 'US'), // American English
        Locale('fr', 'FR'), // French France
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key, required this.title});

  final String title;

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late CustomerDAO customerDAO;
  late TextEditingController _controller;
  List<Customer> customers = [];
  late SharedPreferences prefs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Customer? selectedCustomer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    initializeDatabase();
    _loadPreferences();
  }

  Future<void> initializeDatabase() async {
    final database = await $FloorCustomerDatabase.databaseBuilder('customer_database.db').build();
    customerDAO = database.customerDAO;
    final savedCustomers = await customerDAO.getAllCustomers();
    setState(() {
      customers = savedCustomers;
    });
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? lastInput = prefs.getString('last_input') ?? '';
    _controller.text = lastInput!;
  }

  Future<void> _savePreferences(String input) async {
    prefs.setString('last_input', input);
    await secureStorage.write(key: 'last_customer', value: input); // EncryptedStorage
  }

  void _addCustomer(Customer customer) async {
    await customerDAO.insertCustomer(customer);
    setState(() {
      customers.add(customer);
    });
    _savePreferences(customer.firstName); // Store the last name entered
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customer added!')));
  }

  void _deleteCustomer(Customer customer) async {
    await customerDAO.deleteCustomer(customer);
    setState(() {
      customers.remove(customer);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customer deleted!')));
  }

  void _navigateToCustomerForm([Customer? customer]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormPage(
          customer: customer,
        ),
      ),
    );
    if (result != null) {
      if (customer == null) {
        _addCustomer(result);  // Add new customer
      } else {
        await customerDAO.updateCustomer(result);  // Update existing customer
        setState(() {
          final index = customers.indexWhere((c) => c.id == result.id);
          customers[index] = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showInstructionsDialog();
            },
          ),
        ],
      ),
      body: _buildLayout(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCustomerForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
      ),
    );
  }

  Widget _buildLayout() {
    var size = MediaQuery.of(context).size;
    if (size.width > 720) {  // Landscape or large screen (e.g., tablet/desktop)
      return Row(
        children: [
          Expanded(flex: 1, child: _buildCustomerList()),
          Expanded(flex: 2, child: _buildDetailsPage()),
        ],
      );
    } else {
      return _buildCustomerList();
    }
  }

  Widget _buildCustomerList() {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text('${customers[index].firstName} ${customers[index].lastName}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToCustomerForm(customers[index]),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _confirmDelete(customers[index]);
                },
              ),
            ],
          ),
          onTap: () {
            setState(() {
              selectedCustomer = customers[index];
            });
          },
        );
      },
    );
  }

  void _confirmDelete(Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCustomer(customer);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsPage() {
    if (selectedCustomer == null) {
      return Center(child: const Text("Select a customer to view details"));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ID: ${selectedCustomer!.id}', style: TextStyle(fontSize: 18)),
          Text('First Name: ${selectedCustomer!.firstName}', style: TextStyle(fontSize: 18)),
          Text('Last Name: ${selectedCustomer!.lastName}', style: TextStyle(fontSize: 18)),
          Text('Address: ${selectedCustomer!.address}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _confirmDelete(selectedCustomer!); // Show confirmation dialog
                },
                child: const Text("Delete"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCustomer = null;
                  });
                },
                child: const Text("Back"),
              ),
            ],
          ),
        ],
      );
    }
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text('Use the buttons to add, edit, or delete customers.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
