class Book {
  // 'user_id', 'vehicle_id', 'ends_at'
  final int user_id;
  final int vehicle_id;
  final String ends_at;

  const Book({
    required this.user_id,
    required this.vehicle_id,
    required this.ends_at,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      user_id: json['user_id'],
      vehicle_id: json['vehicle_id'],
      ends_at: json['ends_at'],
    );
  }
}
