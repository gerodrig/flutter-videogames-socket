import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:videogames_voter/models/videogame.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Videogame> videogames = [
    Videogame(
        id: '4', name: 'The Legend of Zelda: Tears of the Kingdom', votes: 0),
    Videogame(id: '2', name: 'Super Mario Odyssey', votes: 0),
    Videogame(id: '3', name: 'Super Smash Bros. Ultimate', votes: 0),
    Videogame(
        id: '1', name: 'The Legend of Zelda: Breath of the Wild', votes: 0),
    Videogame(id: '5', name: 'Gears of War 5', votes: 0),
    Videogame(id: '5', name: 'Spiderman 2', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Videogames Names',
              style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: ListView.builder(
          itemCount: videogames.length,
          itemBuilder: (context, index) => _videogameTile(videogames[index]),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewVideogame,
          child: const Icon(Icons.add),
        ));
  }

  Widget _videogameTile(Videogame videogame) {
    return Dismissible(
      key: Key(videogame.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //Call the delete method in server
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(videogame.name.substring(0, 2).toUpperCase()),
          ),
          title: Text(videogame.name),
          trailing:
              Text('${videogame.votes}', style: const TextStyle(fontSize: 20)),
          onTap: () {}),
    );
  }

  addNewVideogame() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('New Videogame Name'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addVideogameToList(textController.text),
                child: const Text('Add'),
              )
            ]),
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
              title: const Text('New Videogame Name'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => addVideogameToList(textController.text),
                  child: const Text('Add'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ]);
        });
  }

  void addVideogameToList(String name) {
    if (name.isNotEmpty) {
      videogames
          .add(Videogame(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.of(context).pop();
  }
}
