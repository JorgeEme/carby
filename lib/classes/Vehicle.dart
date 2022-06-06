import 'dart:ffi';

import 'package:flutter/foundation.dart';

class VechicleMedia {
  final int id;
  final String full_path;

  VechicleMedia({
    required this.id,
    required this.full_path,
  });

  factory VechicleMedia.fromJson(Map<String, dynamic> json) {
    return VechicleMedia(
        id: json['id'], full_path: json["full_path"]);
  }
}

class Vehicle {
  final int id;
  final int vehicle_type_id;
  final String lat;
  final String lng;
  final bool available;
  final bool is_booked;
  double? distance;
  final String address;
  final String name;
  final String brand;
  final String model;
  final String price_by_minute;
  final int seats;
  final int doors;
  final int automony_km;
  final int horse_power;
  final String gear;
  final bool air_conditioning;
  final bool spare_wheel;
  final bool smart_screen;
  final bool back_cam;
  final bool parking_sensor;
  final bool auto_emergency_braking;
  final List vehicle_images;

  Vehicle({
    required this.vehicle_type_id,
    required this.id,
    required this.lat,
    required this.lng,
    required this.available,
    required this.is_booked,
    required this.address,
    required this.distance,
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
    required this.auto_emergency_braking,
    required this.vehicle_images,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicle_type_id: json["vehicle_type"]['id'],
      lat: json['lat'],
      lng: json['lng'],
      available: json['available'],
      is_booked: json['is_booked'],
      address: json['address'],
      distance: json['distance'],
      name: json['vehicle_type']["name"],
      brand: json['vehicle_type']["brand"],
      model: json['vehicle_type']["model"],
      price_by_minute: json['vehicle_type']["price_by_minute"],
      seats: json['vehicle_type']["seats"],
      doors: json['vehicle_type']["doors"],
      automony_km: json['vehicle_type']["automony_km"],
      horse_power: json['vehicle_type']["horse_power"],
      gear: json['vehicle_type']["gear"],
      air_conditioning: json['vehicle_type']["air_conditioning"],
      spare_wheel: json['vehicle_type']["spare_wheel"],
      smart_screen: json['vehicle_type']["smart_screen"],
      back_cam: json['vehicle_type']["back_cam"],
      parking_sensor: json['vehicle_type']["parking_sensor"],
      auto_emergency_braking: json['vehicle_type']["auto_emergency_braking"],
      vehicle_images: json['vehicle_type']['images']
    );
  }
}
