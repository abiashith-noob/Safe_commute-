import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class SafetyPreferencesScreen extends StatefulWidget {
  const SafetyPreferencesScreen({super.key});

  @override
  State<SafetyPreferencesScreen> createState() =>
      _SafetyPreferencesScreenState();
}

class _SafetyPreferencesScreenState extends State<SafetyPreferencesScreen> {
  // Location & Tracking
  late bool _locationTracking;
  bool _backgroundTracking = true;
  bool _shareLocationWithGuardians = true;

  // Alerts & Notifications
  bool _sosAlerts = true;
  bool _zoneAlerts = true;
  bool _incidentAlerts = true;
  bool _checkinReminders = false;

  // Safety Thresholds
  double _dangerZoneRadius = 500; // meters
  int _checkinIntervalMinutes = 30;
  String _selectedSafetyLevel = 'Moderate';

  // Auto-Features
  bool _autoSosOnShake = false;
  bool _autoShareOnSos = true;
  bool _nightModeAutoEnable = true;

  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _locationTracking = user?.locationTrackingEnabled ?? false;
    
    if (user?.safetyPreferences != null) {
      final prefs = user!.safetyPreferences!;
      _backgroundTracking = prefs['backgroundTracking'] ?? true;
      _shareLocationWithGuardians = prefs['shareLocationWithGuardians'] ?? true;
      _sosAlerts = prefs['sosAlerts'] ?? true;
      _zoneAlerts = prefs['zoneAlerts'] ?? true;
      _incidentAlerts = prefs['incidentAlerts'] ?? true;
      _checkinReminders = prefs['checkinReminders'] ?? false;
      _dangerZoneRadius = (prefs['dangerZoneRadius'] ?? 500).toDouble();
      _checkinIntervalMinutes = prefs['checkinIntervalMinutes'] ?? 30;
      _selectedSafetyLevel = prefs['selectedSafetyLevel'] ?? 'Moderate';
      _autoSosOnShake = prefs['autoSosOnShake'] ?? false;
      _autoShareOnSos = prefs['autoShareOnSos'] ?? true;
      _nightModeAutoEnable = prefs['nightModeAutoEnable'] ?? true;
    }
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Update the location tracking and all preferences in the user model
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      authProvider.updateUser(
        authProvider.user!.copyWith(
          locationTrackingEnabled: _locationTracking,
          safetyPreferences: {
            'backgroundTracking': _backgroundTracking,
            'shareLocationWithGuardians': _shareLocationWithGuardians,
            'sosAlerts': _sosAlerts,
            'zoneAlerts': _zoneAlerts,
            'incidentAlerts': _incidentAlerts,
            'checkinReminders': _checkinReminders,
            'dangerZoneRadius': _dangerZoneRadius,
            'checkinIntervalMinutes': _checkinIntervalMinutes,
            'selectedSafetyLevel': _selectedSafetyLevel,
            'autoSosOnShake': _autoSosOnShake,
            'autoShareOnSos': _autoShareOnSos,
            'nightModeAutoEnable': _nightModeAutoEnable,
          },
        ),
      );
    }

    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Preferences saved successfully',
                style: GoogleFonts.inter()),
          ],
        ),
        backgroundColor: AppColors.safe,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Preferences',
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
              onPressed: _isSaving ? null : _savePreferences,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Safety Level Selector ──
              _buildSectionHeader(
                Icons.shield_rounded,
                'Safety Level',
                'Set your overall safety sensitivity',
                0,
              ),
              const SizedBox(height: 14),
              _buildSafetyLevelSelector().animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 28),

              // ── Location & Tracking ──
              _buildSectionHeader(
                Icons.location_on_rounded,
                'Location & Tracking',
                'Control how your location is used',
                200,
              ),
              const SizedBox(height: 14),
              _buildToggleTile(
                icon: Icons.my_location_rounded,
                title: 'Location Tracking',
                subtitle: 'Enable real-time location monitoring',
                value: _locationTracking,
                onChanged: (v) {
                  setState(() => _locationTracking = v);
                  _markChanged();
                },
                delay: 250,
              ),
              _buildToggleTile(
                icon: Icons.play_circle_outline_rounded,
                title: 'Background Tracking',
                subtitle: 'Continue tracking when app is minimized',
                value: _backgroundTracking,
                onChanged: (v) {
                  setState(() => _backgroundTracking = v);
                  _markChanged();
                },
                delay: 300,
              ),
              _buildToggleTile(
                icon: Icons.share_location_rounded,
                title: 'Share with Guardians',
                subtitle: 'Let guardians see your live location',
                value: _shareLocationWithGuardians,
                onChanged: (v) {
                  setState(() => _shareLocationWithGuardians = v);
                  _markChanged();
                },
                delay: 350,
              ),
              const SizedBox(height: 28),

              // ── Alerts & Notifications ──
              _buildSectionHeader(
                Icons.notifications_active_rounded,
                'Alerts & Notifications',
                'Choose what alerts you receive',
                400,
              ),
              const SizedBox(height: 14),
              _buildToggleTile(
                icon: Icons.emergency_rounded,
                title: 'SOS Alerts',
                subtitle: 'Receive alerts for SOS activations',
                value: _sosAlerts,
                onChanged: (v) {
                  setState(() => _sosAlerts = v);
                  _markChanged();
                },
                accentColor: AppColors.risky,
                delay: 450,
              ),
              _buildToggleTile(
                icon: Icons.warning_amber_rounded,
                title: 'Zone Alerts',
                subtitle: 'Notify when entering risky zones',
                value: _zoneAlerts,
                onChanged: (v) {
                  setState(() => _zoneAlerts = v);
                  _markChanged();
                },
                accentColor: AppColors.moderate,
                delay: 500,
              ),
              _buildToggleTile(
                icon: Icons.report_problem_outlined,
                title: 'Incident Alerts',
                subtitle: 'Get notified about nearby incidents',
                value: _incidentAlerts,
                onChanged: (v) {
                  setState(() => _incidentAlerts = v);
                  _markChanged();
                },
                delay: 550,
              ),
              _buildToggleTile(
                icon: Icons.timer_outlined,
                title: 'Check-in Reminders',
                subtitle: 'Periodic safety check-in prompts',
                value: _checkinReminders,
                onChanged: (v) {
                  setState(() => _checkinReminders = v);
                  _markChanged();
                },
                delay: 600,
              ),
              const SizedBox(height: 28),

              // ── Danger Zone Radius ──
              _buildSectionHeader(
                Icons.radar_rounded,
                'Danger Zone Radius',
                'Alert radius around risky areas',
                650,
              ),
              const SizedBox(height: 14),
              _buildRadiusSlider().animate().fadeIn(delay: 700.ms),
              const SizedBox(height: 28),

              // ── Check-in Interval ──
              _buildSectionHeader(
                Icons.access_time_rounded,
                'Check-in Interval',
                'How often to prompt safety check-ins',
                750,
              ),
              const SizedBox(height: 14),
              _buildIntervalSelector().animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 28),

              // ── Auto Features ──
              _buildSectionHeader(
                Icons.auto_awesome_rounded,
                'Smart Safety',
                'Automatic safety features',
                850,
              ),
              const SizedBox(height: 14),
              _buildToggleTile(
                icon: Icons.vibration_rounded,
                title: 'Shake for SOS',
                subtitle: 'Shake device rapidly to trigger SOS',
                value: _autoSosOnShake,
                onChanged: (v) {
                  setState(() => _autoSosOnShake = v);
                  _markChanged();
                },
                accentColor: AppColors.risky,
                delay: 900,
              ),
              _buildToggleTile(
                icon: Icons.group_rounded,
                title: 'Auto-Share on SOS',
                subtitle: 'Automatically share location on SOS',
                value: _autoShareOnSos,
                onChanged: (v) {
                  setState(() => _autoShareOnSos = v);
                  _markChanged();
                },
                delay: 950,
              ),
              _buildToggleTile(
                icon: Icons.dark_mode_rounded,
                title: 'Night Mode Auto-Enable',
                subtitle: 'Heighten alerts after sunset',
                value: _nightModeAutoEnable,
                onChanged: (v) {
                  setState(() => _nightModeAutoEnable = v);
                  _markChanged();
                },
                delay: 1000,
              ),
              const SizedBox(height: 36),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _savePreferences,
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
                    _isSaving ? 'Saving...' : 'Save Preferences',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 1050.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(
      IconData icon, String title, String subtitle, int delayMs) {
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
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs));
  }

  // ── Toggle Tile ──
  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? accentColor,
    int delay = 0,
  }) {
    final color = accentColor ?? AppColors.primary;
    return Container(
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
    ).animate().fadeIn(delay: Duration(milliseconds: delay));
  }

  // ── Safety Level Selector ──
  Widget _buildSafetyLevelSelector() {
    final levels = [
      {
        'label': 'Relaxed',
        'icon': Icons.sentiment_satisfied_rounded,
        'color': AppColors.safe,
        'desc': 'Fewer alerts',
      },
      {
        'label': 'Moderate',
        'icon': Icons.sentiment_neutral_rounded,
        'color': AppColors.moderate,
        'desc': 'Balanced',
      },
      {
        'label': 'High',
        'icon': Icons.shield_rounded,
        'color': AppColors.risky,
        'desc': 'Maximum safety',
      },
    ];

    return Row(
      children: levels.map((level) {
        final isSelected = _selectedSafetyLevel == level['label'];
        final color = level['color'] as Color;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedSafetyLevel = level['label'] as String);
              _markChanged();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.12)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? color
                      : AppColors.divider,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(level['icon'] as IconData,
                      color: isSelected ? color : AppColors.textHint,
                      size: 28),
                  const SizedBox(height: 8),
                  Text(
                    level['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? color : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level['desc'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Radius Slider ──
  Widget _buildRadiusSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Radius',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textSecondary)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_dangerZoneRadius.round()} m',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              trackHeight: 4,
            ),
            child: Slider(
              min: 100,
              max: 2000,
              divisions: 19,
              value: _dangerZoneRadius,
              onChanged: (v) {
                setState(() => _dangerZoneRadius = v);
                _markChanged();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('100 m',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textHint)),
              Text('2000 m',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Check-in Interval Selector ──
  Widget _buildIntervalSelector() {
    final intervals = [10, 15, 30, 60];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: intervals.map((mins) {
          final isSelected = _checkinIntervalMinutes == mins;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _checkinIntervalMinutes = mins);
                _markChanged();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      '$mins',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'min',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
