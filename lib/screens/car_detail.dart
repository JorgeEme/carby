import 'dart:async';
import 'dart:io';

import 'package:carby/app_color.dart';
import 'package:carby/classes/Vehicle.dart';
import 'package:carby/screens/RideHistoryScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/CurrentUser.dart';
import '../classes/User.dart';
import '../globals.dart' as globals;
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import 'cars_overview.dart';
import 'maplayout2.dart';

// TODO Convert to Stateful Widget .. done
class CarDetail extends StatefulWidget {
  final Vehicle selectedCar;
  final double lat;
  final double long;

  CarDetail(this.selectedCar, this.lat, this.long);
  static const LatLng _center = LatLng(41.4074, 2.1534);

  @override
  State<CarDetail> createState() => _CarDetail();
}

class _CarDetail extends State<CarDetail> {
  bool _isButtonDisabled = false;

  void _buttonOut() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  late PageController _pageController;
  late List<String> images = [];
  String carImage = 'Example car';

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    widget.selectedCar.vehicle_images.forEach((element) {
      images.add(element["full_path"]); // referencia a la ruta absoluta
    });

    _pageController = PageController(viewportFraction: 0.8);
    print(widget.selectedCar.vehicle_images.length);
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CarsOverviewScreen(widget.lat, widget.long)),
              );
            }),
        title: const Text("Car details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
              ),
              child: Stack(
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Image(
                      //   image: NetworkImage(widget.selectedCar.vehicle_images[0]["full_path"]), // selectedCar.imagen (?)
                      //   height: size.width * 0.5,
                      //   width: size.width * 0.8,
                      //   fit: BoxFit.contain,
                      // ),
                      Container(
                        height: size.height / 4,
                        width: 200,
                        child: PageView.builder(
                            itemCount: images.length,
                            pageSnapping: true,
                            controller: _pageController,
                            onPageChanged: (page) {
                              setState(() {
                                // activePage = page;
                              });
                            },
                            itemBuilder: (context, i) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Image.network(images[i]),
                              );
                            }),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.selectedCar.name,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.selectedCar.price_by_minute}\€',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/min',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildStat(
                                UniconsLine.dialpad,
                                '${widget.selectedCar.gear}',
                                'Gear',
                                size,
                                ThemeData(backgroundColor: Colors.black)),
                            buildStat(
                              UniconsLine.dashboard,
                              '${widget.selectedCar.automony_km} KM ',
                              'Fuel',
                              size,
                              themeData,
                            ),
                            buildStat(
                              UniconsLine.users_alt,
                              '${widget.selectedCar.seats}',
                              'Seats',
                              size,
                              themeData,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          right: size.width * 0.025,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildStat(
                              UniconsLine.car_sideview,
                              '${widget.selectedCar.doors}',
                              'Doors',
                              size,
                              themeData,
                            ),
                            _gap(16.0, 16.0),
                            buildStat(
                              UniconsLine.power,
                              '${widget.selectedCar.horse_power}',
                              'Power',
                              size,
                              themeData,
                            ),
                          ],
                        ),
                      ),
                      _gap(16.0, 16.0),
                      _gap(16.0, 16.0),
                      Row(
                        children: [
                          Text(
                            'Location',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            UniconsLine.map_marker,
                            color: const Color(0xff3b22a1),
                            size: size.height * 0.04,
                          ),
                          Text(
                            '${widget.selectedCar.distance}',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'KM',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ), /*
                      Center(
                        child: SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeData.cardColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  UniconsLine.map_marker,
                                  color: const Color(0xff3b22a1),
                                  size: size.height * 0.04,
                                ),
                                Text(
                                  '${widget.selectedCar.address}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  buildSelectButton(size, context, widget.selectedCar),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildStat(
    IconData icon,
    String title,
    String desc,
    Size size,
    ThemeData themeData,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
      ),
      child: SizedBox(
        height: size.width * 0.32,
        width: size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            border: Border.all(
                color: Colors.black, // Set border color
                width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.width * 0.03,
              left: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: size.width * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align buildSelectButton(Size size, context, Vehicle car) {
    String textToShow = 'Reserve now';
    String textToShow1 = 'Rent now';
    Color colortoShow = AppColors.primaryColor;

    if (car.is_booked) {
      textToShow = 'Cancel booking';
      colortoShow = AppColors.containerBorderColor;
    }

    if (!car.available) {
      textToShow = 'Finish rent';
      colortoShow = AppColors.containerBorderColor;
      _buttonOut();
    }

    final headers = {
      HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.01,
        ),
        child: Row(
          children: [
            SizedBox(
              height: size.height * 0.07,
              width: size.width * 0.4,
              child: InkWell(
                hoverColor: colortoShow,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colortoShow,
                  ),
                  child: Align(
                    child: TextButton(
                        child: Text(
                          '$textToShow',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          _buttonOut();
                          print(car.id);
                          if (car.is_booked) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Expanded(
                                        child: Text(
                                            'The car is blocked, if you want, you can finalize the booking'),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        child: const Text("Close"),
                                        style: TextButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(
                                            (context),
                                          );
                                        }),
                                    TextButton(
                                        child: const Text("Finish reserve"),
                                        onPressed: () async {
                                          final nape = await http.put(
                                            Uri.parse(globals.URL_API +
                                                'vehicles/${car.id}/cancel'),
                                            headers: headers,
                                            // body: json.encode(clienteFinal)
                                          );
                                          // DEV_CarDetail
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CarsOverviewScreen(
                                                      widget.lat, widget.long),
                                            ),
                                          );
                                        }),
                                  ],
                                );
                              },
                            );
                          } else {
                            // https://m.carby.info/api/vehicles/1/book
                            final nepe = await http.post(
                              Uri.parse(
                                  globals.URL_API + 'vehicles/${car.id}/book'),
                              headers: headers,
                              // body: json.encode(clienteFinal)
                            );
                            // DEV_CarDetail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapsSample(),
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ),
            ),
            _gap(16.0, 16.0),
            _gap(16.0, 16.0),
            SizedBox(
              height: size.height * 0.07,
              width: size.width * 0.4,
              child: InkWell(
                hoverColor: colortoShow,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colortoShow,
                  ),
                  child: Align(
                    child: TextButton(
                        child: Text(
                          '$textToShow1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          print(car.id);
                          if (!car.available) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Expanded(
                                        child: Text(
                                            'The car is rent now, if you want, you can finalize the rent'),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        child: const Text("Finish rent"),
                                        style: TextButton.styleFrom(
                                          primary: Colors.orangeAccent,
                                        ),
                                        onPressed: () async {
                                          final nape = await http.put(
                                            Uri.parse(globals.URL_API +
                                                'journey/${CurrentUser}'),
                                            //TODO poner el id del usuario
                                            headers: headers,
                                            // body: json.encode(clienteFinal)
                                          );
                                          // DEV_CarDetail
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CarsOverviewScreen(
                                                      widget.lat, widget.long),
                                            ),
                                          );
                                        }),
                                  ],
                                );
                              },
                            );
                          } else {
                            // https://m.carby.info/api/vehicles/1/book
                            
                            final nepe = await http.post(
                              Uri.parse(globals.URL_API +
                                  'vehicles/${car.id}/start-journey'),
                              headers: headers,
                              // body: json.encode(clienteFinal)
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RideHistoryScreen(),
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _gap(g_width, g_height) => SizedBox(width: g_width, height: g_height);
