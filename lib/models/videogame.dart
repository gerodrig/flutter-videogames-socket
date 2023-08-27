class Videogame {
  String id;
  String name;
  int votes;

  Videogame({required this.id, required this.name, required this.votes});

  factory Videogame.fromJson(Map<String, dynamic> json) => Videogame(
        id: json["id"],
        name: json["name"],
        votes: json["votes"],
      );
}
