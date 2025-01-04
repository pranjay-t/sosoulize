import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/commons/post_card.dart';
import 'package:sosoulize/core/commons/profile_buttons.dart';
import 'package:sosoulize/core/commons/profile_icon.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:sosoulize/Features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/${widget.uid}');
  }

  void navigateToMessageScreen(BuildContext context,String receiverId) {
    Routemaster.of(context).push('/message/$receiverId');
  }

  @override
  Widget build(BuildContext context) {
    final mainUser = ref.watch(userProvider)!.uid;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final isGuest = !ref.watch(userProvider)!.isAuthenticated;
    return Scaffold(
      body: ref.watch(getUserDataProvider(widget.uid)).when(
            data: (user) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      leading: Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight,
                            ),
                          );
                        }
                      ),
                      expandedHeight: 200,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: user.uid == mainUser ? 48 : 48,
                                  left: 20),
                              child:  ProfileIcon(radius: 100,profilePic: user.profilePic),
                            ),
                          ),
                        ],
                      ),
                      bottom: AppBar(
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FittedBox(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 22, fontFamily: 'carter'),
                                ),
                              ),
                            if(!isGuest)
                              user.uid == mainUser
                                ? ProfileButtons(
                                  label: 'Edit Profile',
                                  onPressed: () =>
                                      navigateToEditProfile(context),
                                )
                              : ProfileButtons(
                                label: 'Message',
                                onPressed: () => navigateToMessageScreen(context,user.uid),
                              ),
                            ],
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 26),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Text(
                              'u/${user.name} • ${user.karma} karma',
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'carter'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ref.watch(getUserPostsProvider(user.uid)).when(
                        data: (posts) {
                          return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final post = posts[index];
                              return PostCard(
                                post: post,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: 'No posts yet!');
                        },
                        loading: () => const Loader(),
                      ),
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
