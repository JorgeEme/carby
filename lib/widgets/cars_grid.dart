import 'package:carby/app_color.dart';
import 'package:carby/classes/Vehicle.dart';
import 'package:carby/screens/car_detail.dart';
import 'package:flutter/material.dart';

import '/utils/utils.dart';
import 'package:flutter/material.dart';
import '../models/cars.dart';
import '../screens/car_detail.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;

Future<List<Vehicle>> fetchVehicles(lat, lng) async {
  final headers = {
    HttpHeaders.authorizationHeader: globals.auth_token,
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response =
      await http.post(Uri.parse(globals.URL_API + 'vehicles/get-available'),
          headers: headers,
          //body: {"lat": "41.372559", "lng": "2.097661"});
          body: jsonEncode({"lat": lat, "lng": lng}));
  var vehicles = <Vehicle>[];

  var theResponse = jsonDecode(response.body);
  if (theResponse["status"]) {
    for (var i = 0; i < theResponse["data"].length; i++) {
      var dVehicle = Vehicle.fromJson(theResponse["data"][i]);
      vehicles.add(dVehicle);
    }
    return vehicles;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load extras');
  }
}

class CarsGrid extends StatefulWidget {
  const CarsGrid(this.lat, this.long);
  final double lat;
  final double long;

  @override
  _CarsGrid createState() => _CarsGrid();
}

class _CarsGrid extends State<CarsGrid> {
  late Future<List<Vehicle>> vehicleList;
  @override
  void initState() {
    super.initState();
    vehicleList = fetchVehicles(widget.lat, widget.long);
  }

  Widget carGrid(List<Vehicle> vehicles, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: .68),
        itemCount: vehicles.length,
        itemBuilder: (context, i) {
          print(vehicles[i].is_booked);
          return vehicles[i].is_booked
                ? Container(
            padding: const EdgeInsets.only(left: 10),
            width: size.width / 2 - 20,
            height: size.height * .30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: NetworkImage(
                      vehicles[i].vehicle_images[0]["full_path"]), // temporal
                  height: size.width * 0.2,
                  width: size.width * 0.3,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                // Image.asset(
                //   '/assets/images/car1',
                //   fit: BoxFit.cover,
                //   height: 75,
                //   width: size.width / 2 - 20,
                // ),
                const SizedBox(height: 6),
                Text(
                  vehicles[i].brand,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicles[i].model,
                  style: TextStyle(
                    color: AppColors.subTextColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/car.png'), // temporal
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          vehicles[i].gear,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 10),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/seat.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          vehicles[i].seats.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          vehicles[i].price_by_minute.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "\€",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "/Minute",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19),
                          bottomRight: Radius.circular(19),
                        ),
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.white),
                          child: const Icon(Icons.lock),

                          onPressed: () {
                            // DEV_CarDetail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarDetail(
                                    vehicles[i], widget.lat, widget.long),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              ],
            ),
          )
       
                : Container(
            padding: const EdgeInsets.only(left: 10),
            width: size.width / 2 - 20,
            height: size.height * .30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orangeAccent),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: NetworkImage(
                      vehicles[i].vehicle_images[0]["full_path"]), // temporal
                  height: size.width * 0.2,
                  width: size.width * 0.3,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                // Image.asset(
                //   '/assets/images/car1',
                //   fit: BoxFit.cover,
                //   height: 75,
                //   width: size.width / 2 - 20,
                // ),
                const SizedBox(height: 6),
                Text(
                  vehicles[i].brand,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicles[i].model,
                  style: TextStyle(
                    color: AppColors.subTextColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/car.png'), // temporal
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          vehicles[i].gear,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 10),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/seat.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          vehicles[i].seats.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          vehicles[i].price_by_minute.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "\€",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "/Minute",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19),
                          bottomRight: Radius.circular(19),
                        ),
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.white),
                          child: const Text("Reserve"),
                          onPressed: () {
                            // DEV_CarDetail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarDetail(
                                    vehicles[i], widget.lat, widget.long),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              ],
            ),
          );
       
                  
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height * 0.8,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<Vehicle>>(
                    future: vehicleList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return carGrid(snapshot.data!, context);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return Container(
                          margin: EdgeInsets.only(
                              left: size.width * 0.33,
                              right: size.width * 0.33),
                          width: 40,
                          height: 20,
                          child: Center(child: CircularProgressIndicator()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget getCarItems(List<Vehicle> vehicles, context) {
  Size size = MediaQuery.of(context).size;
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: vehicles
          .map((vehicle) => Column(
                children: [
                  Image(
                    image: NetworkImage(vehicle.vehicle_images[0][
                        "full_path"]), // TEMPORAL hasta tener las images en el modelo
                    fit: BoxFit.cover,
                    height: 75,
                  ),
                  _customGap(0.0, 6.0),
                  // const SizedBox(height: 6),
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  _customGap(0.0, 4.0),
                  Text(
                    vehicle.horse_power.toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 127, 127, 127),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/car.png'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            vehicle.gear,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 127, 127, 127),
                                fontSize: 10),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Image.asset('assets/images/seat.png'),
                          _customGap(5.0, 0.0),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Text(
                            vehicle.seats.toString(),
                            style: const TextStyle(
                                color: const Color.fromARGB(255, 127, 127, 127),
                                fontSize: 10),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                vehicle.price_by_minute.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                "\€",
                                style: TextStyle(
                                    color: Color(0xff3b22a1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                "/Minute",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 3, 0, 13),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Reserve",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  _customGap(0.0, 5.0),
                  // const SizedBox(height: 5),
                ],
              ))
          .toList());
}

Widget _customGap(g_width, g_height) =>
    SizedBox(width: g_width, height: g_height);

Widget getTextWidgets(List<Vehicle> vehicles, context) {
  Size size = MediaQuery.of(context).size;
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: vehicles
          .map((vehicle) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ]),
                        child: Column(
                          children: [
                            Hero(
                              tag: vehicle.name,
                              child: Image(
                                image: const NetworkImage(
                                    'https://www.enterprise.com/content/dam/global-vehicle-images/cars/FORD_FUSION_2020.png'), // temporal
                                height: size.width * 0.2,
                                width: size.width * 0.3,
                              ),
                            ),
                            Text(
                              vehicle.name,
                              style: BasicHeading,
                            ),
                            Text((vehicle.price_by_minute).toString(),
                                style: SubHeading),
                            const Text('por minuto')
                          ],
                        )),
                  ]))
          .toList());
}
