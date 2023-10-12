class AddHachlataHome {
  final String uid;
  final String name;
  final String date;
  final String hebrewdate;

  final String color;
  

  AddHachlataHome(
      {required this.uid,
      required this.name,
      required this.date,
      required this.hebrewdate,
      required this.color});
  // this code helps the add hachlata admin check if the hachlata tiles are at home or not
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddHachlataHome &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color == other.color &&
          date == other.date &&
          uid == other.uid;

  @override
  int get hashCode =>
      name.hashCode ^ color.hashCode ^ date.hashCode ^ uid.hashCode;
}
