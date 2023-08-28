import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videogames_voter/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Status Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Server Status: ${socketService.serverStatus}'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            socketService.emit('emit-message',
                {'name': 'Flutter', 'message': 'Hello from Flutter'});
          },
        ));
  }
}
