import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _trips = [
    {
      'from': 'Home',
      'to': 'Office – Tech Park',
      'date': 'Today',
      'time': '8:30 AM – 9:05 AM',
      'duration': '35 min',
      'distance': '4.2 km',
      'safetyScore': 9.2,
      'status': 'completed',
      'mode': 'Walking',
    },
    {
      'from': 'Office – Tech Park',
      'to': 'Café Mocha',
      'date': 'Today',
      'time': '12:15 PM – 12:28 PM',
      'duration': '13 min',
      'distance': '1.1 km',
      'safetyScore': 8.7,
      'status': 'completed',
      'mode': 'Walking',
    },
    {
      'from': 'Home',
      'to': 'Central Mall',
      'date': 'Yesterday',
      'time': '6:45 PM – 7:20 PM',
      'duration': '35 min',
      'distance': '5.8 km',
      'safetyScore': 6.5,
      'status': 'completed',
      'mode': 'Bus',
    },
    {
      'from': 'Central Mall',
      'to': 'Home',
      'date': 'Yesterday',
      'time': '9:10 PM – 9:50 PM',
      'duration': '40 min',
      'distance': '5.8 km',
      'safetyScore': 5.2,
      'status': 'alert',
      'mode': 'Walking',
    },
    {
      'from': 'Home',
      'to': 'Gym – FitZone',
      'date': '23 Apr',
      'time': '6:00 AM – 6:18 AM',
      'duration': '18 min',
      'distance': '2.3 km',
      'safetyScore': 9.0,
      'status': 'completed',
      'mode': 'Walking',
    },
    {
      'from': 'Home',
      'to': 'University',
      'date': '22 Apr',
      'time': '7:30 AM – 8:15 AM',
      'duration': '45 min',
      'distance': '7.1 km',
      'safetyScore': 8.1,
      'status': 'completed',
      'mode': 'Bus',
    },
    {
      'from': 'University',
      'to': 'Library',
      'date': '22 Apr',
      'time': '4:00 PM – 4:12 PM',
      'duration': '12 min',
      'distance': '0.9 km',
      'safetyScore': 9.5,
      'status': 'completed',
      'mode': 'Walking',
    },
  ];

  List<Map<String, dynamic>> get _filteredTrips {
    if (_selectedFilter == 'All') return _trips;
    if (_selectedFilter == 'Alerts') {
      return _trips.where((t) => t['status'] == 'alert').toList();
    }
    return _trips.where((t) => t['mode'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History',
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Stats summary
          _buildStatsSummary().animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          // Filter chips
          _buildFilterChips().animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 8),
          // Trip list
          Expanded(
            child: _filteredTrips.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _filteredTrips.length,
                    itemBuilder: (context, index) {
                      return _buildTripCard(_filteredTrips[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalTrips = _trips.length;
    final totalKm = _trips.fold<double>(
        0, (sum, t) => sum + double.parse(t['distance'].toString().replaceAll(' km', '')));
    final avgSafety = _trips.fold<double>(
            0, (sum, t) => sum + (t['safetyScore'] as double)) /
        totalTrips;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem('$totalTrips', 'Trips', Icons.route_rounded),
          _buildStatDivider(),
          _buildStatItem(
              '${totalKm.toStringAsFixed(1)}', 'km', Icons.straighten_rounded),
          _buildStatDivider(),
          _buildStatItem(avgSafety.toStringAsFixed(1), 'Safety',
              Icons.shield_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 18),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.75))),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Walking', 'Bus', 'Alerts'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = filters[index];
          final isSelected = _selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(f,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, int index) {
    final score = trip['safetyScore'] as double;
    final isAlert = trip['status'] == 'alert';
    final scoreColor = score >= 8
        ? AppColors.safe
        : score >= 6
            ? AppColors.moderate
            : AppColors.risky;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isAlert
            ? Border.all(
                color: AppColors.risky.withValues(alpha: 0.25), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: date + safety score
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(trip['date'] as String,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded, size: 12, color: scoreColor),
                    const SizedBox(width: 4),
                    Text(score.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scoreColor)),
                  ],
                ),
              ),
              const Spacer(),
              if (isAlert)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.riskyLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 12, color: AppColors.risky),
                      const SizedBox(width: 4),
                      Text('Alert',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.risky)),
                    ],
                  ),
                ),
              Icon(
                trip['mode'] == 'Bus'
                    ? Icons.directions_bus_rounded
                    : Icons.directions_walk_rounded,
                size: 18,
                color: AppColors.textHint,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Route path
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.safe,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.safe.withValues(alpha: 0.3),
                            blurRadius: 4)
                      ],
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.safe, scoreColor],
                      ),
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: scoreColor,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: scoreColor.withValues(alpha: 0.3),
                            blurRadius: 4)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip['from'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    Text(trip['to'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Footer: time, duration, distance
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(trip['time'] as String,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textHint)),
              const Spacer(),
              Text(trip['duration'] as String,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Text(trip['distance'] as String,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 80));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded,
              size: 64, color: AppColors.textHint.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('No trips found',
              style: GoogleFonts.inter(
                  fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text('Try a different filter',
              style:
                  GoogleFonts.inter(fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
