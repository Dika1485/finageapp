class Investment {
  final int id;
  // ignore: non_constant_identifier_names
  final String investment;
  final int value;
  final String portfolio;

  // ignore: non_constant_identifier_names
  Investment({required this.id, required this.investment, required this.value, required this.portfolio});

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      investment: json['investment'],
      value: json['value'],
      portfolio: json['portfolio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investment': investment,
      'value': value,
      'portfolio': portfolio,
    };
  }
}
