import '/utils/utils.dart';
import 'package:flutter/material.dart';

class SpecificsSimpleCard extends StatelessWidget {
  final String name;
  final String name2;

  SpecificsSimpleCard({required this.name, required this.name2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: null == null ? 80 : 100,
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: null == null
          ? Column(
              children: [
                Text(
                  name,
                  style: BasicHeading,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name2,
                  style: SubHeading,
                ),
              ],
            )
          : Column(),
    );
  }
}
