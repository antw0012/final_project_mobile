import 'package:flutter/material.dart';
import 'database_helper1.dart';
import 'add_dealership_page.dart';

class DealershipListPage extends StatefulWidget {
  const DealershipListPage({Key? key}) : super(key: key);

  @override
  _DealershipListPageState createState() => _DealershipListPageState();
}

class _DealershipListPageState extends State<DealershipListPage> {
  List<Map<String, dynamic>> _dealershipList = [];

  @override
  void initState() {
    super.initState();
    _loadDealerships();
  }

  Future<void> _loadDealerships() async {
    final dealerships = await DatabaseHelper1.instance.fetchAllDealerships();
    setState(() {
      _dealershipList = dealerships;
    });
  }

  Future<void> _deleteDealership(int id) async {
    try {
      await DatabaseHelper1.instance.deleteDealership(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dealership deleted successfully')),
      );
      _loadDealerships();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting: $e')),
      );
    }
  }

  Future<void> _navigateToAddDealershipPage({Map<String, dynamic>? dealership}) async {
    // If an edit or add operation happens, we await the result.
    // If result == true, that means a dealership was added or updated.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDealershipPage(dealership: dealership),
      ),
    );
    if (result == true) {
      // Refresh the list
      _loadDealerships();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealership List'),
      ),
      body: _dealershipList.isEmpty
          ? const Center(child: Text('No dealerships found.'))
          : ListView.builder(
        itemCount: _dealershipList.length,
        itemBuilder: (context, index) {
          final dealership = _dealershipList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(dealership['name'] ?? ''),
              subtitle: Text(
                '${dealership['city'] ?? ''}, ${dealership['postalCode'] ?? ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _navigateToAddDealershipPage(dealership: dealership),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteDealership(dealership['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddDealershipPage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
