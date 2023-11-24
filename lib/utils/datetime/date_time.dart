import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../f_logs.dart';

class DateTimeUtils {
  DateTimeUtils._();

  //DateTime Methods:-----------------------------------------------------------
  static int getCurrentTimeInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getCurrentTimestamp(LogsConfig config) {
    return DateFormat(config.timestampFormat.toString()).format(DateTime.now());
  }

  static String getTimeInMillis(LogsConfig config) {
    final fiftyDaysFromNow = DateTime.now().subtract(Duration(days: 1));

    return DateFormat(config.timestampFormat.toString())
        .format(fiftyDaysFromNow);
  }

  static int getStartAndEndTimestamps({required FilterType type}) {
    //switch statement
    switch (type) {
      case FilterType.LAST_HOUR:
        // data/time now
        final now = DateTime.now();
        // last hour
        final lh = now.subtract(Duration(hours: 1));
        debugPrint('$lh');
        return lh.millisecondsSinceEpoch;
      case FilterType.LAST_24_HOURS:
        // last twenty four hours from now
        final tfh = DateTime.now().subtract(Duration(hours: 24));
        //print
        if (FLog.getDefaultConfigurations().isDevelopmentDebuggingEnabled) {
          debugPrint('$tfh');
        }

        return tfh.millisecondsSinceEpoch;
      case FilterType.TODAY:
        // data/time now
        final now = DateTime.now();
        // midnight today
        final td = DateTime(now.year, now.month, now.day);
        //print
        if (FLog.getDefaultConfigurations().isDevelopmentDebuggingEnabled) {
          debugPrint('$td');
        }

        return td.millisecondsSinceEpoch;
      case FilterType.WEEK:
        // data/time now
        final now = DateTime.now();
        // midnight today
        final td = DateTime(now.year, now.month, now.day);
        // last week from today
        final w = td.subtract(Duration(days: 7));
        //print
        if (FLog.getDefaultConfigurations().isDevelopmentDebuggingEnabled) {
          debugPrint('$w');
        }

        return w.millisecondsSinceEpoch;
      case FilterType.ALL:
        return 0;
    }
  }
}
