import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class FutureLabModule extends SignBroModule {
  @override
  String get id => 'future_lab';
  @override
  String get title => 'Future Lab';
  @override
  String get description => 'Upcoming technologies & innovations';
  @override
  IconData get icon => Icons.science_outlined;

  @override
  Widget buildPage() => const FutureLabPage();
}

class FutureLabPage extends StatelessWidget {
  const FutureLabPage({super.key});

  static const _technologies = [
    _TechItem('AI Sign Designer', Icons.auto_awesome, Color(0xFF8B5CF6)),
    _TechItem('Mixed Reality', Icons.view_in_ar, Color(0xFF3B82F6)),
    _TechItem('Drone Inspection', Icons.flight, Color(0xFF10B981)),
    _TechItem('Smart LED', Icons.lightbulb_outline, Color(0xFFF59E0B)),
    _TechItem('Digital Twin', Icons.content_copy, Color(0xFFEC4899)),
    _TechItem('Predictive Maintenance', Icons.build_outlined, Color(0xFF06B6D4)),
    _TechItem('City Sign Network', Icons.hub_outlined, Color(0xFFF97316)),
    _TechItem('Immersive Advertising', Icons.vrpano_outlined, Color(0xFF6366F1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Future Lab'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemCount: _technologies.length,
          itemBuilder: (context, index) {
            final tech = _technologies[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tech.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tech.icon, color: tech.color, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      tech.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(fontSize: 10, color: AppTheme.gold, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TechItem {
  final String name;
  final IconData icon;
  final Color color;
  const _TechItem(this.name, this.icon, this.color);
}