import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late types.User _user;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadMessages();
  }

  void _loadMessages() {
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        return types.TextMessage(
          id: doc.id,
          text: data['text'],
          author: types.User(id: data['authorId']),
          createdAt: data['createdAt'],
        );
      }).toList();

      setState(() {
        _messages = messages;
      });
    });
  }

  Future<void> _loadUser() async {
    setState(() {
      _user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
    });
  }

   void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      id: Random().nextInt(10000).toString(),
      text: message.text,
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    FirebaseFirestore.instance.collection('messages').add({
      'text': textMessage.text,
      'authorId': _user.id,
      'createdAt': textMessage.createdAt,
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
            messages: _messages, onSendPressed: _handleSendPressed, user: _user),
      );
}
