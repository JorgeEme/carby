import 'dart:async';
import 'package:carby/classes/Faq.dart';
import 'package:carby/screens/faqs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carby/screens/RideHistoryScreen.dart';
import 'package:carby/screens/signin.dart';
import 'package:carby/screens/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carby/classes/Vehicle.dart';
import 'package:location/location.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../app.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/CurrentUser.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/Post.dart';
import '../globals.dart' as globals;

import 'package:carby/classes/CurrentUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../classes/CurrentUser.dart';
import '../screens/car_detail.dart';
import '../classes/Vehicle.dart';
import '../widgets/push_notification.dart';
import 'car_detail.dart';
import 'conditions.dart';
import 'edit_profile.dart';
import 'cars_overview.dart';
import 'firstregister.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'incidence.dart';

class MapsSample extends StatefulWidget {
  @override
  _MapsSampleState createState() => _MapsSampleState();
}
// double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838); Distancia entre puntos

class _MapsSampleState extends State<MapsSample> {
  late String _userToken;
  late LatLngBounds _mapBounds;
  bool isCardVisible = false;
  int carId = 1;

  late Vehicle selectedVehicle;
  late CurrentUser currentUser;
  late LocationData clientLocation;
  bool _populateAvailable = false;
  double _lastMaxDistance = 0.0;

  String carText = 'Example car';
  String carImage =
      'https://freepngimg.com/thumb/car/8-2-car-png-clipart-thumb.png';
  final Set<Marker> _markers = Set();
  final double _zoom = 15;
  late CameraPosition _initialPosition = const CameraPosition(
      target: LatLng(41.4074,
          2.1534)); // La Salle Gracia 41.4074021330697, 2.15346411719925
  MapType _defaultMapType = MapType.normal;
  final Completer<GoogleMapController> _controller = Completer();

  bool visibleWidget = false;

  // NOTIFICATIONS //

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print( 'onBackground Handler ${ message.messageId }');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print( 'onMessage Handler ${ message.messageId }');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print( 'onMessageOpenApp Handler ${ message.messageId }');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  Future<void> fetchNotification() async {
    var response =
        await http.post(Uri.parse(globals.URL_API + 'users/device-token'),
            headers: {
              HttpHeaders.authorizationHeader: _userToken,
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({"device_token": token, "device_type": 1}));
    if (response.statusCode == 200) {
      print(response.body);
      // return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Apple / Web
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }

  // END NOTIFICATIONS //

  void _changed(bool visibility, String field) {
    setState(() {
      visibleWidget = visibility;
    });
  }

  /* super Duper methods */

  Future<List<Vehicle>> fetchVehiclesWithBounds(latI, longI, topRightLat,
      topRightLng, bottomLeftLat, bottomLeftLng, last_max_distance) async {
    print("Entering fetchVehiclesWithBounds");
    // final prefs = await SharedPreferences.getInstance();

    // _userToken = prefs.getString('userToken')!;

    final prefs = await SharedPreferences.getInstance();

    _userToken = prefs.getString('userToken')!;
    globals.auth_token = _userToken;

    if (!_userToken.contains('Bearer ')) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage2()));
    }

    initializeApp();
    fetchNotification();
    currentUser = await fetchUser();

    _initialPosition = CameraPosition(
        target: LatLng(clientLocation.latitude!, clientLocation.longitude!));

