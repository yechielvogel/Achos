import 'school.dart';

class Category {
  int? id;
  final String? name;
  final int? position;
  final School? school;
  final String color;

  Category({
    this.id,
    this.name,
    this.position,
    this.school,
    this.color = '',
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'position': position,
      'school': school?.toJson(),
      'color': color,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String?,
      position: json['position'] as int?,
      school: (json['school'] is Map<String, dynamic>)
          ? School.fromJson(json['school'])
          : null,
      color: json['color'] as String? ?? '',
    );
  }
}
