library spline_chart;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vet_sotf_app/config/global/palet_colors.dart';

/// A Spline chart widget.
///
/// This widget draws a spline chart based on the given [values].
class SplineChart extends StatelessWidget {
  /// Width of the chart
  final double width;

  /// Height of the chart
  final double height;

  /// Line chart values
  ///
  /// Each key in the hash map represents the X position and it's value as the Y position
  final Map<double, double> values1;

  final Map<double, double> values2;

  /// Start of the X axis
  ///
  /// Defaults to 0
  final double xStart;

  /// End of the X axis
  ///
  /// Defaults to 100
  final double xEnd;

  /// The X axis lable intervals
  ///
  /// Defaults to 10
  final double xStep;

  final double yStart;

  final double yEnd;

  final double yStep;

  /// Color of the line being drawn
  final Color lineColor1;
  final Color lineColor2;

  /// Color of the grid lines
  final Color gridLineColor;

  /// Color of the label texts
  final Color textColor;

  /// Size of the label texts
  final double textSize;

  /// Thickness of the line
  final double strokeWidth;

  /// Color of the fill
  final Color fillColor1;
  final Color fillColor2;

  /// Opacity of the fill
  final double fillOpactiy;

  /// If true, a vertical line will be drawn at [verticalLinePosition]
  final bool verticalLineEnabled;

  /// Position of the vertical line
  final double verticalLinePosition;

  /// Thickness of the vertical line
  final double verticalLineStrokeWidth;

  /// Color of the vertical line
  final Color verticalLineColor;

  /// The text for the vertical line label
  ///
  /// Leave it empty if no label is needed
  final String? verticalLineText;

  /// If true, each data point would be highlighted by circles
  final bool drawCircles;

  /// Fill color of the data point circles
  final Color circleFillColor1;
  final Color circleFillColor2;

  /// Thickness of the data point circles
  final Color circleStrokeColor1;
  final Color circleStrokeColor2;

  /// Radius of the data point circles
  final double circleRadius;

  final String legend1;
  final String legend2;

  const SplineChart(
      {Key? key,
      required this.values1,
      required this.values2,
      this.width = 320.0,
      this.height = 200.0,
      this.lineColor1 = ColorPalet.primaryDefault,
      this.lineColor2 = ColorPalet.secondaryDefault,
      this.gridLineColor = ColorPalet.grisesGray3,
      this.textColor = ColorPalet.grisesGray1,
      this.textSize = 14,
      this.xStart = 0,
      this.xEnd = 100,
      this.xStep = 10,
      this.yStart = 0,
      this.yEnd = 100,
      this.yStep = 10,
      this.strokeWidth = 3,
      this.fillColor1 = ColorPalet.primaryLight,
      this.fillColor2 = ColorPalet.secondaryLight,
      this.fillOpactiy = 0.5,
      this.verticalLineEnabled = false,
      this.verticalLinePosition = 0.0,
      this.verticalLineStrokeWidth = 1.0,
      this.verticalLineColor = Colors.red,
      this.verticalLineText,
      this.drawCircles = false,
      this.circleFillColor1 = ColorPalet.primaryLight,
      this.circleFillColor2 = ColorPalet.secondaryLight,
      this.circleStrokeColor1 = ColorPalet.primaryDefault,
      this.circleStrokeColor2 = ColorPalet.secondaryDefault,
      this.circleRadius = 4,
      this.legend1 = 'Primera',
      this.legend2 = 'Segunda'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
          size: Size(width, height),
          painter: _SplineChartPainter(
            lineColor1: lineColor1,
            lineColor2: lineColor2,
            gridLineColor: gridLineColor,
            textColor: textColor,
            textSize: textSize,
            values1: values1,
            values2: values2,
            xStart: xStart,
            xEnd: xEnd,
            xStep: xStep,
            yStart: yStart,
            yEnd: yEnd,
            yStep: yStep,
            strokeWidth: strokeWidth,
            fillColor1: fillColor1,
            fillColor2: fillColor2,
            fillOpactiy: fillOpactiy,
            verticalLineColor: verticalLineColor,
            verticalLineEnabled: verticalLineEnabled,
            verticalLinePosition: verticalLinePosition,
            verticalLineStrokeWidth: verticalLineStrokeWidth,
            verticalLineText: verticalLineText,
            drawCircles: drawCircles,
            circleFillColor1: circleFillColor1,
            circleStrokeColor1: circleStrokeColor1,
            circleFillColor2: circleFillColor2,
            circleStrokeColor2: circleStrokeColor2,
            circleRadius: circleRadius,
            legend1: legend1,
            legend2: legend2,
          )),
    );
  }
}

