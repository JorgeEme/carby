import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../classes/CurrentUser.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'SecondRegister.dart';
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

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Change password"),
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

Future<CurrentUser> fetchUser() async {
  final headers = {
    HttpHeaders.authorizationHeader: globals.auth_token,
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response = await http.post(
    Uri.parse(globals.URL_API + 'users/change-password'),
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

void _launchURL(url) async {
  if (!await launch(url)) throw 'Could not launch $url';
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
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
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
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onSaved: (value) {
                cliente["current_password"] = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 6) {
                  return 'Must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            TextFormField(
              onSaved: (value) {
                cliente["new_password"] = value!;
              },
              key: passKey,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 6) {
                  return 'Must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Enter a new password',
                  hintText: 'Enter a new password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            TextFormField(
              onSaved: (value) {
                cliente["password_confirm"] = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 6) {
                  return 'Must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Confirm your new password',
                  hintText: 'Enter the same password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
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
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(200, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Continue..',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      // https://m.carby.info/api/register
                      if (cliente["new_password"] !=
                          cliente["password_confirm"]) {
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
                                    child: Text('Passwords do not  match'),
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
                      } else {
                        print(
                            '${cliente["current_password"]}, ${cliente["new_password"]}');

                        final response = await http.post(
                            Uri.parse(
                                globals.URL_API + 'users/change-password'),
                            headers: headers,
                            body: json.encode({
                              "current_password": cliente["current_password"],
                              "new_password": cliente["new_password"]
                            }));
                        var theResponse = jsonDecode(response.body);
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
                                    builder: (context) => SignInPage2()));
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                          'change password was unsuccessful. Try after.'),
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
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
