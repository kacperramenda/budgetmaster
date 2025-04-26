import 'package:budgetmaster/widgets/customBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budgetmaster/theme/colors.dart';
import 'package:budgetmaster/presentation/home_view.dart';

class MainScaffold extends StatefulWidget {
  final int currentIndex;

  const MainScaffold({super.key, required this.currentIndex});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  void _onTabTapped(int index) {
    if (index == widget.currentIndex) return;

    String route;
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/budget';
        break;
      case 2:
        route = '/expenses';
        break;
      case 3:
        route = '/settings';
        break;
      default:
        route = '/home';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(widget.currentIndex),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: widget.currentIndex,
        onTabSelected: _onTabTapped,
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const HomeView();
      case 2:
        return const HomeView();
      case 3:
        return const HomeView();
      default:
        return const HomeView();
    }
  }
}
