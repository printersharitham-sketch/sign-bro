import '../models/sign_model.dart';

/// Real pipeline (production):
/// Camera frame → YOLO/TensorFlow → Corner detection → ARCore/ARKit → OCR → Material classifier
class SignAI {
  static Future<SignModel> analyzeSign() async {
    // Simulates AI processing delay
    await Future.delayed(const Duration(milliseconds: 700));

    return SignModel(
      id: 'SB-${DateTime.now().millisecondsSinceEpoch}',
      width: 3.2,
      height: 1.8,
      type: 'Billboard',
      material: 'Flex Banner',
      lighting: 'Front-lit LED',
      detectedText: 'SHOP MART',
      confidence: 0.94,
      healthScore: 82.0,
      powerWatts: 240.0,
      installationDate: DateTime(2024, 3, 15),
      warrantyEnd: DateTime(2027, 3, 15),
      status: 'Active',
      maintenancePrediction: 'LED replacement in ~6 months',
    );
  }
}
