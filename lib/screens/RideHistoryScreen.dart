import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import 'package:carby/classes/Journey.dart';
import 'package:carby/classes/Vehicle.dart';
import 'package:carby/screens/maplayout2.dart';
import 'package:carby/widgets/specific_simple_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../app_color.dart';
import '/utils/utils.dart';
import 'package:flutter/material.dart';
import '../widgets/specific_card.dart';
import '../globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import 'journey_detail.dart';

Future<List<Journey>> fetchJourneys() async {
  final headers = {
    HttpHeaders.authorizationHeader: globals.auth_token,
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response = await http.get(Uri.parse(globals.URL_API + 'users/journeys'),
      headers: headers);
  var journeys = <Journey>[];
  if (response.statusCode == 200) {
    var theResponse = jsonDecode(response.body);

    for (var i = 0; i < theResponse["data"].length; i++) {
      var dJourney = Journey.fromJson(theResponse["data"][i]);
      try {
        journeys.add(dJourney);
      } catch (e) {
        print(dJourney);
        print("error while adding journey");
        print(e);
      }
    }

    return journeys;
  } else {
    // If the server did not return a 200 OK response,
    throw Exception('Failed to load user journeys');
  }
}

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen();

  @override
  _RideHistoryScreen createState() => _RideHistoryScreen();
}

class _RideHistoryScreen extends State<RideHistoryScreen> {
  late Future<List<Journey>> futureJourneys;
  @override
  void initState() {
    super.initState();
    futureJourneys = fetchJourneys(); // Utilizamos id del usuario logeado
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size.width,
      height: size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text('Ride history', style: SubHeading),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
            height: MediaQuery.of(context).size.height / 1.2,
            child: SingleChildScrollView(
                child: FutureBuilder<List<Journey>>(
              future: futureJourneys,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: size.width,
                    height: size.height * 0.8,
                    child: rideLayout(snapshot.data!, context),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return Container(
                    margin: EdgeInsets.only(
                        left: size.width * 0.33, right: size.width * 0.33),
                    width: 40,
                    height: 20,
                    child:
                        const Center(child: const CircularProgressIndicator()));
              },
            ))),
      ),
    );
  }
}

void _viewFile(url) async {
  var _url1 = url;
  if (await canLaunch(_url1)) {
    await launch(_url1);
  } else {
    print('Something went wrong');
  }
}

Widget rideLayout(List<Journey> journeys, BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return ListView.builder(
      itemCount: journeys.length,
      itemBuilder: (context, i) {
        print(journeys.length);
        return Container(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 8),
          margin: const EdgeInsets.only(bottom: 16),
          height: MediaQuery.of(context).size.height / 5.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromARGB(255, 92, 92, 92),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      child: Text(journeys[i].ride_vehicle.name),
                      onPressed: () {
                        print(journeys[i].toString());
                        // DEV_CarDetail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JourneyDetail(selectedJourney: journeys[i]),
                          ),
                        );
                      }),
                  const Spacer(),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/calandar.png',
                        height: 30,
                        width: 30,
                      ),
                      Text(
                        "Date: ${journeys[i].starts_at.substring(0, 10)}", // ''
                        style: const TextStyle(
                            color: Color.fromARGB(255, 127, 127, 127),
                            fontSize: 10),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/time.png',
                        height: 30,
                        width: 30,
                      ),
                      Text(
                        "Time: ${journeys[i].starts_at.substring(10, journeys[i].starts_at.length)}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 127, 127, 127),
                            fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    _gap(),
                    Column(
                      children: [
                        _gap(),
                        Image.asset(
                          'assets/images/route.png',
                          height: 65,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Salida",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 127, 127, 127),
                                            fontWeight: FontWeight.w400)),
                                    Text(journeys[i].ride_vehicle.address,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/images/car2.png'),
                                      const Text("",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 127, 127, 127),
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("Llegada",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 127, 127, 127),
                                            fontWeight: FontWeight.w400)),
                                    Text("Localizacion final",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\€${journeys[i].total_price}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(
                                      color: Colors.orangeAccent,
                                      icon: const Icon(Icons.download),
                                      tooltip: 'Download journey invoice',
                                      onPressed: () {
                                        _viewFile(journeys[i].invoice_url);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

Widget _gap() => const SizedBox(width: 16);
