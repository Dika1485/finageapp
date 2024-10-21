// ignore: camel_case_types
class DebtCredit {
  final int id;
  // ignore: non_constant_identifier_names
  final String person;
  final int amount;
  final String status;

  // ignore: non_constant_identifier_names
  DebtCredit({required this.id, required this.person, required this.amount, required this.status});

  factory DebtCredit.fromJson(Map<String, dynamic> json) {
    return DebtCredit(
      id: json['id'],
      person: json['person'],
      amount: json['amount'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person': person,
      'amount': amount,
      'status': status,
    };
  }
}
