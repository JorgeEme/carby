import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:carby/classes/Journey.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../app_color.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'dart:convert';
import 'package:carby/app_color.dart';
import 'package:carby/classes/Journey.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import 'PaymentPage.dart';

// TODO Convert to Stateful Widget .. done
class JourneyDetail extends StatefulWidget {
  final Journey selectedJourney;

  JourneyDetail({
    required this.selectedJourney,
  });

  static const LatLng _center = LatLng(41.4074, 2.1534);

  @override
  State<JourneyDetail> createState() => _JourneyDetail();
}

class _JourneyDetail extends State<JourneyDetail> {
  String carImage = 'Example car';

  void _viewFile(url) async {
    var _url1 = url;
    if (await canLaunch(_url1)) {
      await launch(_url1);
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.selectedJourney.ends_at);
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    List<Widget> notEnded = <Widget>[
          _gap(32.0, 0.0),
          buildSelectButton(size / 1.25, context, widget.selectedJourney,
              "Cancelar reserva", "cancel"),
          _gap(16.0, 0.0),
          buildSelectButton(size / 1.25, context, widget.selectedJourney,
              "Finalizar journey", "pay"),
    ];
    if(widget.selectedJourney.ends_at != '') {
      notEnded = <Widget>[];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.download),
            tooltip: 'Download journey invoice',
            onPressed: () {
              _viewFile(widget.selectedJourney.invoice_url);
            },
          ),
        ],
      ),
      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: notEnded,
      ),
      body: Center(
        child: Container(
          width: size.width,
          height: MediaQuery.of(context).size.height / 1.2,
          child: SingleChildScrollView(
            child: Column(children: [
              Image(
                image: NetworkImage(
                    widget.selectedJourney.ride_vehicle.vehicle_images[0]
                        ["full_path"]), // selectedJourney.imagen (?)
                height: size.height * 0.1,
                width: size.width * 0.2,
                fit: BoxFit.contain,
              ),
              Center(
                  child: Text(
                widget.selectedJourney.ride_vehicle.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ride sheet')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Ride id')),
                      DataCell(
                          Text(widget.selectedJourney.journey_id.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Started at')),
                      DataCell(Text(widget.selectedJourney.starts_at)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Ended at')),
                      DataCell(Text('${widget.selectedJourney.ends_at}')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Journey Price')),
                      DataCell(Text(
                          '${widget.selectedJourney.journey_price.toString()} €')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Total price')),
                      DataCell(Text('${widget.selectedJourney.total_price} €')),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Car sheet')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Name')),
                      DataCell(Text(widget.selectedJourney.ride_vehicle.name)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Model')),
                      DataCell(Text(widget.selectedJourney.ride_vehicle.model)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Price per minute')),
                      DataCell(Text(
                          '${widget.selectedJourney.ride_vehicle.price_by_minute}\€')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Autonomy')),
                      DataCell(Text(
                          '${widget.selectedJourney.ride_vehicle.automony_km} KMs')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Horse power')),
                      DataCell(Text(
                          '${widget.selectedJourney.ride_vehicle.horse_power} CVs')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Price per minute')),
                      DataCell(Text(
                          '${widget.selectedJourney.ride_vehicle.price_by_minute}\€')),
                    ]),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     buildSelectButton(size / 1.5, context, widget.selectedJourney,
              //         "Cancelar reserva", "cancel"),
              //     _gap(16.0, 16.0),
              //     buildSelectButton(size / 1.5, context, widget.selectedJourney,
              //         "Finalizar journey", "pay"),
              //   ],
              // )
            ]),

            // buildSelectButton(size/2, context, widget.selectedJourney),
          ),
        ),
      ),
    );
  }

  Align buildSelectButton(
      Size size, context, Journey journey, String buttonValue, String action) {
    String textToShow = buttonValue;
    Color colortoShow = AppColors.primaryColor;

    // if (car.is_booked || !car.available) {
    //   textToShow = 'Reservado';
    //   colortoShow = AppColors.containerBorderColor;
    // }
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
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width / 2,
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
                      print(journey);
                      // https://m.carby.info/journey/3?lat=41.384215&lng=2.154487
                      final response = await http.get(Uri.parse(
                          globals.PAYMENT_ENDPOINT +
                              'journey/3?lat=41.384215&lng=2.154487'));
                      print(response.body);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PaymentWebView(body: response.body)));
                    }),
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
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(
                color: Colors.black, // Set border color
                width: 1.0),
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
}

Widget _gap(g_width, g_height) => SizedBox(width: g_width, height: g_height);
