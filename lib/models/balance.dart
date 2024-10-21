class Balance {
  final int id;
  final String account;
  final int balance;
  final String status;

  Balance({required this.id, required this.account, required this.balance, required this.status});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      id: json['id'],
      account: json['account'],
      balance: json['balance'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'balance': balance,
      'status': status,
    };
  }
}
