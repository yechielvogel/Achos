class Contact {
  final int id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phoneNumber;
  final String? grade;

  Contact({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.phoneNumber,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'grade': grade,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      grade: json['grade'] as String?,
    );
  }
}
