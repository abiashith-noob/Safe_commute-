import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LegalPageScreen extends StatelessWidget {
  final String title;
  const LegalPageScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildContent(),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (title) {
      case 'Terms of Service':
        return _termsOfService();
      case 'Privacy Policy':
        return _privacyPolicy();
      case 'Cookie Policy':
        return _cookiePolicy();
      case 'Open Source Licenses':
        return _openSourceLicenses();
      default:
        return [Text('Content not found', style: GoogleFonts.inter())];
    }
  }

  List<Widget> _termsOfService() {
    return [
      _lastUpdated('April 25, 2026'),
      _paragraph(
        'Welcome to SafeCommute AI. By accessing or using our mobile application, '
        'you agree to be bound by these Terms of Service. Please read them carefully '
        'before using the app.',
      ),
      _heading('1. Acceptance of Terms'),
      _paragraph(
        'By downloading, installing, or using SafeCommute AI, you agree to these Terms '
        'of Service and our Privacy Policy. If you do not agree to these terms, please '
        'do not use the application.',
      ),
      _heading('2. Description of Service'),
      _paragraph(
        'SafeCommute AI provides AI-powered safety route planning, real-time safety zone '
        'mapping, community incident reporting, guardian circle management, SOS emergency '
        'alerts, and safety check-in features. The service is designed to enhance personal '
        'safety during commutes but does not guarantee absolute safety.',
      ),
      _heading('3. User Accounts'),
      _paragraph(
        'You must create an account to use SafeCommute AI. You are responsible for '
        'maintaining the confidentiality of your account credentials and for all activities '
        'under your account. You must provide accurate and complete information during '
        'registration.',
      ),
      _heading('4. User Responsibilities'),
      _bulletList([
        'You must be at least 13 years old to use this service.',
        'You agree not to misuse the SOS feature or submit false incident reports.',
        'You are responsible for ensuring your guardian circle contacts have consented '
            'to being added.',
        'You must not use the app while operating a vehicle.',
        'You agree not to attempt to reverse-engineer, modify, or exploit the app.',
      ]),
      _heading('5. Location Data'),
      _paragraph(
        'SafeCommute AI requires access to your device\'s location to provide core '
        'features. By enabling location tracking, you consent to the collection and '
        'processing of your location data as described in our Privacy Policy. You may '
        'disable location tracking at any time through the app settings.',
      ),
      _heading('6. Guardian Circle'),
      _paragraph(
        'The Guardian Circle feature allows you to share your location and safety '
        'status with trusted contacts. You are solely responsible for managing who '
        'has access to your information through this feature. SafeCommute AI is not '
        'liable for any misuse of shared information by guardians.',
      ),
      _heading('7. Community Reports'),
      _paragraph(
        'Users may submit incident reports to help the community. All reports must be '
        'truthful and accurate. Submitting false or misleading reports may result in '
        'account suspension or termination. SafeCommute AI reserves the right to '
        'remove any report at its discretion.',
      ),
      _heading('8. Limitation of Liability'),
      _paragraph(
        'SafeCommute AI provides safety information and tools as a supplementary aid. '
        'We do not guarantee the accuracy of safety scores, route recommendations, or '
        'incident data. The app should not be used as the sole basis for safety decisions. '
        'In no event shall SafeCommute AI be liable for any direct, indirect, incidental, '
        'or consequential damages arising from use of the service.',
      ),
      _heading('9. Modifications'),
      _paragraph(
        'We reserve the right to modify these Terms at any time. Continued use of the '
        'app after changes constitutes acceptance of the updated terms. We will notify '
        'users of significant changes via in-app notifications.',
      ),
      _heading('10. Termination'),
      _paragraph(
        'We may suspend or terminate your account at any time for violation of these '
        'Terms. Upon termination, your right to use the service ceases immediately. '
        'You may also delete your account at any time through the app settings.',
      ),
      _heading('11. Contact Us'),
      _paragraph(
        'If you have questions about these Terms of Service, please contact us at '
        'legal@safecommute.ai or through the Help & Support section of the app.',
      ),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _privacyPolicy() {
    return [
      _lastUpdated('April 25, 2026'),
      _paragraph(
        'SafeCommute AI is committed to protecting your privacy. This Privacy Policy '
        'explains how we collect, use, store, and protect your personal information.',
      ),
      _heading('1. Information We Collect'),
      _bulletList([
        'Account information: name, email address, phone number.',
        'Location data: real-time GPS coordinates when tracking is enabled.',
        'Usage data: app interactions, feature usage, and trip history.',
        'Device information: device model, OS version, and unique identifiers.',
        'Community data: incident reports and safety feedback you submit.',
      ]),
      _heading('2. How We Use Your Information'),
      _bulletList([
        'Provide and improve safety route planning and zone mapping.',
        'Send real-time safety alerts and notifications.',
        'Share your location with approved guardians during active tracking.',
        'Aggregate anonymized data to improve community safety insights.',
        'Communicate important updates and safety information.',
      ]),
      _heading('3. Data Sharing'),
      _paragraph(
        'We do not sell your personal data to third parties. Your location is only '
        'shared with guardians you explicitly approve. Anonymized, aggregated data '
        'may be used for safety analysis and research.',
      ),
      _heading('4. Data Security'),
      _paragraph(
        'All data is encrypted in transit (TLS 1.3) and at rest (AES-256). We '
        'implement industry-standard security measures including access controls, '
        'audit logging, and regular security assessments.',
      ),
      _heading('5. Data Retention'),
      _paragraph(
        'Trip history is retained for 12 months. Account data is retained until you '
        'delete your account. Incident reports are anonymized after 6 months. You may '
        'request data deletion at any time.',
      ),
      _heading('6. Your Rights'),
      _bulletList([
        'Access and download your personal data.',
        'Request correction of inaccurate data.',
        'Delete your account and associated data.',
        'Opt out of non-essential data collection.',
        'Withdraw consent for location tracking at any time.',
      ]),
      _heading('7. Contact'),
      _paragraph('For privacy inquiries: privacy@safecommute.ai'),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _cookiePolicy() {
    return [
      _lastUpdated('April 25, 2026'),
      _paragraph(
        'This Cookie Policy explains how SafeCommute AI uses cookies and similar '
        'technologies in our mobile application.',
      ),
      _heading('1. What Are Cookies?'),
      _paragraph(
        'Cookies are small data files stored on your device. In mobile apps, similar '
        'technologies like local storage and device identifiers serve the same purpose.',
      ),
      _heading('2. How We Use Cookies'),
      _bulletList([
        'Essential cookies: Required for authentication and session management.',
        'Preference cookies: Store your app settings and preferences.',
        'Analytics cookies: Help us understand app usage and improve features.',
      ]),
      _heading('3. Managing Cookies'),
      _paragraph(
        'You can manage cookie preferences through your device settings or within the '
        'app\'s notification settings. Disabling essential cookies may affect app functionality.',
      ),
      _heading('4. Contact'),
      _paragraph('For questions: privacy@safecommute.ai'),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _openSourceLicenses() {
    final packages = [
      {'name': 'Flutter', 'license': 'BSD-3-Clause', 'author': 'Google'},
      {'name': 'Provider', 'license': 'MIT', 'author': 'Remi Rousselet'},
      {'name': 'Google Fonts', 'license': 'Apache-2.0', 'author': 'Google'},
      {'name': 'Flutter Animate', 'license': 'MIT', 'author': 'Grant Skinner'},
      {'name': 'Flutter Map', 'license': 'BSD-3-Clause', 'author': 'Flutter Map Contributors'},
      {'name': 'Latlong2', 'license': 'Apache-2.0', 'author': 'Mike Rydstrom'},
      {'name': 'Firebase Core', 'license': 'BSD-3-Clause', 'author': 'Google'},
      {'name': 'Firebase Auth', 'license': 'BSD-3-Clause', 'author': 'Google'},
      {'name': 'Cloud Firestore', 'license': 'BSD-3-Clause', 'author': 'Google'},
    ];

    return [
      _paragraph(
        'SafeCommute AI is built using the following open source packages. '
        'We are grateful to the open source community for their contributions.',
      ),
      const SizedBox(height: 16),
      ...packages.map((pkg) => _licenseTile(
            pkg['name']!,
            pkg['license']!,
            pkg['author']!,
          )),
      const SizedBox(height: 32),
    ];
  }

  // ── Helpers ──

  Widget _lastUpdated(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Last updated: $date',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary)),
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary)),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.7)),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.6)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _licenseTile(String name, String license, String author) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.code_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                Text('by $author',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.safe.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(license,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.safe)),
          ),
        ],
      ),
    );
  }
}
