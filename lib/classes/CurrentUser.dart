import 'dart:ffi';

class CurrentUser {
  /*
  {
        "id": 5,
        "full_name": "Eloi Mondelo",
        "email": "emondelossalle@gmail.com",
        "notifications": 1,
        "phone": null,
        "address": null,
        "birth_date": null,
        "validated": 0,
        "rol": {
            "id": 2,
            "name": "Normal User"
        }
}
   */
  final int id;
  final String full_name;
  final String name;
  final String surnames;
  final String email;
  final String avatar_url;
  final int notifications;
  final String phone;
  final String address;
  final String birth_date;
  final Object rol;

  CurrentUser({
    required this.id,
    required this.full_name,
    required this.name,
    required this.surnames,
    required this.email,
    required this.avatar_url,
    required this.notifications,
    required this.phone,
    required this.address,
    required this.birth_date,
    required this.rol,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) => {
          if (value == null) {json[key] = ''}
        });

    return CurrentUser(
      id: json['id'],
      full_name: json['full_name'],
      name: json['name'],
      surnames: json['surnames'],
      email: json['email'],
      avatar_url: json['avatar_url'],
      notifications: json['notifications'],
      phone: json['phone'],
      address: json['address'],
      birth_date: json['birth_date'],
      rol: json['rol'],
    );
  }
}
