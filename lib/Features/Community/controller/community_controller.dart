import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosoulize/Features/Community/repository/community_repository.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/core/constants/constants.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/models/community_model.dart';
import 'package:sosoulize/models/post_model.dart';
import 'package:sosoulize/core/providers/storage_repository_provider.dart';
import 'package:sosoulize/core/constants/utils.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider.family((ref,String uid) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities(uid);
});

final communityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getUserCommunityPostProvider = StreamProvider.family((ref, String communityName) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunityPosts(communityName);
  
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(cloudinaryStorageProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    
    CommunityModel community = CommunityModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);

    state = false;
    res.fold(
      (l) => showSnackBar(context, 'No NAME, no FAME! A name is the first step to Global Domination!'),
      (r) {
        showSnackBar(context, 'Community created sucessfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void joinCommunity(CommunityModel community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'Community Leaved Successfully');
      } else {
        showSnackBar(context, 'Community Joined Successfully');
      }
    });
  }

  void addMods(String communityName,List<String> uids,BuildContext context) async{
    final res = await _communityRepository.addMods(communityName, uids);

    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) {
        showSnackBar(context, 'Saved successfully!');
        Routemaster.of(context).pop();
      }
      );
  }

  Stream<CommunityModel> getCommunityName(String name) {
    return _communityRepository.getCommunityName(name);
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? webProfileFile,
    required Uint8List? webBannerFile,
    required BuildContext context,
    required CommunityModel community,
  }) async {
    state = true;
    if (profileFile != null || webProfileFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/profile',
        id: community.name,
        files: profileFile != null ? [XFile(profileFile.path)] : [],
        webFiles:webProfileFile != null ? [webProfileFile] : [],
        isVideo: false,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (r) {
        community = community.copyWith(avatar: r[0]);
      });
    }
    if (bannerFile != null || webBannerFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/banner',
        id: community.name,
        files: bannerFile!= null ? [XFile(bannerFile.path)] : [],
        webFiles: webBannerFile != null ? [webBannerFile] : [],
        isVideo: false,
      );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(banner: r[0]);
      });
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
      showSnackBar(context, 'Saved sucessfully');
    });
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    // final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<List<Post>> getUserCommunityPosts(String communityName) {
    return _communityRepository.getUserCommunityPosts(communityName);
  }

}
