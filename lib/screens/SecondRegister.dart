import 'package:carby/screens/firstregister.dart';
import 'package:carby/screens/signin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../classes/CurrentUser.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'ThirdRegister.dart';
import 'home.dart';
import 'images.dart';
import 'maplayout.dart';
import 'maplayout2.dart';
import 'signature.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;

class SecondRegister extends StatefulWidget {
  const SecondRegister({Key? key}) : super(key: key);

  @override
  State<SecondRegister> createState() => _SecondRegisterState();
}

class _SecondRegisterState extends State<SecondRegister> {
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
  Map cliente = {"name": "", "surname": "", "phone": "", "address": ""};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              keyboardType: TextInputType.text,
              onSaved: (value) {
                cliente["name"] = value!;
              },
              validator: (value) {
                // add nombre validation
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 4) {
                  return 'Must be at least 4 characters';
                }
                if (value.length > 25) {
                  return 'Must have a maximum of 25 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: '',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (value) {
                cliente["surname"] = value!;
              },
              validator: (value) {
                // add nombre validation
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 4) {
                  return 'Must be at least 4 characters';
                }
                if (value.length > 25) {
                  return 'Must have a maximum of 25 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Surname',
                hintText: '',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onSaved: (value) {
                cliente["phone"] = value!;
              },
              keyboardType: TextInputType.number,
              validator: (value) {
                // add telefono validation
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 9) {
                  return 'Must be at least 9 characters';
                }
                if (value.length > 9) {
                  return 'Must have a maximum of 9 characters';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter a valid phone',
                prefixIcon: Icon(Icons.local_phone),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onSaved: (value) {
                cliente["address"] = value!;
              },
              validator: (value) {
                // add direccion validation
                if (value == null || value.isEmpty) {
                  return 'It cant be empty';
                }
                if (value.length < 6) {
                  return 'Must be at least 6 characters';
                }
                if (value.length > 50) {
                  return 'Must have a maximum of 50 characters';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'New Address',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),

            // boton de continuar
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 3, 135, 161)),
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
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final Future<SharedPreferences> _prefs =
                        SharedPreferences.getInstance();
                    final SharedPreferences prefs = await _prefs;
                    String userToken = prefs.getString('userToken')!;

                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      // https://m.carby.info/api/register

                      print(
                          '${cliente["name"]}, ${cliente["surname"]}, ${cliente["phone"]}, ${cliente["address"]}');
                      final response = await http.put(
                          Uri.parse(globals.URL_API + 'users/edit'),
                          headers: {
                            HttpHeaders.authorizationHeader: userToken,
                            HttpHeaders.contentTypeHeader: 'application/json',
                          },
                          body: json.encode({
                            "name": cliente["name"],
                            "surname": cliente["surname"],
                            "phone": cliente["phone"],
                            "address": cliente["address"]
                          }));
                      var theResponse = jsonDecode(response.body);

                      print(theResponse);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ThirdRegister()));
                    } else {
                      // If the server did not return a 200 OK response,
                      // then throw an exception.
                      throw Exception('Failed to load date of user');
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                _gap(),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
                  child: IconButton(
                    color: const Color.fromARGB(255, 14, 108, 137),
                    iconSize: 31,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstRegister(),
                          ));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
