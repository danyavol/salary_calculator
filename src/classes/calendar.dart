class Calendar {
  static MonthInfo getMonthInfo([int monthIncrement = 0]) {
    final now = DateTime.now();
    final monthLastDay = DateTime(now.year, now.month + 1 + monthIncrement, 0);
    final monthFirstDay = DateTime(monthLastDay.year, monthLastDay.month, 1);

    return MonthInfo(monthLastDay.day, monthFirstDay.weekday);
  }

  static int getWorkingDaysCount(MonthInfo month) {
    final fullWeeksDays = month.monthLength ~/ 7 * 5;
    final restDays = month.monthLength % 7;

    if (restDays == 0) return fullWeeksDays;

    final lastDay = month.firstDay + restDays - 1;
    var restDaysList = [1, 2, 3, 4, 5, 6, 7];

    if (month.firstDay > lastDay) {
      restDaysList.removeRange(lastDay, month.firstDay - 1);
    } else {
      restDaysList = restDaysList.sublist(month.firstDay - 1, lastDay);
    }

    restDaysList
      ..remove(6)
      ..remove(7);

    return fullWeeksDays + restDaysList.length;
  }
}

class MonthInfo {
  int monthLength;
  int firstDay;

  MonthInfo(this.monthLength, this.firstDay);
}
