import '../../../core/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.image,
    super.address,
    super.latitude,
    super.longitude,
    super.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      firstName: json['userFirstName'] ?? '',
      lastName: json['userLastName'] ?? '',
      email: json['userEmail'] ?? '',
      phone: json['userPhone'] ?? '',
      image: json['userImage'] ?? '',
      address: json['userAddress'] ?? '',
      latitude: json['userLatitude'] ?? 0.0,
      longitude: json['userLongitude'] ?? 0.0,
      wallet: json['userWallet'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'userFirstName': firstName,
      'userLastName': lastName,
      'userEmail': email,
      'userPhone': phone,
      'userImage': image,
    };
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? image,
    String? address,
    double? latitude,
    double? longitude,
    double? wallet,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      wallet: wallet ?? this.wallet,
    );
  }
}
