import 'package:every_dollar_app/Transaction.dart';

class BudgetItem {
  String name = '';
  double amount = 0.0;
  double mDisplayedTotal = 0;
  double mCurrentTotal = 0;
  double mRemainingAmount = 0;
  BudgetItem({required this.name, required this.amount})
  {
    mDisplayedTotal = amount;
  }
  List<Transaction> transactions = [];
}