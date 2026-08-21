import 'dart:math' as math;

class Point3D {
  final double x, y, z;
  const Point3D(this.x, this.y, this.z);
  double distanceTo(Point3D p) {
    final dx = x - p.x, dy = y - p.y, dz = z - p.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }
}
