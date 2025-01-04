import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:sosoulize/core/constants/firebase_constants.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/core/constants/type_def.dart';
import 'package:sosoulize/models/community_model.dart';
import 'package:sosoulize/models/post_model.dart';
import 'package:sosoulize/core/providers/auth_provider.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(CommunityModel community) async {
    try {
      var communityName = await _communities.doc(community.name).get();
      if (communityName.exists) {
        throw Failure('Community with the same name exists!');
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return  _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        try {
          communities
              .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
        } catch (e) {
          ErrorText(error: e.toString());
        }
      }
      return communities;
    });
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        try {
          communities
              .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
        } catch (e) {
          ErrorText(error: e.toString());
        }
      }
      return communities;
    });
  }

  Stream<CommunityModel> getCommunityName(String name) {
    return _communities.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayUnion([userId]),
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String communityName,List<String> uids) async{
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'mods' : uids,
          }
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayRemove([userId]),
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserCommunityPosts(String communityName) {
    try {
      return _posts.where('communityName', isEqualTo: communityName).orderBy('createdAt',descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
    } catch (e) {
      return Stream.empty();
    }
  }
  
  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

      CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

}
