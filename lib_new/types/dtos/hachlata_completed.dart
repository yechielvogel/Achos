class HachlataCompleted {
  final int? id;
  final int hachlata;
  final int? subscription;
  final DateTime completedAt;
  final int user;

  HachlataCompleted({
    this.id,
    required this.hachlata,
    this.subscription,
    required this.completedAt,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'hachlata': hachlata,
      'subscription': subscription,
      'completed_at': completedAt.toIso8601String(),
      'user': user,
    };
  }

  factory HachlataCompleted.fromJson(Map<String, dynamic> json) {
    return HachlataCompleted(
      id: json['id'] as int?,
      hachlata: json['hachlata'] as int,
      subscription: json['subscription'] as int?,
      completedAt: DateTime.parse(json['completed_at']),
      user: json['user'] as int,
    );
  }
}
