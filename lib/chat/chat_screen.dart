import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  final types.Room room;

  ChatScreen({required this.room});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(room.name ?? 'Chat')),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(room),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading messages'));
          }

          return Chat(
            messages: snapshot.data ?? [],
            onSendPressed: (partialMessage) {
              FirebaseChatCore.instance.sendMessage(
                types.PartialText(text: partialMessage.text),
                room.id,
              );
            },
            user: types.User(id: user!.uid),
          );
        },
      ),
    );
  }
}
