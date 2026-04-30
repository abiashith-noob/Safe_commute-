import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  bool _locationTracking = true;
  final List<Map<String, String>> _guardians = [];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user.fullName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  void _addGuardian() {
    if (_guardianNameController.text.isNotEmpty &&
        _guardianPhoneController.text.isNotEmpty) {
      setState(() {
        _guardians.add({
          'name': _guardianNameController.text.trim(),
          'phone': _guardianPhoneController.text.trim(),
        });
        _guardianNameController.clear();
        _guardianPhoneController.clear();
      });
    }
  }

  void _finishSetup() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      authProvider.updateUser(
        authProvider.user!.copyWith(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          locationTrackingEnabled: _locationTracking,
        ),
      );
      authProvider.completeProfileSetup();
    }
    Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Complete Your Profile',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 8),
              Text(
                'Set up your profile for a safer commute experience',
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),
              // Profile Photo
              Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Photo picker would open here',
                            style: GoogleFonts.inter()),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Your full name',
                prefixIcon: Icons.person_outline_rounded,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: '+1 (555) 000-0000',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 28),
              // Guardian Section
              Text(
                'Emergency Contacts (Guardian Circle)',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 8),
              Text(
                'Add people who will be alerted in emergencies',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              ..._guardians.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.safeLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.safe.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified_user_rounded,
                          size: 18, color: AppColors.safe),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${entry.value['name']} • ${entry.value['phone']}',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _guardians.removeAt(entry.key));
                        },
                        child: Icon(Icons.close, size: 18, color: AppColors.textHint),
                      ),
                    ],
                  ),
                );
              }),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _guardianNameController,
                      hintText: 'Name',
                      prefixIcon: Icons.person_add_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: _guardianPhoneController,
                      hintText: 'Phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: _addGuardian,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Location Tracking Toggle
              Container(
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Location Tracking',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Required for safety features',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _locationTracking,
                      onChanged: (v) => setState(() => _locationTracking = v),
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _finishSetup,
                  child: const Text('Finish Setup'),
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
