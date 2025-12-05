import 'package:flutter/material.dart';

class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFF00e5ff),
                Color(0xFF00ff9d),
                Color(0xFFffd000),
              ],
            ).createShader(bounds),
            child: Text(
              "ZARIF'S CAR",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color(0xFF00e5ff).withOpacity(0.5),
                    offset: const Offset(0, 0),
                    blurRadius: 20,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.8),
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                  ),
                ],
                letterSpacing: 3,
              ),
            ),
          ),
        );
      },
    );
  }
}
