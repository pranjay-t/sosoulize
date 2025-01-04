import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/posts/controller/post_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/alert_custom_dialog_box.dart';
import 'package:sosoulize/models/post_model.dart';

class HomeShowModalDialog extends ConsumerWidget {
  final Post post;
  const HomeShowModalDialog({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context, Post post) {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final user = ref.watch(userProvider)!;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: theme == ThemeMode.dark
              ? Pallete.appColorDark
              : Pallete.appColorLight,
          context: context,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                if (post.uid == user.uid)
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        deletePost(ref, context, post);
                        Navigator.pop(context);
                      },
                      icon: theme == ThemeMode.dark
                          ? Icon(
                              Icons.delete,
                              color: Pallete.redColor,
                            )
                          : const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'carter',
                        color: (theme == ThemeMode.dark
                            ? Colors.black
                            : Colors.white),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertCustomDialogBox(
                            onPressed: () => deletePost(ref, context, post),
                          );
                        },
                      );
                    },
                  ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: (theme == ThemeMode.dark
                          ? Colors.black
                          : Colors.white),
                    ),
                  ),
                  title: Text(
                    'save',
                    style: TextStyle(
                      fontFamily: 'carter',
                      color:
                          theme == ThemeMode.dark ? Colors.black : Colors.white,
                    ),
                  ),
                  onTap: () {},
                )
              ],
            );
          },
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
