import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/posts/controller/post_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/models/post_model.dart';

class UpvoteDownvoteWidget extends ConsumerWidget {
  final Post post;
  const UpvoteDownvoteWidget({
    super.key,
    required this.post,
  });

  void upvote(Post post, WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).upvote(post);
  }

  void downvote(Post post, WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).downvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return kIsWeb ?
    Column(
      children: [
        IconButton(
          onPressed: () => isGuest ? null : upvote(post, ref),
          icon: post.upvotes.contains(user.uid)
              ? Icon(
                  Icons.thumb_up,
                  size: 30,
                  color: (theme == ThemeMode.dark
                      ? Pallete.appColorDark
                      : Pallete.appColorLight),
                )
              : Icon(
                  Icons.thumb_up_outlined,
                  size: 30,
                  color: (theme == ThemeMode.dark
                      ? Pallete.appColorDark
                      : Pallete.appColorLight),
                ),
        ),
        Text(
          '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
          style: const TextStyle(fontSize: 17, fontFamily: 'carter'),
        ),
        IconButton(
          onPressed: () => isGuest ? null : downvote(post, ref),
          icon: post.downvotes.contains(user.uid)
              ? Icon(
                  Icons.thumb_down,
                  size: 30,
                  color: (theme == ThemeMode.dark
                      ? Pallete.appColorDark
                      : Pallete.appColorLight),
                )
              : Icon(
                  Icons.thumb_down_outlined,
                  size: 30,
                  color: (theme == ThemeMode.dark
                      ? Pallete.appColorDark
                      : Pallete.appColorLight),
                ),
        ),
      ],
    )
    :FittedBox(
      child: Row(
        children: [
          IconButton(
            onPressed: () => isGuest ? null : upvote(post, ref),
            icon: post.upvotes.contains(user.uid)
                ? Icon(
                    Icons.thumb_up,
                    size: 30,
                    color: (theme == ThemeMode.dark
                        ? Pallete.appColorDark
                        : Pallete.appColorLight),
                  )
                : Icon(
                    Icons.thumb_up_outlined,
                    size: 30,
                    color: (theme == ThemeMode.dark
                        ? Pallete.appColorDark
                        : Pallete.appColorLight),
                  ),
          ),
          Text(
            '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
            style: const TextStyle(fontSize: 17, fontFamily: 'carter'),
          ),
          IconButton(
            onPressed: () => isGuest ? null : downvote(post, ref),
            icon: post.downvotes.contains(user.uid)
                ? Icon(
                    Icons.thumb_down,
                    size: 30,
                    color: (theme == ThemeMode.dark
                        ? Pallete.appColorDark
                        : Pallete.appColorLight),
                  )
                : Icon(
                    Icons.thumb_down_outlined,
                    size: 30,
                    color: (theme == ThemeMode.dark
                        ? Pallete.appColorDark
                        : Pallete.appColorLight),
                  ),
          ),
        ],
      ),
    );
  }
}
