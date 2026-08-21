import 'dart:math' as math;

class Point3D {
  final double x, y, z;
  const Point3D(this.x, this.y, this.z);
  double distanceTo(Point3D p) {
    final dx = x - p.x, dy = y - p.y, dz = z - p.z;
    return math.sqrt(dx*dx + dy*dy + dz*dz);
  }
}

class MeasurementResult {
  final double widthMeters, heightMeters, widthFeet, heightFeet, confidence;
  const MeasurementResult({
    required this.widthMeters, required this.heightMeters,
    required this.widthFeet, required this.heightFeet, required this.confidence,
  });
}

class SignBroMeasurementEngine {
  double calibrationFactor = 1.0;
  final List<double> _widthHistory = [];
  final List<double> _heightHistory = [];

  void setCalibration({required double knownMeters, required double measuredMeters}) {
    if (measuredMeters <= 0) return;
    calibrationFactor = knownMeters / measuredMeters;
  }

  MeasurementResult? addMeasurement({
    required Point3D topLeft, required Point3D topRight,
    required Point3D bottomLeft, required Point3D bottomRight,
  }) {
    final topWidth = topLeft.distanceTo(topRight);
    final bottomWidth = bottomLeft.distanceTo(bottomRight);
    final leftHeight = topLeft.distanceTo(bottomLeft);
    final rightHeight = topRight.distanceTo(bottomRight);
    final rawWidth = (topWidth + bottomWidth) / 2;
    final rawHeight = (leftHeight + rightHeight) / 2;
    final correctedWidth = rawWidth * calibrationFactor;
    final correctedHeight = rawHeight * calibrationFactor;
    _widthHistory.add(correctedWidth);
    _heightHistory.add(correctedHeight);
    if (_widthHistory.length > 20) _widthHistory.removeAt(0);
    if (_heightHistory.length > 20) _heightHistory.removeAt(0);
    if (_widthHistory.length < 5) return null;
    final stableWidth = _median(_widthHistory);
    final stableHeight = _median(_heightHistory);
    final error = (_variation(_widthHistory, stableWidth) + _variation(_heightHistory, stableHeight)) / 2;
    final confidence = (100 - error * 1000).clamp(0.0, 100.0);
    return MeasurementResult(
      widthMeters: stableWidth, heightMeters: stableHeight,
      widthFeet: stableWidth * 3.28084, heightFeet: stableHeight * 3.28084,
      confidence: confidence,
    );
  }

  double _median(List<double> values) {
    final sorted = [...values]..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd ? sorted[middle] : (sorted[middle-1] + sorted[middle]) / 2;
  }

  double _variation(List<double> values, double median) {
    if (median == 0) return 0;
    return values.map((v) => (v - median).abs() / median).reduce((a,b) => a+b) / values.length;
  }

  void reset() { _widthHistory.clear(); _heightHistory.clear(); }
}
