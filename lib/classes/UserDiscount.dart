class UserDiscount {
  //   'user_id', 'discount_id'
  final int user_id;
  final int discount_id;

  UserDiscount({
    required this.user_id,
    required this.discount_id,
  });

  factory UserDiscount.fromJson(Map<String, dynamic> json) {
    return UserDiscount(
      user_id: json['typuser_ide_id'],
      discount_id: json['discount_id'],
    );
  }
}
