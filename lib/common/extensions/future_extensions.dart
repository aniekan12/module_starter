extension DurationExtension on num {
  Duration get seconds => Duration(seconds: toInt());
  Duration get mircoSeconds => Duration(microseconds: toInt());
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
}

Future<void> delay(Duration duration) {
  return Future.delayed(duration);
}
