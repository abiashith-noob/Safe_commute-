import 'dart:async';
import 'package:flutter/material.dart';

enum CheckInStatus { inactive, active, pending, missed }

class CheckInProvider extends ChangeNotifier {
  CheckInStatus _status = CheckInStatus.inactive;
  Duration _interval = const Duration(minutes: 30);
  Timer? _checkInTimer;
  Timer? _responseTimer;
  DateTime? _nextCheckIn;
  int _missedCount = 0;

  CheckInStatus get status => _status;
  Duration get interval => _interval;
  DateTime? get nextCheckIn => _nextCheckIn;
  int get missedCount => _missedCount;

  String get intervalLabel {
    if (_interval.inMinutes < 60) {
      return '${_interval.inMinutes} min';
    }
    return '${_interval.inHours} hr';
  }

  void setInterval(Duration duration) {
    _interval = duration;
    notifyListeners();
  }

  void startCheckIn() {
    _status = CheckInStatus.active;
    _missedCount = 0;
    _scheduleNextCheckIn();
    notifyListeners();
  }

  void _scheduleNextCheckIn() {
    _checkInTimer?.cancel();
    _nextCheckIn = DateTime.now().add(_interval);

    _checkInTimer = Timer(_interval, () {
      _status = CheckInStatus.pending;
      notifyListeners();

      // Give 2 minutes to respond
      _responseTimer = Timer(const Duration(minutes: 2), () {
        _status = CheckInStatus.missed;
        _missedCount++;
        notifyListeners();
      });
    });
  }

  void confirmSafe() {
    _responseTimer?.cancel();
    _status = CheckInStatus.active;
    _scheduleNextCheckIn();
    notifyListeners();
  }

  void stopCheckIn() {
    _checkInTimer?.cancel();
    _responseTimer?.cancel();
    _status = CheckInStatus.inactive;
    _nextCheckIn = null;
    _missedCount = 0;
    notifyListeners();
  }

  // For demo: trigger pending state immediately
  void triggerCheckInNow() {
    _checkInTimer?.cancel();
    _status = CheckInStatus.pending;
    notifyListeners();

    _responseTimer = Timer(const Duration(seconds: 30), () {
      _status = CheckInStatus.missed;
      _missedCount++;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _checkInTimer?.cancel();
    _responseTimer?.cancel();
    super.dispose();
  }
}
