import 'dart:async';
import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import 'package:flutter_animation_assignment/assignments/widget/my_scaffold.dart';

const Color pomodoroColor = Color(0xFFff6669);
const Color restColor = FlexColor.blueDarkPrimary;
const Color disabledBgColor = Color(0xFFeeeeee);
const Color disabledIconColor = Color(0xFFbdbdbd);

enum RunningState {
  run,
  rest,
}

enum TimerState {
  onRun,
  onPause,
}

class Assignment3 extends StatefulWidget {
  const Assignment3({super.key});

  @override
  State<Assignment3> createState() => _Assignment3State();
}

class _Assignment3State extends State<Assignment3>
    with TickerProviderStateMixin {
  // State
  RunningState _runningState = RunningState.run;
  TimerState _timerState = TimerState.onPause;
  int _cycleCount = 0;

  // Play & Pause
  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _playPauseAnimation =
      Tween(begin: 0.0, end: 1.0).animate(_playPauseController);

  // Icon and background color animation
  late final AnimationController _colorController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<Color?> _iconColorAnimation = ColorTween(
    begin: disabledIconColor,
    end: Colors.white,
  ).animate(_colorController);

  // Progress
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  late final CurvedAnimation _curvedProgressAnimation = CurvedAnimation(
    parent: _progressController,
    curve: Curves.linear,
  );
  late Animation<double> _animateProgress =
      Tween<double>(begin: 1.0, end: 0.0).animate(
    _curvedProgressAnimation,
  );
  void _animateTick({
    required progressPrev,
    required progress,
  }) {
    _progressController.reset();
    setState(() {
      _animateProgress = Tween<double>(
        begin: progressPrev,
        end: progress,
      ).animate(
        _curvedProgressAnimation,
      );
    });
    _progressController.forward();
  }
  double get _progress {
    if (_runningState == RunningState.run) {
      return _onDisplayDuration / _defaultDuration;
    } else {
      return _onDisplayDuration / _defaultRestDuration;
    }
  }

  // Timer
  final int _defaultDuration = 1500;
  final int _defaultRestDuration = 300;
  late int _onDisplayDuration;
  Timer? _timer;
  void _startTimer() {
    setState(() {});
    _timerState = TimerState.onRun;
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      _onTick,
    );
    _colorController.forward();
  }
  void _onTick(Timer timer) {
    final progressPrev = _progress;
    setState(() {
      if (_onDisplayDuration > 0) {
        _onDisplayDuration--;
        _animateTick(
          progressPrev: progressPrev,
          progress: _progress,
        );
      } else {
        _cycleCount = _cycleCount + 1;

        if (_cycleCount % 2 != 0) {
          _runningState = RunningState.rest;
          _onDisplayDuration = _defaultRestDuration;
        } else {
          _runningState = RunningState.run;
          _onDisplayDuration = _defaultDuration;
        }
        _animateTick(
          progressPrev: progressPrev,
          progress: _progress,
        );
        _playPauseController.reverse();
        _timerState = TimerState.onPause;
        _timer?.cancel();
      }
    });
  }
  void _stopTimer() {
    setState(() {});
    _timerState = TimerState.onPause;
    _timer?.cancel();
    _colorController.reverse();
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
      _stopTimer();
    } else {
      _playPauseController.forward();
      _startTimer();
    }
  }

  void _onRefreshTap() {
    if (_timerState == TimerState.onRun) {
      _timer?.cancel();
      _playPauseController.reverse();
      _timerState = TimerState.onPause;
    }
    setState(() {
      if (_runningState == RunningState.run) {
        _onDisplayDuration = _defaultDuration;
      } else {
        _onDisplayDuration = _defaultRestDuration;
      }
      _animateTick(
        progressPrev: _progress,
        progress: 1.0,
      );
    });
  }

  void _onStopTap() {
    _stopTimer();
    _playPauseController.reverse();
    _timerState = TimerState.onPause;
    setState(() {
      if (_runningState == RunningState.run) {
        _onDisplayDuration = _defaultDuration;
      } else {
        _onDisplayDuration = _defaultRestDuration;
        _runningState = RunningState.run;
      }
      _animateTick(
        progressPrev: _progress,
        progress: 1.0,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _onDisplayDuration = _defaultDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _playPauseController.dispose();
    _progressController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _onDisplayDuration ~/ 60;
    int seconds = _onDisplayDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _getRefreshIsActive {
    if (_runningState == RunningState.run && _timerState == TimerState.onRun) {
      return true;
    } else {
      return false;
    }
  }

  bool get _getStopIsActive {
    if (_timerState == TimerState.onRun) {
      return true;
    } else {
      return false;
    }
  }

  Color get _buttonBgColor {
    return _runningState == RunningState.run ? pomodoroColor : restColor;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      color: Colors.white,
      title: "assignment 3",
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: Text(
                key: ValueKey<String>(
                  _runningState == RunningState.rest
                      ? "Good job."
                      : "Let's go! ",
                ),
                _runningState == RunningState.rest ? "Good job." : "Let's go! ",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: _runningState == RunningState.rest
                      ? restColor
                      : pomodoroColor,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animateProgress,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(300, 300),
                        painter: PomodoroIndicatorPainter(
                          state: _runningState,
                          progress: _animateProgress.value,
                        ),
                      );
                    },
                  ),
                  Text(
                    _formattedTime,
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_iconColorAnimation, _colorController]),
                    builder: (context, child) {
                      return PomodoroButton(
                        onTap: _onRefreshTap,
                        isActive: _getRefreshIsActive,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 30,
                          color: _iconColorAnimation.value,
                        ),
                        buttonSize: 60,
                        bgColor: _getRefreshIsActive
                            ? _buttonBgColor
                            : disabledBgColor,
                      );
                    },
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _buttonBgColor,
                    ),
                    child: PomodoroButton(
                      isActive: true,
                      onTap: _onPlayPauseTap,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playPauseAnimation,
                        color: Colors.white,
                        size: 60,
                      ),
                      buttonSize: 100,
                      bgColor: _buttonBgColor,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_iconColorAnimation, _colorController]),
                    builder: (context, child) {
                      return PomodoroButton(
                        onTap: _onStopTap,
                        isActive: _getStopIsActive,
                        icon: Icon(
                          Icons.stop_rounded,
                          size: 30,
                          color: _iconColorAnimation.value,
                        ),
                        buttonSize: 60,
                        bgColor:
                            _getStopIsActive ? _buttonBgColor : disabledBgColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PomodoroButton extends StatelessWidget {
  const PomodoroButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.isActive,
    required this.buttonSize,
    required this.bgColor,
  });

  final Function()? onTap;
  final Widget icon;
  final bool isActive;
  final double buttonSize;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: buttonSize,
        width: buttonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: icon,
      ),
    );
  }
}

class PomodoroIndicatorPainter extends CustomPainter {
  final double strokeWidth = 25;
  final double progress;
  final RunningState state;

  PomodoroIndicatorPainter({
    required this.progress,
    required this.state,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background Circle
    final bgPaint = Paint()
      ..color = disabledBgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      size.width / 2,
      bgPaint,
    );

    // Indicator Arc
    final indicatorPaint = Paint()
      ..color = state == RunningState.run ? pomodoroColor : restColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final arcRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawArc(
      arcRect,
      -0.5 * pi,
      2 * pi * progress,
      false,
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PomodoroIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.state != state;
  }
}
