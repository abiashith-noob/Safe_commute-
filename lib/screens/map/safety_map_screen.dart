import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/theme.dart';
import '../../providers/map_provider.dart';
import '../../models/incident_model.dart';

class SafetyMapScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const SafetyMapScreen({super.key, this.onBackToHome});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MapProvider>().loadMapData());
  }

  IconData _getIncidentIcon(IncidentType type) {
    switch (type) {
      case IncidentType.harassment:
        return Icons.warning_amber_rounded;
      case IncidentType.theft:
        return Icons.lock_open_rounded;
      case IncidentType.stalking:
        return Icons.visibility_rounded;
      case IncidentType.poorLighting:
        return Icons.lightbulb_outline_rounded;
      case IncidentType.suspiciousActivity:
        return Icons.report_problem_rounded;
      case IncidentType.other:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Map',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            }
          },
        ),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, _) {
          if (mapProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Stack(
            children: [
              // Map
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(6.9271, 79.8612),
                  zoom: 13.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                circles: mapProvider.safetyZones.map((zone) {
                  return Circle(
                    circleId: CircleId('${zone.latitude}_${zone.longitude}'),
                    center: LatLng(zone.latitude, zone.longitude),
                    radius: zone.radiusMeters,
                    fillColor: zone.level.color.withValues(alpha: 0.15),
                    strokeColor: zone.level.color.withValues(alpha: 0.4),
                    strokeWidth: 2,
                  );
                }).toSet(),
                markers: mapProvider.incidents.map((incident) {
                  return Marker(
                    markerId: MarkerId(incident.id),
                    position: LatLng(incident.latitude, incident.longitude),
                    onTap: () => _showIncidentDetails(context, incident),
                    infoWindow: InfoWindow(title: incident.type.label),
                    // We can customize the icon later with BitmapDescriptor
                  );
                }).toSet(),
              ),
              // Filter Chips
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Crime',
                        icon: Icons.gavel_rounded,
                        filter: MapFilter.crime,
                        isActive: mapProvider.activeFilters
                            .contains(MapFilter.crime),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Poor Lighting',
                        icon: Icons.lightbulb_outline,
                        filter: MapFilter.poorLighting,
                        isActive: mapProvider.activeFilters
                            .contains(MapFilter.poorLighting),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Crowd Level',
                        icon: Icons.people_outline,
                        filter: MapFilter.crowdLevel,
                        isActive: mapProvider.activeFilters
                            .contains(MapFilter.crowdLevel),
                      ),
                    ],
                  ),
                ),
              ),
              // Legend
              Positioned(
                bottom: 20,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Legend',
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      _legendItem(AppColors.safe, 'Safe Zone'),
                      _legendItem(AppColors.moderate, 'Moderate'),
                      _legendItem(AppColors.risky, 'Risky Area'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required MapFilter filter,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => context.read<MapProvider>().toggleFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isActive ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }

  void _showIncidentDetails(BuildContext context, IncidentModel incident) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(incident.type.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(incident.type.label,
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(incident.description,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Text(
              'Reported: ${_formatTime(incident.timestamp)}',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textHint),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
