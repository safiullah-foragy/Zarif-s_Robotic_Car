import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CarController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isManualMode = false;
  bool _isConnected = false;
  int _remainingTime = 0;
  Timer? _statusTimer;
  Timer? _commandTimer;
  String _currentCommand = 'STOP';
  bool _isSendingCommand = false;

  bool get isManualMode => _isManualMode;
  bool get isConnected => _isConnected;
  int get remainingTime => _remainingTime;
  String get currentCommand => _currentCommand;

  CarController() {
    _startStatusUpdates();
  }

  void _startStatusUpdates() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateStatus();
    });
  }

  Future<void> _updateStatus() async {
    try {
      final status = await _apiService.getStatus();
      
      if (status != null) {
        _isConnected = true;
        
        // Check if mode changed from server (timeout)
        if (status['mode'] == 'AUTO' && _isManualMode) {
          _isManualMode = false;
          _stopContinuousCommand();
          notifyListeners();
        }
        
        if (_isManualMode && status['timeout'] != null) {
          _remainingTime = status['timeout'] as int;
        } else {
          _remainingTime = 0;
        }
        
        notifyListeners();
      }
    } catch (e) {
      _isConnected = false;
      notifyListeners();
    }
  }

  Future<void> switchToManualMode() async {
    try {
      final success = await _apiService.setMode('MANUAL');
      if (success) {
        _isManualMode = true;
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

  String get formattedTime {
    final minutes = _remainingTime ~/ 60;
    final seconds = _remainingTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _commandTimer?.cancel();
    super.dispose();
  }
}
