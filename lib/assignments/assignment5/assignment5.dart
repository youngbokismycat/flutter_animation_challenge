import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/album_card.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/background_blur.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/explanation_card.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/lp_panel.dart';

enum ButtonType {
  play,
  pause,
}

double getCardSize(Size size) => size.width * 0.75;

class MyGlobalEffects {
  static final List<Effect> transitionIn = [
    FadeEffect(
      duration: 100.ms,
      curve: Curves.easeOut,
    ),
    const ScaleEffect(
        begin: Offset(
          0.8,
          0.8,
        ),
        curve: Curves.easeIn),
  ];
}

class Assignment5 extends StatefulWidget {
  const Assignment5({super.key});

  @override
  State<Assignment5> createState() => _Assignment5State();
}

class _Assignment5State extends State<Assignment5>
    with SingleTickerProviderStateMixin {
  final double bgViewportFraction = 0.9;
  final double fgViewportFraction = 1.5;
  int _currentPage = 0;
  late final size = MediaQuery.of(context).size;
  late final PageController _fgPageController = PageController(
    viewportFraction: fgViewportFraction,
  );

  late final PageController _bgPageController = PageController(
    viewportFraction: bgViewportFraction,
  );

  late final AnimationController _verticalController = AnimationController(
    vsync: this,
  );

  bool _isPlayPauseTap = false;

  void _onPlayPauseTap() {
    setState(() {
      _isPlayPauseTap = !_isPlayPauseTap;
    });
  }

  @override
  void initState() {
    super.initState();
    _fgPageController.addListener(_sync);
  }

  void _sync() {
    _bgPageController.position.jumpTo(
      (_fgPageController.position.pixels / fgViewportFraction -
              size.width / 6) *
          bgViewportFraction,
    );
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          BackgroundBlur(
            currentPage: _currentPage,
            verticalController: _verticalController,
            isAlbumTap: _isPlayPauseTap,
          ),
          LPPanel(
            currentPage: _currentPage,
            isPlayPauseTap: _isPlayPauseTap,
          ),
          ExplainationCard(
            bgPageController: _bgPageController,
            size: size,
            isAlbumTap: _isPlayPauseTap,
          ),
          Positioned.fill(
            bottom: 350,
            child: PageView.builder(
              controller: _fgPageController,
              onPageChanged: _onPageChanged,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    AlbumCard(
                      index: index,
                      isAlbumTap: _isPlayPauseTap,
                      onTap: _onPlayPauseTap,
                    ),
                  ],
                );
              },
            ),
          )
              .animate(
                target: _isPlayPauseTap ? 1 : 0,
              )
              .slideY(
                begin: 0,
                end: -0.1,
                duration: 0.8.seconds,
                curve:
                    _isPlayPauseTap ? Curves.easeInOutQuart : Curves.easeInExpo,
              ),
        ],
      ),
    );
  }
}
