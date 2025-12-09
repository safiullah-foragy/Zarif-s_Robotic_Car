import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CarController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isManualMode = false;
  bool _isConnected = false;
  Timer? _commandTimer;
  Timer? _statusTimer;
  String _currentCommand = 'STOP';
  bool _isSendingCommand = false;
  int _remainingTime = 300; // 5 minutes in seconds

  bool get isManualMode => _isManualMode;
  bool get isConnected => _isConnected;
  String get currentCommand => _currentCommand;
  int get remainingTime => _remainingTime;

  CarController() {
    _startStatusPolling();
  }

  void _startStatusPolling() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final status = await _apiService.getStatus();
      if (status != null) {
        _isConnected = status['connected'] ?? false;
        
        // Sync mode with ESP8266
        final serverMode = status['mode'] ?? 'AUTO';
        _isManualMode = (serverMode == 'MANUAL');
        
        // Update remaining time from server
        if (_isManualMode) {
          _remainingTime = status['timeout'] ?? 300;
        } else {
          _remainingTime = 300;
        }
        
        notifyListeners();
      } else {
        _isConnected = false;
        notifyListeners();
      }
    });
  }

  Future<void> switchToManualMode() async {
    try {
      final success = await _apiService.setMode('MANUAL');
      if (success) {
        _isManualMode = true;
        _remainingTime = 300; // Reset timer
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error switching to manual mode: $e');
    }
  }

  Future<void> switchToAutoMode() async {
    try {
      final success = await _apiService.setMode('AUTO');
      if (success) {
        _isManualMode = false;
        _stopContinuousCommand();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error switching to auto mode: $e');
    }
  }

  void startContinuousCommand(String command) {
    _currentCommand = command;
    _isSendingCommand = true;
    
    // Send command immediately
    _sendCommand(command);
    
    // Then send every 50ms
    _commandTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isSendingCommand && _isManualMode) {
        _sendCommand(_currentCommand);
      }
    });
  }

  void stopContinuousCommand() {
    _stopContinuousCommand();
  }

  void _stopContinuousCommand() {
    _isSendingCommand = false;
    _commandTimer?.cancel();
    _commandTimer = null;
    _sendCommand('STOP');
    _currentCommand = 'STOP';
  }

  Future<void> _sendCommand(String command) async {
    try {
      await _apiService.sendCommand(command);
    } catch (e) {
      debugPrint('Error sending command: $e');
    }
  }

  @override
  void dispose() {
    _commandTimer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }
}
