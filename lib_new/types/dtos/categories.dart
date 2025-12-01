import 'school.dart';

class Category {
  int? id;
  final String? name;
  final int? position;
  final School? school;

  Category({
    this.id,
    this.name,
    this.position,
    this.school,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'position': position,
      'school': school?.toJson(),
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
    );
  }
}
