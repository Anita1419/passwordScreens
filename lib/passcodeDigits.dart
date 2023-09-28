import 'package:flutter/material.dart';
import 'package:image_pdf/utils.dart';

const _passcodeDigitPadding = 8.0;
const _passcodeDigitSizeBig = 36.0;
const _passcodeDigitSizeSmall = 24.0;
const _passcodeDigitGapBig = 16.0;
const _passcodeDigitGapSmall = 4.0;









class PasscodeDigit{

  final Color backgroundColor;
  final Color fontColor;
  final int? value;

  PasscodeDigit({
    required this.backgroundColor, 
    required this.fontColor, 
    this.value
   }
   
   );

    PasscodeDigit copyWith({
    Color? backgroundColor,
    Color? fontColor,
    int? value,
  }) =>
      PasscodeDigit(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        fontColor: fontColor ?? this.fontColor,
        value: value ?? this.value,
      );
}














class PasscodeDigits extends StatelessWidget {
  final List<PasscodeDigit> passcodeDigitValues;
  final bool simpleInputMode;
  const PasscodeDigits({super.key, required this.passcodeDigitValues, required this.simpleInputMode});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: _passcodeDigitSizeBig,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(var i=0; i< passcodeDigitValues.length ; i++)
              Container(
                child: PasscodeDigitContainer(
                  backgroundColor: passcodeDigitValues[i].backgroundColor, 
                  fontColor: passcodeDigitValues[i].fontColor, 
                   digit: passcodeDigitValues[i].value ?? 0,
                  size:  _passcodeDigitSizeBig,     
                          ),
              )
        ].addBetween(
          Container(
            width:  simpleInputMode ?
             _passcodeDigitGapBig : 
             _passcodeDigitGapSmall,
          ) 
        ),
      ),
     
    );
  }
}


class PasscodeDigitContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color fontColor;
  final int digit;
  final double size;
  const PasscodeDigitContainer({super.key, 
  required this.backgroundColor, 
  required this.fontColor, required this.digit, required this.size});

  @override
  Widget build(BuildContext context) {
    final digitContainerSize = size - _passcodeDigitPadding;
    final containerSize = digit != null ? digitContainerSize : 0.0;


    return Container(
      height: _passcodeDigitSizeBig,
      width: _passcodeDigitSizeBig,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:     Color(0xffE4EfE9),
        shape: BoxShape.circle
      ),
      child: Container(
        height: containerSize,
        width: containerSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle
        ),
        child: digit != null ? Center(
          child: Text('$digit' , style: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            height: 1.2
          ),),
        ): null
      ),
    );
  }
}