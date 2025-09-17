import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const EmojiApp());

class EmojiApp extends StatelessWidget {
  const EmojiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Emoji App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EmojiHomePage(),
    );
  }
}

class EmojiHomePage extends StatefulWidget {
  const EmojiHomePage({super.key});

  @override
  State<EmojiHomePage> createState() => _EmojiHomePageState();
}

class _EmojiHomePageState extends State<EmojiHomePage>
    with SingleTickerProviderStateMixin {
  String _selectedEmoji = "Smiley";
  late AnimationController _controller;
  final Random _random = Random();
  final List<Offset> _confettiPositions = [];
  final int _confettiCount = 40;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _confettiCount; i++) {
      _confettiPositions.add(
        Offset(_random.nextDouble(), _random.nextDouble()),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animated Emoji Drawing")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedEmoji,
              items: const [
                DropdownMenuItem(
                  value: "Smiley",
                  child: Text("😊 Smiley Face"),
                ),
                DropdownMenuItem(value: "Heart", child: Text("❤️ Heart")),
                DropdownMenuItem(
                  value: "PartyFace",
                  child: Text("🥳 Party Face"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedEmoji = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _getPainter(
                          _selectedEmoji,
                          _controller.value,
                          _confettiPositions,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPainter _getPainter(
    String emoji,
    double animValue,
    List<Offset> confetti,
  ) {
    switch (emoji) {
      case "Smiley":
        return SmileyPainter();
      case "Heart":
        return HeartPainter();
      case "PartyFace":
        return PartyFacePainter(
          animValue: animValue,
          confettiPositions: confetti,
        );
      default:
        return SmileyPainter();
    }
  }
}

// ==========================
// SMILEY PAINTER (Responsive)
// ==========================
class SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;

    final facePaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(center, radius, facePaint);

    final eyePaint = Paint()..color = Colors.black;
    final eyeOffsetX = radius * 0.4;
    final eyeOffsetY = radius * 0.3;
    final eyeRadius = radius * 0.1;

    canvas.drawCircle(
      Offset(center.dx - eyeOffsetX, center.dy - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffsetX, center.dy - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.3),
      width: radius * 1.2,
      height: radius * 0.6,
    );
    canvas.drawArc(mouthRect, 0.1, pi - 0.2, false, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================
// HEART PAINTER (Responsive)
// ==========================
class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    final path = Path();

    final width = size.width * 0.5;
    final height = size.height * 0.5;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    path.moveTo(centerX, centerY - height / 4);
    path.cubicTo(
      centerX - width / 2,
      centerY - height / 2,
      centerX - width / 2,
      centerY + height / 4,
      centerX,
      centerY + height / 2,
    );
    path.cubicTo(
      centerX + width / 2,
      centerY + height / 4,
      centerX + width / 2,
      centerY - height / 2,
      centerX,
      centerY - height / 4,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================
// PARTY FACE PAINTER WITH ANIMATION
// ==========================
class PartyFacePainter extends CustomPainter {
  final double animValue;
  final List<Offset> confettiPositions;
  final Random random = Random();

  PartyFacePainter({required this.animValue, required this.confettiPositions});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;

    // Face
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow, Colors.orangeAccent.shade100],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, facePaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.3),
      width: radius * 1.2,
      height: radius * 0.6,
    );
    canvas.drawArc(mouthRect, 0.1, pi - 0.2, false, mouthPaint);

    // Cheeks
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.4);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.6, center.dy + radius * 0.1),
      radius * 0.15,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.6, center.dy + radius * 0.1),
      radius * 0.15,
      blushPaint,
    );

    // Eyes (blink animation)
    final eyeWhite = Paint()..color = Colors.white;
    final eyeBlack = Paint()..color = Colors.black;
    final eyeHeight = animValue < 0.1 ? radius * 0.02 : radius * 0.25;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.4, center.dy - radius * 0.3),
        width: radius * 0.3,
        height: eyeHeight,
      ),
      eyeWhite,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.4, center.dy - radius * 0.3),
        width: radius * 0.3,
        height: eyeHeight,
      ),
      eyeWhite,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.3),
      radius * 0.1,
      eyeBlack,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.3),
      radius * 0.1,
      eyeBlack,
    );

    // Party Hat (wiggle animation)
    final hatOffset = sin(animValue * pi * 2) * radius * 0.05;
    final hatPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [Colors.blue, Colors.red, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(
              center.dx - radius * 0.5 + hatOffset,
              center.dy - radius * 1.3,
              radius,
              radius * 0.6,
            ),
          );
    final hatPath = Path()
      ..moveTo(center.dx + hatOffset, center.dy - radius * 1.4)
      ..lineTo(center.dx - radius * 0.5 + hatOffset, center.dy - radius * 0.5)
      ..lineTo(center.dx + radius * 0.5 + hatOffset, center.dy - radius * 0.5)
      ..close();
    canvas.drawPath(hatPath, hatPaint);
    canvas.drawCircle(
      Offset(center.dx + hatOffset, center.dy - radius * 1.45),
      radius * 0.08,
      Paint()..color = Colors.purple,
    );

    // Confetti
    final confettiColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];
    for (var i = 0; i < confettiPositions.length; i++) {
      final offset = confettiPositions[i];
      final x = offset.dx * size.width;
      final y = (offset.dy + animValue) % 1 * size.height;
      canvas.drawCircle(
        Offset(x, y),
        radius * 0.03,
        Paint()..color = confettiColors[i % confettiColors.length],
      );
    }
  }

  @override
  bool shouldRepaint(covariant PartyFacePainter oldDelegate) => true;
}
