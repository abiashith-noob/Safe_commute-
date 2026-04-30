import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../providers/sos_provider.dart';
import '../../widgets/sos_button.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Emergency SOS',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SOSProvider>(
        builder: (context, sosProvider, _) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Countdown or SOS Button
                  if (sosProvider.state == SOSState.countdown)
                    _buildCountdown(context, sosProvider)
                  else if (sosProvider.state == SOSState.active ||
                      sosProvider.state == SOSState.completed)
                    _buildActiveState(context, sosProvider)
                  else
                    _buildIdleState(context, sosProvider),
                  const Spacer(flex: 1),
                  // Status messages
                  if (sosProvider.statusMessages.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sosProvider.statusMessages
                            .map((msg) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    msg,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: msg.startsWith('✅')
                                          ? AppColors.safe
                                          : Colors.white70,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ).animate().fadeIn(),
                  const Spacer(),
                  // Cancel button
                  if (sosProvider.state != SOSState.idle)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: Text('Cancel SOS?',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600)),
                              content: const Text(
                                  'Are you sure you want to cancel the emergency alert?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Keep Active'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    sosProvider.cancelSOS();
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Cancel SOS',
                                      style: TextStyle(color: AppColors.risky)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.close, color: Colors.white54),
                        label: Text('Cancel Emergency',
                            style: GoogleFonts.inter(
                                color: Colors.white54, fontSize: 14)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdleState(BuildContext context, SOSProvider provider) {
    return Column(
      children: [
        SOSButton(
          onPressed: () => provider.triggerSOS(),
        ),
        const SizedBox(height: 24),
        Text(
          'Tap to trigger emergency alert',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white54,
          ),
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 8),
        Text(
          'This will alert your guardians and share your location',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white24,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCountdown(BuildContext context, SOSProvider provider) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 4),
            boxShadow: AppShadows.sos,
          ),
          child: Center(
            child: Text(
              '${provider.countdownSeconds}',
              style: GoogleFonts.inter(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),
        ).animate().scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
            ),
        const SizedBox(height: 24),
        Text(
          'Sending SOS in...',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveState(BuildContext context, SOSProvider provider) {
    return Column(
      children: [
        SOSButton(
          onPressed: () {},
          isActive: true,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .fadeIn(duration: 500.ms)
                .then()
                .fadeOut(duration: 500.ms),
            const SizedBox(width: 8),
            Text(
              'Emergency Alert Active',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        if (provider.isRecording) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic, color: AppColors.accent, size: 18),
              const SizedBox(width: 6),
              Text(
                'Recording audio...',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
