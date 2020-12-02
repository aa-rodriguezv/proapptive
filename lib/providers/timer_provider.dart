import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {

  static Future<DateTime> getStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String timeStr = await prefs.getString('start_time');
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    else {
      return null;
    }
  }

  static void setStartTime(DateTime startTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('start_time', startTime.toString());
  }

  static Future<int> getStopwatchType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int type = await prefs.getInt('stopwatch_type');
    return type != null ? type : 0;
  }

  static void setStopwatchType(int stopwatchType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stopwatch_type', stopwatchType);
  }

  static void removeStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('start_time');
  }

  static Future<Duration> getWorkDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String duration = await prefs.getString('work_duration'); //hh:mm:ss
    if (duration != null) {
      List<String> durationArr = duration.split(":");
      return Duration(hours: int.parse(durationArr[0]), minutes: int.parse(durationArr[1]), seconds: int.parse(durationArr[2]) );
    }
    else {
      return null;
    }
  }

  static setWorkDuration(Duration duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('work_duration', formatTime(duration));
  }

  static Future<Duration> getBreakDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String duration = await prefs.getString('break_duration'); //hh:mm:ss
    if (duration != null) {
      List<String> durationArr = duration.split(":");
      return Duration(hours: int.parse(durationArr[0]), minutes: int.parse(durationArr[1]), seconds: int.parse(durationArr[2]) );
    }
    else {
      return null;
    }
  }

  static setBreakDuration(Duration duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('break_duration', formatTime(duration));
  }

  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}