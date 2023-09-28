import 'package:flutter/material.dart';
import 'package:image_pdf/constants.dart';
import 'package:image_pdf/input_mode_button.dart';
import 'package:image_pdf/passcodeDigits.dart';
import 'package:image_pdf/passwordInput.dart';
import 'package:image_pdf/rotaryDialInput.dart';
import 'package:local_hero/local_hero.dart';


const _animationDuration = Duration(milliseconds: 500);

class PasswordInputViewWidget extends StatefulWidget {
  final String createdPassword ;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  const PasswordInputViewWidget({super.key, 
  required this.createdPassword, 
  required this.onSuccess, 
  required this.onError});

  @override
  State<PasswordInputViewWidget> createState() => _PasswordInputViewWidgetState();
}

class _PasswordInputViewWidgetState extends State<PasswordInputViewWidget> with SingleTickerProviderStateMixin {
  
   List<PasscodeDigit> passcodeDigitValues = [];
  var _simpleInputMode = false;
  

    // new variables
    late final AnimationController _modeChangeController;
    var _currentInputIndex = 0;
    var _passcodeAnimationInProgress = false;

    bool get _isAnimating =>
      _modeChangeController.isAnimating || _passcodeAnimationInProgress;



  
  @override
  void initState() {  
    super.initState();
     _modeChangeController = AnimationController(
      duration: _animationDuration * 2,
      vsync: this,
    )..addListener(() => setState(() {}));

    _resetDigits();
    
  }


  void _resetDigits() => setState(() {
        _currentInputIndex = 0;
        passcodeDigitValues = List.generate(
          widget.createdPassword.length,
          (index) =>  PasscodeDigit(
            backgroundColor:  Color(0xff93A5CF),
            fontColor: Color(0xff93A5CF),
            value: 1
          ),
          growable: false,
        );
      });


      void _onDigitSelected(int index, {bool autovalidate = false}) {
    if (_isAnimating) return;

    final digitValue = passcodeDigitValues[_currentInputIndex];

    setState(() {
      passcodeDigitValues[_currentInputIndex++] = digitValue.copyWith(
        value: Constants.inputValues[index],
        fontColor: Colors.black
      );
    });

    if (autovalidate) _validatePasscode();
  }



  Future<void> _validatePasscode() async {
    if (_isAnimating) return;

    final expectedCode = widget.createdPassword;

    if (_currentInputIndex != expectedCode.length) return;

    final interval = _animationDuration.inMilliseconds ~/ expectedCode.length;
    final codeInput = passcodeDigitValues.fold<String>(
      '',
      (code, element) => code += element.value?.toString() ?? '',
    );

    _togglePasscodeAnimation();

    if (codeInput == expectedCode) {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.green,
        fontColor: Colors.transparent,
        interval: interval,
      );

      widget.onSuccess();
    } else {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        interval: interval,
      );
      await Future.delayed(const Duration(seconds: 1));
      await _changePasscodeDigitColors(
        backgroundColor: Colors.white,
        fontColor: Colors.white,
        interval: interval,
      );

      widget.onError();
    }

    await Future.delayed(_animationDuration);
    _resetDigits();
    _togglePasscodeAnimation();
  }


   Future<void> _changePasscodeDigitColors({
    Color? backgroundColor,
    Color? fontColor,
    int interval = 0,
  }) async {
    for (var i = 0; i < passcodeDigitValues.length; i++) {
      await Future.delayed(Duration(milliseconds: interval));

      setState(() {
        if (backgroundColor != null) {
          passcodeDigitValues[i] = passcodeDigitValues[i].copyWith(
            backgroundColor: backgroundColor,
          );
        }

        if (fontColor != null) {
          passcodeDigitValues[i] = passcodeDigitValues[i].copyWith(
            fontColor: fontColor,
          );
        }
      });
    }
  }

  void _togglePasscodeAnimation() => setState(
        () => _passcodeAnimationInProgress = !_passcodeAnimationInProgress,
      );

  void _onModeChanged() {
    if (_modeChangeController.isCompleted) {
      _changeInputMode();
      Future.delayed(_animationDuration, () => _modeChangeController.reverse());
    } else {
      _modeChangeController.forward().then((_) => _changeInputMode());
    }
  }

   void _changeInputMode() => setState(
        () => _simpleInputMode = !_simpleInputMode,
      );



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: LocalHeroScope(
             curve: Curves.easeInOut,
            duration: _animationDuration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Enter passcode".toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black
                ),
                
                ),
                SizedBox(height: 32.0,),
                Align(
                  alignment:  Alignment.center ,
                  child: PasscodeDigits(
                    passcodeDigitValues: passcodeDigitValues, 
                    simpleInputMode: _simpleInputMode)
                ),
                Expanded(child: 
                
                _simpleInputMode ? PasswordInput(
                 onDigitSelected: (index) => _onDigitSelected(
                              index,
                              autovalidate: true,
                            ),
                ) : RotaryDialInput(
                           animationDuration: _animationDuration,
                          modeChangeController: _modeChangeController,
                          pagePadding: 20.0,
                          passcodeAnimationInProgress:
                              _passcodeAnimationInProgress,
                          onDigitSelected: _onDigitSelected,
                          onValidatePasscode: _validatePasscode,

                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: InputModeButton(
                    simpleInputMode: _simpleInputMode, 
                    onModeChanged: _onModeChanged, animationDuration: _animationDuration,),
                )
              
              ],
            ),
          ),


        ))
        
        
        );
  
  }

  @override
  void dispose() {
    _modeChangeController.dispose();
    super.dispose();
  }


  
}