class _SplineChartPainter extends CustomPainter {
  final Color lineColor1;
  final Color lineColor2;
  final Color gridLineColor;
  final Color textColor;
  final double textSize;
  final Color fillColor1;
  final Color fillColor2;
  final double fillOpactiy;
  final Map<double, double> values1;
  final Map<double, double> values2;
  final double xStart;
  final double xEnd;
  final double xStep;
  final double yStart;
  final double yEnd;
  final double yStep;
  final double strokeWidth;
  final bool verticalLineEnabled;
  final double verticalLinePosition;
  final double verticalLineStrokeWidth;
  final Color verticalLineColor;
  final String? verticalLineText;
  final bool drawCircles;
  final double circleRadius;
  final Color circleFillColor1;
  final Color circleFillColor2;
  final Color circleStrokeColor1;
  final Color circleStrokeColor2;
  final String legend1;
  final String legend2;

  _SplineChartPainter({
    required this.lineColor1,
    required this.lineColor2,
    required this.gridLineColor,
    required this.textColor,
    required this.textSize,
    required this.values1,
    required this.values2,
    required this.xStart,
    required this.xEnd,
    required this.xStep,
    required this.yStart,
    required this.yEnd,
    required this.yStep,
    required this.strokeWidth,
    required this.fillColor1,
    required this.fillColor2,
    required this.fillOpactiy,
    required this.verticalLineEnabled,
    required this.verticalLinePosition,
    required this.verticalLineStrokeWidth,
    required this.verticalLineColor,
    this.verticalLineText,
    required this.drawCircles,
    required this.circleStrokeColor1,
    required this.circleStrokeColor2,
    required this.circleFillColor1,
    required this.circleFillColor2,
    required this.circleRadius,
    required this.legend1,
    required this.legend2,
  });

  // double _calcStepSize(double range, int targetSteps) {
  //   double tempStep = range / targetSteps;
  //   var magPow = pow(10, (log(tempStep) / ln10).floor());
  //   var magMsd = (tempStep / magPow + 0.5);
  //   if (magMsd > 5) {
  //     magMsd = 10;
  //   } else if (magMsd > 2) {
  //     magMsd = 5;
  //   } else if (magMsd > 1) {
  //     magMsd = 2;
  //   }
  //   return magMsd * magPow;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor1
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paint2 = Paint()
      ..color = lineColor2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double yMin = double.infinity, yMax = double.negativeInfinity;
    values1.forEach((key, value) {
      yMin = min(value, yMin);
      yMax = max(value, yMax);
    });

    values2.forEach((key, value) {
      yMin = min(value, yMin);
      yMax = max(value, yMax);
    });

    // double yStep = _calcStepSize(yMax - yMin, 20);
    yMin = yStart;
    yMax = yEnd;
    // yMax = ((yMax / yStep).floor() + 1) * yStep;

    // draw grid lines
    final axisLinePaint = Paint()
      ..color = gridLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + strokeWidth / 2;

    final gridLinePaint = Paint()
      ..color = gridLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - strokeWidth / 2;

    double paddingX = 50;
    double paddingY = 40;

    // yAxis
    canvas.drawLine(Offset(paddingX, 0), Offset(paddingX, size.height - paddingY), axisLinePaint);
    // xAxis
    canvas.drawLine(Offset(paddingX, size.height - paddingY), Offset(size.width, size.height - paddingY), axisLinePaint);

    // intl.NumberFormat numberFormat = intl.NumberFormat.decimalPattern('hi');

