import 'contact.dart';
import 'school.dart';

class User {
  final String? id;
  final String? username;
  final String firebaseUid;
  final String? firebaseFcmToken;
  final bool isActive;
  final School? school;
  final Contact? contact;

  User({
    this.id,
    this.username,
    required this.firebaseUid,
    this.firebaseFcmToken,
    required this.isActive,
    this.school,
    this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firebase_uid': firebaseUid,
      'firebase_fcm_token': firebaseFcmToken,
      'is_active': isActive,
      'school': school?.toJson(),
      'contact': contact?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      username: json['username'] as String?,
      firebaseUid: json['firebase_uid'] as String,
      firebaseFcmToken: json['firebase_fcm_token'] as String?,
      isActive: json['is_active'] as bool,
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      contact:
          json['contact'] != null ? Contact.fromJson(json['contact']) : null,
    );
  }
}
