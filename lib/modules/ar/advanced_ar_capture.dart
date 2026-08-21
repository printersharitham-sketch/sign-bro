import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum ScanStep {
  detect,
  adjustCorners,
  capture,
  review,
  locked,
}

class AdvancedARCapture extends StatefulWidget {
  const AdvancedARCapture({super.key});

  @override
  State<AdvancedARCapture> createState() => _AdvancedARCaptureState();
}

class _AdvancedARCaptureState extends State<AdvancedARCapture> {
  ScanStep _step = ScanStep.detect;
  bool _photoCaptured = false;

  // 4 normalized Offset corners
  Offset topLeft = const Offset(0.2, 0.2);
  Offset topRight = const Offset(0.8, 0.2);
  Offset bottomLeft = const Offset(0.2, 0.8);
  Offset bottomRight = const Offset(0.8, 0.8);

  @override
  void initState() {
    super.initState();
    // Auto-advance from detect to adjustCorners after brief delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _step == ScanStep.detect) {
        setState(() => _step = ScanStep.adjustCorners);
      }
    });
  }

  void updateCorner(String corner, Offset delta, Size containerSize) {
    setState(() {
      final dx = delta.dx / containerSize.width;
      final dy = delta.dy / containerSize.height;

      switch (corner) {
        case 'topLeft':
          topLeft = Offset(
            (topLeft.dx + dx).clamp(0.0, 1.0),
            (topLeft.dy + dy).clamp(0.0, 1.0),
          );
          break;
        case 'topRight':
          topRight = Offset(
            (topRight.dx + dx).clamp(0.0, 1.0),
            (topRight.dy + dy).clamp(0.0, 1.0),
          );
          break;
        case 'bottomLeft':
          bottomLeft = Offset(
            (bottomLeft.dx + dx).clamp(0.0, 1.0),
            (bottomLeft.dy + dy).clamp(0.0, 1.0),
          );
          break;
        case 'bottomRight':
          bottomRight = Offset(
            (bottomRight.dx + dx).clamp(0.0, 1.0),
            (bottomRight.dy + dy).clamp(0.0, 1.0),
          );
          break;
      }
    });
  }

  double _calculateConfidence() {
    // Based on corner spread + stability
    final width1 = (topRight.dx - topLeft.dx).abs();
    final width2 = (bottomRight.dx - bottomLeft.dx).abs();
    final height1 = (bottomLeft.dy - topLeft.dy).abs();
    final height2 = (bottomRight.dy - topRight.dy).abs();

    final spreadScore = ((width1 + width2) / 2 * 100).clamp(0.0, 50.0);
    final stabilityScore = ((height1 + height2) / 2 * 100).clamp(0.0, 50.0);

    return (spreadScore + stabilityScore).clamp(0.0, 100.0);
  }

  void confirmCorners() {
    final confidence = _calculateConfidence();
    if (confidence < 85) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Confidence too low (${confidence.toInt()}%). Adjust corners for better coverage.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _step = ScanStep.capture);
  }

  void capturePhoto() {
    setState(() {
      _photoCaptured = true;
      _step = ScanStep.review;
    });
  }

  void retakePhoto() {
    setState(() {
      _photoCaptured = false;
      _step = ScanStep.capture;
    });
  }

  void lockSign() {
    if (!_photoCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please capture a photo before locking.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _step = ScanStep.locked);
  }

  void continueToDesign() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignDesignNextStep()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Advanced AR Capture'),
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _stepIndicator(),
          const SizedBox(height: 12),
          Expanded(child: _buildMainArea()),
          const SizedBox(height: 12),
          _buildControls(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _stepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ScanStep.values.map((step) {
          final isActive = step == _step;
          final isPast = step.index < _step.index;
          return Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isActive
                    ? AppTheme.cyan
                    : isPast
                        ? Colors.greenAccent
                        : Colors.white24,
                child: Text(
                  '${step.index + 1}',
                  style: TextStyle(
                    color: isActive || isPast ? Colors.black : Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.name.toUpperCase(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white38,
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth - 32, constraints.maxHeight);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Sign overlay painter
                  CustomPaint(
                    size: size,
                    painter: SignOverlayPainter(
                      topLeft: topLeft,
                      topRight: topRight,
                      bottomLeft: bottomLeft,
                      bottomRight: bottomRight,
                      isLocked: _step == ScanStep.locked,
                    ),
                  ),
                  // Center icon
                  Center(
                    child: _step == ScanStep.locked
                        ? const Icon(Icons.lock, color: AppTheme.gold, size: 48)
                        : _step == ScanStep.review
                            ? const Icon(Icons.photo, color: Colors.greenAccent, size: 48)
                            : Icon(Icons.view_in_ar, color: AppTheme.cyan.withOpacity(0.3), size: 48),
                  ),
                  // Corner handles (only in adjustCorners step)
                  if (_step == ScanStep.adjustCorners) ..._cornerHandles(size),
                  // Confidence display
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Confidence: ${_calculateConfidence().toInt()}%',
                        style: TextStyle(
                          color: _calculateConfidence() >= 85 ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _cornerHandles(Size containerSize) {
    Widget handle(String name, Offset position) {
      return Positioned(
        left: position.dx * containerSize.width - 24,
        top: position.dy * containerSize.height - 24,
        child: GestureDetector(
          onPanUpdate: (details) {
            updateCorner(name, details.delta, containerSize);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.cyan.withOpacity(0.3),
              border: Border.all(color: AppTheme.cyan, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.drag_indicator, color: AppTheme.cyan, size: 18),
            ),
          ),
        ),
      );
    }

    return [
      handle('topLeft', topLeft),
      handle('topRight', topRight),
      handle('bottomLeft', bottomLeft),
      handle('bottomRight', bottomRight),
    ];
  }

  Widget _buildControls() {
    switch (_step) {
      case ScanStep.detect:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                CircularProgressIndicator(color: AppTheme.cyan, strokeWidth: 2),
                SizedBox(height: 12),
                Text('Detecting signboard...', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        );
      case ScanStep.adjustCorners:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Text(
                'Drag corners to match the sign edges',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: confirmCorners,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('CONFIRM CORNERS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      case ScanStep.capture:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: capturePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('CAPTURE PHOTO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        );
      case ScanStep.review:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: retakePhoto,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RETAKE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: lockSign,
                  icon: const Icon(Icons.lock),
                  label: const Text('LOCK SIGN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      case ScanStep.locked:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: continueToDesign,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('CONTINUE TO DESIGN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        );
    }
  }
}

class SignOverlayPainter extends CustomPainter {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;
  final bool isLocked;

  SignOverlayPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLocked ? Colors.greenAccent : AppTheme.cyan
      ..strokeWidth = isLocked ? 3 : 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = (isLocked ? Colors.greenAccent : AppTheme.cyan).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final tl = Offset(topLeft.dx * size.width, topLeft.dy * size.height);
    final tr = Offset(topRight.dx * size.width, topRight.dy * size.height);
    final bl = Offset(bottomLeft.dx * size.width, bottomLeft.dy * size.height);
    final br = Offset(bottomRight.dx * size.width, bottomRight.dy * size.height);

    final path = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SignOverlayPainter oldDelegate) =>
      oldDelegate.topLeft != topLeft ||
      oldDelegate.topRight != topRight ||
      oldDelegate.bottomLeft != bottomLeft ||
      oldDelegate.bottomRight != bottomRight ||
      oldDelegate.isLocked != isLocked;
}

class SignDesignNextStep extends StatelessWidget {
  const SignDesignNextStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Sign Design'),
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.gold.withOpacity(0.15),
                  border: Border.all(color: AppTheme.gold, width: 2),
                ),
                child: const Icon(Icons.design_services, color: AppTheme.gold, size: 56),
              ),
              const SizedBox(height: 32),
              const Text(
                'Sign Captured Successfully!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your sign has been locked and is ready for the design phase.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Placeholder for design workflow
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.brush),
                  label: const Text('CONTINUE TO DESIGN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
