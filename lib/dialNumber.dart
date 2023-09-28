import 'package:flutter/material.dart';
import 'package:image_pdf/constants.dart';
import 'package:local_hero/local_hero.dart';


const _dialNumberRadius = Constants.rotaryRingWidth / 2 -
    (Constants.rotaryRingPadding +
        Constants.dialNumberPadding);

class DialNumber extends StatelessWidget {
  final int number;

  const DialNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 'digit_$number',
      child: Container(
        height: Constants.dialNumberRadius * 2,
        width: Constants.dialNumberRadius * 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff93A5CF)
        ),
        child: Text('$number'
        ,style: TextStyle(
          color: Color(0xffE4EfE9), // light

          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
        ),
      ),
    );
  }
}