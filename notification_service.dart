/// Mock notification service.
/// In production, use flutter_local_notifications.
class NotificationService {
  bool _initialized = false;

  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Mock: just print for now
    // In production, use flutter_local_notifications
  }

  Future<void> scheduleCheckIn({
    required Duration interval,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> cancelAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
