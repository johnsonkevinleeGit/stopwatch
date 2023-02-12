import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Timer? timer;
  Duration duration = Duration.zero;
  bool timerOn = false;
  List<Duration> lapList = [];

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
            Expanded(child: Consumer(builder: (context, ref, _) {
              // final lapList = ref.watch(providerOfLaps);
              lapList.sort(((a, b) => b.inSeconds.compareTo(a.inSeconds)));

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemBuilder: (ctx, i) {
                  final lap = lapList[i];

                  return Lap(
                    key: ValueKey(lap.inSeconds),
                    number: i,
                    lap: lap,
                  );
                },
                itemCount: lapList.length,
              );
            })),
          ],
        )));
  }

  void startTimer() {
    setState(() {
      timerOn = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final seconds = duration.inSeconds + 1;
        duration = Duration(seconds: seconds);
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
    final currentSeconds = duration.inSeconds;
    final newLap = Duration(seconds: currentSeconds);
    // final lapList = ref.read(providerOfLaps);
    setState(() {
      lapList.add(newLap);
    });
    // ref.read(providerOfLaps.notifier).state = lapList;
  }

  void resetTimer() {
    setState(() {
      duration = Duration.zero;
      lapList.clear();
    });
    // ref.read(providerOfLaps.notifier).state = [];
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

class Lap extends StatelessWidget {
  const Lap({Key? key, required this.number, required this.lap})
      : super(key: key);
  final int number;
  final Duration lap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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

final providerOfLaps = AutoDisposeStateProvider<List<Duration>>((ref) => []);

// final providerOfDuration = StateProvider.autoDispose((ref) {
//   return Duration.zero;
// });
// final providerOfDate = AutoDisposeStateProvider<DateTime?>((ref) => null);

// final providerOfPeriodicReubild =
//     AutoDisposeStreamProviderFamily<int, Duration>(
//         (ref, duration) => Stream.periodic(duration));

// class PeriodicRebuilderState extends ChangeNotifier {
//   PeriodicRebuilderState(this.duration) {
//     timer = Timer.periodic(duration, (t) {
//       notifyListeners();
//     });
//   }
//   final Duration duration;
//   Timer? timer;

// }

String formatTimerDuration(Duration duration) {
  final seconds = duration.inSeconds;
  final int hour = seconds ~/ 3600;
  final int minute = seconds % 3600 ~/ 60;
  final int second = seconds % 60;
  // final millisecond = seconds * 1000 ~/ 10;

  // final milliseconds = duration.inMilliseconds;
  // final minute = milliseconds ~/ 60000;
  // final second = (milliseconds ~/ 1000) % 60;
  // final centiseconds = (milliseconds ~/ 10) % 100;

  //

  return '${_formatTimer(hour)}:${_formatTimer(minute)}:${_formatTimer(second)}';

  // return '${_formatTimer(minute)}:${_formatTimer(second)}:${_formatTimer(centiseconds)}';
}

String _formatTimer(int timeNum) {
  return timeNum < 10 ? '0$timeNum' : timeNum.toString();
}
