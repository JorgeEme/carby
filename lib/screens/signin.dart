import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../classes/CurrentUser.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'RegisterPage.dart';
import 'firstregister.dart';
import 'forgotpassword.dart';
import 'home.dart';
import 'images.dart';
import 'maplayout.dart';
import 'maplayout2.dart';
import 'signature.dart';
import 'firstregister.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;

class SignInPage2 extends StatelessWidget {
  const SignInPage2({Key? key}) : super(key: key);

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

// Future<CurrentUser> fetchUser() async {
//   final headers = {
//     HttpHeaders.authorizationHeader: globals.auth_token,
//     HttpHeaders.contentTypeHeader: 'application/json',
//   };
//   final response = await http.post(
//     Uri.parse(globals.URL_API + 'login'),
//     headers: headers,
//   );
//   var theResponse = jsonDecode(response.body);
//   if (theResponse["status"]) {
//     return CurrentUser.fromJson(theResponse["data"]);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load extras');
//   }
// }

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
            height: _isSmallScreen ? 200 : 450),
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

  // late CurrentUser currentUser;

  Map clienteFinal = {"email": "", "password": ""};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final headers = {
      // HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onSaved: (value) {
                clienteFinal["email"] = value!;
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
                labelStyle:
                    TextStyle(color: Colors.orangeAccent),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.orange,
                ),
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
              ),
            ),
            _gap(),
            TextFormField(
              onSaved: (value) {
                clienteFinal["password"] = value!;
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
                  hintText: 'Password',
                  labelStyle: const TextStyle(color: Colors.orangeAccent),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.orange,
                  ),
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
                  suffixIcon: IconButton(
                     color: Colors.orange,
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
            // CheckboxListTile(
            //   value: _rememberMe,
            //   onChanged: (value) {
            //     if (value == null) return;
            //     setState(() {
            //       _rememberMe = value;
            //     });
            //   },
            //   title: const Text('Remember me'),
            //   controlAffinity: ListTileControlAffinity.leading,
            //   dense: true,
            //   contentPadding: const EdgeInsets.all(0),
            // ),
            // _gap(),
            // forgotten password

            // register
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
                        text: 'I forgot my password\n\n',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                      ),
                      TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        text: "Register",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _gap(),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 20, 110, 224)),
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
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      // https://m.carby.info/api/login
                      print(
                          '${clienteFinal["email"]}, ${clienteFinal["password"]}');
                      final response = await http.post(
                          Uri.parse(globals.URL_API + 'login'),
                          headers: headers,
                          body: json.encode({
                            "email": clienteFinal["email"],
                            "password": clienteFinal["password"]
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Expanded(
                                    child: Text(
                                        'Please, first register in the app'),
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
                                          builder: (context) => const SignInPage2(),
                                        ),
                                      );
                                    }),
                                TextButton(
                                    child: const Text("Go to register"),
                                    style: TextButton.styleFrom(
                                      primary: Colors.orangeAccent,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        // MaterialPageRoute(builder: (context) => FirstRegister(),),
                                        MaterialPageRoute(
                                          builder: (context) => const SignInPage2(),
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

  Widget _gap() => const SizedBox(height: 16);
}
