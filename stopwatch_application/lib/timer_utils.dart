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
