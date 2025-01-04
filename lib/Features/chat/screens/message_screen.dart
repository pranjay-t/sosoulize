import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Features/chat/controller/chat_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/constants/message_bubble.dart';
import 'package:sosoulize/core/constants/error_text.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String receiverId;

  const MessageScreen({
    super.key,
    required this.receiverId,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final messageController = TextEditingController();

  void sendMessage(BuildContext context) {
    String messageContent = messageController.text.trim();
    if (messageContent.isEmpty) return;
    final chatController = ref.read(chatControllerProvider);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    chatController.createMessage(
      context: context,
      receiverId: widget.receiverId,
      message: messageContent,
      timestamp: timestamp,
    );
    messageController.clear();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    final currUser = ref.read(userProvider)!.uid;
    return ref.read(getUserDataProvider(widget.receiverId)).when(data: (user){
      return Scaffold(
      backgroundColor: theme == ThemeMode.dark
          ? const Color.fromARGB(255, 19, 18, 18)
          : const Color.fromARGB(255, 199, 191, 191),
      appBar: AppBar(
        titleSpacing: -2,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 18,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              user.name,
              style: TextStyle(
                  fontFamily: 'carter',
                  color: theme == ThemeMode.dark
                      ? Pallete.appColorDark
                      : Pallete.appColorLight),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme == ThemeMode.dark
                ? Pallete.appColorDark
                : Pallete.appColorLight,
            size: 30,
          ),
        ),
      ),
      body: ref.watch(getMessageProvider(user.uid)).when(
            data: (messages) {
              return Center(
                child: Responsive(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message = messages[index];
                            return MessageBubble(
                              message: message.message,
                              isCurrentUser: message.senderId == currUser,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'carter',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                ),
                                onSubmitted: (value) => sendMessage(context),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => sendMessage(context),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: theme == ThemeMode.dark
                                    ? Pallete.appColorDark
                                    : Pallete.appColorLight,
                                child: Icon(
                                  Icons.send,
                                  size: 30,
                                  color: theme == ThemeMode.dark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    // ignore:  non_constant_identifier_names, avoid_types_as_parameter_names
    }, error: (error,StackTrace) => ErrorText(error: error.toString()), loading:() => const Loader());
    
  }
}
