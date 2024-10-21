// ignore: camel_case_types
class MonthlyReport {
  final int id;
  // ignore: non_constant_identifier_names
  final String month;
  final int income;
  final int expense;

  // ignore: non_constant_identifier_names
  MonthlyReport({required this.id, required this.month, required this.income, required this.expense});

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      id: json['id'],
      month: json['month'],
      income: json['income'],
      expense: json['expense'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'income': income,
      'expense': expense,
    };
  }
}
