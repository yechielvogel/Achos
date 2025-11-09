import 'package:firebase_auth/firebase_auth.dart';
import 'hachlata.dart';

class Subscription {
  final String? id;
  final User user;
  final DateTime dateStart;
  final DateTime? dateEnd;
  final Hachlata hachlata;
  final String? isActive;

  Subscription({
    this.id,
    required this.user,
    required this.dateStart,
    this.dateEnd,
    required this.hachlata,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user': user.uid,
      'date_start': dateStart.toIso8601String(),
      'date_end': dateEnd?.toIso8601String(),
      'hachlata': hachlata.toJson(),
      'is_active': isActive,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json, User user) {
    return Subscription(
      id: json['id'] as String?,
      user: user,
      dateStart: DateTime.parse(json['date_start']),
      dateEnd:
          json['date_end'] != null ? DateTime.parse(json['date_end']) : null,
      hachlata: Hachlata.fromJson(json['hachlata']),
      isActive: json['is_active'] as String?,
    );
  }
}
