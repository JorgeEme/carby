import 'package:carby/classes/Vehicle.dart';

class Journey {
  //  'user_id', 'vehicle_id', 'discount_id', 'starts_at', 'ends_at', 'journey_price', 'total_price'
  /*

   */
  final int journey_id;
  final int user_id;
  final int vehicle_id;

  final int discount_id;
  final String starts_at;
  final String ends_at;
  final String invoice_url;
  final String journey_price;
  final String total_price;

  final Vehicle ride_vehicle;

  const Journey({
    required this.journey_id,
    required this.user_id,
    required this.vehicle_id,
    required this.discount_id,
    required this.invoice_url,
    required this.starts_at,
    required this.ends_at,
    required this.journey_price,
    required this.total_price,
    required this.ride_vehicle,
  });

  factory Journey.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      json['id'] = '';
    }
    if (json['discount_id'] == null) {
      json['discount_id'] = 0;
    }
    if (json['journey_price'] == null) {
      json['journey_price'] = 0;
    }
    if (json['total_price'] == null) {
      json['total_price'] = 0;
    }
    if (json['ends_at'] == null) {
      json['ends_at'] = '';
    }
    if (json['starts_at'] == null) {
      json['starts_at'] = '';
    }

    if (json['vehicle']['vehicle_type']["doors"] == null) {
      json['vehicle']['vehicle_type']["doors"] = 0;
    }
    if (json['vehicle']["distance"] == null) {
      json['vehicle']["distance"] == -1.0;
    }

    var journeyVehicle = Vehicle.fromJson(json['vehicle']);

    return Journey(
      journey_id: json['id'],
      user_id: json['user_id'],
      vehicle_id: json['vehicle_id'],
      discount_id: json['discount_id'],
      starts_at: json['starts_at'],
      invoice_url: json['invoice_url'],
      ends_at: json['ends_at'],
      journey_price: json['journey_price'],
      total_price: json['total_price'],
      ride_vehicle: journeyVehicle,
    );
  }
}
