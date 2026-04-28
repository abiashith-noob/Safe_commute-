import 'dart:async';
import 'package:flutter/material.dart';

enum SOSState { idle, countdown, active, completed }

class SOSProvider extends ChangeNotifier {
  SOSState _state = SOSState.idle;
  int _countdownSeconds = 3;
  Timer? _countdownTimer;
  bool _isRecording = false;
  List<String> _statusMessages = [];

  SOSState get state => _state;
  int get countdownSeconds => _countdownSeconds;
  bool get isRecording => _isRecording;
  List<String> get statusMessages => _statusMessages;

  void triggerSOS() {
    _state = SOSState.countdown;
    _countdownSeconds = 3;
    _statusMessages = [];
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownSeconds--;
      notifyListeners();

      if (_countdownSeconds <= 0) {
        timer.cancel();
        _activateSOS();
      }
    });
  }

  Future<void> _activateSOS() async {
    _state = SOSState.active;
    notifyListeners();

    // Simulate sending location
    _statusMessages.add('📍 Sending your location...');
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    _statusMessages.add('✅ Location sent to guardians');
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate alerting guardians
    _statusMessages.add('🔔 Alerting all guardians...');
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    _statusMessages.add('✅ 3 guardians notified');
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate audio recording
    _statusMessages.add('🎙️ Starting audio recording...');
    _isRecording = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    _statusMessages.add('✅ Audio recording active');
    notifyListeners();
  }

  void cancelSOS() {
    _countdownTimer?.cancel();
    _state = SOSState.idle;
    _countdownSeconds = 3;
    _isRecording = false;
    _statusMessages = [];
    notifyListeners();
  }

  void completeSOS() {
    _countdownTimer?.cancel();
    _state = SOSState.completed;
    _isRecording = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
