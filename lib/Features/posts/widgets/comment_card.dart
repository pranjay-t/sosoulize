import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/models/comment_model.dart';
import 'package:routemaster/routemaster.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToUser(BuildContext context){
      Routemaster.of(context).push('/user-profile/${comment.userId}');
    }
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    onTap: () => navigateToUser(context),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        comment.profilePic,
                      ),
                      radius: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'u/${comment.username}',
                          style: const TextStyle(
                            fontFamily: 'carter',
                            fontSize: 16
                          ),
                        ),
                        // const SizedBox(height: 6,),
                        Text(comment.text,style: const TextStyle(
                            fontFamily: 'carter',
                            fontSize: 12,
                            color: Color.fromARGB(255, 188, 186, 186)
                          ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.reply),
                ),
                const Text('Reply'),
              ],
            ),
          ],
        ),
    );
  }
}