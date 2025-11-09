import 'package:firebase_auth/firebase_auth.dart';
import 'hachlata.dart';
import 'subscription.dart';

class HachlataCompleted {
  final String? id;
  final Hachlata hachlata;
  final Subscription? subscription;
  final DateTime completedAt;
  final User user;

  HachlataCompleted({
    this.id,
    required this.hachlata,
    this.subscription,
    required this.completedAt,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'hachlata': hachlata.toJson(),
      'subscription': subscription?.toJson(),
      'completed_at': completedAt.toIso8601String(),
      'user': user.uid,
    };
  }

  factory HachlataCompleted.fromJson(Map<String, dynamic> json, User user) {
    return HachlataCompleted(
      id: json['id'] as String?,
      hachlata: Hachlata.fromJson(json['hachlata']),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'], user)
          : null,
      completedAt: DateTime.parse(json['completed_at']),
      user: user,
    );
  }
}
