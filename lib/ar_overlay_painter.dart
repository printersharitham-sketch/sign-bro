import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AROverlayPainter extends CustomPainter {
  final bool locked;
  final bool isNight;
  final bool isLightBoard;
  final ui.Image? designImage;
  final Rect boardRect;
  final double animValue; // for scanning animation 0.0-1.0

  const AROverlayPainter({
    required this.locked,
    required this.isNight,
    required this.isLightBoard,
    required this.boardRect,
    required this.animValue,
    this.designImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Night overlay
    if (isNight) {
      final nightPaint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..blendMode = BlendMode.darken;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), nightPaint);
    }

    // Board area
    final boardPaint = Paint();

    if (designImage != null) {
      // Draw design image mapped to board rect
      paintImage(
        canvas: canvas,
        rect: boardRect,
        image: designImage!,
        fit: BoxFit.fill,
      );
    } else {
      // Placeholder board
      boardPaint.color = locked
          ? const Color(0xFF1a3a6b).withOpacity(0.85)
          : Colors.transparent;
      if (locked) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(boardRect, const Radius.circular(4)),
          boardPaint,
        );
      }
    }

    // Light board glow effect
    if (locked && isLightBoard) {
      final glowPaint = Paint()
        ..color = (isNight ? Colors.amber : Colors.white).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20);
      canvas.drawRRect(
        RRect.fromRectAndRadius(boardRect, const Radius.circular(4)),
        glowPaint,
      );
      // Inner brightness overlay
      final brightPaint = Paint()
        ..color = Colors.white.withOpacity(isNight ? 0.15 : 0.08);
      canvas.drawRRect(
        RRect.fromRectAndRadius(boardRect, const Radius.circular(4)),
        brightPaint,
      );
    }

    // Board border
    final borderPaint = Paint()
      ..color = locked ? Colors.greenAccent : Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = locked ? 3 : 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(boardRect, const Radius.circular(4)),
      borderPaint,
    );

    // Corner brackets
    _drawCornerBrackets(canvas, boardRect, locked ? Colors.greenAccent : Colors.cyanAccent);

    // Scanning line animation (when not locked)
    if (!locked) {
      final scanY = boardRect.top + boardRect.height * animValue;
      final scanPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.transparent, Colors.cyanAccent, Colors.transparent],
        ).createShader(Rect.fromLTWH(boardRect.left, scanY, boardRect.width, 2));
      canvas.drawLine(
        Offset(boardRect.left, scanY),
        Offset(boardRect.right, scanY),
        scanPaint..strokeWidth = 2,
      );
    }

    // Measurement label
    if (locked) {
      _drawMeasurementLabel(canvas, boardRect, size);
    }
  }

  void _drawCornerBrackets(Canvas canvas, Rect rect, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    // Top-left
    canvas.drawLine(Offset(rect.left, rect.top + len), Offset(rect.left, rect.top), paint);
    canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left + len, rect.top), paint);
    // Top-right
    canvas.drawLine(Offset(rect.right - len, rect.top), Offset(rect.right, rect.top), paint);
    canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right, rect.top + len), paint);
    // Bottom-left
    canvas.drawLine(Offset(rect.left, rect.bottom - len), Offset(rect.left, rect.bottom), paint);
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.left + len, rect.bottom), paint);
    // Bottom-right
    canvas.drawLine(Offset(rect.right - len, rect.bottom), Offset(rect.right, rect.bottom), paint);
    canvas.drawLine(Offset(rect.right, rect.bottom), Offset(rect.right, rect.bottom - len), paint);
  }

  void _drawMeasurementLabel(Canvas canvas, Rect rect, Size size) {
    const text = '4.80m × 1.20m';
    final tp = TextPainter(
      text: const TextSpan(
        text: text,
        style: TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(rect.center.dx, rect.bottom + 18),
        width: tp.width + 20,
        height: 26,
      ),
      const Radius.circular(13),
    );
    canvas.drawRRect(bgRect, Paint()..color = Colors.black.withOpacity(0.7));
    tp.paint(canvas, Offset(rect.center.dx - tp.width / 2, rect.bottom + 6));
  }

  @override
  bool shouldRepaint(AROverlayPainter old) => true;
}
