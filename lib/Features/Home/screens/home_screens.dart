// ignore_for_file: deprecated_member_use

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/Home/drawers/community_list_drawer.dart';
import 'package:sosoulize/Features/Home/drawers/profile_drawer.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/constants/constants.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreens extends ConsumerStatefulWidget {
  const HomeScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreensState();
}

class _HomeScreensState extends ConsumerState<HomeScreens> {
  void displayMenuDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-posts');
  }

  final _pageController = NotchBottomBarController();

  void pageChange(int page) {
    setState(() {
      _pageController.index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Scaffold(
      appBar: Constants.appBarWidget[_pageController.index],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      body: Constants.tabWidgets[_pageController.index],
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : AnimatedNotchBottomBar(
              notchBottomBarController: _pageController,
              notchColor: theme == ThemeMode.dark
                  ? Pallete.appColorDark
                  : Pallete.appColorLight,
              color: theme == ThemeMode.dark
                  ? const Color.fromARGB(255, 47, 47, 47)
                  :const Color(0XFFe5e5e5),
              showShadow: false,
              bottomBarHeight: 10,
              durationInMilliSeconds: 300,
              itemLabelStyle: TextStyle(
                color: theme == ThemeMode.dark
                    ? Colors.white
                    : const Color.fromARGB(255, 83, 81, 81),
                fontFamily: 'carter',
                fontSize: 12,
              ),
              onTap: pageChange,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: FaIcon(
                    FontAwesomeIcons.home,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Icon(
                    Icons.home,
                    size: 26,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: FaIcon(
                    FontAwesomeIcons.plus,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: FaIcon(
                    FontAwesomeIcons.plus,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Create',
                ),
                BottomBarItem(
                  inActiveItem: FaIcon(
                    FontAwesomeIcons.solidComments,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: FaIcon(
                      FontAwesomeIcons.solidComments,
                      color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                    ),
                  ),
                  itemLabel: 'Chat',
                ),
                BottomBarItem(
                  inActiveItem: FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color.fromARGB(255, 83, 81, 81),
                  ),
                  activeItem: FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  itemLabel: 'Notification',
                ),
              ],
              kIconSize: 20,
              kBottomRadius: 20,
            ),
    );
  }
}
