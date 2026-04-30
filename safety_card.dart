import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class SafetyCard extends StatelessWidget {
  final String safetyLevel;
  final String address;

  const SafetyCard({
    super.key,
    required this.safetyLevel,
    required this.address,
  });

  Color get _statusColor {
    switch (safetyLevel.toLowerCase()) {
      case 'safe':
        return AppColors.safe;
      case 'moderate':
        return AppColors.moderate;
      case 'risky':
        return AppColors.risky;
      default:
        return AppColors.safe;
    }
  }

  Color get _statusBgColor {
    switch (safetyLevel.toLowerCase()) {
      case 'safe':
        return AppColors.safeLight;
      case 'moderate':
        return AppColors.moderateLight;
      case 'risky':
        return AppColors.riskyLight;
      default:
        return AppColors.safeLight;
    }
  }

  IconData get _statusIcon {
    switch (safetyLevel.toLowerCase()) {
      case 'safe':
        return Icons.verified_user_rounded;
      case 'moderate':
        return Icons.warning_amber_rounded;
      case 'risky':
        return Icons.error_rounded;
      default:
        return Icons.verified_user_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _statusColor.withValues(alpha: 0.08),
            _statusColor.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _statusBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon,
              color: _statusColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Safety Status',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  safetyLevel,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LIVE',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