    // draw vertical grid lines
    double xRatio = (size.width - paddingX) / (xEnd - xStart);
    for (double x = xStart; x <= xEnd; x += xStep) {
      canvas.drawLine(Offset(x * xRatio + paddingX, 0), Offset(x * xRatio + paddingX, size.height - paddingY), gridLinePaint);
      TextSpan span = TextSpan(style: TextStyle(color: textColor, fontSize: textSize), text: x.floor().toString());
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x * xRatio + paddingX - tp.width / 2, size.height - paddingY + 5));
    }

    // draw horizontal grid lines
    double yRatio = (size.height - paddingY) / (yMax - yMin);
    for (double y = yMin; y <= (yMax); y += yStep) {
      double yPos = (size.height - paddingY) - ((y - yMin) * yRatio);
      canvas.drawLine(Offset(paddingX, yPos), Offset(size.width, yPos), gridLinePaint);

      TextSpan span = TextSpan(style: TextStyle(color: textColor, fontSize: textSize), text: y.floor().toString());
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(paddingX - tp.width - 5, yPos - tp.height / 2));
    }

    // sort values by x position
    List<double> xValues = values1.keys.toList();
    xValues.sort((a, b) => (a - b).floor());

    List<Offset> circles = [];

    final path = Path();
    for (int i = 0; i < xValues.length; i++) {
      if (i == 0) {
        if (xValues[0] == 0) {
          path.moveTo(paddingX, size.height - paddingY - ((values1[xValues[0]] ?? 0) - yMin) * yRatio);
          // circles.add(Offset(paddingX, size.height - paddingY - ((values[xValues[0]] ?? 0) - yMin) * yRatio));
        } else {
          path.moveTo(paddingX, size.height - paddingY - yMin);
          // circles.add(Offset(paddingX, size.height - paddingY - yMin));
        }
      } else {
        final yPrevious = size.height - paddingY - ((values1[xValues[i - 1]] ?? 0) - yMin) * yRatio;
        final xPrevious = xValues[i - 1] * xRatio + paddingX;
        final controlPointX = xPrevious + (xValues[i] * xRatio + paddingX - xPrevious) / 2;

        final yValue = size.height - paddingY - ((values1[xValues[i]] ?? 0) - yMin) * yRatio;

        path.cubicTo(controlPointX, yPrevious, controlPointX, yValue, xValues[i] * xRatio + paddingX, yValue);

        circles.add(Offset(xValues[i] * xRatio + paddingX, yValue));
      }
    }
    canvas.drawPath(path, paint);

    List<double> xValues2 = values2.keys.toList();
    xValues2.sort((a, b) => (a - b).floor());

    List<Offset> circles2 = [];

    final path2 = Path();

    for (int i = 0; i < xValues2.length; i++) {
      if (i == 0) {
        if (xValues2[0] == 0) {
          path2.moveTo(paddingX, size.height - paddingY - ((values2[xValues2[0]] ?? 0) - yMin) * yRatio);
          // circles.add(Offset(paddingX, size.height - paddingY - ((values[xValues[0]] ?? 0) - yMin) * yRatio));
        } else {
          path2.moveTo(paddingX, size.height - paddingY - yMin);
          // circles.add(Offset(paddingX, size.height - paddingY - yMin));
        }
      } else {
        final yPrevious = size.height - paddingY - ((values2[xValues2[i - 1]] ?? 0) - yMin) * yRatio;
        final xPrevious = xValues2[i - 1] * xRatio + paddingX;
        final controlPointX = xPrevious + (xValues2[i] * xRatio + paddingX - xPrevious) / 2;

        final yValue = size.height - paddingY - ((values2[xValues2[i]] ?? 0) - yMin) * yRatio;

        path2.cubicTo(controlPointX, yPrevious, controlPointX, yValue, xValues2[i] * xRatio + paddingX, yValue);

        circles2.add(Offset(xValues2[i] * xRatio + paddingX, yValue));
      }
    }
    canvas.drawPath(path2, paint2);

    if (drawCircles) {
      final circleFillPaint = Paint()
        ..color = circleFillColor1
        ..style = PaintingStyle.fill
        ..strokeWidth = strokeWidth;

      final circleStrokePaint = Paint()
        ..color = circleStrokeColor1
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      for (var offset in circles) {
        canvas.drawCircle(offset, circleRadius, circleFillPaint);
        canvas.drawCircle(offset, circleRadius, circleStrokePaint);
      }
    }

    if (drawCircles) {
      final circleFillPaint = Paint()
        ..color = circleFillColor2
        ..style = PaintingStyle.fill
        ..strokeWidth = strokeWidth;

      final circleStrokePaint = Paint()
        ..color = circleStrokeColor2
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      for (var offset in circles2) {
        canvas.drawCircle(offset, circleRadius, circleFillPaint);
        canvas.drawCircle(offset, circleRadius, circleStrokePaint);
      }
    }

    Path fillPath = Path()..addPath(path, Offset.zero);
    fillPath.relativeLineTo(strokeWidth / 2, 0.0);
    fillPath.lineTo(size.width, size.height - paddingY);
    fillPath.lineTo(size.width + strokeWidth / 2, size.height - paddingY);
    fillPath.lineTo(paddingX, size.height - paddingY);
    fillPath.close();

    Paint fillPaint = Paint()
      ..strokeWidth = 0.0
      ..color = fillColor1.withOpacity(fillOpactiy)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    if (verticalLineEnabled) {
      final verticalLinePaint = Paint()
        ..color = verticalLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = verticalLineStrokeWidth;

      canvas.drawLine(Offset(verticalLinePosition * xRatio + paddingX, 0), Offset(verticalLinePosition * xRatio + paddingX, size.height - paddingY),
          verticalLinePaint);

      if (verticalLineText != null) {
        TextSpan span = TextSpan(
          style: TextStyle(color: verticalLineColor, fontSize: textSize),
          text: verticalLineText,
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        double x = verticalLinePosition * xRatio + paddingX + 5;
        if (x + tp.width > size.width) {
          x = verticalLinePosition * xRatio + paddingX - tp.width - 5;
        }
        tp.paint(canvas, Offset(x, 5));
      }
    }

    Path fillPath2 = Path()..addPath(path2, Offset.zero);
    fillPath2.relativeLineTo(strokeWidth / 2, 0.0);
    fillPath2.lineTo(size.width, size.height - paddingY);
    fillPath2.lineTo(size.width + strokeWidth / 2, size.height - paddingY);
    fillPath2.lineTo(paddingX, size.height - paddingY);
    fillPath2.close();

    Paint fillPaint2 = Paint()
      ..strokeWidth = 0.0
      ..color = fillColor2.withOpacity(fillOpactiy)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath2, fillPaint2);

    if (verticalLineEnabled) {
      final verticalLinePaint = Paint()
        ..color = verticalLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = verticalLineStrokeWidth;

      canvas.drawLine(Offset(verticalLinePosition * xRatio + paddingX, 0), Offset(verticalLinePosition * xRatio + paddingX, size.height - paddingY),
          verticalLinePaint);

      if (verticalLineText != null) {
        TextSpan span = TextSpan(
          style: TextStyle(color: verticalLineColor, fontSize: textSize),
          text: verticalLineText,
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        double x = verticalLinePosition * xRatio + paddingX + 5;
        if (x + tp.width > size.width) {
          x = verticalLinePosition * xRatio + paddingX - tp.width - 5;
        }
        tp.paint(canvas, Offset(x, 5));
      }
    }

    TextSpan span = TextSpan(
      style: TextStyle(color: lineColor1, fontSize: textSize),
      text: legend1,
    );
    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    tp.paint(canvas, Offset(tp.width, size.height));
    TextSpan span2 = TextSpan(
      style: TextStyle(color: lineColor2, fontSize: textSize),
      text: legend2,
    );

    TextPainter tp2 = TextPainter(
      text: span2,
      textDirection: TextDirection.ltr,
    );

    tp2.layout();
    tp2.paint(canvas, Offset(size.width - 1.5 * tp.width, size.height));
  }

  @override
  bool shouldRepaint(_SplineChartPainter old) {
    return old.lineColor1 != lineColor1 ||
        old.lineColor2 != lineColor2 ||
        old.gridLineColor != gridLineColor ||
        old.textColor != textColor ||
        old.textSize != textSize ||
        old.fillColor1 != fillColor1 ||
        old.fillColor2 != fillColor2 ||
        old.fillOpactiy != fillOpactiy ||
        old.values1 != values1 ||
        old.values2 != values2 ||
        old.xStart != xStart ||
        old.xEnd != xEnd ||
        old.xStep != xStep ||
        old.strokeWidth != strokeWidth ||
        old.verticalLineEnabled != verticalLineEnabled ||
        old.verticalLinePosition != verticalLinePosition ||
        old.verticalLineStrokeWidth != verticalLineStrokeWidth ||
        old.verticalLineColor != verticalLineColor ||
        old.verticalLineText != verticalLineText ||
        old.drawCircles != drawCircles ||
        old.circleRadius != circleRadius ||
        old.circleFillColor1 != circleFillColor1 ||
        old.circleFillColor2 != circleFillColor2 ||
        old.circleStrokeColor1 != circleStrokeColor1 ||
        old.circleStrokeColor2 != circleStrokeColor2;
  }
}
