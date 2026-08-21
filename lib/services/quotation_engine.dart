import '../models/sign_model.dart';

class Quotation {
  final double material;
  final double frame;
  final double lighting;
  final double letters;
  final double installation;
  final double total;

  Quotation({
    required this.material,
    required this.frame,
    required this.lighting,
    required this.letters,
    required this.installation,
    required this.total,
  });
}

class QuotationEngine {
  static const double _materialRate = 1450; // per sqm
  static const double _frameRate = 450;
  static const double _lightingRate = 600;
  static const double _lettersRate = 850;
  static const double _installationRate = 350;

  static Quotation calculate(SignModel sign) {
    final area = sign.area;
    final material = area * _materialRate;
    final frame = area * _frameRate;
    final lighting = area * _lightingRate;
    final letters = area * _lettersRate;
    final installation = area * _installationRate;
    final total = material + frame + lighting + letters + installation;

    return Quotation(
      material: material,
      frame: frame,
      lighting: lighting,
      letters: letters,
      installation: installation,
      total: total,
    );
  }
}
