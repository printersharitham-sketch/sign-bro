import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/ar_scan_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/map_screen.dart';
import 'live_sign_canvas.dart';
import 'sign_digital_twin.dart';
import 'theme/app_theme.dart';

void main() => runApp(const SignBroApp());

class SignBroApp extends StatelessWidget {
  const SignBroApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sign Bro',
    theme: AppTheme.theme,
    home: const LiveSignCanvas(),
    debugShowCheckedModeBanner: false,
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _screens = const [
    HomeScreen(), ExploreScreen(), ARScanScreen(), CalculatorScreen(), MapScreen(), SignDigitalTwin()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _screens[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.gold,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'AR Scan'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.view_in_ar), label: 'Twin'),
      ],
    ),
  );
}
