

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatStartedEvent extends ChatEvent {}
class ChatMessageReceivedEvent extends ChatEvent {
  const ChatMessageReceivedEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatMessageSentEvent extends ChatEvent {
  const ChatMessageSentEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
class ChatPhotoSelectedState extends ChatEvent {
  const ChatPhotoSelectedState(this.photoStr);

  final String photoStr;

  @override
  List<Object> get props => [photoStr];
}

class ChatMessageDeletedEvent extends ChatEvent {
  const ChatMessageDeletedEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatMessageEditedEvent extends ChatEvent {
  const ChatMessageEditedEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}


