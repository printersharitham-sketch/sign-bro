import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';
import 'guided_ar_capture.dart';
import 'advanced_ar_capture.dart';

class ARModule extends SignBroModule {
  @override
  String get id => 'ar';
  @override
  String get title => 'AR Scanner';
  @override
  String get description => 'Augmented Reality Sign Measurement';
  @override
  IconData get icon => Icons.view_in_ar;

  @override
  Widget buildPage() => const ARPage();
}

class ARPage extends StatefulWidget {
  const ARPage({super.key});

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  bool _isScanning = false;
  bool _isLocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('AR Scanner'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // AR Preview area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isScanning ? AppTheme.cyan : Colors.grey.shade700,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isLocked ? Icons.lock : Icons.view_in_ar,
                        size: 64,
                        color: _isLocked ? AppTheme.gold : AppTheme.cyan,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isLocked
                            ? 'Measurement Locked'
                            : _isScanning
                                ? 'Scanning...'
                                : 'Tap SCAN to begin',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Measurements display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Measurements',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MeasureChip(label: 'Width', value: '4.82m'),
                      _MeasureChip(label: 'Height', value: '1.21m'),
                      _MeasureChip(label: 'Confidence', value: '96.8%'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isScanning = !_isScanning;
                        if (!_isScanning) _isLocked = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isScanning ? Colors.red : AppTheme.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_isScanning ? 'STOP' : 'SCAN'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isScanning
                        ? () {
                            setState(() => _isLocked = !_isLocked);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_isLocked ? 'UNLOCK' : 'LOCK'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // New AR mode navigation buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GuidedARCapture()),
                      );
                    },
                    icon: const Icon(Icons.assistant_navigation, size: 20),
                    label: const Text('Guided Scan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.cyan,
                      side: const BorderSide(color: AppTheme.cyan),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdvancedARCapture()),
                      );
                    },
                    icon: const Icon(Icons.tune, size: 20),
                    label: const Text('Advanced AR'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.gold,
                      side: const BorderSide(color: AppTheme.gold),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasureChip extends StatelessWidget {
  final String label;
  final String value;
  const _MeasureChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.greyText)),
      ],
    );
  }
}
