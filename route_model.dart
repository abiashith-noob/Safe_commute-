import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum SafetyLevel {
  safest('Safest Route', Color(0xFF4CAF50), '🛡️'),
  balanced('Balanced Route', Color(0xFF2196F3), '⚖️'),
  fastest('Fastest Route', Color(0xFFFF9800), '⚡');

  final String label;
  final Color color;
  final String emoji;
  const SafetyLevel(this.label, this.color, this.emoji);
}

class RouteModel {
  final String id;
  final String name;
  final SafetyLevel safetyLevel;
  final double distanceKm;
  final int durationMinutes;
  final List<LatLng> points;
  final int lightingScore;
  final int crowdScore;
  final int incidentCount;

  RouteModel({
    required this.id,
    required this.name,
    required this.safetyLevel,
    required this.distanceKm,
    required this.durationMinutes,
    required this.points,
    this.lightingScore = 3,
    this.crowdScore = 3,
    this.incidentCount = 0,
  });

  String get distanceText => '${distanceKm.toStringAsFixed(1)} km';
  String get durationText {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      return '${hours}h ${mins}m';
    }
    return '$durationMinutes min';
  }
}
