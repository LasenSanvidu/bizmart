import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late types.User _currentUser;
  late types.User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _currentUser = types.User(id: _auth.currentUser!.uid);
  }

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Ensure the order is consistent
    return ids.join('_');
  }

  void loadUserData() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    var userData = userSnapshot.data();
    setState(() {
      user = types.User(id: widget.userId, firstName: userData?['first_name']);
      _isLoading = false;
    });
  }

  Stream<List<types.Message>> _getMessages() {
    final chatId = _getChatId(_auth.currentUser!.uid, widget.userId);

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return types.TextMessage(
          id: doc.id,
          author: types.User(id: data['senderId']),
          createdAt:
              (data['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
          text: data['text'],
        );
      }).toList();
    });
  }

  void _sendMessage(types.PartialText message) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatId =
        _getChatId(currentUserId, widget.userId); // Get unique chat ID

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': message.text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? Text('Loading...')
            : Text('Chat with ${user.firstName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading spinner while data is loading.
                : StreamBuilder<List<types.Message>>(
                    stream:
                        _getMessages(), // Use the stream for real-time updates
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      final messages = snapshot.data!;

                      return Chat(
                        messages: messages,
                        user: _currentUser,
                        onSendPressed: _sendMessage,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
