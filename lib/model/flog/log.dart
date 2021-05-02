import '../../f_logs.dart';

class Log {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Log.
  int? id;

  String className;
  String methodName;
  String text;
  String timestamp;
  String exception;
  String dataLogType;
  int timeInMillis;
  LogLevel logLevel;
  String stacktrace;

  Log({
    this.className = '',
    this.methodName = '',
    required this.text,
    this.timestamp = '',
    this.timeInMillis = 0,
    this.exception = '',
    required this.logLevel,
    this.dataLogType = '',
    this.stacktrace = '',
  });

  /// Converts class to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'className': className,
        'methodName': methodName,
        'text': text,
        'timestamp': timestamp,
        'timeInMillis': timeInMillis,
        'exception': exception,
        'dataLogType': dataLogType,
        'logLevel': LogLevelConverter.fromEnumToString(logLevel),
        'stacktrace': stacktrace,
      };

  /// create `Log` from json
  factory Log.fromJson(Map<String, dynamic> json) => Log(
        className: json['className'] as String? ?? '',
        methodName: json['methodName'] as String? ?? '',
        text: json['text'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
        timeInMillis: json['timeInMillis'] as int? ?? 0,
        exception: json['exception'] as String? ?? '',
        dataLogType: json['dataLogType'] as String? ?? '',
        logLevel: LogLevelConverter.fromStringToEnum(
          json['logLevel'] as String? ?? '',
        ),
        stacktrace: json['stacktrace'] as String? ?? '',
      );
}
