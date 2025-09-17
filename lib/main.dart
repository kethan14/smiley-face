import 'package:flutter/material.dart';

void main() {
  runApp(const EmojiApp());
}

class EmojiApp extends StatelessWidget {
  const EmojiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Drawing App',
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

class _EmojiHomePageState extends State<EmojiHomePage> {
  String _selectedEmoji = "Smiley";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Interactive Emoji Drawing")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedEmoji,
            items: const [
              DropdownMenuItem(value: "Smiley", child: Text("😊 Smiley Face")),
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
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: _getPainter(_selectedEmoji),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomPainter _getPainter(String emoji) {
    switch (emoji) {
      case "Smiley":
        return SmileyPainter();
      case "Heart":
        return HeartPainter();
      case "PartyFace":
        return PartyFacePainter();
      default:
        return SmileyPainter();
    }
  }
}

// Empty stubs for painters
class SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PartyFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
