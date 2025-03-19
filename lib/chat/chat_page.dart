import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String userId;

  ChatPage({required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  types.User? _currentUser;
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

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
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

        if (data.containsKey('imageUrl')) {
          return types.ImageMessage(
            id: doc.id,
            author: types.User(id: data['senderId']),
            createdAt:
                (data['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
            name: "Image",
            uri: data['imageUrl'],
            size: data['imageSize'] ?? 0,
          );
        }

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
    if (_currentUser == null) return;

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

  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null || _currentUser == null) return;

    File imageFile = File(pickedFile.path);
    String imageUrl = await _uploadImageToImgBB(imageFile);

    if (imageUrl.isNotEmpty) {
      final chatId = _getChatId(_currentUser!.id, widget.userId);

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': _currentUser!.id,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String> _uploadImageToImgBB(File image) async {
    String apiKey = "7150e0bb2f8e5ee12b82d796cbbf8865";
    Uri url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");

    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseBody);

    if (jsonResponse['status'] == 200) {
      return jsonResponse['data']['url'];
    }
    return "";
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
                        onAttachmentPressed: _sendImage,
                        theme: DefaultChatTheme(
                          primaryColor: Colors.deepPurpleAccent,
                          secondaryColor: Colors.black,
                          backgroundColor: Colors.white,
                          sentMessageBodyTextStyle: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          receivedMessageBodyTextStyle: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
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
