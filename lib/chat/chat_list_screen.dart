/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart'; // Import your ChatPage
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'chat_page.dart'; // Import your ChatPage
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Method to check if a chat exists with the user
  Future<bool> _hasChatWithUser(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatId = _getChatId(currentUserId, userId);
    // Check if there are any messages in the chat
    final chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .limit(1)
        .get();
    return chatSnapshot.docs.isNotEmpty;
  }

// Method to generate chat ID based on two user IDs
  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(0);
          },
        ),
        title: Text(
          "Chats",
          style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
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
                return const Center(child: CircularProgressIndicator());
              }

              final usersWithChats = futureSnapshot.data ?? [];

              if (usersWithChats.isEmpty) {
                //return const Center(child: Text('No chats found.'));
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        "No conversations yet",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Start chatting with users to see them here",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: usersWithChats.length,
                itemBuilder: (context, index) {
                  final user = usersWithChats[index];
                  return Card(
                    color: const Color.fromARGB(255, 247, 247, 247),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text(
                          user['name'][0].toUpperCase(),
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                      trailing: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.deepPurpleAccent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(userId: user['id']),
                          ),
                        );
                      },
                    ),
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
  Future<List<Map<String, dynamic>>> _getUsersWithChats(
      List<Map<String, dynamic>> users) async {
    final List<Future<Map<String, dynamic>?>> futures = users.map((user) async {
      final hasChat = await _hasChatWithUser(user['id']);
      return hasChat ? user : null;
    }).toList();

    // Wait for all futures to complete and filter out null values
    final results = await Future.wait(futures);
    return results.whereType<Map<String, dynamic>>().toList();
  }
}
