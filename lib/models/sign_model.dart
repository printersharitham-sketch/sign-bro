class SignModel {
  final String id;
  final double width;
  final double height;
  final String type;
  final String material;
  final String lighting;
  final String detectedText;
  final double confidence;
  final double healthScore;
  final double powerWatts;
  final DateTime installationDate;
  final DateTime warrantyEnd;
  final String status;
  final String maintenancePrediction;

  SignModel({
    required this.id,
    required this.width,
    required this.height,
    required this.type,
    required this.material,
    required this.lighting,
    required this.detectedText,
    required this.confidence,
    required this.healthScore,
    required this.powerWatts,
    required this.installationDate,
    required this.warrantyEnd,
    required this.status,
    required this.maintenancePrediction,
  });

  double get area => width * height;

  Map<String, dynamic> toJson() => {
    'id': id,
    'width': width,
    'height': height,
    'type': type,
    'material': material,
    'lighting': lighting,
    'detectedText': detectedText,
    'confidence': confidence,
    'healthScore': healthScore,
    'powerWatts': powerWatts,
    'installationDate': installationDate.toIso8601String(),
    'warrantyEnd': warrantyEnd.toIso8601String(),
    'status': status,
    'maintenancePrediction': maintenancePrediction,
    'area': area,
  };
}
