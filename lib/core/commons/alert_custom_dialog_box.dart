import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Theme/pallete.dart';

class AlertCustomDialogBox extends ConsumerWidget {
  final void Function() onPressed;
  const AlertCustomDialogBox({super.key,required this.onPressed});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currTheme = ref.watch(themeNotifierProvider);
    return AlertDialog(
      backgroundColor: currTheme == Pallete.darkModeAppTheme
          ? Pallete.appColorDark
          : Pallete.appColorLight,
      title: Text(
        'Delete Post',
        style: TextStyle(
          fontFamily: 'carter',
          color: currTheme == Pallete.darkModeAppTheme
              ? Colors.black
              : Colors.white,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this post?',
        style: TextStyle(
          fontFamily: 'carter',
          color: currTheme == Pallete.darkModeAppTheme
              ? Colors.black
              : Colors.white,
              fontSize: 16
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                 
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'carter',
                  color: currTheme == Pallete.darkModeAppTheme
                      ? Colors.black
                      : Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
          onPressed: () => onPressed(),
          child: Text(
            'Delete',
            style: TextStyle(
              fontFamily: 'carter',
              color: currTheme == Pallete.darkModeAppTheme
                  ?  Colors.black
                  : Colors.white,
              fontSize: 20,
            ),
          ),
        ),
          ],
        ),
        
      ],
    );
  }
}
