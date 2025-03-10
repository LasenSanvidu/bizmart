import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Chat extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatId;

  const Chat({super.key, required this.chatId, required this.userMap});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

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
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final userId = _auth.currentUser?.uid ?? '';

          if (data['type'] == "text") {
            return types.TextMessage(
              author: types.User(id: data['sendBy'] == _auth.currentUser?.displayName ? userId : widget.userMap['uid']),
              id: doc.id,
              text: data['message'],
              createdAt: (data['time'] as Timestamp?)?.millisecondsSinceEpoch,
            );
          } else {
            return types.ImageMessage(
              author: types.User(id: data['sendBy'] == _auth.currentUser?.displayName ? userId : widget.userMap['uid']),
              id: doc.id,
              uri: data['message'],
              size: 0, // Size not stored, adjust if needed
              createdAt: (data['time'] as Timestamp?)?.millisecondsSinceEpoch,
              name: 'Image', // Add a default name or fetch from data if available
            );
          }
        }).toList();
      });
    });
  }

  void onSendMessage(types.PartialText message) async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": _auth.currentUser?.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      await _firestore.collection('chat').doc(widget.chatId).collection('chats').add(messages);
    }
  }

  Future getImages() async {
    ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      File imageFile = File(xFile.path);
      await uploadImage(imageFile);
    }
  }

  Future uploadImage(File imageFile) async {
    String fileName = const Uuid().v1();
    int status = 1;

    await _firestore.collection('chat').doc(widget.chatId).collection('chats').doc(fileName).set({
      "sendBy": _auth.currentUser?.displayName,
      "message": "",
      "type_of the message": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance.ref().child('Images').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile).catchError((error) async {
      await _firestore.collection('chat').doc(widget.chatId).collection('chats').doc(fileName).delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await ref.getDownloadURL();
      await _firestore.collection('chat').doc(widget.chatId).collection('chats').doc(fileName).update({
        "message": imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(widget.userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Column(
                children: [
                  Text(widget.userMap['name']),
                  Text(
                    snapshot.data?['status'],
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        backgroundColor: Colors.purple,
      ),
      body: chat_ui.Chat(
        messages: _messages,
        onSendPressed: onSendMessage,
        user: types.User(id: userId),
        onAttachmentPressed: getImages,
        theme: const chat_ui.DefaultChatTheme(
          primaryColor: Colors.purple,
          secondaryColor: Colors.blue,
          inputBackgroundColor: Color.fromARGB(255, 149, 148, 148),
          inputTextColor: Colors.black,
        ),
      )
    );
  }
}