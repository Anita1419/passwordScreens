import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:image_pdf/constants.dart';
import 'dart:math' as math;

import 'package:image_pdf/utils.dart';

class CirclePainter extends CustomPainter {


  final double opacity;

  CirclePainter({super.repaint, required this.opacity});


  @override
  void paint(Canvas canvas, Size size) {
    const ringWidth = Constants.rotaryRingWidth;
    final paint = Paint()
      ..color =             Color(0xff93A5CF).withOpacity(opacity)
      ..strokeWidth = ringWidth
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
        center: size.centerOffset,
        radius: size.width / 2 - ringWidth / 2,
      ),
      0,
      math.pi * 2.0,
      false,
      paint,
    );

  }

  @override
  bool shouldRepaint( CirclePainter oldDelegate) =>
    oldDelegate.opacity != opacity;
  


}






class CircleForeground extends CustomPainter {
  final double numberRadius;
   final double startAngleOffset;
  final double sweepAngle;
  CircleForeground ({  required this.startAngleOffset, required  this.sweepAngle, 
    required this.numberRadius

  });
  
  @override
  void paint(Canvas canvas, Size size) {
        const firstDialNumberPosition = Constants.firstDialNumberPosition;
    const ringWidth = Constants.rotaryRingWidth;

    final angleOffset = startAngleOffset * firstDialNumberPosition;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = ringWidth - Constants.rotaryRingPadding * 2
      ..style = PaintingStyle.stroke;

    canvas
      ..saveLayer(Rect.largest, paint)
      ..drawArc(
        Rect.fromCircle(
          center: size.centerOffset,
          radius: size.width / 2 - ringWidth / 2,
        ),
        angleOffset + firstDialNumberPosition,
        sweepAngle,
        false,
        paint,
      );

    for (int i = 0; i < 10; i++) {
      final offset = Offset.fromDirection(
        angleOffset + math.pi * (-30 - i * 30) / 180,
        numberRadius,
      );

      canvas.drawCircle(
        size.centerOffset + offset,
        Constants.dialNumberRadius,
        Paint()..blendMode = BlendMode.clear,
      );
    }

    canvas.drawCircle(
      size.centerOffset +
          Offset.fromDirection(math.pi / 6, numberRadius),
      ringWidth / 6,
      Paint()
        ..color = Color.fromRGBO(
          255,
          255,
          255,
          sweepAngle / Constants.maxRotaryRingSweepAngle,
        ),
    );

   

     canvas.restore();
    
  }

    @override
  bool shouldRepaint(CircleForeground oldDelegate) =>
      oldDelegate.numberRadius != numberRadius &&
      oldDelegate.startAngleOffset != startAngleOffset &&
      oldDelegate.sweepAngle != sweepAngle;

  

}