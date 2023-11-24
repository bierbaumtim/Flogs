import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:sembast/sembast.dart';
import 'package:stack_trace/stack_trace.dart';

import '../../f_logs.dart';

class FLog {
  // flogs data source
  static final _flogDao = FlogDao.instance;

  //local storage
  static final LogsStorage _storage = LogsStorage.instance;

  //logs configuration
  static LogsConfig _config = LogsConfig();

  // A private constructor. Allows us to create instances of FLog
  // only from within the FLog class itself.
  FLog._();

  //Public Methods:-------------------------------------------------------------
  /// logThis
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  /// @param type         the type
  static Future<void> logThis({
    String? className,
    String? methodName,
    required String text,
    required LogLevel type,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    // prevent to write LogLevel.ALL and LogLevel.OFF to db
    if (![LogLevel.OFF, LogLevel.ALL].contains(type)) {
      await _logThis(
        text,
        type,
        className,
        methodName,
        exception,
        dataLogType,
        stacktrace,
      );
    }
  }

  /// trace
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> trace({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.TRACE,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// debug
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> debug({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.DEBUG,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// info
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> info({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.INFO,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// warning
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> warning({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.WARNING,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// error
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> error({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.ERROR,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// severe
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> severe({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.SEVERE,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// fatal
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static Future<void> fatal({
    String? className,
    String? methodName,
    required String text,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    await _logThis(
      text,
      LogLevel.FATAL,
      className,
      methodName,
      exception,
      dataLogType,
      stacktrace,
    );
  }

  /// printLogs
  ///
  /// This will return array of logs and print them as a string using StringBuffer()
  static void printLogs() async {
    debugPrint(Constants.PRINT_LOG_MSG);

    _getAllLogs().then((logs) {
      var buffer = StringBuffer();

      if (logs.isNotEmpty) {
        for (var log in logs) {
          buffer.write(Formatter.format(log, _config));
        }
        debugPrint(buffer.toString());
      } else {
        debugPrint("No logs found!");
      }
      buffer.clear();
    });
  }

  /// printDataLogs
  ///
  /// This will return array of logs grouped by dataType and print them as a string using StringBuffer()
  static void printDataLogs({
    List<String>? dataLogsType,
    List<String>? logLevels,
    int? startTimeInMillis,
    int? endTimeInMillis,
    FilterType? filterType,
  }) async {
    debugPrint(Constants.PRINT_DATA_LOG_MSG);

    _getAllSortedByFilter(
      filters: Filters.generateFilters(
        dataLogsType: dataLogsType,
        logLevels: logLevels,
        startTimeInMillis: startTimeInMillis,
        endTimeInMillis: endTimeInMillis,
        filterType: filterType,
      ),
    ).then((logs) {
      var buffer = StringBuffer();

      if (logs.isNotEmpty) {
        for (var log in logs) {
          buffer.write(Formatter.format(log, _config));
        }
        debugPrint(buffer.toString());
      } else {
        debugPrint("No logs found!");
      }
      buffer.clear();
    });
  }

  /// printFileLogs
  ///
  /// This will print logs stored in a file as string using StringBuffer()
  static void printFileLogs() async {
    debugPrint(Constants.PRINT_LOG_MSG);

    _storage.readLogsToFile().then(print);
  }

  /// exportLogs
  ///
  /// This will export logs to external storage under FLog directory
  static Future<File> exportLogs() async {
    var buffer = StringBuffer();

    debugPrint(Constants.PRINT_EXPORT_MSG);

    //get all logs and write to file
    final logs = await _getAllLogs();

    for (var log in logs) {
      buffer.write(Formatter.format(log, _config));
    }

    final file = await _storage.writeLogsToFile(buffer.toString());
    debugPrint(buffer.toString());
    buffer.clear();
    return file;
  }

  /// getAllLogs
  ///
  /// This will return the list of logs stored in database
  static Future<List<Log>> getAllLogs() async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      return await _flogDao.getAllLogs();
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// getAllLogsByFilter
  ///
  /// This will return the list of logs stored based on the provided filters
  static Future<List<Log>> getAllLogsByFilter({
    List<String>? dataLogsType,
    List<String>? logLevels,
    int? startTimeInMillis,
    int? endTimeInMillis,
    FilterType? filterType,
  }) async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      return await _flogDao.getAllSortedByFilter(
        filters: Filters.generateFilters(
          dataLogsType: dataLogsType,
          logLevels: logLevels,
          startTimeInMillis: startTimeInMillis,
          endTimeInMillis: endTimeInMillis,
          filterType: filterType,
        ),
      );
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// getAllLogsByCustomFilter
  ///
  /// This will return the list of logs stored based on the custom filters provided
  /// by the user
  static Future<List<Log>> getAllLogsByCustomFilter({
    List<Filter>? filters,
  }) async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      return await _flogDao.getAllSortedByFilter(filters: filters);
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// clearLogs
  ///
  /// This will clear all the logs stored in database
  static Future<void> clearLogs() async {
    await _flogDao.deleteAll();
    debugPrint("Logs Cleared!");
  }

  /// deleteAllLogsByFilter
  ///
  /// This will delete logs by provided filters
  static Future<void> deleteAllLogsByFilter({List<Filter>? filters}) async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      var deleted = await _flogDao.deleteAllLogsByFilter(filters: filters);
      debugPrint("Deleted $deleted logs");
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// applyConfigurations
  ///
  /// This will apply user provided configurations to FLogs
  static void applyConfigurations(LogsConfig config) {
    _config = config;

    //check to see if encryption is enabled
    if (_config.encryptionEnabled) {
      //check to see if encryption key is provided
      if (_config.encryptionKey.isEmpty) {
        throw Exception(Constants.EXCEPTION_NULL_KEY);
      }
    }
  }

  /// getDefaultConfigurations
  ///
  /// Returns the default configuration
  static LogsConfig getDefaultConfigurations() => _config;

  //Private Methods:------------------------------------------------------------
  /// _logThis
  ///
  /// Logs 'String' data along with class & function name to hourly based file with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  /// @param type         the type
  static Future<void> _logThis(
    String text,
    LogLevel type, [
    String? className,
    String? methodName,
    Exception? exception,
    String? dataLogType,
    StackTrace? stacktrace,
  ]) async {
    //check to see if className is not provided
    //then its already been taken from calling class
    if (className == null) {
      final member = Trace.current().frames[2].member;
      className = member != null ? member.split(".")[0] : 'No Stacktrace found';
    }

    //check to see if methodName is not provided
    //then its already been taken from calling class
    if (methodName == null) {
      final member = Trace.current().frames[2].member;
      methodName =
          member != null ? member.split(".")[1] : 'No Stacktrace found';
    }

    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      //creating log object
      final log = Log(
        className: className,
        methodName: methodName,
        text: text,
        logLevel: type,
        dataLogType: dataLogType ?? '',
        exception: exception.toString(),
        timestamp: DateTimeUtils.getCurrentTimestamp(_config),
        timeInMillis: DateTimeUtils.getCurrentTimeInMillis(),
        stacktrace: stacktrace.toString(),
      );

      //writing it to DB
      await _writeLogs(log);
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// _getAllLogs
  ///
  /// This will return the list of logs stored in database
  static Future<List<Log>> _getAllLogs() async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      return await _flogDao.getAllLogs();
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// _getAllSortedByFilter
  ///
  /// This will return the list of logs sorted by provided filters
  static Future<List<Log>> _getAllSortedByFilter({
    List<Filter>? filters,
  }) async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      return await _flogDao.getAllSortedByFilter(filters: filters);
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// _writeLogs
  ///
  /// This will write logs to local database
  static Future<void> _writeLogs(Log log) async {
    //check to see if user provides a valid configuration and logs are enabled
    //if not then don't do anything
    if (_isLogsConfigValid()) {
      // skip write logs when log level is to low or
      // active log level is not in enabled log levels
      if (LogLevel.values.indexOf(_config.activeLogLevel) <=
              LogLevel.values.indexOf(log.logLevel) &&
          _config.logLevelsEnabled.contains(_config.activeLogLevel)) {
        await _flogDao.insert(log);

        //check to see if logcat debugging is enabled
        if (_config.isDebuggable) {
          debugPrint(Formatter.format(log, _config));
        }
      }
    } else {
      throw Exception(Constants.EXCEPTION_NOT_INIT);
    }
  }

  /// _isLogsConfigValid
  ///
  /// This will check if user provided any configuration and logs are enabled
  /// if yes, then it will return true
  /// else it will return false
  static bool _isLogsConfigValid() => _config.isLogsEnabled;
}
