import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({
    super.key,
    required int currentPage,
    required AnimationController verticalController,
    required bool isAlbumTap,
  })  : _currentPage = currentPage,
        _verticalController = verticalController,
        _isPlayPauseTap = isAlbumTap;

  final int _currentPage;
  final AnimationController _verticalController;
  final bool _isPlayPauseTap;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.25,
      child: AnimatedSwitcher(
        duration: 1.seconds,
        child: Container(
          key: ValueKey(_currentPage),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/$_currentPage.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      )
          .animate(
            controller: _verticalController,
            target: _isPlayPauseTap ? 1 : 0,
          )
          .slideY(
            begin: 0,
            end: 0.1,
            duration: 0.8.seconds,
            curve: _isPlayPauseTap ? Curves.easeInOutQuart : Curves.easeInExpo,
          ),
    );
  }
}
