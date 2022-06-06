import 'package:carby/screens/ThirdRegister.dart';
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

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
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
  String date = "";
  DateTime selectedDate = DateTime.now();
  Map cliente = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var passKey = GlobalKey<FormFieldState>();
    final headers = {
      //HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate) {
        setState(() {
          selectedDate = selected;
          date =
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          print(date);
        });
      }
    }

    return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        margin: const EdgeInsets.only(top: 25.0),
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
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.person, color: Colors.orangeAccent),
                      enabledBorder:  OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide:
                            BorderSide(color: Colors.orangeAccent, width: 1.0),
                      ),
                      border:  OutlineInputBorder(),
                      focusedBorder:  OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orangeAccent, width: 2.0),
                        // borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelStyle:  TextStyle(color: Colors.orangeAccent)),
                ),
                _gap(),
                TextFormField(
                  onSaved: (value) {
                    cliente["surnames"] = value!;
                  },
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Enter a surname';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Surnames',
                    hintText: 'Enter surnames',
                    prefixIcon: Icon(Icons.person, color: Colors.orangeAccent),
                    enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                _gap(),
                TextFormField(
                  onSaved: (value) {
                    cliente["phone"] = value!;
                  },
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Enter phone number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter phone number',
                    prefixIcon: Icon(Icons.phone, color: Colors.orangeAccent),
                    enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                _gap(),
                TextFormField(
                  onSaved: (value) {
                    cliente["address"] = value!;
                  },
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Enter address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter address',
                    prefixIcon: Icon(Icons.location_city, color: Colors.orangeAccent),
                    enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                _gap(),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(1990, 1),
                      lastDate: DateTime(2021, 12),
                    );
                    _selectDate(context);
                  },
                  child: IgnorePointer(
                    child: IgnorePointer(
                      child:  TextFormField(
                        onSaved: (date) {
                          cliente["birth_date"] = date!;
                        },
                        decoration:  InputDecoration(
                          hintText: '$date',
                          enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: const TextStyle(color: Colors.orangeAccent),
                          prefixIcon: Icon(Icons.calendar_month, color: Colors.orangeAccent),
                        ),
                      ),
                    ),
                  ),
                ),
                _gap(),
                TextFormField(
                  onSaved: (value) {
                    cliente["email"] = value!;
                  },
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Enter a email';
                    }
                    bool _emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!_emailValid) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter a email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.orangeAccent),
                   enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                _gap(),
                TextFormField(
                  // key: passKey,
                  onSaved: (value) {
                    cliente["password"] = value!;
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
                      labelText: 'Password',
                      hintText: 'Enter a password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.orangeAccent),
                     enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: const TextStyle(color: Colors.orangeAccent),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility, color: Colors.orangeAccent),
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
                      labelText: 'Confirm password',
                      hintText: 'Enter the same password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.orangeAccent),
                      enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 1.0),
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
labelStyle: const TextStyle(color: Colors.orangeAccent),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility, color: Colors.orangeAccent),
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
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState!.save();
                          print(cliente);
                          // https://m.carby.info/api/register
                          if (cliente["password"] !=
                              cliente["password_confirm"]) {
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
                                '${cliente["name"]}, ${cliente["surnames"]}, ${cliente["phone"]}, ${cliente["address"]}, ${cliente["email"]}, ${cliente["password"]}');
                            print(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
                            final response = await http.post(
                                Uri.parse(globals.URL_API + 'register'),
                                headers: headers,
                                body: json.encode({
                                  "name": cliente["name"],
                                  "surnames": cliente["surnames"],
                                  "phone": cliente["phone"],
                                  "address": cliente["address"],
                                  "birth_date":
                                      '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                                  "email": cliente["email"],
                                  "password": cliente["password"]
                                }));
                            var theResponse = jsonDecode(response.body);
                            if (theResponse["status"]) {
                              print(theResponse);

                              final response = await http.post(
                                  Uri.parse(globals.URL_API + 'login'),
                                  headers: headers,
                                  body: json.encode({
                                    "email": cliente["email"],
                                    "password": cliente["password"]
                                  }));
                              var loginResponse = jsonDecode(response.body);

                              if (loginResponse["status"]) {
                                final Future<SharedPreferences> _prefs =
                                    SharedPreferences.getInstance();
                                final SharedPreferences prefs = await _prefs;
                                prefs.setString('userToken',
                                    '${theResponse["data"]["token_type"]} ${theResponse["data"]["access_token"]}');

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ThirdRegister()));
                              }
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const <Widget>[
                                        Expanded(
                                          child:
                                              Text('Register was unsuccessful'),
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
                _gap(),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            text: 'Make login!\n\n',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage2()));
                              },
                          ),
                          TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            text: "Privacy",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const WebViewXPage1()));
                                // _launchURL('http://car-by.es/');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _gap() => const SizedBox(height: 16);
  Widget _customGap(g_width, g_height) =>
      SizedBox(width: g_width, height: g_height);
}
