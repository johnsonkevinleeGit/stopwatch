import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopwatch_application/lap.dart';
import 'package:stopwatch_application/timer_button.dart';
import 'package:stopwatch_application/timer_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Stopwatch Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? mainTimer;
  Duration mainDuration = Duration.zero;
  bool timerOn = false;

  Timer? lapTimer;
  Duration lapDuration = Duration.zero;

  int counter = 1;
  List<Lap> lapList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            SizedBox(
              width: 250,
              child: Text(
                formatTimerDuration(mainDuration),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerButton(
                    color: Colors.grey,
                    onPressed: timerOn ? () => startLap() : () => resetTimer(),
                    text: timerOn ? 'Lap' : 'Reset'),
                const SizedBox(width: 15),
                TimerButton(
                  color: timerOn ? Colors.redAccent : Colors.lightGreen,
                  onPressed: timerOn ? () => stopTimer() : () => startTimer(),
                  text: timerOn ? 'Stop' : 'Start',
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Divider(
                indent: 10, endIndent: 10, color: Colors.white, thickness: 1),
            if (lapDuration != Duration.zero) ...[
              Lap(number: counter, lap: lapDuration),
              const Divider(
                indent: 10,
                endIndent: 10,
                thickness: .5,
                color: Colors.white,
              ),
            ],
            Expanded(child: Builder(builder: (context) {
              return ListView.separated(
                itemCount: lapList.length,
                itemBuilder: (ctx, i) => lapList[i],
                separatorBuilder: (context, index) => const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: .5,
                  color: Colors.white,
                ),
              );
            })),
          ],
        )));
  }

  void startTimer() {
    setState(() {
      timerOn = true;
    });
    mainTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        final milliseconds = mainDuration.inMilliseconds + 10;
        mainDuration = Duration(milliseconds: milliseconds);
      });
    });

    lapTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        final milliseconds = lapDuration.inMilliseconds + 10;
        lapDuration = Duration(milliseconds: milliseconds);
      });
    });
  }

  void stopTimer() {
    setState(() {
      timerOn = false;
    });
    mainTimer?.cancel();
    lapTimer?.cancel();
  }

  void startLap() {
    final currentMilliseconds = lapDuration.inMilliseconds;
    final newLap = Lap(
        key: ValueKey(currentMilliseconds),
        number: counter,
        lap: Duration(milliseconds: currentMilliseconds));

    setState(() {
      lapDuration = Duration.zero;
      lapList.insert(0, newLap);
      counter++;
    });
  }

  void resetTimer() {
    setState(() {
      mainDuration = Duration.zero;
      lapDuration = Duration.zero;
      lapList.clear();
      counter = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainTimer?.cancel();
    lapTimer?.cancel();
  }
}
