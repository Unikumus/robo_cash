import 'package:flutter/material.dart';
import 'package:simple_robo_cash/core/settings.dart';

import '../data/depth_datasource.dart';

class BarCustomPainter extends CustomPainter {
  const BarCustomPainter({
    required this.data,
    required this.animationValue,
  });

  final List<DepthEntry> data;

  final double animationValue;

  static const barHeight = 40.0;
  static const decoratedWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    /// X HORIZONTAL
    drawHorizontalLines(canvas, Size(size.width, size.height));

    /// Y VERTICAL
    drawVerticalLines(canvas, size, size.width / 10);

    drawHeader(canvas, size);

    /// BARS
    drawBars(canvas, size);
  }

  void drawHeader(Canvas canvas, Size size) {
    Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawRect(
      Offset.zero & Size(size.width, barHeight * 2 - 1),
      paint2..color = surface,
    );
  }

  void drawBars(Canvas canvas, Size size) {
    const separatorHeight = barHeight / 4;
    const startPoint = barHeight * 3;
    final maxBarWidth = size.width - 10;

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final BorderRadius borderRadius = BorderRadius.circular(15);

    var startY = 0.0 + startPoint;

    for (var i = 0; i < data.length; i++) {
      var bar = data[i];

      Offset barOffset = Offset(
        0,
        (barHeight * i) + startY,
      );

      Size barSize = Size(
        maxBarWidth * bar.volume + decoratedWidth / 2,
        barHeight,
      );

      Offset decorationOffset = Offset(
        maxBarWidth * bar.volume,
        (barHeight * i) + startY,
      );

      Size decorationSize = const Size(decoratedWidth, barHeight);

      /// main bar
      canvas.drawRect(
        barOffset & barSize,
        paint
          ..color = bar.type == DepthEntryType.ask
              ? askColor.withOpacity(0.2 + (animationValue * 0.5))
              : bidColor.withOpacity(0.2 + (animationValue * 0.5)),
      );

      /// bar decoration
      final RRect borderRect = borderRadius.toRRect(decorationOffset & decorationSize);

      canvas.drawRRect(
        borderRect,
        paint..color = bar.type == DepthEntryType.ask ? askColor : bidColor,
      );

      /// text
      const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: bar.price.toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: 100,
      );
      final xCenter = barOffset.dx - (textPainter.width) / 2 + 20;
      final yCenter = barOffset.dy - (textPainter.height) / 2 + barHeight / 2 - 2;
      final offset2 = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset2);

      startY += separatorHeight;
    }
  }

  void drawHorizontalLines(Canvas canvas, Size size) {
    var startY = 0.0;

    var gapY = barHeight / 4;

    int totalLines = (size.height / gapY).round();

    for (var i = 0; i <= totalLines; i++) {
      var point1 = Offset(0, startY + gapY * i);
      var point2 = Offset(size.width + 0, startY + gapY * i);

      canvas.drawLine(point1, point2, Paint()..color = chartLineH);
    }
  }

  void drawVerticalLines(Canvas canvas, Size size, double sectorSize) {
    int totalLines = 10;

    var startY = 0.0;
    var gapX = sectorSize;

    var startX = 0;

    for (var i = 0; i < totalLines + 1; i++) {
      var point1 = Offset(gapX * i + startX, startY);
      var point2 = Offset(gapX * i + startX, size.height);
      canvas.drawLine(point1, point2, Paint()..color = chartLineV);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
