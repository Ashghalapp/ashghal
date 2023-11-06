import 'package:ashghal_app_frontend/core/localization/app_localization.dart';

class DateTimeFormatter {
  static String getRecentOrYesterdayOrLastMonthOrMonthOrYear(
      DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Recent';
    } else if (difference.inDays <= 30) {
      return 'Last Month';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays <= 365) {
      return dateTime.toLocal().toString().split(' ')[1]; // Month name
    } else {
      return dateTime.year.toString();
    }
  }

  static String getHourMinuteDateFormat(DateTime dateTime) {
    final hour =
        (dateTime.hour == 12 || dateTime.hour == 0 ? 12 : dateTime.hour % 12)
            .toString()
            .padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    print(minute);
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // If the date is today, return the time (HH:mm a format).
      return getHourMinuteDateFormat(dateTime);
    } else if (difference.inDays == 1) {
      // If the date is yesterday, return "Yesterday".
      return AppLocalization.yesterday;
    } else {
      // If more than one day has passed, return the date in "dd/MM/yy" format.
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString().substring(2);
      return '$day/$month/$year';
    }
  }

  static String formatDateTimeyMMMd(DateTime dateTime) {
    final String year = dateTime.year.toString();
    final String month = _getMonthAbbreviation(dateTime.month);
    final String day = dateTime.day.toString();

    return '$year $month $day';
  }

  static String _getMonthAbbreviation(int month) {
    switch (month) {
      case DateTime.january:
        return 'Jan';
      case DateTime.february:
        return 'Feb';
      case DateTime.march:
        return 'Mar';
      case DateTime.april:
        return 'Apr';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'Jun';
      case DateTime.july:
        return 'Jul';
      case DateTime.august:
        return 'Aug';
      case DateTime.september:
        return 'Sep';
      case DateTime.october:
        return 'Oct';
      case DateTime.november:
        return 'Nov';
      case DateTime.december:
        return 'Dec';
      default:
        return '';
    }
  }

  static String formatDateTimeyMMMdHHSS(DateTime dateTime) {
    return "${formatDateTimeyMMMd(dateTime)}   ${getHourMinuteDateFormat(dateTime)}";
  }
}
