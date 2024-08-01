import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_animation_assignment/assignments/assignment5/widgets/album_card.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/background_blur.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/explanation_card.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/widgets/lp_panel.dart';

enum ButtonType {
  play,
  pause,
}

double getCardSize(Size size) => size.width * 0.75;

class Assignment5 extends StatefulWidget {
  const Assignment5({super.key});

  @override
  State<Assignment5> createState() => _Assignment5State();
}

class _Assignment5State extends State<Assignment5>
    with TickerProviderStateMixin {
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

  bool _isAlbueTap = false;

  void _onAlbumTap() {
    setState(() {
      _isAlbueTap = !_isAlbueTap;
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
            isAlbumTap: _isAlbueTap,
          ),
          LPPanel(
            currentPage: _currentPage,
            isPlayPauseTap: _isAlbueTap,
          ),
          const ActionBar().animate(target: _isAlbueTap ? 1 : 0).fade(
                begin: 0,
                end: 1,
                duration: 900.milliseconds,
                delay: 1.seconds,
              ),
          Positioned.fill(
            top: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              alignment: Alignment.center,
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Lyric(
                    lyric: 'These are your children',
                  ),
                  Lyric(
                    lyric: 'I am your son',
                  ),
                  Lyric(
                    lyric: 'My sweet Lithonia, what have you done?',
                  ),
                  Lyric(
                    lyric: 'These are your children',
                  ),
                  Lyric(
                    lyric: 'I am your son',
                  ),
                ],
              ),
            ),
          ).animate(target: _isAlbueTap ? 1 : 0).fade(
                begin: 0,
                end: 1,
                duration: 900.milliseconds,
                delay: 1.seconds,
              ),
          ExplainationCard(
            bgPageController: _bgPageController,
            size: size,
            isAlbumTap: _isAlbueTap,
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
                      isAlbumTap: _isAlbueTap,
                      onTap: _onAlbumTap,
                    ),
                  ],
                );
              },
            ),
          )
              .animate(
                target: _isAlbueTap ? 1 : 0,
              )
              .slideY(
                begin: 0,
                end: -0.05,
                duration: 0.8.seconds,
                curve: _isAlbueTap ? Curves.easeInOutQuart : Curves.easeInExpo,
              ),
        ],
      ),
    );
  }
}

class Lyric extends StatelessWidget {
  const Lyric({
    super.key,
    required this.lyric,
  });
  final String lyric;

  @override
  Widget build(BuildContext context) {
    return Text(
      lyric,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            spreadRadius: 10,
            color: Colors.black,
          ),
        ],
      ),
      child: const Align(
        widthFactor: 1,
        heightFactor: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FaIcon(
              FontAwesomeIcons.solidSquarePlus,
              color: Colors.white,
            ),
            FaIcon(
              FontAwesomeIcons.pause,
              color: Colors.white,
            ),
            FaIcon(
              FontAwesomeIcons.play,
              color: Colors.white,
            ),
            FaIcon(
              FontAwesomeIcons.share,
              color: Colors.white,
            ),
            FaIcon(
              FontAwesomeIcons.voicemail,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    super.repaint,
    required this.progressValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    //track
    final trackPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    //progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    //thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 8, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ProgressBar) {
      return oldDelegate.progressValue != progressValue;
    }
    return true;
  }
}
