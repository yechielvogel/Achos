import 'categories.dart';
import 'school.dart';

class Hachlata {
  final int? id;
  final School? school;
  final Category? category;
  final String name;
  final String? description;
  final String? photoUrl;
  final bool? isActive;

  Hachlata({
    this.id,
    required this.school,
    required this.category,
    required this.name,
    this.description,
    this.photoUrl,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'school': school?.toJson(),
      'category': category?.toJson(),
      'name': name,
      'description': description,
      'photo_url': photoUrl,
      'is_active': isActive,
    };
  }

  factory Hachlata.fromJson(Map<String, dynamic> json) {
    return Hachlata(
      id: json['id'] as int?,
      school: (json['school'] is Map<String, dynamic>)
          ? School.fromJson(json['school'])
          : null,
      category: (json['category'] is Map<String, dynamic>)
          ? Category.fromJson(json['category'])
          : null,
      name: json['name'] as String,
      description: json['description'] as String?,
      photoUrl: json['photo_url'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }
}
