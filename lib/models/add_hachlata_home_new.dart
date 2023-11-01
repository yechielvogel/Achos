class AddHachlataHomeNew {
  final String uid;
  final String name;
  final String date;
  final String hebrewdate;

  final String color;

  AddHachlataHomeNew({
    required this.uid,
    required this.name,
    required this.date,
    required this.hebrewdate,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddHachlataHomeNew &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color == other.color &&
          date == other.date &&
          uid == other.uid;

  @override
  int get hashCode =>
      name.hashCode ^ color.hashCode ^ date.hashCode ^ uid.hashCode;
  String toString() {
    return 'AddHachlataHomeNew { uid: $uid, name: $name, date: $date, hebrew date: $hebrewdate, color: $color }';
  }
}
