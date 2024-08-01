import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

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
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            height: size.width * 1.5,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 40,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Youngbok The Caaat",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Youngbok The Cat Youngbok The Cat Youngbok The Cat Youngbok The Cat Youngbok The Cat Youngbok The Cat Youngbok The Cat ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(70),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        20,
                      ),
                      bottomLeft: Radius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Add to playlist +",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
