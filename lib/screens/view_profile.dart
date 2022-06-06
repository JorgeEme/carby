import 'dart:async';

import 'package:carby/screens/signin.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'maplayout2.dart';

class viewProfile extends StatefulWidget {
  const viewProfile({Key? key}) : super(key: key);

  @override
  _viewProfile createState() => _viewProfile();
}

class _viewProfile extends State<viewProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CurrentUser currentUser;
  late String _userToken;

  // shared prefs
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    // globals.URL_API = "nepe";
    // print(globals.URL_API
    // );
    // _getUserToken();
    // _prefs.then((SharedPreferences prefs) {
    
    // _userToken = prefs.getString('userToken')!;
    //  print(_userToken);
    //   return prefs.getString('userToken') ?? '';
    // });
  }

  Future<String> _getUserToken() async {
    final SharedPreferences prefs = await _prefs;
    _userToken = (prefs.getString('userToken') ?? 'notdefined');
    return _userToken;
  }

  Future<CurrentUser> fetchUser() async {
    var usertoken =  globals.auth_token;
    // var usertoken =  await _getUserToken();
    if (!usertoken.contains('Bearer ')) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage2()));
    }
    final response = await http.get(
      Uri.parse(globals.URL_API + 'users/current-user'),
      headers: {
      HttpHeaders.authorizationHeader: usertoken,
      HttpHeaders.contentTypeHeader: 'application/json',
      }
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return _futureDrawer();
  }

  Widget profileOverview(CurrentUser currentUser, context) {
    print(currentUser.birth_date);
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
                  builder: (context) => MapsSample(),
                ),
              );
            }),
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: size.height / 3.8,
              width: size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 174, 25),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: size.height * .15,
                      width: size.height * .15,
                      child: Image.network(currentUser.avatar_url),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(currentUser.email)
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    initialValue: currentUser.full_name,
                    decoration: const InputDecoration(
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
                  _gap(16.0, 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: currentUser.birth_date,
                    decoration: const InputDecoration(
                      hintText: '',
                      prefixIcon: Icon(Icons.date_range, color: Colors.orangeAccent),
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
                  _gap(16.0, 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: currentUser.address,
                    decoration: const InputDecoration(
                      hintText: '',
                      prefixIcon: Icon(Icons.home, color: Colors.orangeAccent),
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
                  _gap(16.0, 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: currentUser.phone,
                    decoration: const InputDecoration(
                      semanticCounterText: 'Phone',
                      hintText: '',
                      prefixIcon: Icon(Icons.local_phone, color: Colors.orangeAccent),
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
                  _gap(16.0, 16.0),
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
                            'Edit profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getUserToken,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  _futureDrawer() {
    Size size = MediaQuery.of(context).size; //check the size of device
    return Container(
        child: FutureBuilder<CurrentUser>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return profileOverview(snapshot.data!, context);
        } else if (snapshot.hasError) {
          return Container(
              margin: EdgeInsets.only(
                  left: size.width * 0.33, right: size.width * 0.33),
              width: 40,
              height: 20,
              child: Center(child: CircularProgressIndicator()));
        }
        return Container(
            margin: EdgeInsets.only(
                left: size.width * 0.33, right: size.width * 0.33),
            width: 40,
            height: 20,
            child: Center(child: CircularProgressIndicator()));
      },
    ));
  }

  Padding heading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.subTextColor,
        ),
      ),
    );
  }

  Widget _gap(g_width, g_height) => SizedBox(width: g_width, height: g_height);
}
