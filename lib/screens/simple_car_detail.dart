import 'package:carby/widgets/specific_simple_card.dart';

import '/utils/utils.dart';
import 'package:flutter/material.dart';
import '../widgets/specific_card.dart';

// TODO Convert to Stateful Widget
class SimpleCarDetail extends StatelessWidget {
  String booknow = "Book now";
  final String nombre;
  final int plazas;
  final double bateria;
  final double alcance;
  final double precio_minuto;
  final double precio_standby;
  final String matricula;
  final String imagen;

  SimpleCarDetail({
    required this.nombre,
    required this.plazas,
    required this.bateria,
    required this.alcance,
    required this.precio_minuto,
    required this.precio_standby,
    required this.matricula,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark,
                  size: 30, color: Theme.of(context).accentColor)),
          const IconButton(onPressed: null, icon: Icon(Icons.share, size: 30)),
        ],
      ),
      body: Column(
        children: [
          Text(nombre, style: MainHeading),
          Text(
            matricula,
            style: BasicHeading,
          ),
          Image(
            image: NetworkImage(imagen),
          ),
          // Image.asset(path),
          //  Hero(tag: title, child: Image.asset(path)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SpecificsCard(
                name: 'e/minuto',
                price: precio_minuto,
                name2: 'Euro',
              ),
              SpecificsCard(
                name: 'e/standby',
                price: precio_standby,
                name2: 'Euro',
              ),
              SpecificsCard(
                name: 'Bateria',
                price: bateria,
                name2: 'actual',
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'SPECIFICATIONS',
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SpecificsSimpleCard(
                name: 'Alcance',
                name2: alcance.toString(),
              ),
              SpecificsSimpleCard(
                name: 'Plazas',
                name2: plazas.toString(),
              ),
              SpecificsSimpleCard(
                name: 'CV',
                name2: '120',
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 14, 108, 137)),
              fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            onPressed: () async {
              booknow = "Booked";
            },
            child: Text(
              "$booknow",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
