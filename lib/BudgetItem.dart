
class BudgetItem {
  String title = '';
  double amount = 0.0;
  double mDisplayedTotal = 0;
  double mCurrentTotal = 0;
  double mRemainingAmount = 0;
  BudgetItem({required this.title, required this.amount})
  {
    mDisplayedTotal = amount;
  }
}