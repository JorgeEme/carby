import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../translations/locale_keys.g.dart';
import 'dart:typed_data';
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Sign extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Sign();

  @override
  _Sign createState() => _Sign();
}

class _Sign extends State<Sign> {
  late int contractId;
  late String type;
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  String? _retrieveDataError;

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(border: Border.all(), color: Colors.white);
    }

    BoxDecoration myMainBoxDecoration() {
      return BoxDecoration(
        border: Border.all(),
        color: const Color.fromARGB(255, 227, 227, 227),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 14, 108, 137),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(),
            ),
            // page title
            Container(
              height: 35,
              color: const Color.fromARGB(255, 234, 0, 43),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            flex: 10,
                            child: Center(
                              child: Text("Firma",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))),
                            ),
                          )
                        ]),
                  ]),
            ),
            Column(
              children: <Widget>[
                //SIGNATURE CANVAS
                Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 25.0),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Signature(
                      controller: _controller,
                      height: 300,
                      backgroundColor: Colors.white,
                    )),
                //OK AND CLEAR BUTTONS
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //SHOW EXPORTED IMAGE IN NEW ROUTE
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.blue,
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            final Uint8List? signature =
                                await _controller.toPngBytes();
                            if (signature != null) {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: Center(
                                        child: Container(
                                          color: Colors.grey[300],
                                          child: Image.memory(signature),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.undo),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _controller.undo());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _controller.redo());
                        },
                      ),
                      //CLEAR CANVAS
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _controller.clear());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Footer (back/next button)
            Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 14, 108, 137)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 40)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              LocaleKeys.previous.tr(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 4,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 14, 108, 137),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 40)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_controller.isNotEmpty) {
                                final Uint8List? signature =
                                    await _controller.toPngBytes();
                                final doCheckinSign = await http.post(
                                    Uri.parse(
                                        'http://192.168.1.143:3000/document'),
                                    headers: headers,
                                    body: json.encode({
                                      "any": "2022",
                                      "tipus": "firma",
                                      "state": type,
                                      "modificacio":
                                          DateTime.now().toIso8601String(),
                                      "contingut": signature,
                                      "contracte": contractId,
                                    }));
                                if (doCheckinSign.statusCode == 200) {
                                  // upload de firma ok, passar contracte a state checkin
                                  final doCheckinChangeState = await http.put(
                                      Uri.parse(
                                          'http://192.168.1.143:3000/contracte/edit/' +
                                              contractId.toString()),
                                      headers: headers,
                                      body: json.encode({"status": type}));
                                  if (doCheckinChangeState.statusCode == 200) {
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
                                                    LocaleKeys.checkinOk.tr()),
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
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/',
                                                          (_) => false);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  throw Exception(
                                      "Error, no s'ha trobat un contracte amb l'id especificada ");
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
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                LocaleKeys.faltafirmaIn.tr()),
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
                            },
                            child: const Text(
                              "Firmar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
