import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket/domain/chat_model.dart';

import '../../../main.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<MessageModel> messages = [];


  ChatBloc() : super(ChatInitialState()) {
    on<ChatStartedEvent>((event, emit) {
      // channel.sink.add('{"event":"pusher:subscribe","data":{"channel":"Test"}}');
      List<dynamic> list = box.get('messages', defaultValue: []);
      messages = list.map((e) => e as MessageModel).toList();

      emit(ChatMessagesLoadedState(messages));
    });

    on<ChatMessageReceivedEvent>((event, emit) {
      MessageModel messageModel = MessageModel(
        message: getMessage(event.message),
        time: DateTime.now().toString(),
        isMe: false,
        isRead: false,
        isPhoto: false,
        isSelected: false,
      );
      messages.add(messageModel);
      box.put('messages', messages);

      emit(ChatMessagesLoadedState(messages));
    });
    on<ChatMessageSentEvent>((event, emit) {
      MessageModel messageModel = MessageModel(
        message: event.message,
        time: DateTime.now().toString(),
        isMe: true,
        isRead: true,
        isPhoto: false,
        isSelected: false,
      );

      messages.add(messageModel);
      box.put('messages', messages);
      emit(ChatMessagesLoadedState(messages));
    });
    on<ChatPhotoSelectedState>((event, emit) {
      MessageModel messageModel = MessageModel(
        message: event.photoStr,
        time: DateTime.now().toString(),
        isMe: true,
        isRead: true,
        isPhoto: true,
        isSelected: false,
      );

      messages.add(messageModel);
      box.put('messages', messages);


      emit(ChatMessagesLoadedState(messages));

    });
    // channel.stream.listen((event) {
    //   print(event);
  }
}

String getMessage(event2) {
  //get message from event
  //'{"channel":"Test","event":"test","data":"{\"PPP\":{\"message\":\"Salom\",\"time\":\"1223\"}}"}'
  if (!event2.contains("message")) {
    return "";
  }
  print(event2);
  try {
    String jsonString = event2;
    Map<String, dynamic> decodedJson = json.decode(jsonString);
    String channel = decodedJson["channel"];
    String event = decodedJson["event"];
    String dataJsonString = decodedJson["data"];
    Map<String, dynamic> dataJson = json.decode(dataJsonString);
    String message = dataJson["message"];

    print(channel); // Output: Test
    print(event); // Output: test
    print(message); // Output: Salom// Output: 1223

    return message;
  } catch (e) {
    print(e);
    return '';
  }
}
