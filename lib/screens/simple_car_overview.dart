import '/utils/utils.dart';
import 'package:flutter/material.dart';
import '../widgets/cars_grid.dart';
import 'maplayout2.dart';

class CarsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Carby', style: SubHeading),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Available Cars',
              style: MainHeading,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25.0, bottom: 0),
              height: MediaQuery.of(context).size.height / 1.2,
              child: SingleChildScrollView(
                // child: CarsGrid(),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 18.0),
            child: IconButton(
              color: const Color.fromARGB(255, 14, 108, 137),
              iconSize: 31,
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MapsSample(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
