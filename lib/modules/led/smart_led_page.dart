import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class SmartLEDModule extends SignBroModule {
  @override
  String get id => 'smart_led';
  @override
  String get title => 'Smart LED';
  @override
  String get description => 'LED sign monitoring & control';
  @override
  IconData get icon => Icons.lightbulb_outline;

  @override
  Widget buildPage() => const SmartLEDPage();
}

class SmartLEDPage extends StatefulWidget {
  const SmartLEDPage({super.key});

  @override
  State<SmartLEDPage> createState() => _SmartLEDPageState();
}

class _SmartLEDPageState extends State<SmartLEDPage> {
  bool _isOnline = true;
  double _brightness = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Smart LED Control'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Online/Offline Switch
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 32,
                    color: _isOnline ? AppTheme.gold : AppTheme.greyText,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LED Panel Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                        Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(fontSize: 13, color: _isOnline ? const Color(0xFF10B981) : Colors.red)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOnline,
                    onChanged: (v) => setState(() => _isOnline = v),
                    activeColor: AppTheme.gold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Brightness Slider
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Brightness', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                      Text('${(_brightness * 100).toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.gold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.gold,
                      inactiveTrackColor: AppTheme.lightGrey,
                      thumbColor: AppTheme.gold,
                    ),
                    child: Slider(
                      value: _brightness,
                      onChanged: _isOnline ? (v) => setState(() => _brightness = v) : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Info Cards
            Row(
              children: const [
                Expanded(child: _InfoCard(icon: Icons.bolt, label: 'Power', value: '120W', color: Color(0xFFF59E0B))),
                SizedBox(width: 12),
                Expanded(child: _InfoCard(icon: Icons.thermostat, label: 'Temp', value: '42°C', color: Color(0xFF3B82F6))),
                SizedBox(width: 12),
                Expanded(child: _InfoCard(icon: Icons.favorite, label: 'Health', value: '98%', color: Color(0xFF10B981))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
        ],
      ),
    );
  }
}