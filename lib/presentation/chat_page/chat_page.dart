import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket/data/chat_socket_client.dart';
import 'package:socket/presentation/chat_page/widgets/message_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/has_network.dart';
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
  String photo = "";

  _getPhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      //get base64 photo from image
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Do you want to send this photo?"),
                content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.file(File(image.path), fit: BoxFit.cover, frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      } else {
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      }
                    }, errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text("Error"),
                      );
                    })),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18))),
                  TextButton(
                      onPressed: () async {
                        final File imageTemporary = File(image.path);
                        final imagePermanent = await saveImagePermanently(imageTemporary);
                        photo = base64Encode(imagePermanent.readAsBytesSync());
                        _bloc.add(ChatPhotoSelectedState(photo));
                        setState(() {});
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text("Send", style: TextStyle(color: Colors.red, fontSize: 18))),
                ],
              );
            });
      }
    }
  }

  Future<File> saveImagePermanently(File imageTemporary) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePermanent = await imageTemporary.copy('${directory.path}/${imageTemporary.path.split('/').last}');
    return imagePermanent;
  }

  ChatSocketClient chatSocketClient = ChatSocketClient();

  @override
  void initState() {
    _bloc.add(ChatStartedEvent());
    chatSocketClient.subscribe();
    chatSocketClient.channel.stream.listen((event) {
      if (event.contains("message")) {
        chatSocketClient.sendMessage(_controller.text);
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        backgroundColor: const Color(0xffffbb00),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        elevation: 1,
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
                        child: ListView.builder(
                            shrinkWrap: false,
                            reverse: true,
                            dragStartBehavior: DragStartBehavior.down,
                            itemCount: state.messages.length,
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            itemBuilder: (_, index) {
                              return state.messages.isNotEmpty
                                  ? messageItem(context: context, size: MediaQuery.of(context).size.width * 0.85, message: state.messages[state.messages.length - 1 - index])
                                  : Container();
                            }),
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
    chatSocketClient.close();
    _controller.dispose();
    super.dispose();
  }

  _customTextField() {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(right: 8, left: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Color(0xffe0e0e0)),
        ),
        //elevation only top
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Center(
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.text,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            border: InputBorder.none,
            hintText: 'Enter a message',
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //check if keyboard is open
                    MediaQuery.of(context).viewInsets.bottom > 0.0
                        ? IconButton(
                            onPressed: () async {
                              if (await hasNetwork()) {
                                if (_controller.text.isNotEmpty) {
                                  _bloc.add(ChatMessageSentEvent(_controller.text));
                                  chatSocketClient.sendMessage(_controller.text);
                                  _controller.clear();
                                  if (mounted) FocusScope.of(context).unfocus();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.send_outlined,
                              color: Color(0xffffbb00),
                              size: 32.0,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              _getPhoto();
                            },
                            icon: const Icon(
                              Icons.attach_file,
                              color: Color(0xaa4444aa),
                              size: 32.0,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
