import 'package:every_dollar_app/Transaction.dart';

class BudgetItem {
  String name = '';
  double amount = 0.0;
  double mDisplayedTotal = 0;
  double mCurrentTotal = 0;
  double mRemainingAmount = 0;
  final String? id;  // Optional: Use Uuid or DateTime.now().toString() for uniqueness
  BudgetItem({required this.name, required this.amount, this.id})
  {
    mDisplayedTotal = amount;
  }
  List<Transaction> transactions = [];
}