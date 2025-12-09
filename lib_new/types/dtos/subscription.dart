import 'hachlata.dart';
import 'user.dart';

class Subscription {
  final int? id;
  final int user;
  final DateTime dateStart;
  final DateTime? dateEnd;
  final Hachlata hachlata;
  final bool? isActive;

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
      'user': user,
      'date_start': dateStart.toIso8601String(),
      if (dateEnd != null) 'date_end': dateEnd?.toIso8601String(),
      'hachlata': hachlata.id,
      'is_active': isActive,
    };
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json,
  ) {
    return Subscription(
      id: json['id'],
      user: json['user'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd:
          json['date_end'] != null ? DateTime.parse(json['date_end']) : null,
      hachlata: Hachlata.fromJson(json['hachlata']),
      isActive: json['is_active'] as bool?,
    );
  }
}
