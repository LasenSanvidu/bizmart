import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a consistent chat ID for two users
  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Ensure order is consistent
    return ids.join('_');
  }

  /// Send a message to a specific user
  Future<void> sendMessage(String receiverId, String text) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("User is not logged in.");
      return;
    }

    final chatId = _getChatId(currentUser.uid, receiverId);

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': currentUser.uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("Message sent successfully!");
  }
}
