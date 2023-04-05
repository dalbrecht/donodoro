import 'package:app1/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Settings());
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;
  late SharedPreferences prefs;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  static const int DEFAULT_WORK_VAL = 30;
  static const int SHORT_BREAK_VAL = 5;
  static const int LONG_BREAK_VAL = 20;

  @override
  initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      workTime = DEFAULT_WORK_VAL;
      await prefs.setInt(WORKTIME, DEFAULT_WORK_VAL);
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      shortBreak = SHORT_BREAK_VAL;
      await prefs.setInt(SHORTBREAK, SHORT_BREAK_VAL);
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      longBreak = LONG_BREAK_VAL;
      await prefs.setInt(LONGBREAK, LONG_BREAK_VAL);
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSettings(String key, String value) {
    int newVal = int.parse(value);
    if( newVal > 180 ) {
      newVal = 180;
    } else if(newVal <= 0) {
      newVal = 0;
    }
    prefs.setInt(key, newVal);
  }

  incrementSettings(String key, int value) {
    int? settingsVal = prefs.getInt(key);
    settingsVal ??= DEFAULT_WORK_VAL;
    settingsVal += value;
    if (settingsVal >= 1 && settingsVal <= 180) {
      prefs.setInt(key, settingsVal);
      switch (key) {
        case WORKTIME:
          {
            setState(() {
              txtWork.text = settingsVal.toString();
            });
            break;
          }
        case SHORTBREAK:
          {
            setState(() {
              txtShort.text = settingsVal.toString();
            });
            break;
          }
        case LONGBREAK:
          {
            setState(() {
              txtLong.text = settingsVal.toString();
            });
            break;
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle values = const TextStyle(fontSize: 24);
    Color buttonColor = const Color(0xff009688);
    String incrTxt = "+";
    int incrVal = 1;
    String decrTxt = "-";
    int decrVal = -1;
    double buttonSize = 25;
    return Container(
        child: GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 3,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
          Text("Work", style: values),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: incrTxt,
            value: incrVal,
            setting: WORKTIME,
            callback: incrementSettings,
          ),
          TextField(
              style: values,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: txtWork,
         ),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: decrTxt,
            value: decrVal,
            setting: WORKTIME,
            callback: incrementSettings,
          ),
          Text("Short", style: values),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: incrTxt,
            value: incrVal,
            setting: SHORTBREAK,
            callback: incrementSettings,
          ),
          TextField(
              style: values,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: txtShort),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: decrTxt,
            value: decrVal,
            setting: SHORTBREAK,
            callback: incrementSettings,
          ),
          Text("Long", style: values),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: incrTxt,
            value: incrVal,
            setting: LONGBREAK,
            callback: incrementSettings,
          ),
          TextField(
              style: values,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: txtLong),
          SettingsButton(
            color: buttonColor,
            size: buttonSize,
            text: decrTxt,
            value: decrVal,
            setting: LONGBREAK,
            callback: incrementSettings,
          ),
        ]));
  }
}
