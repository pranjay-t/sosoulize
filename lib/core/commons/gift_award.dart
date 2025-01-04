import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/posts/controller/post_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/constants/constants.dart';
import 'package:sosoulize/models/post_model.dart';

class GiftAward extends ConsumerWidget {
  final Post post;
  const GiftAward({
    super.key,
    required this.post,
  });

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double maxWidth = kIsWeb
                          ? MediaQuery.of(context).size.width * 0.4
                          : MediaQuery.of(context).size.width * 0.8;

                      double maxHeight = kIsWeb
                          ? MediaQuery.of(context).size.height * 0.6
                          : MediaQuery.of(context).size.height * 0.8;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kIsWeb ? 8 : 4,
                          ),
                          itemCount: user.awards.length,
                          itemBuilder: (BuildContext context, int index) {
                            final award = user.awards[index];
                            return GestureDetector(
                              onTap: () => isGuest
                                  ? null
                                  : awardPost(ref, award, context),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(Constants.awards[award]!),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            });
      },
      icon: Icon(
        Icons.card_giftcard,
        color: theme == ThemeMode.dark
            ? Pallete.appColorDark
            : Pallete.appColorLight,
      ),
    );
  }
}
