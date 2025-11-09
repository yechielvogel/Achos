import 'package:firebase_auth/firebase_auth.dart';
import 'school.dart';

class Admin {
  final String? id;
  final User? user;
  final School school;

  Admin({
    this.id,
    required this.user,
    required this.school,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user': user?.uid,
      'school': school.toJson(),
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json, User? user) {
    return Admin(
      id: json['id'] as String?,
      user: user,
      school: School.fromJson(json['school']),
    );
  }
}
