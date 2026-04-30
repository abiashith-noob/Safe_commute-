import 'package:flutter/material.dart';

enum ZoneLevel {
  safe(Color(0xFF4CAF50), 'Safe'),
  moderate(Color(0xFFFF9800), 'Moderate'),
  risky(Color(0xFFF44336), 'Risky');

  final Color color;
  final String label;
  const ZoneLevel(this.color, this.label);
}

class SafetyZoneModel {
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final ZoneLevel level;

  SafetyZoneModel({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.level,
  });
}
