class Discount {
  // 'code', 'percentage', 'amount'
  final int code;
  final int percentage;
  final int amount;

  const Discount({
    required this.code,
    required this.percentage,
    required this.amount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      code: json['code'],
      percentage: json['percentage'],
      amount: json['amount'],
    );
  }
}
