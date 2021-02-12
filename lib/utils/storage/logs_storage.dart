import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../f_logs.dart';

class LogsStorage {
  static final LogsStorage _singleton = LogsStorage._();

  /// Singleton accessor
  static LogsStorage get instance => _singleton;

  // A private constructor. Allows us to create instances of LogsStorage
  // only from within the LogsStorage class itself.
  LogsStorage._();

  // Filing methods:------------------------------------------------------------
  Future<String> get _localPath async {
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory?.path ?? '';
  }

  Future<File> get _localFile async {
    final path = "${await _localPath}/${Constants.DIRECTORY_NAME}";

    //creating directory
    Directory(path).create()
        // The created directory is returned as a Future.
        .then((directory) {
      debugPrint(directory.path);
    });

    //opening file
    var file = File("$path/flog.txt");
    var isExist = await file.exists();

    //check to see if file exist
    if (isExist) {
      debugPrint('File exists------------------>_getLocalFile()');
    } else {
      debugPrint('file does not exist---------->_getLocalFile()');
    }

    return file;
  }

  /// Read the Log-String from file
  Future<String> readLogsToFile() async {
    try {
      final file = await _localFile;

      // Read the file
      var contents = await file.readAsString();

      return contents;
    } on Object catch (_) {
      // If encountering an error, return error message
      return "Unable to read file";
    }
  }

  /// Writes the `log`-String to file
  Future<File> writeLogsToFile(String log) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$log');
  }
}
