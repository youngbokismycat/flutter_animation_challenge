import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

import 'widget/my_scaffold.dart';

class Assignment1 extends HookWidget {
  const Assignment1({super.key});
  final duration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final isFlip = useState(false);
    useEffect(() {
      final timer = Timer.periodic(duration, (Timer t) {
        isFlip.value = !isFlip.value;
      });

      // Clean up the timer when the widget is disposed
      return timer.cancel;
    }, []);

    final size = MediaQuery.of(context).size;
    return MyScaffold(
      color: Colors.black,
      title: 'Assignment 1',
      body: Center(
        child: Container(
          color: isFlip.value ? Colors.white : Colors.black,
          height: size.width * 0.8,
          width: size.width * 0.8,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: isFlip.value ? BoxShape.circle : BoxShape.rectangle,
                    color: Colors.red,
                  ),
                ),
                AnimatedAlign(
                  duration: duration,
                  alignment: isFlip.value
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    color: isFlip.value ? Colors.black : Colors.white,
                    width: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
