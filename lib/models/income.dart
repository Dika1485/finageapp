class Income {
  final int id;
  // ignore: non_constant_identifier_names
  final String source;
  final int amount;
  final int frequency;

  // ignore: non_constant_identifier_names
  Income({required this.id, required this.source, required this.amount, required this.frequency});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      source: json['source'],
      amount: json['amount'],
      frequency: json['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'frequency': frequency,
    };
  }
}
