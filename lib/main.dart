import 'package:app1/timermodel.dart';
import 'package:app1/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:app1/timer.dart';
import 'package:app1/settings.dart';
import 'package:app1/settings_adjuster.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'My Work Timer',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: TimerHomePage(
          defaultPadding: defaultPadding,
          timer: timer,
        ));
  }
}

class TimerHomePage extends StatelessWidget {
  final double defaultPadding;
  final CountDownTimer timer;

  const TimerHomePage(
      {required this.defaultPadding, required this.timer, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(const PopupMenuItem(value: 'Settings', child: Text('Settings')));
    menuItems.add(const PopupMenuItem(value: 'New Settings', child: Text('New Settings')));


    return Scaffold(
        appBar: AppBar(title: const Text('My Work Timer'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if(s=='Settings') {
                goToSettings(context);
              } else if(s=='New Settings') {
                goToNewSettings(context);
              }
            },
          )
        ]),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.all(defaultPadding),
              ),
              Expanded(
                  child: ProductivityButton(
                      color: const Color(0xff009688),
                      text: "Work",
                      onPressed: () => timer.startWork(),
                      size: defaultPadding)),
              Padding(
                padding: EdgeInsets.all(defaultPadding),
              ),
              Expanded(
                  child: ProductivityButton(
                      color: const Color(0xff607D8B),
                      text: "Short Break",
                      onPressed: () => timer.startBreak(true),
                      size: defaultPadding)),
              Padding(
                padding: EdgeInsets.all(defaultPadding),
              ),
              Expanded(
                  child: ProductivityButton(
                      color: const Color(0xff455A64),
                      text: "Long Break",
                      onPressed: () => timer.startBreak(false),
                      size: defaultPadding)),
              Padding(
                padding: EdgeInsets.all(defaultPadding),
              ),
            ]),
            Expanded(
              child: StreamBuilder(
                  initialData: '00:00',
                  stream: timer.stream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    TimerModel timer = (snapshot.data == '00:00')
                        ? TimerModel('00:00', 1)
                        : snapshot.data;
                    return CircularPercentIndicator(
                        radius: availableWidth / 2.1,
                        lineWidth: 10.0,
                        percent: timer.percent,
                        center: Text(timer.time,
                            style: Theme.of(context).textTheme.displayLarge),
                        progressColor: const Color(0xff009688));
                  }),
            ),
            Row(children: [
              Padding(padding: EdgeInsets.all(defaultPadding)),
              Expanded(
                  child: ProductivityButton(
                      color: const Color(0xff212121),
                      text: "Stop",
                      onPressed: () => timer.stopTimer(),
                      size: defaultPadding)),
              Padding(padding: EdgeInsets.all(defaultPadding)),
              Expanded(
                  child: ProductivityButton(
                      color: const Color(0xff009688),
                      text: "Restart",
                      onPressed: () => timer.startTimer(),
                      size: defaultPadding)),
              Padding(padding: EdgeInsets.all(defaultPadding))
            ])
          ]);
        }));
  }
  void goToSettings(BuildContext context) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const SettingsScreen())
    );
  }

  void goToNewSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewSettingsScreen())
    );
  }
}
