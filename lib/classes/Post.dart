class Post {
  final String device_token;

  const Post({
    required this.device_token,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      device_token: json['device_token'],
    );
  }
}
