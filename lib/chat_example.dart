

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ChatExamplePage extends StatefulWidget {
  const ChatExamplePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ChatExamplePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatExamplePage> {
  // const echo = new Echo({
  //   cluster: 'mt1', // Replace with your Pusher cluster
  //   encrypted: true,
  //   wsHost: 'ws.lipe.uz', // Replace with your WebSocket host
  //   wsPort: 443, // Adjust the port as needed
  // });
  // channel

  final _controller = TextEditingController();

  late IOWebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.lipe.uz:443/app/lipeapp_key?protocol=7&version=4.3.1&flash=true&cluster=mt1&broadcaster=pusher'),
      headers: {'websocket': 'pusher', 'connection': 'Upgrade', 'channel': 'Test'});

  @override
  void initState() {
    channel.sink.add('{"event":"pusher:subscribe","data":{"channel":"Test"}}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffbb00),
      appBar: AppBar(
        backgroundColor: const Color(0xffffbb00),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed:(){}
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        elevation: 1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatefulBuilder(
              builder: (context, setState2) {

                return Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return const Text('No data');
                      }
                    },
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric( vertical: 4, horizontal:6),
              margin:  const EdgeInsets.symmetric( vertical:8, horizontal: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(

                      border: InputBorder.none,
                      hintText: 'Enter a message',
                      suffix: IconButton(
                        onPressed: (){
                          channel.sink.add('{"event":"test","data":{"message":"${_controller.text}"}}');
                          _controller.clear();
                        },
                        icon: const Icon(Icons.send, color: Color(0xffffbb00),),
                      )
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
