

import 'package:equatable/equatable.dart';
import 'package:socket/domain/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatMessageReceivedState extends ChatState {
  const ChatMessageReceivedState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatMessagesLoadedState extends ChatState {
  const ChatMessagesLoadedState(this.messages);

  final List<MessageModel> messages;

  @override
  List<Object> get props => [messages];
}



class ChatMessageDeletedState extends ChatState {
  const ChatMessageDeletedState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatMessagesErrorState extends ChatState {
  const ChatMessagesErrorState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

