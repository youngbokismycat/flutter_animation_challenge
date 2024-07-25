import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation_assignment/assignments/assignment5/assignment5.dart';

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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
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
    ).animate(target: _isTouched ? 1 : 0).scale(
          begin: const Offset(1, 1),
          end: const Offset(0.95, 0.95),
          duration: 200.milliseconds,
          curve: Curves.ease,
        );
  }
}
