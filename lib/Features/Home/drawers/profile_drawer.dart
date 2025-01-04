import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logOut(WidgetRef ref) {
  ref.watch(authControllerProvider.notifier).logOut();
  clearLocalData();
}

void clearLocalData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

void navigateToUserProfile(String uid, BuildContext context) {
  Routemaster.of(context).push('/user-profile/$uid');
}

void toggleTheme(WidgetRef ref) {
  return ref.read(themeNotifierProvider.notifier).toggleTheme();
}

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'u/${user.name}',
            style: const TextStyle(fontSize: 16, fontFamily: 'carter'),
          ),
          const Divider(
            thickness: 0.7,
          ),
          ListTile(
            title: const Text(
              'My Profile',
              style: TextStyle(fontSize: 16, fontFamily: 'carter'),
            ),
            leading:  Builder(
              builder: (context) {
                return Icon(
                  Icons.person,
                  color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
                );
              }
            ),
            onTap: () => navigateToUserProfile(user.uid, context),
          ),
          ListTile(
            title: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontFamily: 'carter'),
            ),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () {
              logOut(ref);
            },
          ),
            const Divider(
            thickness: 0.7,
            ),
            ListTile(
            title:  Text(
              theme !=
                ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
              style:const TextStyle(fontSize: 16, fontFamily: 'carter'),
            ),
            trailing: Switch.adaptive(
              value: theme ==
                ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
              activeTrackColor: Pallete.appColorDark,
              inactiveTrackColor: Pallete.appColorLight,
              activeColor: Colors.black,
              inactiveThumbColor: Colors.white,
            ),
            ),
        ],
      )),
    );
  }
}