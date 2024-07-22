import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

final List<Map<String, String>> qnAs = [
  {"Q": "Who created Helvetica?", "A": "Max Miedinger"},
  {"Q": "Who created Flutter?", "A": "Google"},
  {"Q": "Who created Nomad coder?", "A": "Nico"},
  {"Q": "Who created Youngbok?", "A": "Youngbok"},
];
const double indicatorHeight = 15.0;
double getWidth(Size size) => size.width * 0.85;

const defaultDuration = Duration(milliseconds: 220);

class Assignment4 extends StatefulWidget {
  const Assignment4({super.key});

  @override
  State<Assignment4> createState() => _Assignment4State();
}

class _Assignment4State extends State<Assignment4>
    with TickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  // Flip Controller
  late final FlipCardController _flipCardController = FlipCardController();

  // ForeCard Position Controller
  late final AnimationController _horizontalDragController =
      AnimationController(
    lowerBound: size.width * -1 - 200,
    upperBound: size.width + 200,
    duration: const Duration(
      seconds: 1,
    ),
    value: 0.0,
    vsync: this,
  );

  // Progress Controller
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: defaultDuration,
  );

  // Progress Animation
  late Animation<double> _progress = Tween<double>(
    begin: 0.05,
    end: _progressEnd,
  ).animate(
    _curvedProgressAnimation,
  );

  // Progress Curve
  late final CurvedAnimation _curvedProgressAnimation = CurvedAnimation(
    parent: _progressController,
    curve: Curves.ease,
  );

  // Back Card Scale
  late final Tween<double> _scale = Tween<double>(
    begin: 0.8,
    end: 1.0,
  );

  // Fore Card Angle
  late final Tween<double> _angle = Tween<double>(
    begin: -15,
    end: 15,
  );

  // Index to identify cards
  int _index = 0;

  // Progress end point to set "next" start point
  double get _progressEnd => max(
        0.05,
        _index / qnAs.length,
      );

  void _onHorizontalDrag(DragUpdateDetails details) {
    setState(() {
      _horizontalDragController.value += details.delta.dx;
    });
  }

  void _animateProgress({
    required double begin,
    required double end,
  }) {
    _progressController.reset();
    _progress = Tween<double>(
      begin: begin,
      end: end,
    ).animate(_curvedProgressAnimation);

    _progressController.forward();
  }

  void _whenComplete() {
    final prevProgressEnd = _progressEnd;
    setState(() {
      _horizontalDragController.value = 0.0;
      _flipCardController.state!.isFront = true;
      _index += 1;
      _animateProgress(
        begin: prevProgressEnd,
        end: _progressEnd,
      );
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_horizontalDragController.value < -120) {
      _horizontalDragController.reverse().whenComplete(
            _whenComplete,
          );
    } else if (_horizontalDragController.value > 120) {
      _horizontalDragController.forward().whenComplete(
            _whenComplete,
          );
    } else {
      _horizontalDragController.animateTo(
        0.0,
        curve: Curves.ease,
      );
    }
  }

  Object getObjectWithSwipeCheckPoint({
    required Object defaultValue,
    required Object leftValue,
    required Object rightValue,
  }) {
    return _horizontalDragController.value < 30 &&
            _horizontalDragController.value > -30
        ? defaultValue
        : _horizontalDragController.value.isNegative
            ? leftValue
            : rightValue;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _horizontalDragController,
      builder: (context, child) {
        final scale = min(
          _scale.transform(
            _horizontalDragController.value.abs() / size.width,
          ),
          1.0,
        );
        final angle = _angle.transform(
              (_horizontalDragController.value + size.width / 2) / size.width,
            ) *
            pi /
            720;

        final textValue = getObjectWithSwipeCheckPoint(
          defaultValue: "",
          leftValue: "Need to review",
          rightValue: "I got it right",
        ) as String;

        final colorValue = getObjectWithSwipeCheckPoint(
          defaultValue: const Color(
            0xFF54cdff,
          ),
          leftValue: const Color(
            0xFFff7952,
          ),
          rightValue: const Color(
            0xFF73de7b,
          ),
        ) as Color;

        return AnimatedContainer(
          duration: defaultDuration,
          color: colorValue,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [
                AllDoneText(index: _index),
                IndicatorText(textValue: textValue),
                if (_index < qnAs.length - 1)
                  Transform.scale(
                    scale: scale,
                    child: QuizCard(
                      text: qnAs[_index + 1]['Q']!,
                      size: size,
                    ),
                  ),
                if (_index < qnAs.length)
                  GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDrag,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.rotate(
                      angle: angle,
                      child: Transform.translate(
                        offset: Offset(_horizontalDragController.value, 0),
                        child: FlipCard(
                          onTapFlipping: true,
                          rotateSide: RotateSide.bottom,
                          controller: _flipCardController,
                          frontWidget: QuizCard(
                            size: size,
                            text: qnAs[_index]["Q"]!,
                          ),
                          backWidget: QuizCard(
                            size: size,
                            text: qnAs[_index]["A"]!,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 40,
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (context, child) => CustomPaint(
                      size: Size(
                        getWidth(size),
                        indicatorHeight,
                      ),
                      painter: ProgressIndicatorPainter(
                        progress: _progress.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AllDoneText extends StatelessWidget {
  const AllDoneText({
    super.key,
    required int index,
  }) : _index = index;

  final int _index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: defaultDuration,
        opacity: _index == 4 ? 1 : 0,
        child: const Text(
          "All done!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class IndicatorText extends StatelessWidget {
  const IndicatorText({
    super.key,
    required this.textValue,
  });

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      child: AnimatedSwitcher(
        duration: defaultDuration,
        child: Text(
          textValue,
          key: ValueKey(textValue),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.size,
    required this.text,
    this.onTap,
  });

  final Size size;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        width: getWidth(size),
        height: size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}

class ProgressIndicatorPainter extends CustomPainter {
  final double progress;

  ProgressIndicatorPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..strokeWidth = size.width
      ..color = Colors.black.withOpacity(0.2)
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..strokeWidth = size.width * progress
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    final bgRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      indicatorHeight,
      const Radius.circular(10),
    );

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      size.width * progress,
      indicatorHeight,
      const Radius.circular(10),
    );

    canvas.drawRRect(bgRRect, bgPaint);
    canvas.drawRRect(progressRRect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
