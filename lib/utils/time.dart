class TimeFormatter {
  final DateTime? dateTime;
  TimeFormatter({this.dateTime});

  static final monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String get currentDate => formattDate(DateTime.now());

  static String formattDate(DateTime? date) {
    if (date == null) return '00:00:00';
    return "${monthList[date.month - 1].toString()} ${date.day.toString()}, ${date.year.toString()}";
  }

  static String formattTime(DateTime? date) {
    if (date == null) return 'Jan 1, 1900';
    return "${(date.hour > 12 ? date.hour - 12 : date.hour).toString()}:${date.minute.toString()}${date.hour > 12 ? 'pm' : 'am'}";
  }

  static String formattedTimeDate(DateTime? time) {
    if (time == null) return '00:00:00';
    return "${formattTime(time)}, ${formattDate(time)}";
  }
}
