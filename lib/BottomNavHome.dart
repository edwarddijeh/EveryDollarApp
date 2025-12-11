import 'package:flutter/material.dart';
import 'package:every_dollar_app/Homepage.dart';
import 'package:every_dollar_app/Budgetpage.dart';
import 'package:every_dollar_app/TransactionsPage.dart';
import 'package:every_dollar_app/ChartsPage.dart';

class BottomNavHome extends StatefulWidget {
  const BottomNavHome({super.key});
  @override
  State<BottomNavHome> createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MyHomePage(title: 'Home'),  // Your counter page
    BudgetPage(title: 'Budget'),
    TransactionsPage(title: 'Transactions'),
    ChartsPage(title: 'Charts'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}