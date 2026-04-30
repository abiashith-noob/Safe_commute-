import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqItems = [
    {
      'q': 'How does the SOS feature work?',
      'a': 'Tap the SOS button on the home screen or shake your device (if enabled). '
          'This immediately alerts all guardians in your circle with your live location, '
          'and optionally contacts emergency services.',
      'icon': Icons.emergency_rounded,
      'color': const Color(0xFFF44336),
    },
    {
      'q': 'How do I add a guardian?',
      'a': 'Go to Profile → Guardian Circle → tap the + button. Enter your guardian\'s '
          'name, phone number, and relationship. They will receive an invitation to '
          'join your safety circle.',
      'icon': Icons.people_rounded,
      'color': const Color(0xFF9C27B0),
    },
    {
      'q': 'What are safety zones?',
      'a': 'Safety zones are areas on the map color-coded by risk level — green (safe), '
          'orange (moderate), and red (risky). These are calculated from community reports, '
          'lighting data, and incident history.',
      'icon': Icons.map_rounded,
      'color': const Color(0xFF4CAF50),
    },
    {
      'q': 'How is the route safety score calculated?',
      'a': 'The safety score (1-10) considers lighting conditions, crowd density, '
          'historical incidents, and community feedback along the route. Higher scores '
          'indicate safer routes.',
      'icon': Icons.route_rounded,
      'color': const Color(0xFF2196F3),
    },
    {
      'q': 'Can I use the app offline?',
      'a': 'Basic features like SOS and previously cached routes work offline. However, '
          'live map data, incident reports, and real-time guardian alerts require an '
          'internet connection.',
      'icon': Icons.wifi_off_rounded,
      'color': const Color(0xFF607D8B),
    },
    {
      'q': 'How do safety check-ins work?',
      'a': 'When check-in is active, the app periodically asks if you\'re safe. If you '
          'don\'t respond within the set time, your guardians are automatically notified '
          'with your last known location.',
      'icon': Icons.timer_rounded,
      'color': const Color(0xFFFF9800),
    },
    {
      'q': 'Is my location data private?',
      'a': 'Yes. Your location is only shared with guardians you explicitly approve. '
          'We do not sell or share your data with third parties. All data is encrypted '
          'in transit and at rest.',
      'icon': Icons.lock_rounded,
      'color': const Color(0xFF00897B),
    },
  ];

  List<Map<String, dynamic>> get _filteredFaq {
    if (_searchQuery.isEmpty) return _faqItems;
    final q = _searchQuery.toLowerCase();
    return _faqItems
        .where((item) =>
            (item['q'] as String).toLowerCase().contains(q) ||
            (item['a'] as String).toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support',
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Header card
            _buildHeaderCard().animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 24),

            // Quick actions
            _buildQuickActions().animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 28),

            // FAQ section
            Text('Frequently Asked Questions',
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary))
                .animate()
                .fadeIn(delay: 250.ms),
            const SizedBox(height: 12),

            // Search
            _buildSearchBar().animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),

            // FAQ list
            ..._filteredFaq.asMap().entries.map((entry) {
              return _buildFaqTile(entry.value, entry.key);
            }),

            if (_filteredFaq.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textHint.withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      Text('No matching questions',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: AppColors.textHint)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 28),

            // Contact section
            _buildContactSection()
                .animate()
                .fadeIn(delay: 500.ms),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 14),
          Text('How can we help?',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text(
            'Find answers to common questions or reach out to our support team',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email Us',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'label': 'Live Chat',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.bug_report_outlined,
        'label': 'Report Bug',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.lightbulb_outline_rounded,
        'label': 'Suggest',
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Row(
      children: actions.map((a) {
        final color = a['color'] as Color;
        return Expanded(
          child: GestureDetector(
            onTap: () => _handleQuickAction(a['label'] as String),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(a['icon'] as IconData, color: color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(a['label'] as String,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _searchQuery = v),
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search FAQ...',
        prefixIcon:
            const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textHint, size: 18),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildFaqTile(Map<String, dynamic> faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (faq['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(faq['icon'] as IconData,
                color: faq['color'] as Color, size: 20),
          ),
          title: Text(faq['q'] as String,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          children: [
            Text(faq['a'] as String,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 350 + index * 60));
  }

  Widget _buildContactSection() {
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
        children: [
          Text('Still need help?',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text('Our support team is available 24/7',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textHint)),
          const SizedBox(height: 16),
          _buildContactRow(
              Icons.email_rounded, 'support@safecommute.ai', AppColors.primary),
          const SizedBox(height: 10),
          _buildContactRow(
              Icons.phone_rounded, '+94 11 234 5678', AppColors.safe),
          const SizedBox(height: 10),
          _buildContactRow(Icons.language_rounded,
              'www.safecommute.ai/help', AppColors.moderate),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () => _handleContactTap(text),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ),
          Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.textHint),
        ],
      ),
    );
  }

  void _handleQuickAction(String label) async {
    switch (label) {
      case 'Email Us':
        final uri = Uri(
          scheme: 'mailto',
          path: 'support@safecommute.ai',
          queryParameters: {
            'subject': 'SafeCommute AI - Support Request',
            'body': 'Hi SafeCommute Team,\n\nI need help with:\n\n',
          },
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open email client',
                  style: GoogleFonts.inter()),
              backgroundColor: AppColors.risky,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        break;
      case 'Live Chat':
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Live chat coming soon!',
                  style: GoogleFonts.inter()),
              backgroundColor: AppColors.safe,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        break;
      case 'Report Bug':
        final uri = Uri(
          scheme: 'mailto',
          path: 'bugs@safecommute.ai',
          queryParameters: {
            'subject': 'SafeCommute AI - Bug Report',
            'body':
                'Bug Description:\n\nSteps to Reproduce:\n1. \n2. \n3. \n\nExpected Behavior:\n\nActual Behavior:\n\nDevice Info:\n',
          },
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
        break;
      case 'Suggest':
        final uri = Uri(
          scheme: 'mailto',
          path: 'feedback@safecommute.ai',
          queryParameters: {
            'subject': 'SafeCommute AI - Feature Suggestion',
            'body': 'Hi,\n\nI would like to suggest:\n\n',
          },
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
        break;
    }
  }

  void _handleContactTap(String text) async {
    Uri? uri;
    if (text.contains('@')) {
      uri = Uri(
        scheme: 'mailto',
        path: text,
        queryParameters: {
          'subject': 'SafeCommute AI - Support Request',
        },
      );
    } else if (text.startsWith('+')) {
      uri = Uri(scheme: 'tel', path: text.replaceAll(' ', ''));
    } else if (text.startsWith('www.')) {
      uri = Uri.parse('https://$text');
    }
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
