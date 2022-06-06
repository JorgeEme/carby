import 'package:carby/screens/info.dart';
import 'package:flutter/material.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 100.0),
              child: Image.asset('assets/images/logo-dashboard-white.png',
                  width: 200, height: 35),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(200, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await context.setLocale(Locale('ca'));
                          navigateToSubPage(context);
                        },
                        child: Text(
                          "Català",
                          style: TextStyle(
                              color: Colors.redAccent[700], fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(200, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await context.setLocale(Locale('es'));
                          navigateToSubPage(context);
                        },
                        child: Text(
                          "Castellano",
                          style: TextStyle(
                              color: Colors.redAccent[700], fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(200, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await context.setLocale(Locale('en'));
                          navigateToSubPage(context);
                        },
                        child: Text(
                          "English",
                          style: TextStyle(
                              color: Colors.redAccent[700], fontSize: 20),
                        ),
                      ),
                    ),
                    /*
                                        Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0),
                      child: IconButton(
                        iconSize: 31,
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () async {
                          navigateToSubPage(context);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 18.0),
                      child: IconButton(
                        iconSize: 31,
                        icon: Icon(Icons.info_outline_rounded),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Version()));
                        },
                      ),
                    ),
                  
                     */
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future navigateToSubPage(context) async {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Home()));
}
