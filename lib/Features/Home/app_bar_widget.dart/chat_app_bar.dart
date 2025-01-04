import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/profile_icon.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void goBack(BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return AppBar(
      title: Text(
        'Chats ',
        style: TextStyle(
          fontFamily: 'carter',
          color: theme == Pallete.darkModeAppTheme
              ? Pallete.appColorDark 
              : Pallete.appColorLight,
        ),
      ),
      centerTitle: false,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => kIsWeb ? goBack(context):displayMenuDrawer(context),
          icon: kIsWeb 
          ? Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: theme == Pallete.darkModeAppTheme
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          )
          : Icon(
            Icons.menu,
            size: 35,
            color: theme == Pallete.darkModeAppTheme
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
        );
      }),
      actions:  [
        ProfileIcon(
          radius: 35,
          profilePic: user.profilePic,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
