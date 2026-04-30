import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import 'legal_page_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About',
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // App logo & name
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.shield_rounded,
                    color: Colors.white, size: 48),
              ),
            ).animate().fadeIn(duration: 400.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 400.ms,
                ),
            const SizedBox(height: 20),
            Text('SafeCommute AI',
                    style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary))
                .animate()
                .fadeIn(delay: 150.ms),
            const SizedBox(height: 6),
            Text('Version 1.0.0 (Build 1)',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textHint))
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.safe.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Up to date',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.safe)),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 32),

            // Mission card
            _buildCard(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFE91E63),
              title: 'Our Mission',
              body:
                  'SafeCommute AI is built to make every journey safer. We use '
                  'AI-powered safety analysis, community-driven incident reports, '
                  'and real-time alerts to help you navigate with confidence — '
                  'day or night.',
              delay: 300,
            ),

            const SizedBox(height: 14),

            // Features card
            _buildCard(
              icon: Icons.auto_awesome_rounded,
              iconColor: const Color(0xFFFF9800),
              title: 'Key Features',
              delay: 400,
              child: Column(
                children: [
                  _featureRow(Icons.route_rounded, 'AI-powered safe route planning'),
                  _featureRow(Icons.map_rounded, 'Real-time safety zone mapping'),
                  _featureRow(Icons.emergency_rounded, 'One-tap SOS with guardian alerts'),
                  _featureRow(Icons.people_rounded, 'Guardian circle for loved ones'),
                  _featureRow(Icons.report_rounded, 'Community incident reporting'),
                  _featureRow(Icons.timer_rounded, 'Automated safety check-ins'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tech stack card
            _buildCard(
              icon: Icons.code_rounded,
              iconColor: const Color(0xFF2196F3),
              title: 'Built With',
              delay: 500,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _techChip('Flutter'),
                  _techChip('Dart'),
                  _techChip('Firebase'),
                  _techChip('Google Maps'),
                  _techChip('Provider'),
                  _techChip('AI / ML'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Legal links
            _buildCard(
              icon: Icons.gavel_rounded,
              iconColor: const Color(0xFF607D8B),
              title: 'Legal',
              delay: 600,
              child: Column(
                children: [
                  _legalRow(context, Icons.description_outlined,
                      'Terms of Service'),
                  _legalRow(context, Icons.privacy_tip_outlined,
                      'Privacy Policy'),
                  _legalRow(context, Icons.cookie_outlined,
                      'Cookie Policy'),
                  _legalRow(
                      context, Icons.source_outlined, 'Open Source Licenses'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Footer
            Text('Made with ❤️ in Sri Lanka',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary))
                .animate()
                .fadeIn(delay: 700.ms),
            const SizedBox(height: 6),
            Text('© 2026 SafeCommute AI. All rights reserved.',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textHint))
                .animate()
                .fadeIn(delay: 750.ms),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? body,
    Widget? child,
    int delay = 0,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
          if (body != null) ...[
            const SizedBox(height: 14),
            Text(body,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.6)),
          ],
          if (child != null) ...[
            const SizedBox(height: 14),
            child,
          ],
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay));
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _techChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary)),
    );
  }

  Widget _legalRow(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LegalPageScreen(title: title),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textHint),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textSecondary)),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
