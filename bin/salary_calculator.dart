import 'dart:io';

const defaultExchangeRate = 2.59;
const defaultTaxes = 2.2;

void main() {
  int salary = getSalary();
  double exchangeRate = getExchangeRate();
  double taxes = getTaxes();

  SalaryCalculator(salary, exchangeRate, taxes).display();
}

int getSalary() {
  try {
    stdout.writeln('Введите вашу зарплату (USD):');
    final salary = stdin.readLineSync() ?? '';
    return int.parse(salary);
  } catch (_) {
    stdout.writeln('Неверный формат! Попробуйте еще раз.\n');
    return getSalary();
  }
}

double getExchangeRate() {
  try {
    stdout.writeln(
        'Введите текущий курс обмена USD в BYN ($defaultExchangeRate по умолчанию):');
    final exchangeRate = stdin.readLineSync() ?? '';
    return exchangeRate.isEmpty
        ? defaultExchangeRate
        : double.parse(exchangeRate);
  } catch (_) {
    stdout.writeln('Неверный формат! Попробуйте еще раз.\n');
    return getExchangeRate();
  }
}

double getTaxes() {
  try {
    stdout.writeln(
        'Введите процент всех налогов, вычетаемых из вашей ЗП ($defaultTaxes% по умолчанию):');
    final taxes = stdin.readLineSync() ?? '';
    return taxes.isEmpty ? defaultTaxes : double.parse(taxes);
  } catch (_) {
    stdout.writeln('Неверный формат! Попробуйте еще раз.\n');
    return getTaxes();
  }
}

class SalaryCalculator {
  int salary;
  double exchangeRate;
  double taxes;

  double get cleanSalary => salary * (100 - taxes) / 100;

  SalaryCalculator(this.salary,
      [this.exchangeRate = defaultExchangeRate, this.taxes = defaultTaxes]);

  void display() {
    final yearSalary = getYearSalary();
    final monthSalary = getMonthSalary();
    final daySalary = getDaySalary();
    final hourSalary = getHourSalary(daySalary);

    String result = '\nВаша чистая зарплата:\n';
    result +=
        'В год     ${_round(yearSalary)} USD (${_round(_inRubles(yearSalary))} BYN)\n';
    result +=
        'В месяц   ${_round(monthSalary)} USD (${_round(_inRubles(monthSalary))} BYN)\n';
    result +=
        'В день    ${_round(daySalary)} USD (${_round(_inRubles(daySalary))} BYN)\n';
    result +=
        'В час     ${_round(hourSalary)} USD (${_round(_inRubles(hourSalary))} BYN)\n';

    print(result);
  }

  double getYearSalary() {
    return cleanSalary * 12;
  }

  double getMonthSalary() {
    return cleanSalary;
  }

  double getDaySalary() {
    final workingDays = Calendar.getWorkingDaysCount(Calendar.getMonthInfo());
    return cleanSalary / workingDays;
  }

  double getHourSalary([double? daySalary]) {
    return daySalary != null ? daySalary / 8 : getDaySalary() / 8;
  }

  double _inRubles(double dollars) {
    return dollars * exchangeRate;
  }

  String _round(double num) {
    return num.toStringAsFixed(2);
  }
}

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
