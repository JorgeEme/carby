import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import '../app_color.dart';
import '../classes/CurrentUser.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;
import '../models/cars.dart';
import '../models/simplecar.dart';
import '../widgets/cars_grid.dart';
import 'car_detail.dart';
import 'simple_car_detail.dart';
import 'cars_overview.dart';
import 'firstregister.dart';
import 'maplayout.dart';
import 'view_profile.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CurrentUser currentUser;
  late TextEditingController txt = TextEditingController();
  late Map clienteInicial;
  late Map clienteFinal;
  String date = "";
  DateTime selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    return _futureDrawer();
  }

  Widget editProfileOverview(CurrentUser currentUser, context) {
    final headers = {
      HttpHeaders.authorizationHeader: globals.auth_token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    clienteInicial = {
      // objeto map que compararemos
      "email": currentUser.email,
      "full_name": currentUser.full_name,
      "name": currentUser.name,
      "surnames": currentUser.surnames,
      "phone": currentUser.phone,
      "address": currentUser.address,
      "birth_date": currentUser.birth_date
    };
    clienteFinal = {
      // objeto map que compararemos
      "email": currentUser.email,
      "full_name": currentUser.full_name,
      "name": currentUser.name,
      "surnames": currentUser.surnames,
      "phone": currentUser.phone,
      "address": currentUser.address,
      "birth_date": currentUser.birth_date
    };
    txt.text = clienteFinal["birth_date"];

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate) {
        setState(() {
          selectedDate = selected;
          date =
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          clienteFinal["birth_date"] = date;
          txt.text = clienteFinal["birth_date"];
          print(clienteFinal["birth_date"]);
        });
      }
    }

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
                  builder: (context) => viewProfile(),
                ),
              );
            }),
        title: const Text("Edit profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: size.height / 3.8,
              width: size.width,
              decoration: const BoxDecoration(
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
                      height: size.height * .14,
                      width: size.height * .14,
                      child: Image.asset('assets/images/rent-a-car.png',
                          fit: BoxFit.cover),
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
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        clienteFinal["name"] = value!;
                      },
                      initialValue: currentUser.name,
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
                          prefixIcon:
                              Icon(Icons.person, color: Colors.orangeAccent),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 2.0),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(color: Colors.orangeAccent)),
                    ),
                    _gap(16.0, 16.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        clienteFinal["surnames"] = value!;
                      },
                      initialValue: currentUser.surnames,
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
                          prefixIcon:
                              Icon(Icons.person, color: Colors.orangeAccent),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 2.0),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(color: Colors.orangeAccent)),
                    ),
                    _gap(16.0, 16.0),
                    TextFormField(
                      onSaved: (value) {
                        clienteFinal["address"] = value!;
                      },
                      initialValue: currentUser.address,
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
                          prefixIcon:
                              Icon(Icons.home, color: Colors.orangeAccent),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 2.0),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(color: Colors.orangeAccent)),
                    ),
                    /*_gap(16.0, 16.0),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1990, 1),
                          lastDate: DateTime(2021, 12),
                        );
                        _selectDate(context);
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: txt,
                          // initialValue: '${clienteFinal["birth_date"]}',
                          // onSaved: (date) {
                          //   clienteFinal["birth_date"] = date!;
                          // },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 2.0),
                              // borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: TextStyle(color: Colors.orangeAccent),
                            prefixIcon: const Icon(Icons.calendar_month,
                                color: Colors.orangeAccent),
                          ),
                        ),
                      ),
                    ),*/
                    _gap(16.0, 16.0),

//                     Container(
//                       margin: const EdgeInsets.only(bottom: 16.0),
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Colors.grey, // Set border color
//                             width: 1.0), // Set border width
//                         borderRadius: BorderRadius.all(
//                             Radius.circular(5.0)), // Set rounded corner radius
// // Make rounded corner of border
//                       ),
//                       child: InputDatePickerFormField(
//                         firstDate: firstDate,
//                         lastDate: lastDate,
//                         onDateSubmitted: (date) {
//                           print(date);
//                           setState(() {
//                             selectedDate = date;
//                           });
//                         },
//                         onDateSaved: (date) {
//                           print(date);
//                           setState(() {
//                             selectedDate = date;
//                           });
//                         },
//                       ),
//                     ),

                    TextFormField(
                      onSaved: (value) {
                        clienteFinal["phone"] = value!;
                      },
                      initialValue: currentUser.phone.toString(),
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
                          prefixIcon: Icon(Icons.local_phone,
                              color: Colors.orangeAccent),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 2.0),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(color: Colors.orangeAccent)),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState!.save();
                            clienteFinal["birth_date"] =
                                "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                            if (selectedDate.month.toString().length == 1) {
                              clienteFinal["birth_date"] =
                                  "${selectedDate.year}-0${selectedDate.month}-${selectedDate.day}";
                            }
                            if (selectedDate.day.toString().length == 1) {
                              clienteFinal["birth_date"] =
                                  "${selectedDate.year}-${selectedDate.month}-0${selectedDate.day}";
                            }

                            if (selectedDate.day.toString().length == 1 &&
                                selectedDate.month.toString().length == 1) {
                              clienteFinal["birth_date"] =
                                  "${selectedDate.year}-0${selectedDate.month}-0${selectedDate.day}";
                            }

                            print(clienteFinal["birth_date"]);
                            if (!const MapEquality()
                                .equals(clienteInicial, clienteFinal)) {
                              print("objects are not the same");

                              var response = await http.put(
                                  Uri.parse(globals.URL_API + 'users/edit'),
                                  headers: headers,
                                  body: json.encode(clienteFinal));

                              print(response.body);
                              var theResponse = jsonDecode(response.body);
                              if (theResponse["status"]) {
                                // correct edit
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
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                'Profile edit was successful'),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      viewProfile(),
                                                ),
                                              );
                                            }),
                                      ],
                                    );
                                  },
                                );
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
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(theResponse["data"]),
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

                                throw Exception('Failed to edit user extras');
                              }
                            }
                            // }
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => viewProfile()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _futureDrawer() {
    Size size = MediaQuery.of(context).size; //check the size of device+

    return Container(
        child: FutureBuilder<CurrentUser>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return editProfileOverview(snapshot.data!, context);
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