    final response =
        await http.post(Uri.parse(globals.URL_API + 'vehicles/get-available'),
            headers: {
              HttpHeaders.authorizationHeader: globals.auth_token,
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              "lat": clientLocation.latitude,
              "lng": clientLocation.longitude,
              "topRightLat": _mapBounds.northeast.latitude, // northeast
              "topRightLng": _mapBounds.northeast.longitude, // northeast
              "bottomLeftLat": _mapBounds.southwest.latitude, // southwest
              "bottomLeftLng": _mapBounds.southwest.longitude, // southwest
              "last_max_distance": 0
            }));

    var theResponse = jsonDecode(response.body);
    print(theResponse["status"]);
    print(theResponse["data"]);

    var vehicles = <Vehicle>[];

    if (theResponse["status"]) {
      for (var i = 0; i < theResponse["data"].length; i++) {
        try {
          var dVehicle = Vehicle.fromJson(theResponse["data"][i]);
          vehicles.add(dVehicle);
        } catch (e) {
          print("error while adding car");
          print(e);
        }
      }

      _lastMaxDistance = vehicles[0].distance!;

      return vehicles;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load vehicles');
    }
  }

  Future<CurrentUser> fetchRate() async {
    final headers = {
      HttpHeaders.authorizationHeader: _userToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.get(
      Uri.parse(globals.URL_API + 'rate'),
      headers: headers,
    );
    var theResponse = jsonDecode(response.body);
    if (theResponse["status"]) {
      return CurrentUser.fromJson(theResponse["data"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load extras');
    }
  }

  Future<LocationData> askForLocation() async {
    // ASK + RETURN initial location
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        askForLocation();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        askForLocation();
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

// https://m.carby.info/api/users/current-user

  Future<CurrentUser> fetchUser() async {
    final headers = {
      HttpHeaders.authorizationHeader: _userToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.get(
      Uri.parse(globals.URL_API + 'users/current-user'),
      headers: headers,
    );
    var theResponse = jsonDecode(response.body);
    if (theResponse["status"]) {
      // PUSH NOTIFICATIONS

      return CurrentUser.fromJson(theResponse["data"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<void> fetchlogOut() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Remove data for the 'counter' key.
    final success = await prefs.remove('userToken');

    final headers = {
      HttpHeaders.authorizationHeader: _userToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.get(
      Uri.parse(globals.URL_API + 'users/logout'),
      headers: headers,
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    _goToInitial();
    // TODO replantear localización de la petición de permisos
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.backgroundColor,
        title: const Text("Carby's map"),
        centerTitle: true,
      ),
      drawer: _futureDrawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _markers,
            mapType: _defaultMapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onCameraMove: (CameraPosition cameraPosition) {
              if (_populateAvailable) {
                _populateAvailable = false;
                populateMapWithVehiclesWithBounds(
                    clientLocation.latitude!,
                    clientLocation.longitude!,
                    _mapBounds.northeast.latitude,
                    _mapBounds.northeast.longitude,
                    _mapBounds.southwest.latitude,
                    _mapBounds.southwest.longitude,
                    _lastMaxDistance);
                print(cameraPosition.zoom);
              }
            },
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
          ),
          Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 50),
              child: Column(
                children: <Widget>[
                  visibleWidget
                      ? Expanded(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 240,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.all(15),
                                      elevation: 10,
                                      child: Column(
                                        children: <Widget>[
                                          // const Image(
                                          //   width: 100,
                                          //   height: 100,
                                          //   image: NetworkImage(
                                          //       'https://cdn-icons-png.flaticon.com/512/1048/1048314.png'),
                                          // ),
                                          Image(
                                            width: 100,
                                            height: 100,
                                            image: NetworkImage('$carImage'),
                                          ),
                                          Container(
                                            child: Text('$carText'),
                                          ),
                                          Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                Text(selectedVehicle.brand),
                                                _customGap(8.0, 0.0),
                                                Text(selectedVehicle.model),
                                                _customGap(8.0, 0.0),
                                                Text(selectedVehicle.gear),
                                              ])),
                                          Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                Text(
                                                    '${selectedVehicle.price_by_minute}/min'),
                                                _customGap(8.0, 0.0),
                                                Text(
                                                    '${selectedVehicle.horse_power} CV'),
                                                _customGap(8.0, 0.0),
                                                Text(
                                                    '${selectedVehicle.automony_km} KMs'),
                                              ])),
                                          Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                color: Colors.grey[400],
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  size: 22.0,
                                                ),
                                                onPressed: () {
                                                  _changed(false, "tag");
                                                },
                                              ),
                                              IconButton(
                                                color: Colors.grey[400],
                                                icon: const Icon(
                                                  Icons.arrow_forward,
                                                  size: 22.0,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CarDetail(
                                                              selectedVehicle,
                                                              clientLocation
                                                                  .latitude!,
                                                              clientLocation
                                                                  .longitude!),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                      : Container(),
                ],
              )),
        ],
      ),
    );
  }

  Widget _drawer2(CurrentUser currentUser, context) {
    final headers = {
      HttpHeaders.authorizationHeader: _userToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    ThemeData themeData = Theme.of(context);
    return Drawer(
      elevation: 16.0,
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                  ),
                  accountName: Text(currentUser.full_name),
                  accountEmail: Text(currentUser.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.network(currentUser.avatar_url),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarsOverviewScreen(
                                clientLocation.latitude!,
                                clientLocation.longitude!)));
                  },
                  title: Text("Car list"),
                  leading: Icon(Icons.car_rental),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => viewProfile()));
                  },
                  title: Text("My Account"),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RideHistoryScreen()));
                  },
                  title: Text("Ride History"),
                  leading: Icon(Icons.calendar_today),
                ),
                ListTile(
                  onTap: () {
                    _goToCoords(40.416688, -3.703797, "madrid", "Madrid",
                        "Welcome to Madrid");
                    Navigator.of(context).pop();
                  },
                  title: Text("Madrid"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    _goToCoords(39.469895, -0.375935, "valencia", "Valencia",
                        "Welcome to Valencia");
                    Navigator.of(context).pop();
                  },
                  title: Text("Valencia"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    _goToCoords(41.403101, 2.173712, "barcelona", "Barcelona",
                        "Welcome to Barcelona");
                    Navigator.of(context).pop();
                  },
                  title: Text("Barcelona"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                const Divider(
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {
                    _showRatingAppDialog();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => RatingsWidget()));
                  },
                  title: Text("Rate the app"),
                  trailing: Icon(Icons.star),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewXPage1(),
                      ),
                    );
                  },
                  title: Text("Terms and use conditions"),
                  trailing: Icon(Icons.privacy_tip),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Faqs(),
                      ),
                    );
                  },
                  title: Text("Faqs"),
                  trailing: Icon(Icons.question_mark),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncidencePage(),
                      ),
                    );
                  },
                  title: Text("Send a Issue"),
                  trailing: Icon(Icons.warning_amber),
                ),
                ListTile(
                  onTap: () async {
                    final nape = await http.post(
                      Uri.parse(globals.URL_API + 'users/logout'),
                      headers: headers,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage2(),
                      ),
                    );
                  },
                  title: Text("Logout"),
                  trailing: Icon(Icons.logout),
                ),
              ],
            ),
          )),
    );
  }

  _futureDrawer() {
    return Container(
        child: FutureBuilder<CurrentUser>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _drawer2(snapshot.data!, context);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Text('${snapshot.error}');
      },
    ));
  }

  void _showRatingAppDialog() {
    final headers = {
      HttpHeaders.authorizationHeader: _userToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final _dialog = RatingDialog(
      initialRating: 1.0,
      starSize: 25,
      starColor: Colors.orangeAccent,
      // your ap4p's name?
      title: const Text(
        'Rate app',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image:
          Image.asset('assets/images/rent-a-car.png', width: 100, height: 150),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        if (response.rating > 0) {
          final apiResponse = await http.post(
              Uri.parse(globals.URL_API + 'rate'),
              headers: headers,
              body: json.encode(
                  {"rating": response.rating, "comment": response.comment}));

          if (jsonDecode(apiResponse.body)["status"]) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Expanded(
                        child: Text('The app was rated correctly'),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: const Text("Back to map"),
                        style: TextButton.styleFrom(
                          primary: Colors.orangeAccent,
                        ),
                        onPressed: () async {
                          // DEV_CarDetail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapsSample(),
                            ),
                          );
                        }),
                  ],
                );
              },
            );
          }
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        }
      },
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _dialog;
        });
  }

  Future<void> _goToCoords(double lat, double long, String markerId,
      String city, String description) async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
    setState(() {
      // _markers.clear();
      _markers.add(
        Marker(
            markerId: MarkerId(markerId),
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: city, snippet: description)),
      );
    });
  }

  Future<void> _goToLondon() async {
    double lat = 51.5074;
    double long = -0.1278;
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: const MarkerId('london'),
            position: LatLng(lat, long),
            infoWindow: const InfoWindow(
                title: 'London', snippet: 'Welcome to London')),
      );
    });
  }

  Future<void> _goToInitial() async {
    clientLocation = await askForLocation();
    double lat = clientLocation.latitude!;
    double long = clientLocation.longitude!;
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));

    LatLngBounds mapBounds = await controller.getVisibleRegion();
    _mapBounds = mapBounds;

    setState(() {
      // _markers.clear();
      // populateMapWithVehicles(lat, long);
      populateMapWithVehiclesWithBounds(
          clientLocation.latitude!,
          clientLocation.longitude!,
          _mapBounds.northeast.latitude,
          _mapBounds.northeast.longitude,
          _mapBounds.southwest.latitude,
          _mapBounds.southwest.longitude,
          _lastMaxDistance);
    });
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Container(
              height: 300,
              width: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(15),
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    const Image(
                      image: NetworkImage(
                          'https://www.yourtrainingedge.com/wp-content/uploads/2019/05/background-calm-clouds-747964.jpg'),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text('Montañas'),
                    ),
                  ],
                ),
              ));
        });
  }

  Container miCardImage() {
    return Container(
        height: 300,
        child: Visibility(
          visible: isCardVisible,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(
              children: <Widget>[
                const Image(
                  image: NetworkImage(
                      'https://www.yourtrainingedge.com/wp-content/uploads/2019/05/background-calm-clouds-747964.jpg'),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Montañas'),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _customGap(g_width, g_height) =>
      SizedBox(width: g_width, height: g_height);

  // Future<void> populateMap(latI, longI, amount, name) async {
  //   double lat = latI;
  //   double long = longI;
  //   // _markers.clear();
  //   // Peticion GET de los marcadores en un radio de 5km

  //   setState(() {
  //     _markers.clear();
  //     for (var i = 0; i < amount; i++) {
  //       // TODO de cada registro coger la id
  //       print("adding marker $name $i");
  //       _markers.add(
  //         Marker(
  //             onTap: () {
  //               visibleWidget ? null : _changed(true, "obs");
  //               carId = i;
  //               setState(() {
  //                 carText = allSimpleCars.simplecars[carId].nombre;
  //                 carImage = allSimpleCars.simplecars[carId].imagen;
  //               });
  //             },
  //             markerId: MarkerId('$name $i'), // id del registro
  //             position: LatLng(lat + i / 100, long + i / 100),
  //             infoWindow: InfoWindow(title: '$name $i', snippet: '$name $i')),
  //       );
  //     }
  //   });
  // }

  Future<void> populateMapWithVehiclesWithBounds(latI, longI, topRightLat,
      topRightLng, bottomLeftLat, bottomLeftLng, last_max_distance) async {
    double lat = latI;
    double long = longI;
    // _markers.clear();
    // Peticion GET de los marcadores en un radio de 5km
    List<Vehicle> vehicleList;
    vehicleList = await fetchVehiclesWithBounds(latI, longI, topRightLat,
        topRightLng, bottomLeftLat, bottomLeftLng, last_max_distance);
    setState(() {
      _markers.clear();
      vehicleList.forEach((vehicle) {
        _markers.add(
          Marker(
              onTap: () {
                visibleWidget ? null : _changed(true, "obs");
                //carId = i;
                setState(() {
                  selectedVehicle = vehicle;
                  carText = selectedVehicle.name;
                  carImage = vehicle.vehicle_images[0]
                      ["full_path"]; // TODO vehicle.images (?)
                });
              },
              markerId: MarkerId('${vehicle.id}'), // id del registro
              position:
                  LatLng(double.parse(vehicle.lat), double.parse(vehicle.lng)),
              infoWindow: InfoWindow(
                  title: '${vehicle.model}',
                  snippet: '${vehicle.price_by_minute}\€/minuto')),
        );
        // print(_markers);
      });
    });

    _populateAvailable = true;
  }
}
