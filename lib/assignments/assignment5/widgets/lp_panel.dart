import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LPPanel extends StatelessWidget {
  const LPPanel({
    super.key,
    required int currentPage,
    required bool isPlayPauseTap,
  })  : _currentPage = currentPage,
        _isPlayPauseTap = isPlayPauseTap;

  final int _currentPage;
  final bool _isPlayPauseTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -300,
      child: Transform.scale(
        scale: 2.3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.grey.shade900,
                    Colors.black,
                    Colors.black,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            Container(
              key: ValueKey(
                _currentPage,
              ),
              width: 385,
              height: 385,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/$_currentPage.jpg',
                  ),
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                  delay: 1.seconds,
                )
                .rotate(
                  duration: 80.seconds,
                ),
          ],
        )
            .animate(
              target: _isPlayPauseTap ? 1 : 0,
            )
            .slideX(
              delay: 1.seconds,
              begin: -1,
              end: 0,
              duration: _isPlayPauseTap ? 2.seconds : 500.milliseconds,
              curve: Curves.easeOutCirc,
            )
            .animate(),
      ),
    );
  }
}
