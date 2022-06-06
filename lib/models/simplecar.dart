import 'package:flutter/foundation.dart';

class SimpleCarItem {
  final String nombre;
  final int plazas;
  final double bateria;
  final double alcance;
  final double precio_minuto;
  final double precio_standby;
  final String matricula;
  final String imagen;

  SimpleCarItem({
    required this.nombre,
    required this.plazas,
    required this.bateria,
    required this.alcance,
    required this.precio_minuto,
    required this.precio_standby,
    required this.matricula,
    required this.imagen,
  });
}

CarsList allSimpleCars = CarsList(simplecars: [
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
  SimpleCarItem(
      nombre: 'Honda Civic 2018',
      plazas: 5,
      bateria: 95.0,
      alcance: 285.0,
      precio_minuto: 0.31,
      precio_standby: 0.16,
      matricula: 'X5512A',
      imagen:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),
]);

class CarsList {
  List<SimpleCarItem> simplecars;

  CarsList({required this.simplecars});
}
