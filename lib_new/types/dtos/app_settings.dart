import 'school.dart';

class AppSettings {
  int? id;
  final bool? isEditingEnabled;
  final School? school;

  AppSettings({
    this.id,
    this.isEditingEnabled,
    this.school,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'is_editing_enabled': isEditingEnabled,
      'school': school?.toJson(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      id: json['id'] as int,
      isEditingEnabled: json['is_editing_enabled'] as bool?,
      school: json['school'] != null ? School.fromJson(json['school']) : null,
    );
  }
}
