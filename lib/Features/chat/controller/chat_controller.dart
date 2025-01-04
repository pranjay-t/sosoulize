import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/chat/repository/chat_repository.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/models/message_model.dart';
import 'package:sosoulize/models/user_models.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

final fetchAllChatRoomsProvider = StreamProvider((ref) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.fetchAllChatRooms();
});

final getMessageProvider = StreamProvider.family((ref,String receiverId) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.getMessages(receiverId);
});

class ChatController {
  final ChatRepository _chatRepository;
  final Ref _ref;
  ChatController({
    required ChatRepository chatRepository,
    required Ref ref,
  })  : _chatRepository = chatRepository,
        _ref = ref;

  void createMessage({
    required BuildContext context,
    required String receiverId,
    required String message,
    required String timestamp,
  }) {
    final userId = _ref.read(userProvider)!.uid;
    try {
      _chatRepository.createMessage(
        newMessage: Message(
          senderId: userId,
          receiverId: receiverId,
          message: message,
          timestamp: timestamp,
        ),
        senderId: userId,
        receiverId: receiverId,
      );
    } catch (e) {
      Failure(e.toString());
    }
  }

  Stream<List<Message>> getMessages(String receiverId) {
    final senderId = _ref.read(userProvider)!.uid;
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _chatRepository.getMessages(chatRoomId);
  }

  Stream<List<UserModels>> fetchAllChatRooms() {
    final userId = _ref.read(userProvider)!.uid;
    return _chatRepository.fetchAllChatRooms(userId);
  }
}
