import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_pdf/CirclePainter.dart';
import 'package:image_pdf/constants.dart';
import 'dart:math' as math;

import 'package:image_pdf/dialNumber.dart';
import 'package:image_pdf/utils.dart';

class RotaryDialInput extends StatefulWidget {

    final Duration animationDuration;
  final AnimationController modeChangeController;
  final double pagePadding;
  final bool passcodeAnimationInProgress;
  final ValueSetter<int> onDigitSelected;
  final AsyncCallback onValidatePasscode;

  const RotaryDialInput({super.key,
  required this.animationDuration,
    required this.modeChangeController,
    required this.pagePadding,
    required this.passcodeAnimationInProgress,
    required this.onDigitSelected,
    required this.onValidatePasscode,
  
  
  
  });

  @override
  State<RotaryDialInput> createState() => _RotaryDialInputState();
}

class _RotaryDialInputState extends State<RotaryDialInput> with SingleTickerProviderStateMixin{




   late final AnimationController _dialController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _rotaryDialForegroundAnimation;
  late Animation<double> _rotaryDialBackgroundAnimation;

  var _currentDragOffset = Offset.zero;
  var _startAngleOffset = 0.0;


  bool get _isAnimating =>
      _dialController.isAnimating ||
      widget.modeChangeController.isAnimating ||
      widget.passcodeAnimationInProgress;





      @override
  void initState() {
    super.initState();

    _dialController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(
        () => setState(() => _startAngleOffset = _rotationAnimation.value),
      );

    _rotaryDialForegroundAnimation = Tween<double>(
      begin: Constants.maxRotaryRingSweepAngle,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: widget.modeChangeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _rotaryDialBackgroundAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: widget.modeChangeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }


  @override
  void dispose() {
    _dialController.dispose();
    super.dispose();
  }


  TickerFuture _rotateDialToStart() {
    _rotationAnimation = Tween<double>(
      begin: _startAngleOffset,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _dialController, curve: Curves.easeInOut),
    );

    _dialController.reset();

    return _dialController.forward();
  }



  void _onPanStart(DragStartDetails details, Offset centerOffset) {
    if (_isAnimating) return;

    _currentDragOffset = details.localPosition - centerOffset;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset centerOffset) {
    if (_isAnimating) return;

    final previousOffset = _currentDragOffset;
    _currentDragOffset += details.delta;

    final currentDirection = _currentDragOffset.direction;
    final previousDirection = previousOffset.direction;

    if (currentDirection * previousDirection < 0.0) return;

    final angle = _startAngleOffset + currentDirection - previousDirection;

    if (angle < 0.0 || angle >= Constants.maxRotaryRingAngle) return;

    setState(() => _startAngleOffset = angle);
  }


  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final offset =
        Constants.firstDialNumberPosition * (_startAngleOffset - 1);

    if (offset < -math.pi / 12) {
      _rotateDialToStart();

      return;
    }

    final numberIndex = ((offset * 180 / math.pi).abs() / 30).round();

    _addDigit(numberIndex);
  }

  void _addDigit(int index) {
    widget.onDigitSelected(index);

    _rotateDialToStart().then((_) async => await widget.onValidatePasscode());
  }











  @override
  Widget build(BuildContext context) {
    const inputValues = Constants.inputValues;
    return LayoutBuilder(
      builder: (context , constraints) {
        final width = constraints.maxWidth;
        final size = Size(width,width);
        final dialNumberCenter = width / 2 - 20.0 - Constants.rotaryRingPadding * 2 - Constants.dialNumberPadding * 2;

        final centerOffset = size.centerOffset;
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: size,

              painter: CirclePainter(
                 opacity: _rotaryDialBackgroundAnimation.value,
              ),
            ),
            for(var i = 0 ; i < inputValues.length ; i++)
                Transform.translate(offset: Offset.
                fromDirection(
                  (i+1) * -math.pi / 6,
                  dialNumberCenter ,
                  
                  
                  ),
                  child: DialNumber(number: inputValues[i]),
                  
                  
                  ),
                  GestureDetector(
                     onPanStart: (details) => _onPanStart(details, centerOffset),
              onPanUpdate: (details) => _onPanUpdate(details, centerOffset),
              onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: size,
                      painter: CircleForeground(
                        numberRadius: dialNumberCenter, 
                        startAngleOffset: _startAngleOffset,
                         sweepAngle: _rotaryDialForegroundAnimation.value,
                       
                        
                        ),
                    ),
                  )
          ],
        );
      },
    );
  }
}