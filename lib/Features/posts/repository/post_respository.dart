import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/core/constants/firebase_constants.dart';
import 'package:sosoulize/core/constants/type_def.dart';
import 'package:sosoulize/models/comment_model.dart';
import 'package:sosoulize/models/community_model.dart';
import 'package:sosoulize/models/post_model.dart';
import 'package:sosoulize/core/providers/auth_provider.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRespository(firestore: ref.watch(firestoreProvider));
});

class PostRespository {
  final FirebaseFirestore _firestore;
  PostRespository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<CommunityModel> communities) {
    try {
      return _posts
          .where(
            'communityName',
            whereIn: communities.map((e) => e.name).toList(),
          )
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => Post.fromMap(e.data() as Map<String, dynamic>),
                )
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Stream.value([]);
    }
  }

  Stream<List<Post>> fetchGuestPosts() {
    try {
      return _posts
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => Post.fromMap(e.data() as Map<String, dynamic>),
                )
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Stream.value([]);
    }
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (e) => Post.fromMap(e.data() as Map<String, dynamic>),
        );
  }

  FutureVoid addComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommentModel>> getCommentOfPosts(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => CommentModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
