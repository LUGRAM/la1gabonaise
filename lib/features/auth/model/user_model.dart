class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? plan; // moabi | kevazingo | null
  final bool isVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.plan,
    this.isVerified = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      plan: json['plan'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'plan': plan,
    'is_verified': isVerified,
    'created_at': createdAt?.toIso8601String(),
  };

  UserModel copyWith({String? name, String? avatar, String? plan}) {
    return UserModel(
      id: id, name: name ?? this.name,
      email: email, phone: phone,
      avatar: avatar ?? this.avatar,
      plan: plan ?? this.plan,
      isVerified: isVerified,
      createdAt: createdAt,
    );
  }
}
