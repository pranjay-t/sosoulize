import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/core/constants/firebase_constants.dart';
import 'package:sosoulize/core/constants/type_def.dart';
import 'package:sosoulize/core/providers/auth_provider.dart';
import 'package:sosoulize/models/message_model.dart';
import 'package:sosoulize/models/user_models.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(firestore: ref.watch(firestoreProvider));
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createMessage({
    required Message newMessage,
    required String senderId,
    required String receiverId,
  }) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      final chatRoomDoc = await _chats.doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await _chats.doc(chatRoomId).set({
          'participants': ids,
          'lastMessage': newMessage.message,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        await _chats.doc(chatRoomId).update({
          'lastMessage': newMessage.message,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      await _chats
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    return _chats
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Message.fromMap(e.data()),
              )
              .toList(),
        );
  }

  Stream<List<UserModels>> fetchAllChatRooms(String userId) {
    return _chats
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
        List<UserModels> userModels = [];

      for (var doc in snapshot.docs) {
        final participants = List<String>.from(
          (doc.data() as Map<String, dynamic>)['participants'],
        );

        final otherUserId = participants.firstWhere((id) => id != userId);

        final userDoc =
            await _firestore.collection('users').doc(otherUserId).get();

        if (userDoc.exists) {
          userModels.add(
            UserModels.fromMap(userDoc.data() as Map<String, dynamic>),
          );
        }
      }

      return userModels;
    });
  }

  CollectionReference get _chats =>
      _firestore.collection(FirebaseConstants.chatsCollection);
}
