import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proapptive/providers/timer_provider.dart';

class Stopwatch extends StatefulWidget {
  @override
  StopwatchState createState() => StopwatchState();
}

class StopwatchState extends State<Stopwatch> {
  DateTime startTime;

  Duration elapsedWorkSeconds = Duration(seconds: 0);

  Duration elapsedBreakSeconds = Duration(seconds: 0);

  Duration savedWorkSeconds = Duration(seconds: 0);

  Duration savedBreakSeconds = Duration(seconds: 0);

  int running = 0;

  Timer timer;

  @override
  void initState() {
    loadTimerData();
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void loadTimerData() async {
    int r = await TimerProvider.getStopwatchType();
    DateTime s = await TimerProvider.getStartTime();
    Duration w = await TimerProvider.getWorkDuration();
    Duration b = await TimerProvider.getBreakDuration();
    setState(() {
      savedWorkSeconds = w != null ? w : Duration(seconds: 0);
      savedBreakSeconds = b != null ? b : Duration(seconds: 0);
      running = r != null ? r : 0;
      if (running != 0) {
        startTime = s;
        resume();
      }
    });
  }

  void start(int type) {
    setState(() {
      running = type;
    });
    startTime = DateTime.now();
    TimerProvider.setStartTime(startTime);
    TimerProvider.setStopwatchType(type);
    launchTimer();
  }

  void resume() {
    launchTimer();
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
    }
    if (running == 1) {
      savedWorkSeconds += elapsedWorkSeconds;
      TimerProvider.setWorkDuration(savedWorkSeconds);
      elapsedWorkSeconds = Duration(seconds: 0);
    } else if (running == 2) {
      savedBreakSeconds += elapsedBreakSeconds;
      TimerProvider.setBreakDuration(savedBreakSeconds);
      elapsedBreakSeconds = Duration(seconds: 0);
    }
    setState(() {
      running = 0;
    });
    startTime = null;
    TimerProvider.removeStartTime();
    TimerProvider.setStopwatchType(0);
  }

  void launchTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (running == 1 && startTime != null) {
            elapsedWorkSeconds = Duration(
                seconds: DateTime.now().difference(startTime).inSeconds);
          } else if (running == 2) {
            elapsedBreakSeconds = Duration(
                seconds: DateTime.now().difference(startTime).inSeconds);
          }
        });
      }
    });
  }

  String getTotalWorkSeconds() {
    return TimerProvider.formatTime(elapsedWorkSeconds + savedWorkSeconds);
  }

  String getTotalBreakSeconds() {
    return TimerProvider.formatTime(elapsedBreakSeconds + savedBreakSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  getTotalWorkSeconds(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                  child: RaisedButton(
                onPressed: running == 1
                    ? stop
                    : () {
                        stop();
                        start(1);
                      },
                child: running == 1
                    ? Text("Detener trabajo")
                    : Text("Iniciar trabajo"),
              )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  getTotalBreakSeconds(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                  child: RaisedButton(
                onPressed: running == 2
                    ? stop
                    : () {
                        stop();
                        start(2);
                      },
                child: running == 2
                    ? Text("Detener descanso")
                    : Text("Iniciar descanso"),
              )),
            ],
          )
        ]);
  }
}
