import 'package:flutter/material.dart';

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
