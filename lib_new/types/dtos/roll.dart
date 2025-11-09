class Roll {
  final int? id;
  final String? name;
  final String description;
  final String? createdAt;

  Roll({
    this.id,
    this.name,
    this.description = '',
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
    };
  }

  factory Roll.fromJson(Map<String, dynamic> json) {
    return Roll(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String?,
    );
  }
}
