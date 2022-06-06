import '/utils/utils.dart';
import 'package:flutter/material.dart';
import '../widgets/cars_grid.dart';
import 'maplayout2.dart';

class CarsOverviewScreen extends StatelessWidget {
  CarsOverviewScreen(this.lat,this.long);

  final double lat;
  final double long;

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        elevation: 0,
        title: Text('Available Cars', style: SubHeading),
      ),
      body: ListView(
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     'Available Cars',
          //     style: MainHeading,
          //   ),
          // ),
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
              height: MediaQuery.of(context).size.height / 1.25,
              child: SingleChildScrollView(
                child: CarsGrid(lat, long),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
            child: IconButton(
              color: const Color.fromARGB(255, 14, 108, 137),
              iconSize: 31,
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsSample(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
