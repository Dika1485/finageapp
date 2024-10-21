// ignore: camel_case_types
class TransactionCategory {
  final int id;
  // ignore: non_constant_identifier_names
  final String transaction;
  final String type;
  final int amount;

  // ignore: non_constant_identifier_names
  TransactionCategory({required this.id, required this.transaction, required this.type, required this.amount});

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'],
      transaction: json['transaction'],
      type: json['type'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction': transaction,
      'type': type,
      'amount': amount,
    };
  }
}
