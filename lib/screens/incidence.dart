import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../classes/CurrentUser.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'SecondRegister.dart';
import 'conditions.dart';
import 'home.dart';
import 'images.dart';
import 'maplayout.dart';
import 'maplayout2.dart';
import 'signature.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'signin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;

class IncidencePage extends StatelessWidget {
  const IncidencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapsSample(),
                  ),
                );
              }),
          title: const Text("Incidence"),
          centerTitle: true,
        ),
        body: Center(
            child: _isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/rent-a-car.png',
            width: _isSmallScreen ? 300 : 600,
            height: _isSmallScreen ? 100 : 150),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  Map cliente = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var passKey = GlobalKey<FormFieldState>();
    final headers = {
      //HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return Container(
        margin: const EdgeInsets.only(top: 25.0),
        height: MediaQuery.of(context).size.height / 1.4,
        constraints: const BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onSaved: (value) {
                    cliente["name"] = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a name of incidence';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Issue',
                    hintText: 'Enter a name the Incidence',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          cliente["description"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a description of Issue';
                          }
                          return null;
                        },
                        maxLines: 8, //or null
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your Issue here"),
                      ),
                    )),
                //Boton
                _gap(),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 20, 110, 224)),
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(200, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState!.save();
                          //m.carby.info/api/issues/create
                          print(
                              '${cliente["name"]}, ${cliente["description"]}');
                          final response = await http.post(
                              Uri.parse(globals.URL_API + 'issues/create'),
                              headers: headers,
                              body: json.encode({
                                "name": cliente["name"],
                                "description": cliente["description"]
                              }));
                          var theResponse = jsonDecode(response.body);
                          print(theResponse);
                          if (theResponse["status"]) {
                            final Future<SharedPreferences> _prefs =
                                SharedPreferences.getInstance();
                            final SharedPreferences prefs = await _prefs;

                            prefs
                                .setString('userToken',
                                    '${theResponse["data"]["token_type"]} ${theResponse["data"]["access_token"]}')
                                .then((bool success) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapsSample()));
                            });
                          } else {
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
                                        child:
                                            Text('Issue was send successful'),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        child: const Text("Ok"),
                                        style: TextButton.styleFrom(
                                          primary: Colors.orangeAccent,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          print("Form did not validate");
                          // If the server did not return a 200 OK response,
                          // then throw an exception.
                          // throw Exception('Failed to load email and password');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _gap() => const SizedBox(height: 16);
}
