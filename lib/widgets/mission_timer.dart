import 'dart:async';

import 'package:flutter/cupertino.dart';

class MissionTimer extends StatefulWidget {
  final int time;

  const MissionTimer(this.time, {super.key});

  @override
  State<MissionTimer> createState() => MissionTimerState(time);
}

class MissionTimerState extends State<MissionTimer> {
  final int _initialTime;
  int _timeRemaining;
  var _isRunning = false;
  Timer? _timer;

  MissionTimerState(int time)
      : _initialTime = time,
        _timeRemaining = time;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  startTimer() {
    if (_isRunning) {
      return;
    }

    setState(() {
      _timeRemaining = _initialTime;
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 25), (Timer timer) {
      if (_timeRemaining <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
      } else {
        setState(() {
          _timeRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startTimer,
      onDoubleTap: () {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/timer.png'),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              _isRunning ? '$_timeRemaining' : '$_initialTime',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
