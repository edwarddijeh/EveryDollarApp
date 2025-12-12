// File: lib/BudgetCategoryContainer.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:every_dollar_app/BudgetItem.dart';

class BudgetCategoryContainer extends StatefulWidget {
  final String categoryName;
  final List<BudgetItem> items;
  final void Function(BudgetItem) onAddItem;
  final void Function(BudgetItem)? onRemoveItem;

  const BudgetCategoryContainer({super.key,
    required this.categoryName,
    required this.items,
    required this.onAddItem,
    this.onRemoveItem,
  });

  @override
  State<BudgetCategoryContainer> createState() => _BudgetCategoryContainerState();
}

class _BudgetCategoryContainerState extends State<BudgetCategoryContainer> {

  @override
  Widget build(BuildContext context) {
    final total = widget.items.fold(0.0, (sum, item) => sum + item.amount);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.categoryName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),

            // widget.items list
            widget.items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('No items yet', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return GestureDetector(
                        onTap: () => _showEditDialog(context, item, index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(item.name)),
                              Text(
                                '\$${item.amount.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (widget.onRemoveItem != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => widget.onRemoveItem!(item),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 16),

            // Add Button — Now works!
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add),
                label: Text('Add ${widget.categoryName} Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to $widget.categoryName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final amountText = amountController.text.trim();
              if (name.isNotEmpty && amountText.isNotEmpty) {
                final amount = double.tryParse(amountText);
                if (amount != null && amount > 0) {
                  widget.onAddItem(BudgetItem(name: name, amount: amount));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid amount')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, BudgetItem item, int index) {
  final nameController = TextEditingController(text: item.name);
  final amountController = TextEditingController(text: item.amount.toStringAsFixed(2));

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit ${widget.categoryName} Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newName = nameController.text.trim();
            final newAmountText = amountController.text.trim();

            if (newName.isNotEmpty && newAmountText.isNotEmpty) {
              final newAmount = double.tryParse(newAmountText);
              if (newAmount != null && newAmount > 0) {
                setState(() {
                  widget.items[index] = BudgetItem(name: newName, amount: newAmount);
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
  }
}