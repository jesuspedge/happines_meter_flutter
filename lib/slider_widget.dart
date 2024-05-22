import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    required this.onSlide,
    this.width = 150,
    super.key,
  });

  final double width;
  final ValueChanged<double> onSlide;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with SingleTickerProviderStateMixin {
  double _sliderRelativePosition = 0;
  double _startedDraggingAtY = 0;
  Duration animationDuration = const Duration(milliseconds: 100);

  late final AnimationController _animationController;
  late final Animation<double> _sliderAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: animationDuration);

    _sliderAnimation =
        CurveTween(curve: Curves.easeInQuad).animate(_animationController);

    _animationController.addListener(() {
      setState(() => _sliderRelativePosition = _sliderAnimation.value);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green,
          Colors.lightGreen,
          Colors.yellow.shade700,
          Colors.orangeAccent,
          Colors.redAccent,
        ],
      ).createShader(bounds),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final sliderRadius = _radius;
          final sliderMaxY = constraints.maxHeight - sliderRadius;
          final sliderPosY = sliderMaxY * _sliderRelativePosition;

          return Stack(
            alignment: Alignment.topRight,
            children: [
              _buildMeter(
                maxHeight: constraints.maxHeight,
                sliderRadius: sliderRadius,
              ),
              _buildSlider(sliderMaxY: sliderMaxY, sliderPositionY: sliderPosY),
            ],
          );
        },
      ),
    );
  }

  ClipRect _buildMeter({
    required double maxHeight,
    required double sliderRadius,
  }) {
    return ClipRect(
      child: SizedBox(
        height: maxHeight,
        width: widget.width,
        child: CustomPaint(
          foregroundPainter: SliderLinePainter(
            percent: _sliderRelativePosition,
            sliderRadius: sliderRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required double sliderMaxY,
    required double sliderPositionY,
  }) {
    return Positioned(
      bottom: sliderPositionY,
      child: GestureDetector(
        onVerticalDragStart: (start) {
          _startedDraggingAtY = sliderPositionY;
          _animationController.stop();
        },
        onVerticalDragUpdate: (update) {
          final newSliderPositionY =
              _startedDraggingAtY - update.localPosition.dy;
          final newSliderRelativePosition = newSliderPositionY / sliderMaxY;

          setState(
            () => _sliderRelativePosition =
                max(0, min(1, newSliderRelativePosition)),
          );

          widget.onSlide(_sliderRelativePosition);
        },
        child: Container(
          height: _radius,
          width: _radius,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 3),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _radius => widget.width * 0.35;
}

class SliderLinePainter extends CustomPainter {
  SliderLinePainter({
    required this.percent,
    required this.sliderRadius,
    super.repaint,
  });

  final double percent;
  final double sliderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final halfSliderRadius = sliderRadius * 0.5;
    final seventyFiveSliderRadius = sliderRadius * 0.75;
    final xPosition = size.width - halfSliderRadius;
    final maxHeight = size.height - sliderRadius;
    final sliderTopYPosition =
        maxHeight * lerpDouble(1, 0, percent)! - halfSliderRadius;
    final sliderBottomYPosition = sliderTopYPosition + sliderRadius * 2;

    final thirdWidth = size.width * 0.3;
    final twentyWidth = size.width * 0.2;
    final tenWidth = size.width * 0.1;
    final maxDivisionsHeight = size.height - halfSliderRadius;
    final minDivisionsHeight = halfSliderRadius;
    final divisionsHeight = (maxDivisionsHeight - minDivisionsHeight) * 0.05;

    final painterLine = Paint()
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    final painterFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white54;

    final painterDivisions = Paint()
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black54;

    final pathLine = Path()
      ..moveTo(xPosition, 0)
      ..lineTo(
        xPosition,
        sliderTopYPosition,
      )
      ..cubicTo(
        xPosition,
        sliderTopYPosition + 25,
        xPosition - seventyFiveSliderRadius,
        sliderTopYPosition + 10,
        xPosition - seventyFiveSliderRadius,
        sliderTopYPosition + sliderRadius,
      )
      ..cubicTo(
        xPosition - seventyFiveSliderRadius,
        sliderBottomYPosition - 10,
        xPosition,
        sliderBottomYPosition - 25,
        xPosition,
        sliderBottomYPosition,
      )
      ..lineTo(xPosition, size.height);

    final pathFill = Path()
      ..lineTo(xPosition, 0)
      ..lineTo(
        xPosition,
        sliderTopYPosition,
      )
      ..cubicTo(
        xPosition,
        sliderTopYPosition + 25,
        xPosition - seventyFiveSliderRadius,
        sliderTopYPosition + 10,
        xPosition - seventyFiveSliderRadius,
        sliderTopYPosition + sliderRadius,
      )
      ..cubicTo(
        xPosition - seventyFiveSliderRadius,
        sliderBottomYPosition - 10,
        xPosition,
        sliderBottomYPosition - 25,
        xPosition,
        sliderBottomYPosition,
      )
      ..lineTo(xPosition, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    final pathDivisions = Path()
      ..moveTo(0, minDivisionsHeight)
      ..lineTo(thirdWidth, minDivisionsHeight)
      ..moveTo(0, minDivisionsHeight + divisionsHeight)
      ..lineTo(tenWidth, minDivisionsHeight + divisionsHeight)
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 2))
      ..lineTo(twentyWidth, minDivisionsHeight + (divisionsHeight * 2))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 3))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 3))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 4))
      ..lineTo(thirdWidth, minDivisionsHeight + (divisionsHeight * 4))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 5))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 5))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 6))
      ..lineTo(twentyWidth, minDivisionsHeight + (divisionsHeight * 6))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 7))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 7))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 8))
      ..lineTo(thirdWidth, minDivisionsHeight + (divisionsHeight * 8))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 9))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 9))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 10))
      ..lineTo(twentyWidth, minDivisionsHeight + (divisionsHeight * 10))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 11))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 11))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 12))
      ..lineTo(thirdWidth, minDivisionsHeight + (divisionsHeight * 12))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 13))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 13))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 14))
      ..lineTo(twentyWidth, minDivisionsHeight + (divisionsHeight * 14))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 15))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 15))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 16))
      ..lineTo(thirdWidth, minDivisionsHeight + (divisionsHeight * 16))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 17))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 17))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 18))
      ..lineTo(twentyWidth, minDivisionsHeight + (divisionsHeight * 18))
      ..moveTo(0, minDivisionsHeight + (divisionsHeight * 19))
      ..lineTo(tenWidth, minDivisionsHeight + (divisionsHeight * 19))
      ..moveTo(0, maxDivisionsHeight)
      ..lineTo(thirdWidth, maxDivisionsHeight);

    canvas
      ..drawPath(pathLine, painterLine)
      ..drawPath(pathFill, painterFill)
      ..drawPath(pathDivisions, painterDivisions);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
