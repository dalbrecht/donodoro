import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewSettingsScreen extends StatelessWidget {
  const NewSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Settings'),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return const NewSettings();
        }));
  }
}

class NewSettings extends StatefulWidget {
  const NewSettings({Key? key}) : super(key: key);

  @override
  State<NewSettings> createState() => _NewSettingsState();
}

class _NewSettingsState extends State<NewSettings> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          shrinkWrap: true,
          children: const [
            SettingsAdjuster(label: 'Work', prefKey: 'workTime'),
            SettingsAdjuster(label: 'Short Break', prefKey: 'shortBreak'),
            SettingsAdjuster(label: 'Long Break', prefKey: 'longBreak'),
          ],
        ));
  }
}

class SettingsAdjuster extends StatefulWidget {
  final String label;
  final String prefKey;

  @override
  const SettingsAdjuster({required this.label, required this.prefKey, Key? key})
      : super(key: key);

  @override
  State<SettingsAdjuster> createState() => _SettingsAdjusterState();
}

class _SettingsAdjusterState extends State<SettingsAdjuster> {
  late TextEditingController txtController;
  late SharedPreferences prefs;

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    int? settingsVal = prefs.getInt(widget.prefKey);
    settingsVal ??= 30;
    setState(() {
      txtController.text = settingsVal.toString();
    });
  }

  @override
  initState() {
    txtController = TextEditingController();
    txtController.addListener(updateSettings);
    initPrefs();
    super.initState();
  }

  updateSettings() {
    String rawVal = txtController.value.text;
    int newVal = int.parse(rawVal);
    if (newVal <= 1) {
      newVal = 1;
    } else if (newVal >= 180) {
      newVal = 180;
    }
    // txtController.text = newVal.toString();
    prefs.setInt(widget.prefKey, newVal);
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  Future<int> getCurrentPrefValue() async {
    int? settingsVal = prefs.getInt(widget.prefKey);
    settingsVal ??= 30;
    return settingsVal;
  }

  incrementSettings(int value) {
    int? settingsVal = prefs.getInt(widget.prefKey);
    settingsVal ??= 30;
    settingsVal += value;
    if (settingsVal >= 1 && settingsVal <= 180) {
      prefs.setInt(widget.prefKey, settingsVal);
      txtController.text = settingsVal.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Column(children: [
          Row(children: [
            Text(widget.label,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ]),
          Row(children: [
            Expanded(
                flex: 1,
                child: SettingsButton(
                  color: const Color(0xff009688),
                  size: 25,
                  text: '+',
                  value: 1,
                  callback: incrementSettings,
                )),
            Expanded(
                flex: 3,
                child: FocusScope(
                    onFocusChange: (value) {
                      if (!value) {
                        updateSettings();
                      }
                    },
                    child: TextField(
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onEditingComplete: () => updateSettings(),
                        controller: txtController))),
            Expanded(
                flex: 1,
                child: SettingsButton(
                  color: const Color(0xff009688),
                  size: 25,
                  text: '-',
                  value: -1,
                  callback: incrementSettings,
                )),
          ])
        ]));
  }
}

typedef CallbackSetting = void Function(int);

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final double size;
  final CallbackSetting callback;

  const SettingsButton(
      {required this.color,
      required this.text,
      required this.value,
      required this.size,
      required this.callback,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: color,
        onPressed: () => callback(value),
        minWidth: size,
        child: Text(text, style: const TextStyle(color: Colors.white)));
  }
}
