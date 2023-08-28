class Videogame {
  final String id;
  final String name;
  final int votes;

  Videogame({required this.id, required this.name, required this.votes});

  factory Videogame.fromMap(Map<String, dynamic> map) => Videogame(
        id: map["id"] as String? ?? 'no-id',
        name: map["name"] as String? ?? 'no-name',
        votes: map["votes"] as int? ?? 0,
      );
}
