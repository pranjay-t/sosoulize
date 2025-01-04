import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sosoulize/Features/Community/controller/community_controller.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/posts/controller/post_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/alert_custom_dialog_box.dart';
import 'package:sosoulize/core/commons/gift_award.dart';
import 'package:sosoulize/core/commons/home_show_modal_dialog.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/commons/multi_image_post.dart';
import 'package:sosoulize/core/commons/upvote_downvote_widget.dart';
import 'package:sosoulize/core/constants/constants.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:sosoulize/core/constants/video_post_card.dart';
import 'package:sosoulize/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

   void deletePost(WidgetRef ref, BuildContext context,Post post) {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final isTypeVideo = post.type == 'video';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final postCardSize = MediaQuery.of(context).size.height * 0.34;
    return Column(
      children: [
        Responsive(
          child: Container(
            decoration: BoxDecoration(
              color: theme == ThemeMode.dark
                  ? const Color.fromARGB(255, 27, 27, 27)
                  : const Color(0xFFe5e5e5),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (kIsWeb) UpvoteDownvoteWidget(post: post),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Builder(
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: Container(
                                        width: 54,
                                        height: 54,
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: theme == ThemeMode.dark
                                                  ? Pallete.appColorDark
                                                  : Pallete.appColorLight,
                                              width: 3),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                          child: Image.network(
                                            post.communityProfilePic,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () =>
                                                navigateToCommunity(context),
                                            child: FittedBox(
                                              child: Text(
                                                'r/${post.communityName}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'carter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Text(
                                          'u/${post.username}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'carter'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            HomeShowModalDialog(post: post),
                          ],
                        ),
                        if (post.awards.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 25,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.awards.length,
                              itemBuilder: (BuildContext context, int index) {
                                final award = post.awards[index];
                                final awardUrl = Constants.awards[award];
                                return Image.asset(
                                  awardUrl!,
                                  height: 23,
                                );
                              },
                            ),
                          ),
                        ],
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'carter',
                            ),
                          ),
                        ),
                        if (isTypeImage)
                          SizedBox(
                            height:kIsWeb ? 400 : postCardSize,
                            width: double.infinity,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 124, 121, 121),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MultiImagePost(
                                  imagesList: post.link,
                                ),
                              ),
                            ),
                          ),
                        if(isTypeVideo)
                          VideoPostCard(postVideo: post.link[0]),
                        if (isTypeLink)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: (post.link.isNotEmpty &&
                                    post.link[0].isNotEmpty)
                                ? AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionVertical,
                                    link: post.link[0],
                                    errorBody: 'Failed to load link preview.',
                                  )
                                : const Text('Error loading url'),
                          ),
                        if (isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              post.description!,
                              style: TextStyle(
                                fontFamily: 'carter',
                                color: theme == ThemeMode.light
                                    ? Colors.black
                                    : const Color.fromARGB(255, 211, 208, 208),
                              
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!kIsWeb) UpvoteDownvoteWidget(post: post),
                            Row(
                              children: [
                                FittedBox(
                                  child: IconButton(
                                    onPressed: () => isGuest ? null : navigateToComments(context),
                                    icon: FaIcon(
                                      FontAwesomeIcons.comment,
                                      color: theme == ThemeMode.dark
                                          ? Pallete.appColorDark
                                          : Pallete.appColorLight,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    style: const TextStyle(
                                        fontSize: 17, fontFamily: 'carter'),
                                  ),
                                ),
                              ],
                            ),
                            ref
                                .watch(communityByNameProvider(
                                    post.communityName))
                                .when(
                                  data: (community) {
                                    if (community.mods.contains(user.uid)) {
                                      return IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertCustomDialogBox(onPressed: () => deletePost(ref, context,post),);
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.admin_panel_settings,
                                          size: 28,
                                          color: theme == ThemeMode.dark
                                              ? Pallete.appColorDark
                                              : Pallete.appColorLight,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                  ),
                                  loading: () => const Loader(toShow: false,),
                                ),
                            FittedBox(child: GiftAward(post: post)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
