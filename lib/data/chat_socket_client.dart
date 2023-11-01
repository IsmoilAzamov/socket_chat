import 'package:web_socket_channel/io.dart';

// late IOWebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.lipe.uz:443/app/lipeapp_key?protocol=7&version=4.3.1&flash=true&cluster=mt1&broadcaster=pusher'),
//     headers: {'websocket': 'pusher', 'connection': 'Upgrade', 'channel': 'Test'});

class ChatSocketClient {
  late IOWebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.lipe.uz:443/app/lipeapp_key?protocol=7&version=4.3.1&flash=true&cluster=mt1&broadcaster=pusher'),
      headers: {'websocket': 'pusher', 'connection': 'Upgrade', 'channel': 'Test'});

  void sendMessage(String message) {
    //channel Test ga yozish
   String str="""{"channel":"Test", "event":"test", "data":"{\\"message\\":\\"$message\\"}"}""";
   print(str);
  channel.sink.add(str);


  }

  void subscribe() {
    channel.sink.add('{"event":"pusher:subscribe","data":{"channel":"Test"}}');
  }

  void unsubscribe() {
    channel.sink.add('{"event":"pusher:unsubscribe","data":{"channel":"Test"}}');
  }

  void close() {
    channel.sink.close();
  }
  Future<bool> isConnect()async{
    return await channel.sink.done;
  }


}
