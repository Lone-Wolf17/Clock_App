import 'dart:async';
import 'dart:math';

import 'package:clock_app/constants/my_colors.dart';
import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {

  final double size;

  const ClockView({Key key, this.size}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {

  @override
  void initState() {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {

  DateTime dateTime = DateTime.now();

  /// 60 sec = 360, 1 sec = 6 deg
  /// 60 min = 360, 1 min = 6 deg
  /// 24 hr = 360, 1 hr = 15 deg

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()
      ..color = MyColors.clockBG;

    var outlineBrush = Paint()
      ..color = MyColors.clockOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 20;

    var centerFillBrush = Paint()
      ..color = MyColors.clockOutline;

    var secHandBrush = Paint()
      ..color = MyColors.secHandColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width /60;

    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: [MyColors.minHandStatColor, MyColors.minHandEndColor])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width /30;

    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [MyColors.hourHandStatColor, MyColors.hourHandEndColor])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width /24;

    var dashBrush = Paint()
      ..color = MyColors.clockOutline
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;


    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    var hourHandX = centerX +
        radius * 0.4 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        radius * 0.4 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 190);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.6 * sin(dateTime.minute * 6 * pi / 190);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.6 * sin(dateTime.second * 6 * pi / 190);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, radius * 0.12, centerFillBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;

    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
