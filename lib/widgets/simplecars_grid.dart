import '/utils/utils.dart';
import 'package:flutter/material.dart';
// import '../models/cars.dart';
// import '../screens/car_detail.dart';

import '../models/simplecar.dart';
import '../screens/simple_car_detail.dart';

class CarsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: allSimpleCars.simplecars.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => SimpleCarDetail(
                      nombre: allSimpleCars.simplecars[i].nombre,
                      plazas: allSimpleCars.simplecars[i].plazas,
                      bateria: allSimpleCars.simplecars[i].bateria,
                      alcance: allSimpleCars.simplecars[i].alcance,
                      precio_minuto:
                          allSimpleCars.simplecars[i].precio_minuto,
                      precio_standby:
                          allSimpleCars.simplecars[i].precio_standby,
                      matricula: allSimpleCars.simplecars[i].matricula,
                      imagen: allSimpleCars.simplecars[i].imagen,
                    )));
          },
          child: Container(
              margin: EdgeInsets.only(
                  top: i.isEven ? 20 : 20, bottom: i.isEven ? 0 : 0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 5, spreadRadius: 1)
                  ]),
              child: Column(
                children: [
                  Hero(
                      tag: allSimpleCars.simplecars[i].nombre,
                      child: //Image( image: NetworkImage(allCars.cars[i].path), ),
                          Image.asset('/assets/images/car$i')),
                  Text(
                    allSimpleCars.simplecars[i].nombre,
                    style: BasicHeading,
                  ),
                  Text((allSimpleCars.simplecars[i].precio_minuto).toString(), style: SubHeading),
                  const Text('per month')
                ],
              )),
        ),
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
