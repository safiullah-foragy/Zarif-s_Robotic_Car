import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_controller.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarController>(
      builder: (context, controller, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1a1f3a).withOpacity(0.8),
                Color(0xFF2a2f4a).withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFF00e5ff).withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00e5ff).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Connection indicator
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: controller.isConnected ? Color(0xFF00ff9d) : Color(0xFFff3366),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: controller.isConnected ? Color(0xFF00ff9d).withOpacity(0.6) : Color(0xFFff3366).withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Status text
                  Text(
                    controller.isManualMode ? 'MANUAL MODE' : 'AUTO MODE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              
              // Timer display (only in manual mode)
              if (controller.isManualMode && controller.remainingTime > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Time: ${(controller.remainingTime ~/ 60)}:${(controller.remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
