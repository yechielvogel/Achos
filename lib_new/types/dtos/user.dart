import 'contact.dart';
import 'roll.dart';
import 'school.dart';

class User {
  final int? id;
  final String? username;
  final String firebaseUid;
  final String? firebaseFcmToken;
  final bool isActive;
  final School? school;
  final Contact? contact;
  final Roll? roll;

  User({
    this.id,
    this.username,
    this.firebaseUid = '',
    this.firebaseFcmToken,
    this.isActive = false,
    this.school,
    this.contact,
    this.roll,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'firebase_uid': firebaseUid,
      'firebase_fcm_token': firebaseFcmToken,
      'is_active': isActive,
      'school': school?.toJson(),
      'contact': contact?.toJson(),
      'roll': roll?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String?,
      firebaseUid: json['firebase_uid'] as String,
      firebaseFcmToken: json['firebase_fcm_token'] as String?,
      isActive: json['is_active'] as bool,
      school: (json['school'] is Map<String, dynamic>)
          ? School.fromJson(json['school'])
          : null,
      contact: (json['contact'] is Map<String, dynamic>)
          ? Contact.fromJson(json['contact'])
          : null,
      roll: (json['roll'] is Map<String, dynamic>)
          ? Roll.fromJson(json['roll'])
          : null,
    );
  }
}
