import 'package:flutter/foundation.dart';

class CarItem {
  final String title;
  final String matri;
  final String price;
  final String path;
  final String color;
  final String gearbox;
  final String fuel;
  final String brand;
  final int person;

  CarItem(
      {required this.title,
      required this.matri,
      required this.price,
      required this.path,
      required this.color,
      required this.gearbox,
      required this.fuel,
      required this.brand,
      required this.person});
}

CarsList allCars = CarsList(cars: [
  CarItem(
      title: 'Honda Civic 2018',
      matri: '1111 AAA',
      price: '0.13',
      color: 'Grey',
      gearbox: '4',
      fuel: '400',
      brand: 'Honda',
      person: 4,
      path:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),

  //path: 'assets/images/car1.jpg'),
  CarItem(
      title: 'Land Rover Evoque 2016',
      matri: '2222 BBB',
      price: '0.15',
      color: 'Grey',
      gearbox: '6',
      fuel: '400',
      brand: 'Land Rover',
      person: 4,
      path:
          'https://www.binicarsmenorca.com/images/2019-honda-civic-sedan-1558453497.jpg'),
  CarItem(
      title: 'Mercedes Benz SLS 2019',
      matri: '3333 CCC',
      price: '0.16',
      color: 'Red',
      gearbox: '5',
      fuel: '400',
      brand: 'Mercedes',
      person: 5,
      path:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),

  CarItem(
      title: 'Audi A6 2018',
      matri: '4444 DDD',
      price: '0.19',
      color: 'Grey',
      gearbox: '5',
      fuel: '400',
      brand: 'Audi',
      person: 5,
      path:
          'https://www.binicarsmenorca.com/images/2019-honda-civic-sedan-1558453497.jpg'),

  CarItem(
      title: 'Jaguar XF 2019',
      matri: '5555 EEE',
      price: '0.20',
      color: 'White',
      gearbox: '6',
      fuel: '400',
      brand: 'Jaguar',
      person: 5,
      path:
          'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'),

  CarItem(
      title: 'BMW E-1 2018',
      matri: '6666 FFF',
      price: '0.12',
      color: 'Grey',
      gearbox: '6',
      fuel: '400',
      brand: 'BMW',
      person: 2,
      path:
          'https://www.binicarsmenorca.com/images/2019-honda-civic-sedan-1558453497.jpg'),
]);

class CarsList {
  List<CarItem> cars;

  CarsList({required this.cars});
}
