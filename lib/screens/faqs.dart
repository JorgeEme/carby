import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:carby/classes/Faq.dart';

class Faqs extends StatefulWidget {
  const Faqs({Key? key}) : super(key: key);
  @override
  _Faqs createState() => _Faqs();
}

class _Faqs extends State<Faqs> {
  late Future<List<Faq>> futureFaqs;
  @override
  void initState() {
    super.initState();
    futureFaqs = fetchFaqs(); // Utilizamos id del usuario logeado
  }
  Future<List<Faq>> fetchFaqs() async {
    final response = await http.get(Uri.parse(globals.URL_API + 'faqs'));
    var faqs = <Faq>[];

    var theResponse = jsonDecode(response.body);
    if (theResponse["status"]) {
      for (var i = 0; i < theResponse["data"].length; i++) {
        var dVehicle = Faq.fromJson(theResponse["data"][i]);
        faqs.add(dVehicle);
      }
      return faqs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load extras');
    }
  }

  Widget rideLayout(List<Faq> faqs, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, i) {
          return Container(
            child: RichText(
              text: TextSpan(
                text: faqs[i].question + '\n',
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                    text:
                       '\n' +faqs[i].answer + '\n',
                  ),
                ],
              ),
            ),
          );
        });
  }

    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size.width,
      height: size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text('Faqs'),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
            height: MediaQuery.of(context).size.height / 1.2,
            child: SingleChildScrollView(
                child: FutureBuilder<List<Faq>>(
              future: futureFaqs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: size.width,
                    height: size.height * 0.8,
                    child: rideLayout(snapshot.data!, context),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return Container(
                    margin: EdgeInsets.only(
                        left: size.width * 0.33, right: size.width * 0.33),
                    width: 40,
                    height: 20,
                    child:
                        const Center(child: const CircularProgressIndicator()));
              },
            ))),
      ),
    );
  }
}
