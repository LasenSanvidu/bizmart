import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A beautifully designed chat screen widget
class Chat extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatId;

  const Chat({
    super.key,
    required this.chatId,
    required this.userMap,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  /// Loads chat messages from Firestore in real-time
  void _loadMessages() {
    _firestore
        .collection('chat')
        .doc(widget.chatId)
        .collection('chats')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final currentUserId = _auth.currentUser?.uid ?? '';
          return data['type'] == "text"
              ? types.TextMessage(
                  author: types.User(
                    id: data['sendBy'] == _auth.currentUser?.displayName
                        ? currentUserId
                        : widget.userMap['uid'],
                  ),
                  id: doc.id,
                  text: data['message'],
                  createdAt: (data['time'] as Timestamp?)?.millisecondsSinceEpoch,
                )
              : types.ImageMessage(
                  author: types.User(
                    id: data['sendBy'] == _auth.currentUser?.displayName
                        ? currentUserId
                        : widget.userMap['uid'],
                  ),
                  id: doc.id,
                  uri: data['message'],
                  size: 0,
                  createdAt: (data['time'] as Timestamp?)?.millisecondsSinceEpoch,
                  name: 'Image',
                );
        }).toList();
      });
    });
  }

  /// Handles sending text messages
  Future<void> _onSendMessage(types.PartialText message) async {
    if (message.text.isEmpty) return;

    final messageData = {
      "sendBy": _auth.currentUser?.displayName,
      "message": message.text,
      "type": "text",
      "time": FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('chat')
        .doc(widget.chatId)
        .collection('chats')
        .add(messageData);
  }

  /// Picks an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      await _uploadImage(File(xFile.path));
    }
  }

  /// Uploads image to Firebase Storage and updates Firestore
  Future<void> _uploadImage(File imageFile) async {
    final fileName = const Uuid().v1();
    bool uploadSuccess = true;

    await _firestore
        .collection('chat')
        .doc(widget.chatId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendBy": _auth.currentUser?.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    final ref = _storage.ref().child('Images').child("$fileName.jpg");
    try {
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection('chat')
          .doc(widget.chatId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});
    } catch (error) {
      await _firestore
          .collection('chat')
          .doc(widget.chatId)
          .collection('chats')
          .doc(fileName)
          .delete();
      uploadSuccess = false;
      debugPrint('Image upload failed: $error');
    }

    if (!uploadSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(widget.userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final status = snapshot.data?['status'] ?? 'Offline';
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Text(
                    widget.userMap['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userMap['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        color: status == 'Online' ? Colors.greenAccent : Colors.grey[300],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: chat_ui.Chat(
          messages: _messages,
          onSendPressed: _onSendMessage,
          user: types.User(id: currentUserId),
          onAttachmentPressed: _pickImage,
          theme: chat_ui.DefaultChatTheme(
            primaryColor: Colors.purple,
            secondaryColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.transparent,
            inputBackgroundColor: Colors.white.withOpacity(0.9),
            inputTextColor: Colors.black87,
            inputBorderRadius: BorderRadius.circular(25),
            inputContainerDecoration: BoxDecoration(
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            sentMessageBodyTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            receivedMessageBodyTextStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            messageBorderRadius: 20,
            attachmentButtonIcon: const Icon(
              Icons.attach_file,
              color: Colors.purple,
            ),
            sendButtonIcon: const Icon(
              Icons.send,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}