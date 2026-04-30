import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../models/incident_model.dart';
import '../../providers/incident_provider.dart';
import '../../widgets/custom_text_field.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  IncidentType _selectedType = IncidentType.harassment;
  String? _imagePath;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<IncidentProvider>();
    final success = await provider.submitIncident(
      type: _selectedType,
      description: _descriptionController.text.trim(),
      latitude: 6.9271,
      longitude: 79.8612,
      imageUrl: _imagePath,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.safeLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.safe, size: 48),
              ),
              const SizedBox(height: 16),
              Text('Report Submitted',
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                'Thank you for helping keep everyone safe!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Incident',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto-captured info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Colombo Fort, Colombo 01',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // Incident Type
              Text('Incident Type',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: IncidentType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(type.emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            type.label,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),

              // Description
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Describe what happened...',
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please describe the incident';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 24),

              // Image Upload
              Text('Evidence (Optional)',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() => _imagePath = 'mock_image.jpg');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image selected (demo)',
                          style: GoogleFonts.inter()),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.divider,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _imagePath != null
                            ? Icons.check_circle_rounded
                            : Icons.cloud_upload_outlined,
                        size: 36,
                        color: _imagePath != null
                            ? AppColors.safe
                            : AppColors.textHint,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _imagePath != null
                            ? 'Image attached'
                            : 'Tap to upload image/video',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _imagePath != null
                              ? AppColors.safe
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),

              // Submit Button
              Consumer<IncidentProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed:
                          provider.isSubmitting ? null : _submitReport,
                      icon: provider.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                          provider.isSubmitting ? 'Submitting...' : 'Submit Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.moderate,
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
