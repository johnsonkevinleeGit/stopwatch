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
  Timer? timer;
  Duration duration = Duration.zero;
  bool timerOn = false;
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
          children: [
            const SizedBox(height: 25),
            Text(
              formatTimerDuration(duration),
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: Colors.white),
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
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        final milliseconds = duration.inMilliseconds + 10;
        duration = Duration(milliseconds: milliseconds);
      });
    });
  }

  void stopTimer() {
    setState(() {
      timerOn = false;
    });
    timer?.cancel();
  }

  void startLap() {
    final currentMilliseconds = duration.inMilliseconds;
    final newLap = Lap(
        key: ValueKey(currentMilliseconds),
        number: counter,
        lap: Duration(milliseconds: currentMilliseconds));

    setState(() {
      lapList.insert(0, newLap);
      counter++;
    });
  }

  void resetTimer() {
    setState(() {
      duration = Duration.zero;
      lapList.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
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

class CurrentLap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
