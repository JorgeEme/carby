class VehicleTypeMedia {
  //    'vehicle_type_id', 'media'
  final int vehicle_id;
  final int media;

  VehicleTypeMedia({
    required this.vehicle_id,
    required this.media,
  });

  factory VehicleTypeMedia.fromJson(Map<String, dynamic> json) {
    return VehicleTypeMedia(
      vehicle_id: json['vehicle_id'],
      media: json['media'],
    );
  }
}
