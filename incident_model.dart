enum IncidentType {
  harassment('Harassment', '⚠️'),
  theft('Theft', '🔒'),
  stalking('Stalking', '👁️'),
  poorLighting('Poor Lighting', '💡'),
  suspiciousActivity('Suspicious Activity', '🚨'),
  other('Other', '📋');

  final String label;
  final String emoji;
  const IncidentType(this.label, this.emoji);
}

class IncidentModel {
  final String id;
  final IncidentType type;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? imageUrl;
  final String reportedBy;

  IncidentModel({
    required this.id,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    DateTime? timestamp,
    this.imageUrl,
    this.reportedBy = 'Anonymous',
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'reportedBy': reportedBy,
    };
  }

  factory IncidentModel.fromMap(Map<String, dynamic> map) {
    return IncidentModel(
      id: map['id'] ?? '',
      type: IncidentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => IncidentType.other,
      ),
      description: map['description'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      imageUrl: map['imageUrl'],
      reportedBy: map['reportedBy'] ?? 'Anonymous',
    );
  }
}
