import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<types.User> _allUsers = [];
  List<types.User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final users = snapshot.docs
        .map((doc) => types.User(
              id: doc.id,
              firstName: doc['first_name'] ?? '',
            ))
        .where((user) => user.id != currentUser.uid) // Exclude current user
        .toList();

    setState(() {
      _allUsers = users;
      _filteredUsers = users;
    });
  }

  void _searchUsers(String query) {
    final filtered = _allUsers
        .where((user) =>
            user.firstName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredUsers = filtered;
    });
  }

  Future<void> _startChat(types.User user) async {
    final room = await FirebaseChatCore.instance.createRoom(user);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Users')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search users...',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchUsers,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text('No users found'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        title: Text(user.firstName ?? 'Unknown'),
                        onTap: () => _startChat(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
