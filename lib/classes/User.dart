class User {
  //   'type_id', 'name', 'surnames', 'email', 'password', 'notifications', 'phone', 'address', 'lat', 'lng', 'avatar', 'lang', 'remember_token', 'settings'
  final int type_id;
  final String name;
  final String surnames;
  final String email;
  String password;
  final bool notifications;
  final int phone;
  final String address;
  final double lat;
  final double lng;
  final String avatar_url;
  final String lang;
  final String remember_token;
  final String settings;

  User({
    required this.type_id,
    required this.name,
    required this.surnames,
    required this.email,
    required this.password,
    required this.notifications,
    required this.phone,
    required this.address,
    required this.lat,
    required this.lng,
    required this.avatar_url,
    required this.lang,
    required this.remember_token,
    required this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type_id: json['type_id'],
      name: json['name'],
      surnames: json['surnames'],
      email: json['email'],
      password: json['password'],
      notifications: json['notifications'],
      phone: json['phone'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      avatar_url: json['avatar_url'],
      lang: json['lang'],
      remember_token: json['remember_token'],
      settings: json['settings'],
    );
  }
}
