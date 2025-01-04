import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardSize = kIsWeb ? 100 : 120;
    double iconSize = kIsWeb ? 90 : 45;
    final theme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          children: [
            GestureDetector(
              onTap: () => navigateToType(context, 'image'),
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  child: Icon(
                    Icons.image_outlined,
                    size: iconSize,
                    color: theme == Pallete.darkModeAppTheme
                        ? Pallete.appColorDark
                        : Pallete.appColorLight,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'video'),
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  child: Icon(
                    Icons.play_circle,
                    size: iconSize,
                    color: theme == Pallete.darkModeAppTheme
                        ? Pallete.appColorDark
                        : Pallete.appColorLight,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'link'),
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.link,
                      size: 38,
                      color: theme == Pallete.darkModeAppTheme
                          ? Pallete.appColorDark
                          : Pallete.appColorLight,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'text'),
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  child: Icon(
                    Icons.text_format,
                    size: iconSize,
                    color: theme == Pallete.darkModeAppTheme
                        ? Pallete.appColorDark
                        : Pallete.appColorLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
