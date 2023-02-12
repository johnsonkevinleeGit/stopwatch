import 'dart:async';

import 'package:flutter/material.dart';

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
  bool mainTimerOn = false;

  Timer? lapTimer;
  Duration lapDuration = Duration.zero;

  int counter = 1;
  List<Lap> lapList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Text(
                formatTimerDuration(mainDuration),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerButton(
                    color: Colors.grey,
                    onPressed:
                        mainTimerOn ? () => startLap() : () => resetTimer(),
                    text: mainTimerOn ? 'Lap' : 'Reset'),
                const SizedBox(width: 15),
                TimerButton(
                  color: mainTimerOn ? Colors.redAccent : Colors.lightGreen,
                  onPressed:
                      mainTimerOn ? () => stopTimer() : () => startTimer(),
                  text: mainTimerOn ? 'Stop' : 'Start',
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
      mainTimerOn = true;
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
      mainTimerOn = false;
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
  }
}

class TimerButton extends StatelessWidget {
  const TimerButton(
      {Key? key,
      required this.color,
      required this.onPressed,
      required this.text})
      : super(key: key);
  final Color color;
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onPressed,
          child: Text(text, style: Theme.of(context).textTheme.headline6)),
    );
  }
}

class Lap extends StatelessWidget {
  const Lap({Key? key, required this.number, required this.lap})
      : super(key: key);
  final int number;
  final Duration lap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Lap $number',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white)),
          Text(
            formatTimerDuration(lap),
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

String formatTimerDuration(Duration duration) {
  final milliseconds = duration.inMilliseconds;
  final minute = milliseconds ~/ 60000;
  final second = (milliseconds ~/ 1000) % 60;
  final millisecond = (milliseconds % 1000) ~/ 10;

  return '${_formatTimer(minute)}:${_formatTimer(second)}:${_formatTimer(millisecond)}';
}

String _formatTimer(int timeNum) {
  return timeNum < 10 ? '0$timeNum' : timeNum.toString();
}
