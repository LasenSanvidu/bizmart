/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  ChatPage({required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  types.User? _currentUser; // Nullable to handle async initialization
  late types.User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _currentUser = types.User(id: firebaseUser.uid);
      });
    }
    await loadUserData();
  }

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Ensure the order is consistent
    return ids.join('_');
  }

  Future<void> loadUserData() async {
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
    if (_currentUser == null) return; // Ensure user is set before sending

    final currentUserId = _currentUser!.id;
    final chatId = _getChatId(currentUserId, widget.userId);

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
      body: _isLoading || _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<types.Message>>(
                    stream: _getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final messages = snapshot.data ?? [];

                      return Chat(
                        messages: messages,
                        user: _currentUser!,
                        onSendPressed: _sendMessage,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  ChatPage({required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  types.User? _currentUser; // Nullable to handle async initialization
  late types.User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _currentUser = types.User(id: firebaseUser.uid);
      });
    }
    await loadUserData();
  }

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Ensure the order is consistent
    return ids.join('_');
  }

  Future<void> loadUserData() async {
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
    if (_currentUser == null) return; // Ensure user is set before sending

    final currentUserId = _currentUser!.id;
    final chatId = _getChatId(currentUserId, widget.userId);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isLoading
            ? Text('Loading...')
            : Text(
                'Chat with ${user.firstName}',
                style: GoogleFonts.poppins(),
              ),
        centerTitle: true,
      ),
      body: _isLoading || _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<types.Message>>(
                    stream: _getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final messages = snapshot.data ?? [];

                      return Chat(
                        messages: messages,
                        user: _currentUser!,
                        onSendPressed: _sendMessage,
                        theme: DefaultChatTheme(
                          // Customize colors here
                          primaryColor: Colors
                              .deepPurpleAccent, // Message bubbles for current user
                          secondaryColor:
                              Colors.black, // Message bubbles for other users
                          backgroundColor: Colors.white, // Background color
                          sentMessageBodyTextStyle: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight
                                  .w500), // Text color for sent messages
                          receivedMessageBodyTextStyle: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight
                                  .w500), // Text color for received messages
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
