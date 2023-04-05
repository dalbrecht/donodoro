import 'dart:async';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = false;
  late Timer timer;
  Duration _time = const Duration(minutes: 30, seconds: 0);
  Duration _fullTime = const Duration(minutes: 30, seconds: 0);
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? loadedVal = prefs.getInt('workTime');
    loadedVal ??= 30;
    work = loadedVal;

    loadedVal = prefs.getInt('shortBreak');
    loadedVal ??= 5;
    shortBreak = loadedVal;

    loadedVal = prefs.getInt('longBreak');
    loadedVal ??= longBreak;
    longBreak = longBreak;

  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        _time = _time - const Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }

      time = returnTime(_time);
      return TimerModel(time, _radius);
    });
  }

  String returnTime(Duration t) {
    String minutes =
        (t.inMinutes < 10) ? '0${t.inMinutes}' : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = (numSeconds < 10) ? '0$numSeconds' : '$numSeconds';
    String formattedTime = '$minutes:$seconds';
    return formattedTime;
  }

  void startWork() async{
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: work, seconds: 0);
    _fullTime = _time;
  }

  void stopTimer() {
    _isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
    _isActive = true;
  }
}
