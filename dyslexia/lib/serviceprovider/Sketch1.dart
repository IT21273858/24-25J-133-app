import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';

class Drawing extends CustomPainter {
  final List<Offset?> points;
  Drawing(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    // paint.color = readingTitleColor;
    paint.color = Colors.white;
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Paint fillPaint = Paint();
    fillPaint.color = Colors.white; // Fill color
    fillPaint.style = PaintingStyle.fill; // Fill for shape

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Path path = Path();

    // bool started = false;
    // for (Offset? point in points) {
    //   if (point == null) {
    //     if (started) {
    //       path.close(); // Close the shape when stroke ends
    //       started = false;
    //     }
    //     continue;
    //   }
    //   if (!started) {
    //     path.moveTo(point.dx, point.dy);
    //     started = true;
    //   } else {
    //     path.lineTo(point.dx, point.dy);
    //   }
    // }

    // if (started) {
    //   path.close(); // Ensure the shape is closed
    // }

    // First, fill the shape
    // canvas.drawPath(path, fillPaint);

    // Then, draw the outline on top
    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
