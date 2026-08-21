import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'ar_overlay_painter.dart';
import 'design_studio.dart';

class LiveSignCanvas extends StatefulWidget {
  const LiveSignCanvas({super.key});
  @override
  State<LiveSignCanvas> createState() => _LiveSignCanvasState();
}

class _LiveSignCanvasState extends State<LiveSignCanvas> with TickerProviderStateMixin {
  CameraController? controller;
  late AnimationController _scanAnim;

  bool locked = false;
  bool isNight = false;
  bool isLightBoard = true;

  String signType = "Detecting...";
  String detectedText = "Point camera at signboard";
  String detectedSize = "-- × --";
  String material = "Scanning";
  int confidence = 0;

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      controller = CameraController(back, ResolutionPreset.high, enableAudio: false);
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void lockSign() => setState(() {
    locked = true;
    signType = "Illuminated ACP Board";
    detectedText = "YOUR BRAND";
    detectedSize = "4.80m × 1.20m";
    material = "ACP + Acrylic + LED";
    confidence = 94;
  });

  void unlockSign() => setState(() {
    locked = false;
    signType = "Detecting...";
    detectedText = "Scanning...";
    detectedSize = "-- × --";
    material = "Scanning";
    confidence = 0;
  });

  @override
  void dispose() {
    _scanAnim.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boardRect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height * 0.38),
      width: screenSize.width * 0.86,
      height: screenSize.height * 0.27,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Positioned.fill(
          child: (controller != null && controller!.value.isInitialized)
              ? CameraPreview(controller!)
              : Container(
                  color: const Color(0xFF0a1628),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, color: Colors.white24, size: 48),
                        SizedBox(height: 8),
                        Text("Camera initializing...", style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  ),
                ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) => CustomPaint(
              painter: AROverlayPainter(
                locked: locked,
                isNight: isNight,
                isLightBoard: isLightBoard,
                boardRect: boardRect,
                animValue: _scanAnim.value,
              ),
            ),
          ),
        ),
        Positioned.fill(child: IgnorePointer(child: DecoratedBox(
          decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(.6), Colors.transparent, Colors.black.withOpacity(.8)],
          )),
        ))),
        SafeArea(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(30)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.view_in_ar, color: Colors.cyanAccent, size: 20),
                SizedBox(width: 8),
                Text("SIGN BRO AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13)),
              ]),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => isNight = !isNight),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isNight ? Colors.indigo.withOpacity(.8) : Colors.amber.withOpacity(.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(isNight ? Icons.nights_stay : Icons.wb_sunny, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => isLightBoard = !isLightBoard),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isLightBoard ? Colors.amber.withOpacity(.8) : Colors.grey.withOpacity(.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(isLightBoard ? Icons.lightbulb : Icons.lightbulb_outline, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(isLightBoard ? "LIT" : "UNLIT", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ]),
        )),
        Positioned(top: 100, left: 0, right: 0,
          child: Center(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: locked ? Colors.green.withOpacity(.85) : Colors.black.withOpacity(.70),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(locked ? Icons.lock : Icons.radar, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                locked ? "SIGNBOARD LOCKED" : "AI SEARCHING FOR SIGNBOARD",
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ]),
          )),
        ),
        Positioned(left: 16, right: 16, bottom: 140,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.82),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Column(children: [
              _infoRow(Icons.category, "SIGN TYPE", signType),
              _infoRow(Icons.text_fields, "TEXT DETECTED", detectedText),
              _infoRow(Icons.layers, "MATERIAL", material),
              _infoRow(Icons.verified, "AI CONFIDENCE", confidence == 0 ? "--" : "$confidence%"),
              _infoRow(Icons.wb_sunny, "MODE", isNight ? "🌙 Night" : "☀️ Day"),
              _infoRow(Icons.lightbulb, "BOARD", isLightBoard ? "💡 Illuminated" : "⬜ Non-illuminated"),
            ]),
          ),
        ),
        Positioned(bottom: 35, left: 20, right: 20,
          child: Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: locked ? unlockSign : null,
              icon: const Icon(Icons.refresh),
              label: const Text("RESCAN"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white30),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: locked ? null : lockSign,
              child: Container(
                width: 76, height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: locked ? Colors.grey : Colors.cyanAccent,
                  boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(.4), blurRadius: 25)],
                ),
                child: Icon(locked ? Icons.lock : Icons.center_focus_strong, color: Colors.black, size: 32),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.icon(
              onPressed: locked ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DesignStudio())) : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("AI DESIGN"),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 18, color: Colors.cyanAccent),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      const Spacer(),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    ]),
  );
}
