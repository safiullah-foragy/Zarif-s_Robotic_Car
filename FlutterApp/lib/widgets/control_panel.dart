import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_controller.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarController>(
      builder: (context, controller, child) {
        if (!controller.isManualMode) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Forward Button
            ControlButton(
              label: '↑\nFORWARD',
              color: Color(0xFF00ff9d),
              onPressStart: () => controller.startContinuousCommand('FORWARD'),
              onPressEnd: () => controller.stopContinuousCommand(),
            ),
            
            const SizedBox(height: 20),
            
            // Left and Right Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ControlButton(
                  label: '←\nLEFT',
                  color: Color(0xFF00e5ff),
                  onPressStart: () => controller.startContinuousCommand('LEFT'),
                  onPressEnd: () => controller.stopContinuousCommand(),
                ),
                const SizedBox(width: 50),
                ControlButton(
                  label: '→\nRIGHT',
                  color: Color(0xFFffd000),
                  onPressStart: () => controller.startContinuousCommand('RIGHT'),
                  onPressEnd: () => controller.stopContinuousCommand(),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Backward Button
            ControlButton(
              label: '↓\nBACKWARD',
              color: Color(0xFFff4081),
              onPressStart: () => controller.startContinuousCommand('BACKWARD'),
              onPressEnd: () => controller.stopContinuousCommand(),
            ),
          ],
        );
      },
    );
  }
}

class ControlButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;

  const ControlButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressStart,
    required this.onPressEnd,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        widget.onPressStart();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressEnd();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        widget.onPressEnd();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isPressed 
              ? [Color.lerp(widget.color, Colors.black, 0.4)!, Color.lerp(widget.color, Colors.black, 0.5)!]
              : [widget.color, Color.lerp(widget.color, Colors.black, 0.2)!],
          ),
          shape: BoxShape.circle,
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
