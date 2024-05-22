import 'package:flutter/material.dart';
import 'package:happiness_meter/face_widget.dart';
import 'package:happiness_meter/slider_widget.dart';

class HappinessMeterPage extends StatefulWidget {
  const HappinessMeterPage({super.key});

  @override
  State<HappinessMeterPage> createState() => _HappinessMeterPageState();
}

class _HappinessMeterPageState extends State<HappinessMeterPage> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0089CE),
            Color(0xFF70E4E3),
            Color(0xFF667DB6),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Happiness Meter',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Row(
            children: [
              SliderWidget(
                width: 200,
                onSlide: (value) => setState(() => _sliderValue = value),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaceWidget(sliderValue: _sliderValue, size: 100),
                  const SizedBox(height: 10),
                  Text(
                    '${(_sliderValue * 100).ceil()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 3),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
