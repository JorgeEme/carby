class VehicleType {
  //  'name', 'brand', 'model', 'price_by_minute', 'seats', 'doors', 'automony_km', 'horse_power', 'gear', 'air_conditioning', 'spare_wheel',
  //  'smart_screen', 'back_cam', 'parking_sensor', 'auto_emergency_braking'

  final int vehicle_type_id;
  final String name;
  final String brand;
  final String model;
  final double price_by_minute;
  late int seats;
  final int doors;
  final int automony_km;
  final int horse_power;
  final int gear;
  final bool air_conditioning;
  final bool spare_wheel;
  final bool smart_screen;
  final bool back_cam;
  final bool parking_sensor;
  final bool auto_emergency_braking;

   VehicleType(
      {required this.vehicle_type_id,
      required this.name,
      required this.brand,
      required this.model,
      required this.price_by_minute,
      required this.seats,
      required this.doors,
      required this.automony_km,
      required this.horse_power,
      required this.gear,
      required this.air_conditioning,
      required this.spare_wheel,
      required this.smart_screen,
      required this.back_cam,
      required this.parking_sensor,
      required this.auto_emergency_braking});

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      vehicle_type_id: json['vehicle_type_id'],
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      price_by_minute: json['price_by_minute'],
      seats: json['seats'],
      doors: json['doors'],
      automony_km: json['automony_km'],
      horse_power: json['horse_power'],
      gear: json['gear'],
      air_conditioning: json['air_conditioning'],
      spare_wheel: json['spare_wheel'],
      smart_screen: json['smart_screen'],
      back_cam: json['back_cam'],
      parking_sensor: json['parking_sensor'],
      auto_emergency_braking: json['auto_emergency_braking'],
    );
  }
}
