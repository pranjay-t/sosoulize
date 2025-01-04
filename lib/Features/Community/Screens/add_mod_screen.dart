import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/Community/controller/community_controller.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/commons/profile_icon.dart';
import 'package:sosoulize/core/constants/error_text.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};

  void addMod(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeMod(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods(String communityName, List<String> uids, BuildContext context,
      WidgetRef ref) {
    ref
        .watch(communityControllerProvider.notifier)
        .addMods(communityName, uids, context);
  }

  int ctr = 0;
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  saveMods(widget.name, uids.toList(), context, ref),
              icon: Icon(
                weight: 10,
                size: 28,
                Icons.done,
                color: theme == ThemeMode.dark
                    ? Pallete.appColorDark
                    : Pallete.appColorLight,
              )),
        ],
      ),
      body: ref.watch(communityByNameProvider(widget.name)).when(
            data: (community) {
              if (ctr == 0) {
                uids = community.mods.toSet();
              }
              ctr++;
              return Center(
                child: Responsive(
                  child: ListView.builder(
                    itemCount: community.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final member = community.members[index];
                      return ref.read(getUserDataProvider(member)).when(
                            data: (user) {
                              return CheckboxListTile(
                                activeColor: theme == ThemeMode.dark
                                    ? Pallete.appColorDark
                                    : Pallete.appColorLight,
                                checkColor: theme == ThemeMode.dark
                                    ? Colors.black
                                    : Colors.white,
                                value: uids.contains(member),
                                onChanged: (val) {
                                  if (val!) {
                                    addMod(member);
                                  } else {
                                    removeMod(member);
                                  }
                                },
                                title: Row(
                                  children: [
                                     ProfileIcon(radius: 35,profilePic: user.profilePic,),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'u/${user.name}',
                                          style: const TextStyle(
                                              fontFamily: 'carter'),
                                        ),
                                        Text(
                                          '${user.karma} karma',
                                          style: const TextStyle(
                                              fontFamily: 'carter',
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
