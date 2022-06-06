import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;
import '../classes/CurrentUser.dart';
import 'maplayout2.dart';

class RatingsWidget extends StatefulWidget {
  @override
  _RatingsWidgetState createState() => _RatingsWidgetState();
}

Future<CurrentUser> fetchUser() async {
  final headers = {
    HttpHeaders.authorizationHeader: globals.auth_token,
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

class _RatingsWidgetState extends State<RatingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate the app"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.cyan,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Rate app',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: _showRatingAppDialog,
          ),
        ),
      ),
    );
  }

  void _showRatingAppDialog() {
    final headers = {
      HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rate app',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 100),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        print(response.toString());
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
  }
}
