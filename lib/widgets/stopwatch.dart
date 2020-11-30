import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Stopwatch extends StatefulWidget {
  @override
  StopwatchState createState() => StopwatchState();

}

class StopwatchState extends State<Stopwatch>{
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String housStr = "00";
  String minutesStr = "00";
  String secondsStr = "00";

  Stream<int> stopwatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if(timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if(!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int> (
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("$housStr:$minutesStr:$secondsStr"),
    );
  }
}