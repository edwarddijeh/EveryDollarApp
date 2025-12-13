// File: lib/BudgetPage.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:every_dollar_app/BudgetItem.dart';
import 'package:every_dollar_app/BudgetCategoryContainer.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, required this.title});
  final String title;

  @override
  State<BudgetPage> createState() => _BudgetPage();
}

class _BudgetPage extends State<BudgetPage> {
  // Data structure: '2025-12' → { 'Groceries': [items], 'Utilities': [...], ... }
  final Map<String, Map<String, List<BudgetItem>>> monthlyBudgets = {};

  // Current month in 'YYYY-MM' format
  String currentMonthKey =
      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';

  Map<String, List<BudgetItem>> initbudgetCategories() 
  {
    Map<String, List<BudgetItem>> resultMap = 
    {
    'Income': [BudgetItem(name: 'Paycheck 1', amount: 200.0), BudgetItem(name: "Paycheck 2", amount: 300.0)],
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
    return resultMap;
  }

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
  void initState() {
    super.initState();
    _ensureMonthExists();
  }

  // Make sure the current month has all categories initialized
  void _ensureMonthExists() {
    monthlyBudgets.putIfAbsent(currentMonthKey, initbudgetCategories);
  }

  // Convert '2025-12' → 'December 2025'
  String _formatMonth(String monthKey) {
    final parts = monthKey.split('-');
    final year = parts[0];
    final monthInt = int.parse(parts[1]);
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${monthNames[monthInt - 1]} $year';
  }

  // Scrollable Month/Year Picker (replace your entire _pickMonth with this)
  Future<void> _pickMonth() async {
    String? tempSelectedKey = currentMonthKey; // Temporary selection

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // ~60% of screen
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Budget Month',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (tempSelectedKey != null) {
                          setState(() {
                            currentMonthKey = tempSelectedKey!;
                            _ensureMonthExists();
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Scrollable list of months
              Expanded(
                child: ListView.builder(
                  itemCount: 24, // 2 years × 12 months = 24
                  itemBuilder: (context, index) {
                    const startYear = 2025;
                    final year = startYear + (index ~/ 12);
                    final month = (index % 12) + 1;
                    final monthKey = '$year-${month.toString().padLeft(2, '0')}';

                    final isSelected = monthKey == tempSelectedKey;

                    return ListTile(
                      title: Center(
                        child: Text(
                          _formatMonth(monthKey),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      onTap: () {
                        tempSelectedKey = monthKey;
                        // Refresh the list to show new selection highlight
                        (context as Element).markNeedsBuild();
                      },
                      tileColor: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.15)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCategories = monthlyBudgets[currentMonthKey]!;
    final isEmpty = currentCategories.values.every((list) => list.isEmpty);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          // Month selector button
          TextButton(
            onPressed: _pickMonth,
            child: Text(
              _formatMonth(currentMonthKey),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body:isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No items yet for ${_formatMonth(currentMonthKey)}\n'
                  'Tap "Add Item" in any category to begin',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          : ListView(
            children: categoryOrder.map((category) {
              final items = currentCategories[category]!;
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