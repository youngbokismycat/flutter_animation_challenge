import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/assignment5.dart';
import 'package:siri_wave/siri_wave.dart';

class AlbumCard extends StatefulWidget {
  const AlbumCard({
    super.key,
    required this.isAlbumTap,
    required this.index,
    required this.onTap,
  });
  final bool isAlbumTap;
  final int index;
  final Function() onTap;

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool _isTouched = false;
  void _onTap() async {
    setState(() {
      _isTouched = true;
    });
    widget.onTap();

    await Future.delayed(200.milliseconds);

    setState(() {
      _isTouched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = IOS9SiriWaveformController(
      amplitude: 0.75,
      speed: 0.25,
    );
    final size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 218.7,
          child: Visibility(
            visible: widget.isAlbumTap ? true : false,
            child: SiriWaveform.ios9(
              controller: controller,
              options: const IOS9SiriWaveformOptions(
                height: 180,
                width: 280,
              ),
            ),
          ),
        )
            .animate(
              target: widget.isAlbumTap ? 1 : 0,
            )
            .fade(
              begin: 0,
              end: 1,
              delay: 1.seconds,
              duration: 100.milliseconds,
            ),
        Positioned(
          right: -140.5,
          child: Visibility(
            visible: widget.isAlbumTap ? true : false,
            child: Transform.rotate(
              angle: pi * 0.5,
              child: SiriWaveform.ios9(
                controller: controller,
                options: const IOS9SiriWaveformOptions(
                  height: 180,
                  width: 280,
                ),
              ),
            ),
          ),
        )
            .animate(
              target: widget.isAlbumTap ? 1 : 0,
            )
            .fade(
              begin: 0,
              end: 1,
              delay: 1.seconds,
              duration: 100.milliseconds,
            ),
        Positioned(
          top: 219,
          child: Visibility(
            visible: widget.isAlbumTap ? true : false,
            child: Transform.rotate(
              angle: pi,
              child: SiriWaveform.ios9(
                controller: controller,
                options: const IOS9SiriWaveformOptions(
                  height: 180,
                  width: 280,
                ),
              ),
            ),
          ),
        )
            .animate(
              target: widget.isAlbumTap ? 1 : 0,
            )
            .fade(
              begin: 0,
              end: 1,
              delay: 1.seconds,
              duration: 100.milliseconds,
            ),
        Positioned(
          left: -140.5,
          child: Visibility(
            visible: widget.isAlbumTap ? true : false,
            child: Transform.rotate(
              angle: -0.5 * pi,
              child: SiriWaveform.ios9(
                controller: controller,
                options: const IOS9SiriWaveformOptions(
                  height: 180,
                  width: 280,
                ),
              ),
            ),
          ),
        )
            .animate(
              target: widget.isAlbumTap ? 1 : 0,
            )
            .fade(
              begin: 0,
              end: 1,
              delay: 1.seconds,
              duration: 100.milliseconds,
            ),
        GestureDetector(
          onTap: _onTap,
          child: Container(
            height: getCardSize(size),
            width: getCardSize(size),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 10,
                  offset: const Offset(0, 20),
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/${widget.index}.jpg"),
              ),
            ),
          ),
        )
            .animate(
              target: _isTouched ? 1 : 0,
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(0.95, 0.95),
              duration: 500.milliseconds,
              curve: Curves.ease,
            ),
      ],
    );
  }
}
