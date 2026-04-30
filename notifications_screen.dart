import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Push Notification Toggles ──
  bool _pushEnabled = true;
  bool _sosNotifications = true;
  bool _guardianAlerts = true;
  bool _zoneWarnings = true;
  bool _incidentReports = true;
  bool _checkinReminders = false;
  bool _tripUpdates = true;
  bool _communityAlerts = false;

  // ── Sound & Vibration ──
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedTone = 'Default';

  // ── Quiet Hours ──
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool _hasChanges = false;
  bool _isSaving = false;

  // Mock recent notifications
  final List<Map<String, dynamic>> _recentNotifications = [
    {
      'icon': Icons.warning_amber_rounded,
      'color': const Color(0xFFFF9800),
      'title': 'Zone Alert',
      'body': 'You are entering a moderate-risk area near Market Square.',
      'time': '5 min ago',
      'read': false,
    },
    {
      'icon': Icons.shield_rounded,
      'color': const Color(0xFF4CAF50),
      'title': 'Safety Check-in',
      'body': 'Your guardian Mom was notified of your safe arrival.',
      'time': '23 min ago',
      'read': false,
    },
    {
      'icon': Icons.report_problem_outlined,
      'color': const Color(0xFFF44336),
      'title': 'Incident Nearby',
      'body': 'A suspicious activity was reported 400m from your location.',
      'time': '1h ago',
      'read': true,
    },
    {
      'icon': Icons.route_rounded,
      'color': const Color(0xFF2196F3),
      'title': 'Route Update',
      'body': 'Your saved route "Home → Office" has a new safety score: 8.5',
      'time': '3h ago',
      'read': true,
    },
    {
      'icon': Icons.people_rounded,
      'color': const Color(0xFF9C27B0),
      'title': 'Guardian Request',
      'body': 'Brother – Arun accepted your guardian invitation.',
      'time': 'Yesterday',
      'read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Notification settings saved',
                style: GoogleFonts.inter()),
          ],
        ),
        backgroundColor: AppColors.safe,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _quietStart : _quietEnd;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietStart = picked;
        } else {
          _quietEnd = picked;
        }
      });
      _markChanged();
    }
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : _saveSettings,
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Save',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecentTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  RECENT NOTIFICATIONS TAB
  // ═══════════════════════════════════════════
  Widget _buildRecentTab() {
    if (_recentNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off_outlined,
                size: 64, color: AppColors.textHint.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('No notifications yet',
                style: GoogleFonts.inter(
                    fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text('Your alerts will appear here',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textHint)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _recentNotifications.length + 1, // +1 for clear button
      itemBuilder: (context, index) {
        if (index == _recentNotifications.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() => _recentNotifications.clear());
                },
                icon: const Icon(Icons.clear_all_rounded, size: 18),
                label: Text('Clear All',
                    style: GoogleFonts.inter(fontSize: 13)),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textHint,
                ),
              ),
            ),
          );
        }

        final notif = _recentNotifications[index];
        final isUnread = notif['read'] == false;

        return GestureDetector(
          onTap: () {
            setState(() {
              _recentNotifications[index]['read'] = true;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUnread
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: isUnread
                  ? Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (notif['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(notif['icon'] as IconData,
                      color: notif['color'] as Color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['body'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['time'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 80));
      },
    );
  }

  // ═══════════════════════════════════════════
  //  SETTINGS TAB
  // ═══════════════════════════════════════════
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Master Toggle ──
          _buildMasterToggle().animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),

          // ── Notification Types ──
          _buildSectionHeader(
            Icons.tune_rounded,
            'Notification Types',
            'Choose which notifications you receive',
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 14),
          _buildToggleTile(
            icon: Icons.emergency_rounded,
            title: 'SOS Notifications',
            subtitle: 'Critical emergency alerts',
            value: _sosNotifications,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _sosNotifications = v);
                    _markChanged();
                  }
                : null,
            accentColor: AppColors.risky,
            delay: 150,
          ),
          _buildToggleTile(
            icon: Icons.people_rounded,
            title: 'Guardian Alerts',
            subtitle: 'Updates from your guardian circle',
            value: _guardianAlerts,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _guardianAlerts = v);
                    _markChanged();
                  }
                : null,
            accentColor: const Color(0xFF9C27B0),
            delay: 200,
          ),
          _buildToggleTile(
            icon: Icons.warning_amber_rounded,
            title: 'Zone Warnings',
            subtitle: 'Alerts when entering risky areas',
            value: _zoneWarnings,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _zoneWarnings = v);
                    _markChanged();
                  }
                : null,
            accentColor: AppColors.moderate,
            delay: 250,
          ),
          _buildToggleTile(
            icon: Icons.report_problem_outlined,
            title: 'Incident Reports',
            subtitle: 'Community-reported incidents nearby',
            value: _incidentReports,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _incidentReports = v);
                    _markChanged();
                  }
                : null,
            delay: 300,
          ),
          _buildToggleTile(
            icon: Icons.timer_outlined,
            title: 'Check-in Reminders',
            subtitle: 'Periodic safety check-in prompts',
            value: _checkinReminders,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _checkinReminders = v);
                    _markChanged();
                  }
                : null,
            delay: 350,
          ),
          _buildToggleTile(
            icon: Icons.route_rounded,
            title: 'Trip Updates',
            subtitle: 'Route safety score changes',
            value: _tripUpdates,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _tripUpdates = v);
                    _markChanged();
                  }
                : null,
            delay: 400,
          ),
          _buildToggleTile(
            icon: Icons.groups_rounded,
            title: 'Community Alerts',
            subtitle: 'General community safety updates',
            value: _communityAlerts,
            onChanged: _pushEnabled
                ? (v) {
                    setState(() => _communityAlerts = v);
                    _markChanged();
                  }
                : null,
            delay: 450,
          ),
          const SizedBox(height: 28),

          // ── Sound & Vibration ──
          _buildSectionHeader(
            Icons.volume_up_rounded,
            'Sound & Vibration',
            'Customize alert feedback',
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 14),
          _buildToggleTile(
            icon: Icons.music_note_rounded,
            title: 'Alert Sound',
            subtitle: _selectedTone,
            value: _soundEnabled,
            onChanged: (v) {
              setState(() => _soundEnabled = v);
              _markChanged();
            },
            delay: 550,
          ),
          _buildToggleTile(
            icon: Icons.vibration_rounded,
            title: 'Vibration',
            subtitle: 'Haptic feedback for alerts',
            value: _vibrationEnabled,
            onChanged: (v) {
              setState(() => _vibrationEnabled = v);
              _markChanged();
            },
            delay: 600,
          ),

          // ── Alert Tone Selector ──
          if (_soundEnabled) ...[
            const SizedBox(height: 12),
            _buildToneSelector().animate().fadeIn(delay: 650.ms),
          ],

          const SizedBox(height: 28),

          // ── Quiet Hours ──
          _buildSectionHeader(
            Icons.bedtime_rounded,
            'Quiet Hours',
            'Mute non-critical alerts during these hours',
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 14),
          _buildToggleTile(
            icon: Icons.do_not_disturb_on_rounded,
            title: 'Enable Quiet Hours',
            subtitle:
                '${_formatTime(_quietStart)} – ${_formatTime(_quietEnd)}',
            value: _quietHoursEnabled,
            onChanged: (v) {
              setState(() => _quietHoursEnabled = v);
              _markChanged();
            },
            delay: 750,
          ),
          if (_quietHoursEnabled) ...[
            const SizedBox(height: 10),
            _buildQuietHoursPicker().animate().fadeIn(delay: 800.ms),
          ],

          const SizedBox(height: 36),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                _isSaving ? 'Saving...' : 'Save Settings',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 850.ms),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Master Toggle ──
  Widget _buildMasterToggle() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _pushEnabled
            ? AppColors.primaryGradient
            : const LinearGradient(colors: [
                Color(0xFFE0E0E0),
                Color(0xFFBDBDBD),
              ]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (_pushEnabled ? AppColors.primary : Colors.grey)
                .withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _pushEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Push Notifications',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _pushEnabled
                      ? 'All notifications are active'
                      : 'All notifications are paused',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _pushEnabled,
            onChanged: (v) {
              setState(() => _pushEnabled = v);
              _markChanged();
            },
            activeTrackColor: Colors.white.withValues(alpha: 0.4),
            activeColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              Text(subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textHint)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Toggle Tile ──
  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? accentColor,
    int delay = 0,
  }) {
    final color = accentColor ?? AppColors.primary;
    final disabled = onChanged == null;

    return Opacity(
      opacity: disabled ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: color,
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)),
    );
  }

  // ── Tone Selector ──
  Widget _buildToneSelector() {
    final tones = ['Default', 'Chime', 'Urgent', 'Gentle'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alert Tone',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: tones.map((tone) {
              final isSelected = _selectedTone == tone;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTone = tone);
                    _markChanged();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        tone,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Quiet Hours Picker ──
  Widget _buildQuietHoursPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _pickTime(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text('Start',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textHint)),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(_quietStart),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward_rounded,
                color: AppColors.textHint, size: 20),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickTime(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text('End',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textHint)),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(_quietEnd),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
