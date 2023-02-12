import 'package:flutter/material.dart';
import 'package:stopwatch_application/timer_utils.dart';

class Lap extends StatelessWidget {
  const Lap({Key? key, required this.number, required this.lap})
      : super(key: key);
  final int number;
  final Duration lap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text('Lap $number',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white)),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 8),
            child: Text(
              formatTimerDuration(lap),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
