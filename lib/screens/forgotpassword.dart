import 'package:carby/screens/signin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firstregister.dart';
import 'home.dart';
import 'images.dart';
import 'maplayout.dart';
import 'maplayout2.dart';
import 'signature.dart';
import 'firstregister.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../classes/CurrentUser.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;
import 'edit_profile.dart';
import '../app_color.dart';
import '../classes/CurrentUser.dart';
import 'edit_profile.dart';
import 'images.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage2(),
                  ),
                );
              }),
          title: const Text("Forgot password"),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final headers = {
    HttpHeaders.authorizationHeader: globals.auth_token,
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Si ha olvidado la contraseña, por favor, introduzca su email y le llegara un correo para reestablecerla ',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            _gap(),
            _gap(),
            TextFormField(
              controller: emailEditingController,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Introduce tu email';
                }
                bool _emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!_emailValid) {
                  return 'Introduce un email valido';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
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
                      'Reestablecer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      String clientemail = emailEditingController.text;

                      /// do something TODO comprobar usuario en BD
                      // https://m.carby.info/api/forget

                      final response =
                          await http.post(Uri.parse(globals.URL_API + 'forget'),
                              headers: headers,
                              body: jsonEncode({
                                "email": clientemail,
                              }));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage2()));
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
                                  child: Text('This email dont exists'),
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
                                    Navigator.push(
                                      context,
                                      // MaterialPageRoute(builder: (context) => FirstRegister(),),
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPassword(),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        },
                      );
                      // If the server did not return a 200 OK response,
                      // then throw an exception.
                      throw Exception('Failed to load extras');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<CurrentUser> fetchUser() async {
    final headers = {
      HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.get(
      Uri.parse(globals.URL_API + 'users/current-user'),
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

  Widget _gap() => const SizedBox(height: 16);
}
