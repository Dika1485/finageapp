class Currency {
  final int id;
  // ignore: non_constant_identifier_names
  final String currency;
  // ignore: non_constant_identifier_names
  final int exchange_rate;
  final String symbol;

  // ignore: non_constant_identifier_names
  Currency({required this.id, required this.currency, required this.exchange_rate, required this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'],
      currency: json['currency'],
      exchange_rate: json['exchange_rate'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency': currency,
      'exchange_rate': exchange_rate,
      'symbol': symbol,
    };
  }
}
