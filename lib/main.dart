import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/ar_scan_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SignBroApp());
}

class SignBroApp extends StatelessWidget {
  const SignBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGN BRO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ExploreScreen(),
    SizedBox(), // Placeholder — camera opens as full screen
    ProjectsScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int index) {
    if (index == 2) {
      // Open AR camera as fullscreen push
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ARScanScreen()),
      );
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SignBroBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
