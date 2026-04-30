class GuardianModel {
  final String id;
  final String name;
  final String phone;
  final String relation;
  final bool isActive;
  final bool isLocationSharing;
  final DateTime? sharingExpiresAt;

  GuardianModel({
    required this.id,
    required this.name,
    required this.phone,
    this.relation = 'Friend',
    this.isActive = true,
    this.isLocationSharing = false,
    this.sharingExpiresAt,
  });

  GuardianModel copyWith({
    String? name,
    String? phone,
    String? relation,
    bool? isActive,
    bool? isLocationSharing,
    DateTime? sharingExpiresAt,
  }) {
    return GuardianModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      isActive: isActive ?? this.isActive,
      isLocationSharing: isLocationSharing ?? this.isLocationSharing,
      sharingExpiresAt: sharingExpiresAt ?? this.sharingExpiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
      'isActive': isActive,
      'isLocationSharing': isLocationSharing,
      'sharingExpiresAt': sharingExpiresAt?.toIso8601String(),
    };
  }

  factory GuardianModel.fromMap(Map<String, dynamic> map) {
    return GuardianModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relation: map['relation'] ?? 'Friend',
      isActive: map['isActive'] ?? true,
      isLocationSharing: map['isLocationSharing'] ?? false,
      sharingExpiresAt: map['sharingExpiresAt'] != null
          ? DateTime.parse(map['sharingExpiresAt'])
          : null,
    );
  }
}
