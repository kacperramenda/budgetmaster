import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter/material.dart';

class ExpensesSetView extends StatelessWidget {
  const ExpensesSetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              PageHeader(
                title: 'Zestawienie wydatków',
                route: '/home',
              ),
          
        ],
      ),
    );
  }
}
