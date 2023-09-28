import 'package:flutter/material.dart';
import 'package:image_pdf/constants.dart';
import 'package:image_pdf/dialNumber.dart';

class PasswordInput extends StatelessWidget {
 final ValueSetter<int> onDigitSelected;
  const PasswordInput({super.key, required this.onDigitSelected});

Widget _renderDialNumber(int index) => GestureDetector(
        onTap: () => onDigitSelected(index),
        child: DialNumber(number: Constants.inputValues[index]),
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for(var i=0; i<3 ; i++) 
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for(var j =0;j<3;j++)
                _renderDialNumber(Constants.inputValues[i * 3 + j]),

            ],
           ),
           _renderDialNumber(Constants.inputValues.last)

        

      ],
    );
  }
}