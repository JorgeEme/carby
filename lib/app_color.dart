import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = fromHex('#146EE0'); //azul
  static Color secondaryColor = fromHex('#F8F8F8'); //blanco con un poco de gris
  static Color containerBorderColor = fromHex('#CCCCCC'); //gris clarito
  static Color subTextColor = fromHex('#7F7F7F'); //gris oscuro

  static Color buttonTextColor = fromHex('#623B82'); //morado
  static Color lightBlue = fromHex('#372868'); //morado mas oscuro
  static Color cyanColor = fromHex('#4dcbee'); //azul clarito
  static Color gradient1 = fromHex('#22B0FF'); //azul cielo
  static Color gradient2 = fromHex('#ABFEBA'); //verde cesped claro
  static Color greenColor = fromHex('#39F5BB'); //verde brillante
  static Color yellowColor = fromHex('#F7E584'); //amarillo pollito

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
