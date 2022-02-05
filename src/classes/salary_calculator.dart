import '../constants/constants.dart';
import 'calendar.dart';

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
