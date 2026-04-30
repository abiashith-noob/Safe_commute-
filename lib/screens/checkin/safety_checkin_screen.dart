import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../providers/checkin_provider.dart';

class SafetyCheckinScreen extends StatelessWidget {
  const SafetyCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Check-In',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CheckInProvider>(
        builder: (context, checkIn, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                _buildStatusCard(checkIn).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 28),

                // Interval Selector
                Text('Check-In Interval',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildIntervalChip(context, checkIn, '15 min',
                        const Duration(minutes: 15)),
                    const SizedBox(width: 8),
                    _buildIntervalChip(context, checkIn, '30 min',
                        const Duration(minutes: 30)),
                    const SizedBox(width: 8),
                    _buildIntervalChip(
                        context, checkIn, '1 hr', const Duration(hours: 1)),
                    const SizedBox(width: 8),
                    _buildIntervalChip(
                        context, checkIn, '2 hr', const Duration(hours: 2)),
                  ],
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 28),

                // Active Check-In Info
                if (checkIn.status == CheckInStatus.active) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.safeLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.safe.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: AppColors.safe, size: 40),
                        const SizedBox(height: 12),
                        Text('Check-In Active',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.safe)),
                        const SizedBox(height: 4),
                        Text(
                            'Next check-in: every ${checkIn.intervalLabel}',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],

                // Pending Check-In
                if (checkIn.status == CheckInStatus.pending) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.moderate.withValues(alpha: 0.1),
                          AppColors.moderate.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.moderate.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.notification_important_rounded,
                                color: AppColors.moderate, size: 48)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 600.ms),
                        const SizedBox(height: 12),
                        Text('Are you safe?',
                            style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.moderate)),
                        const SizedBox(height: 8),
                        Text(
                            'Please confirm you are safe. Your guardians will\nbe alerted if you don\'t respond.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => checkIn.confirmSafe(),
                            icon: const Icon(Icons.check_circle_rounded),
                            label: const Text("I'm Safe"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.safe),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().shake(hz: 2, duration: 500.ms),
                ],

                // Missed Check-In
                if (checkIn.status == CheckInStatus.missed) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.riskyLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.risky.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.warning_rounded,
                            color: AppColors.risky, size: 48),
                        const SizedBox(height: 12),
                        Text('Check-In Missed!',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.risky)),
                        const SizedBox(height: 8),
                        Text(
                            'Your guardians have been notified.\nMissed ${checkIn.missedCount} check-in(s)',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => checkIn.confirmSafe(),
                            icon: const Icon(Icons.check_circle_rounded),
                            label: const Text("I'm Safe Now"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.safe),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                ],
                const SizedBox(height: 28),

                // Action Buttons
                if (checkIn.status == CheckInStatus.inactive) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => checkIn.startCheckIn(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start Check-In'),
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => checkIn.stopCheckIn(),
                      icon: const Icon(Icons.stop_rounded),
                      label: const Text('Stop Check-In'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.risky,
                          side: const BorderSide(color: AppColors.risky)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Demo trigger button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton.icon(
                      onPressed: () => checkIn.triggerCheckInNow(),
                      icon: const Icon(Icons.flash_on, size: 18),
                      label: Text('Trigger Check-In Now (Demo)',
                          style: GoogleFonts.inter(fontSize: 13)),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(CheckInProvider checkIn) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (checkIn.status) {
      case CheckInStatus.inactive:
        statusColor = AppColors.textHint;
        statusText = 'Inactive';
        statusIcon = Icons.pause_circle_outline;
      case CheckInStatus.active:
        statusColor = AppColors.safe;
        statusText = 'Active';
        statusIcon = Icons.check_circle_outline;
      case CheckInStatus.pending:
        statusColor = AppColors.moderate;
        statusText = 'Pending Response';
        statusIcon = Icons.notification_important_outlined;
      case CheckInStatus.missed:
        statusColor = AppColors.risky;
        statusText = 'Missed';
        statusIcon = Icons.error_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Check-In Status',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textHint)),
              const SizedBox(height: 4),
              Text(statusText,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalChip(BuildContext context, CheckInProvider checkIn,
      String label, Duration duration) {
    final isSelected = checkIn.interval == duration;
    return Expanded(
      child: GestureDetector(
        onTap: () => checkIn.setInterval(duration),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
            ),
            boxShadow: isSelected ? AppShadows.card : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
