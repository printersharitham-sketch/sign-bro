import 'package:flutter/material.dart';
import '../models/measurement_engine.dart';
import '../theme/app_theme.dart';

class MeasurementCard extends StatelessWidget {
  final MeasurementResult result;
  final VoidCallback? onPlaceSign;
  const MeasurementCard({super.key, required this.result, this.onPlaceSign});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xEE102544),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.gold),
    ),
    child: Column(
      children: [
        const Text('MEASUREMENT DETECTED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          '${result.widthFeet.toStringAsFixed(1)} × ${result.heightFeet.toStringAsFixed(1)} ft',
          style: const TextStyle(color: AppTheme.gold, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          '${result.widthMeters.toStringAsFixed(2)} × ${result.heightMeters.toStringAsFixed(2)} m',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: result.confidence / 100,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation(result.confidence > 80 ? Colors.green : AppTheme.gold),
        ),
        const SizedBox(height: 4),
        Text('Confidence: ${result.confidence.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onPlaceSign,
          child: const Text('PLACE SIGN BOARD'),
        ),
      ],
    ),
  );
}
