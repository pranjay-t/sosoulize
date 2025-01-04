import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name/');
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/add-mod/$name/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return Scaffold(
      appBar: AppBar(

        title: Text(
          'Mod Tools',
          style: TextStyle(
            fontFamily: 'carter',
            color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
        ),
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
        ),
      ),
      body: Center(
        child: Responsive(
          child: Column(
            children: [
              ListTile(
                onTap: () => navigateToAddMod(context),
                title:const Text(
                  'Add Moderator',
                  style: TextStyle(
                    fontFamily: 'carter',
                  ),
                ),
                leading:const Icon(
                  Icons.add_outlined,
                ),
              ),
              ListTile(
                onTap: () => navigateToEditCommunity(context),
                title:const Text(
                  'Edit Community',
                  style: TextStyle(
                    fontFamily: 'carter',
                  ),
                ),
                leading:const Icon(
                  Icons.edit_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
