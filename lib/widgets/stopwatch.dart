import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proapptive/providers/timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadStartTime();
    loadElapsedTimes();
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void loadStartTime() async {
    int r = await TimerProvider.getStopwatchType();
    DateTime s = await TimerProvider.getStartTime();
    setState(() {
      running = r;
      if (running != null && running != 0) {
        startTime = s;
        resume();
      }
    });
  }

  void loadElapsedTimes() async {
    Duration w = await TimerProvider.getWorkDuration();
    Duration b = await TimerProvider.getBreakDuration();
    setState(() {
      savedWorkSeconds = w;
      savedBreakSeconds = b;
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
      elapsedWorkSeconds += savedWorkSeconds;
      TimerProvider.setWorkDuration(elapsedWorkSeconds + savedWorkSeconds);
    } else if (running == 2) {
      elapsedBreakSeconds += savedBreakSeconds;
      TimerProvider.setBreakDuration(elapsedBreakSeconds + savedBreakSeconds);
    }
    setState(() {
      running = 0;
    });
    startTime = null;
    TimerProvider.removeStartTime();
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
    return savedWorkSeconds != null
        ? TimerProvider.formatTime(elapsedWorkSeconds + savedWorkSeconds)
        : TimerProvider.formatTime(elapsedWorkSeconds);
  }

  String getTotalBreakSeconds() {
    return savedBreakSeconds != null
        ? TimerProvider.formatTime(elapsedBreakSeconds + savedBreakSeconds)
        : TimerProvider.formatTime(elapsedBreakSeconds);
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
