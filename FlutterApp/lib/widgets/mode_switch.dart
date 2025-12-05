import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_controller.dart';

class ModeSwitch extends StatelessWidget {
  const ModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarController>(
      builder: (context, controller, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1a1f3a).withOpacity(0.9),
                Color(0xFF2a2f4a).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: controller.isManualMode ? Color(0xFFff4081) : Color(0xFF00ff9d),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (controller.isManualMode ? Color(0xFFff4081) : Color(0xFF00ff9d)).withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.isManualMode ? '🎮 MANUAL' : '🤖 AUTO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 16),
              Switch(
                value: controller.isManualMode,
                onChanged: (value) {
                  if (value) {
                    controller.switchToManualMode();
                  } else {
                    controller.switchToAutoMode();
                  }
                },
                activeColor: Color(0xFFff4081),
                activeTrackColor: Color(0xFFff4081).withOpacity(0.5),
                inactiveThumbColor: Color(0xFF00ff9d),
                inactiveTrackColor: Color(0xFF00ff9d).withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
