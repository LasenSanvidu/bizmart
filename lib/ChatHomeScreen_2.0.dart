import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/chat.dart';

class ChatHomeScreen2 extends StatefulWidget {
  const ChatHomeScreen2({super.key});

  @override
  State<ChatHomeScreen2> createState() => _ChatHomeScreen2State();
}

class _ChatHomeScreen2State extends State<ChatHomeScreen2>
    with WidgetsBindingObserver {
  Map<String, dynamic> userMap = {};
  bool isLoading = false;
  List<String> notifications = [];
  List<Map<String, dynamic>> recentChats = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(
              '${message.notification?.title}: ${message.notification?.body}');
        });
        _showNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(
              '${message.notification?.title}: ${message.notification?.body}');
        });
      }
    });

    _fetchLastChattedUsers();
  }

  void _showNotification(RemoteMessage message) {
    print(
        "Notification received: ${message.notification?.title} - ${message.notification?.body}");
  }

  Future<void> _fetchLastChattedUsers() async {
    if (_auth.currentUser == null) return;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("chats")
          .where("users", arrayContains: _auth.currentUser!.uid)
          .orderBy("lastMessageTime", descending: true)
          .limit(5)
          .get();

      List<Map<String, dynamic>> chats = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> chatData = doc.data() as Map<String, dynamic>;
        List<dynamic> users = chatData["users"];
        String otherUserId =
            users.firstWhere((id) => id != _auth.currentUser!.uid);

        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(otherUserId).get();

        if (userDoc.exists) {
          chats.add({
            "name": userDoc["name"],
            "lastMessage": chatData["lastMessage"],
          });
        }
      }
      setState(() {
        recentChats = chats;
      });
    } catch (e) {
      debugPrint("Error fetching last chats: $e");
    }
  }

  String chatId(String user1, String user2) {
    return user1.compareTo(user2) > 0 ? "$user1$user2" : "$user2$user1";
  }

  void onSearch() async {
    setState(() => isLoading = true);
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: _search.text)
          .get();

      setState(() {
        userMap = querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.first.data() as Map<String, dynamic>
            : {};
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100, // Softer background
        appBar: AppBar(
          elevation: 0, // Flat design
          backgroundColor: Colors.grey.shade900, // Dark gray AppBar
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white70),
            onPressed: () {},
          ),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: isSearchMode
                ? TextField(
                    controller: _search,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search by email',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white70),
                        onPressed: onSearch,
                      ),
                    ),
                  )
                : const Text(
                    'Chats',
                    key: ValueKey('title'),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSearchMode ? Icons.close : Icons.search,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  isSearchMode = !isSearchMode;
                  if (!isSearchMode) {
                    _search.clear();
                    userMap = {};
                  }
                });
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userMap.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          String currentUserName =
                              _auth.currentUser?.displayName ?? 'Unknown';
                          String otherUserName = userMap['name'] ?? 'Unknown';
                          String roomId =
                              chatId(currentUserName, otherUserName);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                chatId: roomId,
                                userMap: userMap,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: userMap['image'] != null &&
                                          userMap['image'].isNotEmpty
                                      ? NetworkImage(userMap['image'])
                                      : null,
                                  child: userMap['image'] == null ||
                                          userMap['image'].isEmpty
                                      ? const Icon(Icons.person,
                                          size: 28, color: Colors.grey)
                                      : null,
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userMap['name'] ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tap to chat',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chat_bubble_outline,
                                    color: Colors.grey.shade600),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 25),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            _firestore.collection("notifications").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "No notifications yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            );
                          }

                          List<DocumentSnapshot> notificationDocs =
                              snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: notificationDocs.length,
                            itemBuilder: (context, index) {
                              var notificationData = notificationDocs[index]
                                  .data() as Map<String, dynamic>;

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey.shade200,
                                        child: const Icon(Icons.notifications,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(width: 13),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notificationData['title'] ??
                                                  'No Title',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              notificationData['body'] ??
                                                  'No content available',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
