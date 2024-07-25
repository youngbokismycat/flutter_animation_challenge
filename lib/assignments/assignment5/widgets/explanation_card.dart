import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExplainationCard extends StatelessWidget {
  const ExplainationCard({
    super.key,
    required PageController bgPageController,
    required this.size,
    required bool isAlbumTap,
  })  : _bgPageController = bgPageController,
        _isPlayPauseTap = isAlbumTap;

  final PageController _bgPageController;
  final Size size;
  final bool _isPlayPauseTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 100,
      child: PageView.builder(
        controller: _bgPageController,
        pageSnapping: false,
        itemCount: 5,
        itemBuilder: (context, index) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: size.width * 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
        ),
      ).animate(target: _isPlayPauseTap ? 1 : 0).slideY(
            begin: 0,
            end: 2,
            duration: 0.8.seconds,
            curve: _isPlayPauseTap ? Curves.easeInOutQuart : Curves.easeInExpo,
          ),
    );
  }
}
