class School {
  final int id;
  final String? name;

  School({
    required this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int,
      name: json['name'] as String?,
    );
  }
}
