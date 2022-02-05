import 'dart:io';

import 'classes/salary_calculator.dart';
import 'constants/constants.dart';

void main() {
  int salary = getSalary();
  double exchangeRate = getExchangeRate();
  double taxes = getTaxes();

  SalaryCalculator(salary, exchangeRate, taxes).display();

  stdin.readLineSync();
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
