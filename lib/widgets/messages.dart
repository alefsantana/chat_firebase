import 'package:chat_fire_base/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('creatdAt', descending: true)
          .snapshots(),

      // ignore: missing_return
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, i) => MessageBubble(
            chatDocs[i]['text'],
            chatDocs[i]['userName'],
            chatDocs[i]['userImage'],
            chatDocs[i]['userId'] == user.uid,
            key: ValueKey(chatDocs[i]),

          ),
        );
      },
    );
  }
}
