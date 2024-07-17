import 'package:flutter/material.dart';
import 'package:flutter_animation_assignment/assignments/widget/my_scaffold.dart';

class Assignment2 extends StatefulWidget {
  const Assignment2({super.key});

  @override
  State<Assignment2> createState() => _Assignment2State();
}

class _Assignment2State extends State<Assignment2>
    with TickerProviderStateMixin {
  late final List<AnimationController> _animationControllers;
  late final List<CurvedAnimation> _curves;
  late final List<Animation<Color?>> _colors;

  @override
  void initState() {
    super.initState();
    _animationControllers = List<AnimationController>.generate(25, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        reverseDuration: const Duration(milliseconds: 500),
      );
    });
    _curves = List<CurvedAnimation>.generate(
      25,
      (index) {
        return CurvedAnimation(
          parent: _animationControllers[index],
          curve: CustomJumpCurve(),
          reverseCurve: Curves.easeOutCirc,
        );
      },
    );

    _colors = _curves.map((controller) {
      return ColorTween(
        begin: Colors.black,
        end: const Color(0xFFff1750),
      ).animate(controller);
    }).toList();

    _colorTransition();
  }

  List<int> _generateZigzagOrder(int rows, int cols) {
    List<int> order = [];
    for (int i = 0; i < rows; i++) {
      if (i % 2 == 0) {
        for (int j = 0; j < cols; j++) {
          order.add(i * cols + j);
        }
      } else {
        for (int j = cols - 1; j >= 0; j--) {
          order.add(i * cols + j);
        }
      }
    }
    return order;
  }

  void _colorTransition() async {
    final order = _generateZigzagOrder(5, 5); // 5x5 grid for 25 items
    for (var index in order) {
      _animationControllers[index].forward();
      _animationControllers[index].addStatusListener(
          (AnimationStatus status) => _eachItemsStatusListener(status, index));
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  void _eachItemsStatusListener(AnimationStatus status, int index) async {
    if (status == AnimationStatus.completed) {
      await Future.delayed(
        const Duration(milliseconds: 250),
      );
      _animationControllers[index].reverse();
    } else if (status == AnimationStatus.dismissed) {
      await Future.delayed(
        const Duration(milliseconds: 600),
      );
      _animationControllers[index].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "Assignment 2",
      color: Colors.black,
      body: Center(
        child: Transform.flip(
          flipX: true,
          flipY: true,
          origin: const Offset(0, -100),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 40,
              mainAxisSpacing: 40,
            ),
            children: List.generate(25, (index) {
              return AnimatedBuilder(
                animation: _curves[index],
                builder: (context, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        _animationControllers[index].value * 5),
                    color: _colors[index].value,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class CustomJumpCurve extends Curve {
  @override
  double transformInternal(double t) {
    if (t < 0.33) {
      return 1.0; // First segment stays at 1
    } else if (t < 0.66) {
      return 0.0; // Second segment drops to 0
    } else {
      return 1.0; // Third segment goes back to 1
    }
  }
}
