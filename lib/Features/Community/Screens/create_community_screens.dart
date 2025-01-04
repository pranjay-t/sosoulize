import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/Community/controller/community_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';

class CreateCommunityScreens extends ConsumerStatefulWidget {
  const CreateCommunityScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreensState();
}

class _CreateCommunityScreensState
    extends ConsumerState<CreateCommunityScreens> {
  final _communityNameController = TextEditingController();
  final _descriptionNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _communityNameController.dispose();
    _descriptionNameController.dispose();
  }

  void createCommunity() {
    final communityName = _communityNameController.text.trim();
    if (communityName.isEmpty) return;
    ref.watch(communityControllerProvider.notifier).createCommunity(communityName, context);
    
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 30,
          ),
          color: theme == ThemeMode.dark
              ? Pallete.appColorDark
              : Pallete.appColorLight,
        ),
        title: Text(
          'Create a community',
          style: TextStyle(
            fontFamily: 'carter',
            color: (theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight),
          ),
        ),
      ),
      body: Center(
        child: Responsive(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: isLoading
                ? const Loader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tell us about your Crew!',
                              style: TextStyle(
                                fontFamily: 'carter',
                                fontSize: 21,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              'A name and description help people understand what your crew is all about',
                              style: TextStyle(
                                fontFamily: 'carter',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: _communityNameController,
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9_]*$'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: 'r/Commmunity_name',
                          hintStyle: const TextStyle(
                              fontFamily: 'carter', fontSize: 15),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: (theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: _descriptionNameController,
                        maxLength: 500,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Description (optional)',
                          hintStyle: const TextStyle(
                              fontFamily: 'carter', fontSize: 15),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: (theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: createCommunity,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            "Create Community",
                            style: TextStyle(
                              fontSize: 18,
                              color: theme == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              fontFamily: 'carter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
