import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/core/constants/error_text.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return const Scaffold(
      body: Center(child: ErrorText(error: 'In Progress')));
  }
}