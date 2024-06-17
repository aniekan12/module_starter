import 'package:logger/logger.dart';

Logger logger() => Logger(printer: $CustomLogPrinter());

class $CustomLogPrinter extends LogPrinter {
  $CustomLogPrinter();

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emojis = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;
    final time = event.time;

    return [color!('$emojis: $time: $message')];
  }
}
