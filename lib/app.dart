import 'package:carby/pages.dart';
import 'package:carby/routes.dart';
import 'package:carby/screens/ThirdRegister.dart';
import 'package:carby/screens/home.dart';
import 'package:carby/screens/images.dart';
import 'package:carby/screens/maplayout.dart';
import 'package:carby/screens/maplayout2.dart';
import 'package:carby/screens/signature.dart';
import 'package:carby/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/register.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkLogged();
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      title: 'Carby',
      theme: ThemeData(
        backgroundColor: Colors.orangeAccent,
        primaryColor: Colors.white, // F55A13
        fontFamily: 'Jost',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Color.fromARGB(255, 14, 108, 137)),
        ),
      ),
      // home: MapsSample(),
      home: SignInPage2(),
      // initialRoute: Routes.SPLASH,
      // routes: appRoutes(),
    );
  }

  checkLogged() async {
    print("object");
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
  }
}
