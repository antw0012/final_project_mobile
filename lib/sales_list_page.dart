import 'package:flutter/material.dart';
import 'add_sales_page.dart'; // Import Add Sales Page
import 'database_helper2.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({Key? key}) : super(key: key);

  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  List<Map<String, dynamic>> _salesList = [];

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final sales = await DatabaseHelper2.instance.fetchAllSales();
    setState(() {
      _salesList = sales;
    });
  }

  Future<void> _deleteSale(int id) async {
    await DatabaseHelper2.instance.deleteSale(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales record deleted')),
    );
    _loadSales();
  }

  Future<void> _navigateToAddSalesPage() async {
    // Navigate to Add Sales Page and reload list after returning
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSalesPage()),
    );
    if (result == true) {
      _loadSales(); // Reload sales after a successful addition
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales List'),
      ),
      body: _salesList.isEmpty
          ? const Center(child: Text('No sales records found.'))
          : ListView.builder(
        itemCount: _salesList.length,
        itemBuilder: (context, index) {
          final sale = _salesList[index];
          return ListTile(
            title: Text('Sale ID: ${sale['id']}'),
            subtitle: Text(
                'Customer ID: ${sale['customerId']} | Date: ${sale['date']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteSale(sale['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSalesPage, // Navigate to Add Sales Page
        child: const Icon(Icons.add),
      ),
    );
  }
}
