import 'dart:ui';

import 'package:flutter/material.dart';

Color _getColor(double sliderValue) {
  switch (sliderValue) {
    case >= 0.8 && <= 1:
      return Colors.green;
    case >= 0.6 && < 0.8:
      return Colors.lightGreen;
    case >= 0.4 && < 0.6:
      return Colors.yellow.shade700;
    case >= 0.2 && < 0.4:
      return Colors.orangeAccent;
    case >= 0 && < 0.2:
      return Colors.redAccent;
    default:
      return Colors.green.shade600;
  }
}

class FaceWidget extends StatelessWidget {
  const FaceWidget({
    required this.sliderValue,
    required this.size,
    super.key,
  });

  final double sliderValue;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: _getColor(sliderValue),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 3),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          width: 4,
          color: Colors.white,
        ),
      ),
      child: CustomPaint(
        foregroundPainter: MouthFacePainter(percent: sliderValue),
        painter: EyesFacePainter(),
      ),
    );
  }
}

class EyesFacePainter extends CustomPainter {
  EyesFacePainter({
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final horizontalCenter = size.width * 0.5;
    final eyesTop = size.height * 0.3;
    final eyesSeparation = size.width * 0.2;

    final painter = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black54;

    canvas
      ..drawCircle(
        Offset(horizontalCenter - eyesSeparation, eyesTop),
        size.width * 0.1,
        painter,
      )
      ..drawCircle(
        Offset(horizontalCenter + eyesSeparation, eyesTop),
        size.width * 0.1,
        painter,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MouthFacePainter extends CustomPainter {
  MouthFacePainter({
    required this.percent,
    super.repaint,
  });

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final mouthStart = size.width * 0.2;
    final mouthEnd = size.width * 0.8;
    final mouthTop = size.height * lerpDouble(0.7, 0.6, percent)!;
    final mouthCenter = size.width * 0.5;
    final mouthPointValue = size.height * lerpDouble(0.4, 1, percent)!;

    final painter = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..color = Colors.black54
      ..strokeCap = StrokeCap.round;

    final arc = Path()
      ..moveTo(mouthStart, mouthTop)
      ..quadraticBezierTo(
        mouthCenter,
        mouthPointValue,
        mouthEnd,
        mouthTop,
      );

    canvas.drawPath(arc, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
