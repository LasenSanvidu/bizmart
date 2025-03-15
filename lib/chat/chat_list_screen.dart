import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart'; // Import your ChatPage
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 ChatListScreen({super.key});

  // Method to check if a chat exists with the user
  Future<bool> _hasChatWithUser(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatId = _getChatId(currentUserId, userId);

    // Check if there are any messages in the chat
    final chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .limit(1) // Only need to check if there are any messages
        .get();

    return chatSnapshot.docs.isNotEmpty;
  }

  // Method to generate chat ID based on two user IDs
  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Ensure the order is consistent
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found"));
          }

          List<Map<String, dynamic>> users = snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id, // Get Firestore document ID
              'name': doc['first_name'], // Ensure 'name' field exists
            };
          }).toList();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getUsersWithChats(users),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final usersWithChats = futureSnapshot.data ?? [];

              if (usersWithChats.isEmpty) {
                return Center(child: Text('No chats found.'));
              }

              return ListView.builder(
                itemCount: usersWithChats.length,
                itemBuilder: (context, index) {
                  final user = usersWithChats[index];
                  return ListTile(
                    title: Text(user['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(userId: user['id']), // Pass Firestore document ID
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // This method filters users with existing chats
  Future<List<Map<String, dynamic>>> _getUsersWithChats(List<Map<String, dynamic>> users) async {
    final List<Future<Map<String, dynamic>?>> futures = users.map((user) async {
      final hasChat = await _hasChatWithUser(user['id']);
      return hasChat ? user : null;
    }).toList();

    // Wait for all futures to complete and filter out null values
    final results = await Future.wait(futures);

    return results.whereType<Map<String, dynamic>>().toList();
  }
}
