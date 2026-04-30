import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/guardian_model.dart';

class GuardianTile extends StatelessWidget {
  final GuardianModel guardian;
  final VoidCallback? onToggleSharing;
  final VoidCallback? onRemove;

  const GuardianTile({
    super.key,
    required this.guardian,
    this.onToggleSharing,
    this.onRemove,
  });

  Color get _avatarColor {
    switch (guardian.relation.toLowerCase()) {
      case 'mother':
      case 'father':
        return const Color(0xFFE91E63);
      case 'brother':
      case 'sister':
        return const Color(0xFF9C27B0);
      case 'spouse':
      case 'partner':
        return const Color(0xFFF44336);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
        border: guardian.isLocationSharing
            ? Border.all(color: AppColors.safe.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _avatarColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                guardian.name.isNotEmpty ? guardian.name[0].toUpperCase() : '?',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guardian.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      guardian.relation,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${guardian.phone}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                if (guardian.isLocationSharing) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.safe,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sharing location',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.safe,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  guardian.isLocationSharing
                      ? Icons.location_on_rounded
                      : Icons.location_off_outlined,
                  color: guardian.isLocationSharing
                      ? AppColors.safe
                      : AppColors.textHint,
                  size: 22,
                ),
                onPressed: onToggleSharing,
                tooltip: 'Toggle location sharing',
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.textHint,
                  size: 22,
                ),
                onPressed: onRemove,
                tooltip: 'Remove guardian',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
