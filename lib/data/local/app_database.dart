import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import '../../f_logs.dart';

class AppDatabase {
  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  /// Singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  /// Key for encryption
  String encryptionKey = "";

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  /// Database object accessor
  Future<Database> get database async {
    /// If completer is null, AppDatabaseClass is newly instantiated,
    /// so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      /// Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }

    /// If the database is already opened, awaiting the future will happen instantly.
    /// Otherwise, awaiting the returned future will take some time - until complete() is called
    /// on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future<void> _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, DBConstants.DB_NAME);

    // Check to see if encryption is set, then provide codec
    // else init normal db with path
    Database database;
    if (FLog.getDefaultConfigurations().encryptionEnabled &&
        FLog.getDefaultConfigurations().encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      final codec = getXXTeaSembastCodec(
        password: FLog.getDefaultConfigurations().encryptionKey,
      );

      database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }

    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter!.complete(database);
  }
}
