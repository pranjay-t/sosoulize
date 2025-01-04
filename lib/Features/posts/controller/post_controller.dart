import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/posts/repository/post_respository.dart';
import 'package:sosoulize/core/enums/enums.dart';
import 'package:sosoulize/models/comment_model.dart';
import 'package:sosoulize/models/community_model.dart';
import 'package:sosoulize/models/post_model.dart';
import 'package:sosoulize/core/providers/storage_repository_provider.dart';
import 'package:sosoulize/Features/user_profile/controller/user_profile_controller.dart';
import 'package:sosoulize/core/constants/utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';


final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(cloudinaryStorageProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final userPostsProvider = StreamProvider.family((ref,List<CommunityModel> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final getPostCommentProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getCommentOfPosts(postId);
});

final getPostForGuestProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).fetchGuestPosts();
});

class PostController extends StateNotifier<bool> {
  final PostRespository _postRepository;
  final StorageRepository _storageRepository;

  final Ref _ref;
  PostController({
    required PostRespository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required String description,
    required CommunityModel selectedcommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.textPost);

    final post = Post(
      id: postId,
      title: title,
      link: [],
      communityName: selectedcommunity.name,
      communityProfilePic: selectedcommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required List<String> link,
    required CommunityModel selectedcommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.linkPost);

    final post = Post(
      id: postId,
      title: title,
      communityName: selectedcommunity.name,
      communityProfilePic: selectedcommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareFilePost( {
    required BuildContext context,
    required String title,
    required List<XFile> files,
    required List<Uint8List> webFiles,
    required CommunityModel selectedcommunity,
    required bool isVideo,
  }) async {

    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final fileRes = await _storageRepository.storeFiles(
      path: 'posts/${selectedcommunity.name}',
      id: postId,
      files: files,
      webFiles: webFiles,
      isVideo: isVideo,
    );
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.imagePost);

    fileRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final post = Post(
          id: postId,
          title: title,
          communityName: selectedcommunity.name,
          communityProfilePic: selectedcommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type:isVideo ? 'video' : 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        final res = await _postRepository.addPost(post);
        state = false;

        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, 'Posted Successfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  

  void deletePost(Post post,BuildContext context) async {
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.deletePost);

     final res = await _postRepository.deletePost(post);
     res.fold((l) => showSnackBar(context, l.message), (r) => showSnackBar(context,'Deleted Successfully'));
  }

  void upvote(Post post){
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, userId);
  }
  void downvote(Post post){
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, userId);
  }


  Stream<List<Post>> fetchUserPosts(List<CommunityModel> communities) {
    if(communities.isNotEmpty){
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required String text,
    required String postId,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.comment);

    final commentId = const Uuid().v1();
    CommentModel comment = CommentModel(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: postId,
      username: user.name,
      profilePic: user.profilePic,
      userId: user.uid,
    );
    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }


  Stream<List<CommentModel>> getCommentOfPosts(String postId) {
    return _postRepository.getCommentOfPosts(postId);
  }

}
