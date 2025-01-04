import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageBubble extends ConsumerWidget {
  final String message;
  final bool isCurrentUser;
  const MessageBubble({super.key,required this.message,required this.isCurrentUser}); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: isCurrentUser 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          padding:const  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin:const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isCurrentUser  ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft:const Radius.circular(16),
              topRight:const Radius.circular(16),
              bottomLeft:
                   Radius.circular(isCurrentUser  ? 16 : 0),
              bottomRight:
                  Radius.circular(isCurrentUser  ? 0 : 16),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black,
              fontFamily: 'carter',
            ),
          ),
        ),
      ),
    );
  }
}
