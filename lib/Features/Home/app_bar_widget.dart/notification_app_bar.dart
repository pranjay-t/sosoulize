import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/profile_icon.dart';

class NotificationAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifierProvider);
    return AppBar(
      title: Text(
        'Notifications ',
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
          onPressed: () => displayMenuDrawer(context),
          icon:const Icon(
            Icons.menu,
            size: 35,
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
