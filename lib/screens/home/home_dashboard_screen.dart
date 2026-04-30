import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/safety_card.dart';
import '../../widgets/grid_action_card.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocationProvider>().fetchCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final location = context.watch<LocationProvider>();
    final userName = auth.user?.fullName.split(' ').first ?? 'User';

    // Start live tracking if the user enabled it in their profile
    final shouldTrack = auth.user?.locationTrackingEnabled ?? false;
    if (shouldTrack && !location.isTracking) {
      Future.microtask(() => location.toggleTracking(true));
    } else if (!shouldTrack && location.isTracking) {
      Future.microtask(() => location.toggleTracking(false));
    }

    return Scaffold(
      body: SafeArea(
        child: Consumer<LocationProvider>(
          builder: (context, location, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $userName! 👋',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stay safe on your commute',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                            ),
                            child: Center(
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),
                  // Safety Status Card
                  SafetyCard(
                    safetyLevel: location.safetyLevel,
                    address: location.currentAddress,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 24),
                  // Quick Actions Title
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  // 2x2 Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.1,
                    children: [
                      GridActionCard(
                        icon: Icons.route_rounded,
                        title: 'Smart Route',
                        subtitle: 'Find safer paths',
                        color: AppColors.primary,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.routePlanner),
                      ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.9, 0.9)),
                      GridActionCard(
                        icon: Icons.map_rounded,
                        title: 'Safety Map',
                        subtitle: 'View safety zones',
                        color: AppColors.safe,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.safetyMap),
                      ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                      GridActionCard(
                        icon: Icons.people_rounded,
                        title: 'Guardian Circle',
                        subtitle: 'Trusted contacts',
                        color: const Color(0xFF9C27B0),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.guardianCircle),
                      ).animate().fadeIn(delay: 700.ms).scale(begin: const Offset(0.9, 0.9)),
                      GridActionCard(
                        icon: Icons.emergency_rounded,
                        title: 'Emergency SOS',
                        subtitle: 'Send alert now',
                        color: AppColors.accent,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.sos),
                      ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Additional Quick Access
                  Text(
                    'More Features',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 900.ms),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Safety Check-In',
                    subtitle: 'Set automatic check-in intervals',
                    color: const Color(0xFF00BCD4),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.safetyCheckin),
                  ).animate().fadeIn(delay: 1000.ms).slideX(begin: 0.1),
                  const SizedBox(height: 10),
                  _buildFeatureTile(
                    icon: Icons.report_outlined,
                    title: 'Report Incident',
                    subtitle: 'Help keep others safe',
                    color: AppColors.moderate,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.incidentReport),
                  ).animate().fadeIn(delay: 1100.ms).slideX(begin: 0.1),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.aiAssistant),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
    ).animate().scale(delay: 1000.ms);
  }
}
