// File: lib/BudgetPage.dart
import 'package:flutter/material.dart';
import 'package:every_dollar_app/BudgetItem.dart';
import 'package:every_dollar_app/BudgetCategoryContainer.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, required this.title});
  final String title;

  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  final Map<String, List<BudgetItem>> budgetCategories = {
    'Income': [],
    'Giving': [],
    'Savings': [],
    'Housing and Utilities': [],
    'Transportation': [],
    'Food': [],
    'Personal': [],
    'Health': [],
    'Lifestyle': [],
    'Insurance': [],
    'Subscriptions': [],
  };

  final List<String> categoryOrder = [
    'Income',
    'Giving',
    'Savings',
    'Housing and Utilities',
    'Transportation',
    'Food',
    'Personal',
    'Health',
    'Lifestyle',
    'Insurance',
    'Subscriptions',
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
              children: categoryOrder.map((category) {
                final items = budgetCategories[category]!;
                return BudgetCategoryContainer(
                  categoryName: category,
                  items: items,
                  onAddItem: (item) {
                    setState(() {
                      items.add(item);
                    });
                  },
                  onRemoveItem: (item) {
                    setState(() {
                      items.remove(item);
                    });
                  },
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add item',
        child: const Icon(Icons.add),
        onPressed: () {
          // Optional: scroll to top or show hint
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tap "Add Item" button inside any category'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}