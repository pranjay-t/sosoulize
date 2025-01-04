import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/chat/controller/chat_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:routemaster/routemaster.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  void navigateToMessageScreen(BuildContext context,String receiverId) {
    Routemaster.of(context).push('/message/$receiverId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(fetchAllChatRoomsProvider).when(
            data: (ids) {
              if (ids.isEmpty) {
                return const Center(
                  child: ErrorText(error: 'No chat room created.')
                );
              }
              return Center(
                child: Responsive(
                  child: ListView.builder(
                    itemCount: ids.length,
                    itemBuilder: (BuildContext context, int index) {
                      final id = ids[index];
                      return GestureDetector(
                        onTap: () => navigateToMessageScreen(context,id.uid),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(id.profilePic),
                              ),
                            ),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                id.name,
                                style: const TextStyle(
                                  fontFamily: 'carter',
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                'blah blah blah blah...',
                                style: TextStyle(
                                  fontFamily: 'carter',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
