import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../providers/guardian_provider.dart';
import '../../widgets/guardian_tile.dart';
import '../../widgets/custom_text_field.dart';

class GuardianCircleScreen extends StatefulWidget {
  const GuardianCircleScreen({super.key});

  @override
  State<GuardianCircleScreen> createState() => _GuardianCircleScreenState();
}

class _GuardianCircleScreenState extends State<GuardianCircleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GuardianProvider>().loadGuardians());
  }

  void _showAddGuardianSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String relation = 'Friend';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Add Guardian',
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameCtrl,
              labelText: 'Name',
              hintText: 'Guardian name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneCtrl,
              labelText: 'Phone',
              hintText: '+1 (555) 000-0000',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Text('Relation',
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setInnerState) {
                return Wrap(
                  spacing: 8,
                  children: ['Friend', 'Mother', 'Father', 'Brother', 'Sister', 'Spouse', 'Other']
                      .map((r) => ChoiceChip(
                            label: Text(r),
                            selected: relation == r,
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13,
                              color: relation == r
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            onSelected: (_) {
                              setInnerState(() => relation = r);
                            },
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                    context.read<GuardianProvider>().addGuardian(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          relation: relation,
                        );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Guardian'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDurationPicker(String guardianId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share Location For',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...[
              ('30 minutes', const Duration(minutes: 30)),
              ('1 hour', const Duration(hours: 1)),
              ('2 hours', const Duration(hours: 2)),
              ('Until I stop', const Duration(hours: 24)),
            ].map((option) => ListTile(
                  leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                  title: Text(option.$1, style: GoogleFonts.inter(fontSize: 15)),
                  onTap: () {
                    context.read<GuardianProvider>().toggleLocationSharing(
                          guardianId, true, duration: option.$2);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guardian Circle',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGuardianSheet,
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Add Guardian', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
      body: Consumer<GuardianProvider>(
        builder: (context, guardianProvider, _) {
          if (guardianProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (guardianProvider.guardians.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline,
                      size: 80,
                      color: AppColors.textHint.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No guardians added yet',
                      style: GoogleFonts.inter(
                          fontSize: 16, color: AppColors.textHint)),
                  const SizedBox(height: 8),
                  Text('Tap + to add your first guardian',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.textHint)),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0).withValues(alpha: 0.08),
                      const Color(0xFF9C27B0).withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: const Color(0xFF9C27B0), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Guardians will receive your location and alerts during emergencies.',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),
              ...guardianProvider.guardians.asMap().entries.map((entry) {
                final guardian = entry.value;
                return GuardianTile(
                  guardian: guardian,
                  onToggleSharing: () {
                    if (guardian.isLocationSharing) {
                      guardianProvider.toggleLocationSharing(
                          guardian.id, false);
                    } else {
                      _showDurationPicker(guardian.id);
                    }
                  },
                  onRemove: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text('Remove Guardian',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        content: Text(
                            'Remove ${guardian.name} from your guardian circle?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              guardianProvider.removeGuardian(guardian.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Remove',
                                style: TextStyle(color: AppColors.risky)),
                          ),
                        ],
                      ),
                    );
                  },
                ).animate().fadeIn(
                    delay: Duration(milliseconds: 200 + entry.key * 100));
              }),
            ],
          );
        },
      ),
    );
  }
}
