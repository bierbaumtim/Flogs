import '../../f_logs.dart';

class Log {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Log.
  int id;

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
    this.className,
    this.methodName,
    this.text,
    this.timestamp,
    this.timeInMillis,
    this.exception,
    this.logLevel,
    this.dataLogType,
    this.stacktrace,
  });

  /// Converts class to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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
  }

  /// create `Log` from json
  static Log fromJson(Map<String, dynamic> json) {
    return Log(
      className: json['className'] as String,
      methodName: json['methodName'] as String,
      text: json['text'] as String,
      timestamp: json['timestamp'] as String,
      timeInMillis: json['timeInMillis'] as int,
      exception: json['exception'] as String,
      dataLogType: json['dataLogType'] as String,
      logLevel: LogLevelConverter.fromStringToEnum(json['logLevel'] as String),
      stacktrace: json['stacktrace'] as String,
    );
  }
}
