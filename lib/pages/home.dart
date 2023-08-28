import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:videogames_voter/models/videogame.dart';
import 'package:videogames_voter/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Videogame> videogames = [];

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-videogames', _handleActiveVideogames);
  }

  _handleActiveVideogames(dynamic payload) {
    if (payload is List) {
      videogames =
          payload.map((videogame) => Videogame.fromMap(videogame)).toList();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-videogames');
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Videogames Names',
              style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: <Widget>[
            Container(
                margin: const EdgeInsets.only(right: 10),
                // child: Icon(Icons.check_circle, color: Colors.blue[300]),
                child: (socketService.serverStatus == ServerStatus.offline)
                    ? Icon(Icons.offline_bolt, color: Colors.red[300])
                    : Icon(Icons.check_circle, color: Colors.green[300]))
          ],
        ),
        body: Column(children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: videogames.length,
              itemBuilder: (context, index) =>
                  _videogameTile(videogames[index]),
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewVideogame,
          child: const Icon(Icons.add),
        ));
  }

  Widget _videogameTile(Videogame videogame) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(videogame.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          socketService.emit('delete-videogame', {'id': videogame.id}),
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
          onTap: () =>
              socketService.emit('vote-videogame', {'id': videogame.id})),
    );
  }

  addNewVideogame() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      setState(() {
        socketService.emit('add-videogame', {'name': name});
      });
    }

    Navigator.of(context).pop();
  }

//?Show Graph
  _showGraph() {
    Map<String, double> dataMap = {};
    // dataMap.putIfAbsent('Flutter', () => 5);
    for (var videogame in videogames) {
      dataMap.putIfAbsent(videogame.name, () => videogame.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!,
      Colors.green[50]!,
      Colors.green[200]!,
      Colors.purple[50]!,
      Colors.purple[200]!,
    ];

    return SizedBox(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 2.7,
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ));
  }
}
