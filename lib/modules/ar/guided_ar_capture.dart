import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';

enum CaptureState {
  searching,
  moveCloser,
  moveBack,
  alignBoard,
  holdSteady,
  boardReady,
  locked,
}

class GuidedARCapture extends StatefulWidget {
  const GuidedARCapture({super.key});

  @override
  State<GuidedARCapture> createState() => _GuidedARCaptureState();
}

class _GuidedARCaptureState extends State<GuidedARCapture> {
  CaptureState _state = CaptureState.searching;
  double _coverage = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    setState(() {
      _state = CaptureState.searching;
      _coverage = 0.0;
      _stability = 0.0;
      _confidence = 0.0;
    });

    _simulationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_state == CaptureState.searching && _coverage < 0.3) {
          _coverage += 0.05;
          if (_coverage >= 0.3) _state = CaptureState.moveCloser;
        } else if (_state == CaptureState.moveCloser && _coverage < 0.5) {
          _coverage += 0.04;
          if (_coverage >= 0.5) _state = CaptureState.moveBack;
        } else if (_state == CaptureState.moveBack && _coverage < 0.7) {
          _coverage += 0.03;
          _stability += 0.1;
          if (_coverage >= 0.7) _state = CaptureState.alignBoard;
        } else if (_state == CaptureState.alignBoard && _stability < 0.6) {
          _stability += 0.08;
          _confidence += 0.05;
          if (_stability >= 0.6) _state = CaptureState.holdSteady;
        } else if (_state == CaptureState.holdSteady && _confidence < 0.85) {
          _stability += 0.05;
          _confidence += 0.08;
          _coverage += 0.02;
          if (_confidence >= 0.85) _state = CaptureState.boardReady;
        } else if (_state == CaptureState.boardReady) {
          _coverage = (_coverage + 0.01).clamp(0.0, 1.0);
          _stability = (_stability + 0.02).clamp(0.0, 1.0);
          _confidence = (_confidence + 0.02).clamp(0.0, 1.0);
        }

        _coverage = _coverage.clamp(0.0, 1.0);
        _stability = _stability.clamp(0.0, 1.0);
        _confidence = _confidence.clamp(0.0, 1.0);
      });
    });
  }

  void _rescan() {
    _startSimulation();
  }

  void _lockSign() {
    if (_confidence < 0.85) {
      _showNotReady();
      return;
    }
    _simulationTimer?.cancel();
    setState(() {
      _state = CaptureState.locked;
    });
  }

  void _showNotReady() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Not ready \u2014 AI Confidence must reach 85% before locking.'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _state == CaptureState.boardReady || _state == CaptureState.locked;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Guided AR Capture'),
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _instruction(),
          const SizedBox(height: 12),
          Expanded(child: _scanFrame(isReady)),
          const SizedBox(height: 12),
          _accuracyPanel(),
          const SizedBox(height: 12),
          _bottomPanel(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _instruction() {
    String text;
    Color color;
    IconData icon;

    switch (_state) {
      case CaptureState.searching:
        text = 'Searching for signboard...';
        color = Colors.white70;
        icon = Icons.search;
        break;
      case CaptureState.moveCloser:
        text = 'Move closer to the sign';
        color = Colors.orangeAccent;
        icon = Icons.arrow_downward;
        break;
      case CaptureState.moveBack:
        text = 'Move back slightly';
        color = Colors.orangeAccent;
        icon = Icons.arrow_upward;
        break;
      case CaptureState.alignBoard:
        text = 'Align the board in frame';
        color = Colors.amberAccent;
        icon = Icons.crop_free;
        break;
      case CaptureState.holdSteady:
        text = 'Hold steady...';
        color = Colors.lightBlueAccent;
        icon = Icons.pan_tool;
        break;
      case CaptureState.boardReady:
        text = 'Board ready \u2014 tap LOCK SIGN';
        color = Colors.greenAccent;
        icon = Icons.check_circle;
        break;
      case CaptureState.locked:
        text = 'Sign locked successfully!';
        color = AppTheme.gold;
        icon = Icons.lock;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accuracyPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _progressRow('BOARD COVERAGE', _coverage, AppTheme.cyan),
          const SizedBox(height: 10),
          _progressRow('PHONE STABILITY', _stability, Colors.amberAccent),
          const SizedBox(height: 10),
          _progressRow('AI CONFIDENCE', _confidence, _confidence >= 0.85 ? Colors.greenAccent : Colors.redAccent),
        ],
      ),
    );
  }

  Widget _progressRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600)),
            Text('${(value * 100).toInt()}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _scanFrame(bool isReady) {
    final frameColor = isReady ? Colors.greenAccent : AppTheme.cyan;

    return Center(
      child: Container(
        width: 300,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: _CornerBracketPainter(color: frameColor, isReady: isReady),
          child: Center(
            child: _state == CaptureState.locked
                ? Icon(Icons.lock, color: AppTheme.gold, size: 48)
                : Icon(Icons.view_in_ar, color: frameColor.withOpacity(0.4), size: 48),
          ),
        ),
      ),
    );
  }

  Widget _bottomPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _state == CaptureState.locked ? null : _rescan,
              icon: const Icon(Icons.refresh),
              label: const Text('RESCAN'),
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
              onPressed: _state == CaptureState.locked ? null : _lockSign,
              icon: const Icon(Icons.lock),
              label: const Text('LOCK SIGN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _state == CaptureState.boardReady ? Colors.greenAccent : AppTheme.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final bool isReady;

  _CornerBracketPainter({required this.color, required this.isReady});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = isReady ? 4 : 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 35.0;

    // Top-left
    canvas.drawLine(const Offset(0, cornerLen), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLen, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - cornerLen, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLen), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height - cornerLen), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLen, size.height), paint);

    // Bottom-left
    canvas.drawLine(Offset(cornerLen, size.height), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isReady != isReady;
}
