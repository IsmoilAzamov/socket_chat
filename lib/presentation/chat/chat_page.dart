import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socket/domain/chat_model.dart';
import 'package:socket/presentation/chat/widgets/message_item.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ChatPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final _bloc = ChatBloc();
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isListening = false;

  late IOWebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.lipe.uz:443/app/lipeapp_key?protocol=7&version=4.3.1&flash=true&cluster=mt1&broadcaster=pusher'),
      headers: {'websocket': 'pusher', 'connection': 'Upgrade', 'channel': 'Test'});

  @override
  void initState() {
    channel.sink.add('{"event":"pusher:subscribe","data":{"channel":"Test"}}');
    channel.stream.listen((event) {
      if (event.contains("message")) {
        _bloc.add(ChatMessageReceivedEvent(event));
      }
      setState(() {});
    }, onDone: () {
      print('Done');
    }, onError: (error) {
      _bloc.add(ChatMessageReceivedEvent(error.toString()));
      print(error.toString());
    });
    //check subscription

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffffbb00),
        title: Text(widget.title),
        elevation: 2,
      ),
      body: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is ChatInitialState) {
                      return const Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            'No messages yet',
                            style: TextStyle(color: Colors.black45, fontSize: 18, fontWeight: FontWeight.w400),
                          )),
                        ],
                      ));
                    } else if (state is ChatMessageReceivedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xffffbb00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(state.message, style: const TextStyle(color: Colors.black)),
                          ),
                        ],
                      );
                    } else if (state is ChatMessagesLoadedState) {
                      return Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          child: ListView.builder(
                              shrinkWrap: true,
                              dragStartBehavior: DragStartBehavior.down,
                              itemCount: state.messages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return messageItem(size: MediaQuery.of(context).size.width * 0.75, message: state.messages[index]);
                              }),
                        ),
                      );
                    } else if (state is ChatMessageDeletedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xffffbb00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(state.message, style: const TextStyle(color: Colors.black)),
                          ),
                        ],
                      );
                    } else {
                      return const Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          )),
                        ],
                      ));
                    }
                  }),
              _customTextField()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  _customTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
          keyboardType: TextInputType.text,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter a message',
              suffix: IconButton(
                onPressed: () {
                  _bloc.add(ChatMessageSentEvent(_controller.text));
                  //subscribe to send message
                  //send message

                  channel.sink.add('{"event":"test","data":{"message":"${_controller.text}"}}');
                  if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 100) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent - 100,
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      curve: Curves.easeInOut,
                    );
                  }
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                  //close keyboard
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xffffbb00),
                  size: 32.0,
                ),
              ))),
    );
  }
}
