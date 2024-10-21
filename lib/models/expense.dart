class Expense {
  final int id;
  // ignore: non_constant_identifier_names
  final String expense;
  final int cost;
  final String category;

  // ignore: non_constant_identifier_names
  Expense({required this.id, required this.expense, required this.cost, required this.category});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      expense: json['expense'],
      cost: json['cost'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense': expense,
      'cost': cost,
      'category': category,
    };
  }
}
