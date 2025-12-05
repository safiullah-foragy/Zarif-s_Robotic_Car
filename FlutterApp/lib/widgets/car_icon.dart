import 'package:flutter/material.dart';
import 'dart:math' as math;

class CarIcon extends StatefulWidget {
  const CarIcon({super.key});

  @override
  State<CarIcon> createState() => _CarIconState();
}

class _CarIconState extends State<CarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: const Size(120, 120),
            painter: CarPainter(),
          ),
        );
      },
    );
  }
}

class CarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Car body
    paint.color = Colors.deepOrange;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(25, 50, 70, 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(bodyRect, paint);

    // Car roof
    paint.color = Colors.deepOrange.shade800;
    final roofPath = Path()
      ..moveTo(40, 50)
      ..lineTo(45, 35)
      ..lineTo(75, 35)
      ..lineTo(80, 50)
      ..close();
    canvas.drawPath(roofPath, paint);

    // Windows
    paint.color = Colors.lightBlue.shade200;
    canvas.drawRect(const Rect.fromLTWH(47, 38, 10, 10), paint);
    canvas.drawRect(const Rect.fromLTWH(63, 38, 10, 10), paint);

    // Wheels
    paint.color = Colors.black87;
    canvas.drawCircle(const Offset(35, 70), 8, paint);
    canvas.drawCircle(const Offset(85, 70), 8, paint);

    // Wheel hubs
    paint.color = Colors.grey;
    canvas.drawCircle(const Offset(35, 70), 4, paint);
    canvas.drawCircle(const Offset(85, 70), 4, paint);

    // Front light
    paint.color = Colors.yellowAccent;
    canvas.drawCircle(const Offset(92, 55), 3, paint);

    // Rear light
    paint.color = Colors.red;
    canvas.drawCircle(const Offset(28, 55), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
