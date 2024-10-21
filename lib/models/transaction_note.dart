// ignore: camel_case_types
class TransactionNote {
  final int id;
  // ignore: non_constant_identifier_names
  final String detail;
  final int amount;
  final String category;

  // ignore: non_constant_identifier_names
  TransactionNote({required this.id, required this.detail, required this.amount, required this.category});

  factory TransactionNote.fromJson(Map<String, dynamic> json) {
    return TransactionNote(
      id: json['id'],
      detail: json['detail'],
      amount: json['amount'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detail': detail,
      'amount': amount,
      'category': category,
    };
  }
}
