import 'package:flutter_test/flutter_test.dart';
import 'package:signbro/models/measurement_engine.dart';

void main() {
  group('SignBroMeasurementEngine', () {
    late SignBroMeasurementEngine engine;

    setUp(() {
      engine = SignBroMeasurementEngine();
    });

    test('initial calibration factor is 1.0', () {
      expect(engine.calibrationFactor, 1.0);
    });

    test('setCalibration updates factor correctly', () {
      engine.setCalibration(knownMeters: 2.0, measuredMeters: 1.0);
      expect(engine.calibrationFactor, 2.0);
    });

    test('setCalibration ignores zero measuredMeters', () {
      engine.setCalibration(knownMeters: 2.0, measuredMeters: 0.0);
      expect(engine.calibrationFactor, 1.0);
    });

    test('addMeasurement returns null for less than 5 readings', () {
      for (int i = 0; i < 4; i++) {
        final result = engine.addMeasurement(
          topLeft: const Point3D(0, 2, 0),
          topRight: const Point3D(3, 2, 0),
          bottomLeft: const Point3D(0, 0, 0),
          bottomRight: const Point3D(3, 0, 0),
        );
        expect(result, isNull);
      }
    });

    test('addMeasurement returns result after 5 readings', () {
      MeasurementResult? result;
      for (int i = 0; i < 5; i++) {
        result = engine.addMeasurement(
          topLeft: const Point3D(0, 2, 0),
          topRight: const Point3D(3, 2, 0),
          bottomLeft: const Point3D(0, 0, 0),
          bottomRight: const Point3D(3, 0, 0),
        );
      }
      expect(result, isNotNull);
      expect(result!.widthMeters, closeTo(3.0, 0.01));
      expect(result.heightMeters, closeTo(2.0, 0.01));
      expect(result.widthFeet, closeTo(3.0 * 3.28084, 0.1));
      expect(result.heightFeet, closeTo(2.0 * 3.28084, 0.1));
      expect(result.confidence, 100.0);
    });

    test('reset clears history', () {
      for (int i = 0; i < 10; i++) {
        engine.addMeasurement(
          topLeft: const Point3D(0, 2, 0),
          topRight: const Point3D(3, 2, 0),
          bottomLeft: const Point3D(0, 0, 0),
          bottomRight: const Point3D(3, 0, 0),
        );
      }
      engine.reset();
      final result = engine.addMeasurement(
        topLeft: const Point3D(0, 2, 0),
        topRight: const Point3D(3, 2, 0),
        bottomLeft: const Point3D(0, 0, 0),
        bottomRight: const Point3D(3, 0, 0),
      );
      expect(result, isNull);
    });

    test('Point3D distanceTo works correctly', () {
      const a = Point3D(0, 0, 0);
      const b = Point3D(3, 4, 0);
      expect(a.distanceTo(b), closeTo(5.0, 0.001));
    });
  });
}
