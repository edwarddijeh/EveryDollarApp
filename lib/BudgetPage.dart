import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:every_dollar_app/BudgetItem.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  List<BudgetItem> mBudgetItems = [];

  void _addBudgetItem(String name, double amount) {
    setState(() {
    mBudgetItems.add(BudgetItem(title: name, amount: amount));
    });
  }

  void _showAddBudgetItemDialog() {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Budget Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Groceries',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'e.g., 150.00',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text.trim();
              final String amountText = amountController.text.trim();

              if (name.isNotEmpty && amountText.isNotEmpty) {
                final double? amount = double.tryParse(amountText);
                if (amount != null && amount > 0) {
                  _addBudgetItem(name, amount);
                  Navigator.of(context).pop();
                } else {
                  // Optional: Show error for invalid amount
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: mBudgetItems.isEmpty
          ? const Center(child: Text('No items yet'))
          : ListView.builder(
              itemCount: mBudgetItems.length,
              itemBuilder: (context, index) {
                final item = mBudgetItems[index];
                return ListTile(
                  title: Text(item.title),
                  trailing: Text('\$${item.amount.toStringAsFixed(2)}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBudgetItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
