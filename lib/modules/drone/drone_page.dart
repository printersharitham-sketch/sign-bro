import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class DroneModule extends SignBroModule {
  @override
  String get id => 'drone';
  @override
  String get title => 'Drone Inspection';
  @override
  String get description => 'Aerial sign inspection & survey';
  @override
  IconData get icon => Icons.flight;

  @override
  Widget buildPage() => const DronePage();
}

class DronePage extends StatefulWidget {
  const DronePage({super.key});

  @override
  State<DronePage> createState() => _DronePageState();
}

class _DronePageState extends State<DronePage> {
  bool _connected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Drone Inspection'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Card
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
                children: [
                  Icon(
                    Icons.flight,
                    size: 48,
                    color: _connected ? AppTheme.gold : AppTheme.greyText,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _connected ? 'Drone Connected' : 'No Drone Connected',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _connected ? AppTheme.darkText : AppTheme.greyText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatusIndicator(label: 'Battery', value: _connected ? '87%' : '--', active: _connected),
                      _StatusIndicator(label: 'Signal', value: _connected ? 'Strong' : '--', active: _connected),
                      _StatusIndicator(label: 'GPS', value: _connected ? 'Locked' : '--', active: _connected),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Connect/Disconnect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _connected = !_connected);
                },
                icon: Icon(_connected ? Icons.link_off : Icons.link, size: 18),
                label: Text(_connected ? 'DISCONNECT DRONE' : 'CONNECT DRONE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _connected ? Colors.red : AppTheme.gold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Start Inspection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _connected ? () {} : null,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('START INSPECTION'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String label;
  final String value;
  final bool active;
  const _StatusIndicator({required this.label, required this.value, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFF10B981) : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: active ? AppTheme.darkText : AppTheme.greyText)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
      ],
    );
  }
}