import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';

void main() {
  init();
  runApp(HomePage());
}

void init() {
  /// Configuration example 1
//  LogsConfig config = LogsConfig()
//    ..isDebuggable = true
//    ..isDevelopmentDebuggingEnabled = true
//    ..customClosingDivider = "|"
//    ..customOpeningDivider = "|"
//    ..csvDelimiter = ", "
//    ..isLogsEnabled = true
//    ..encryptionEnabled = false
//    ..encryptionKey = "123"
//    ..formatType = FormatType.FORMAT_CURLY
//    ..logLevelsEnabled = [LogLevel.INFO, LogLevel.ERROR]
//    ..dataLogTypes = [
//      DataLogType.DEVICE.toString(),
//      DataLogType.NETWORK.toString(),
//      "Zubair"
//    ]
//    ..timestampFormat = TimestampFormat.TIME_FORMAT_FULL_1;

  /// Configuration example 2
//  LogsConfig config = FLog.getDefaultConfigurations()
//    ..isDevelopmentDebuggingEnabled = true
//    ..timestampFormat = TimestampFormat.TIME_FORMAT_FULL_2;

  /// Configuration example 3 Format Custom
  final config = FLog.getDefaultConfigurations()
    ..isDevelopmentDebuggingEnabled = true
    ..timestampFormat = TimestampFormat.TIME_FORMAT_FULL_3
    ..formatType = FormatType.FORMAT_CUSTOM
    ..fieldOrderFormatCustom = [
      FieldName.TIMESTAMP,
      FieldName.LOG_LEVEL,
      FieldName.CLASSNAME,
      FieldName.METHOD_NAME,
      FieldName.TEXT,
      FieldName.EXCEPTION,
      FieldName.STACKTRACE
    ]
    ..customOpeningDivider = "|"
    ..customClosingDivider = "|";

  FLog.applyConfigurations(config);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //runtime permission
  final _permissionGroup = Permission.storage;

  @override
  void initState() {
    super.initState();
    requestPermission(_permissionGroup);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextField(),
              _buildRow1(context),
              _buildRow2(),
              _buildRow3(),
              _buildRow4(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return CircularProgressIndicator();
//    return TextFormField(
//      decoration: InputDecoration(hintText: "Enter text"),
//    );
  }

  Widget _buildRow1(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildButton("Log Event", () {
          for (var i = 0; i < 2; i++) {
            if (i % 2 == 0) {
              FLog.logThis(
                className: "HomePage",
                methodName: "_buildRow1",
                text: "My log",
                type: LogLevel.INFO,
                dataLogType: DataLogType.DEVICE.toString(),
              );
            } else {
              FLog.error(
                text: "My log",
                dataLogType: "Zubair",
                className: "Home",
                exception: Exception("This is a test"),
              );
            }
            FLog.warning(
              className: "HomePage",
              methodName: "_buildRow1",
              text: "My log",
              dataLogType: "Umair",
            );
            // not logged because this LogLevel is lower then default INFO
            FLog.trace(
              className: "HomePage",
              methodName: "_buildRow1",
              text: "My log",
              dataLogType: "Umair",
            );
          }
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Print Logs", FLog.printLogs),
      ],
    );
  }

  Widget _buildRow2() {
    return Row(
      children: <Widget>[
        _buildButton("Export Logs", FLog.exportLogs),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Clear Logs", FLog.clearLogs),
      ],
    );
  }

  Widget _buildRow3() {
    return Row(
      children: <Widget>[
        _buildButton("Print File Logs", FLog.printFileLogs),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Print Data Logs", () {
          FLog.printDataLogs(dataLogsType: [
            DataLogType.DEVICE.toString(),
            "Zubair",
            "Jawad"
          ], logLevels: [
            LogLevel.ERROR.toString(),
            LogLevel.WARNING.toString()
          ], filterType: FilterType.WEEK
//            startTimeInMillis: 1556132400000,
//            endTimeInMillis: 1556650800000,
              );
        }),
      ],
    );
  }

  Widget _buildRow4() {
    return Row(
      children: <Widget>[
        _buildButton("Log Event with StackTrace", () {
          FLog.error(
            text: "My log",
            dataLogType: "Zubair",
            className: "Home",
            exception: Exception("Exception and StackTrace"),
            stacktrace: StackTrace.current,
          );
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Delete Logs by Filter (older then 10 seconds)", () {
          FLog.deleteAllLogsByFilter(filters: [
            Filter.lessThan(DBConstants.FIELD_TIME_IN_MILLIS,
                DateTime.now().millisecondsSinceEpoch - 1000 * 10)
          ]);
        }),
      ],
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(title),
        textColor: Colors.white,
        color: Colors.blueAccent,
      ),
    );
  }

  //permission methods:---------------------------------------------------------
  Future<void> requestPermission(Permission permission) async {
    await permission.request();
  }
}
