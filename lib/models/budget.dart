class Budget {
  final int id;
  // ignore: non_constant_identifier_names
  final String budget_item;
  final int allocated;
  final int spent;

  // ignore: non_constant_identifier_names
  Budget({required this.id, required this.budget_item, required this.allocated, required this.spent});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      budget_item: json['budget_item'],
      allocated: json['allocated'],
      spent: json['spent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budget_item': budget_item,
      'allocated': allocated,
      'spent': spent,
    };
  }
}
