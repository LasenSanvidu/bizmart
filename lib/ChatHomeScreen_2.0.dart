
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
        backgroundColor: Colors.white, // White background for the body
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.black, // Black AppBar
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isSearchMode
                ? TextField(
                    controller: _search,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search by email',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: onSearch,
                      ),
                    ),
                  )
                : const Text(
                    'Chat',
                    key: ValueKey('title'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSearchMode ? Icons.close : Icons.search,
                color: Colors.white,
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userMap.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          String currentUserName =
                              _auth.currentUser?.displayName ?? 'Unknown';
                          String otherUserName = userMap['name'] ?? 'Unknown';
                          String roomId = chatId(currentUserName, otherUserName);

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
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white, // White card background
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: userMap['image'] != null &&
                                      userMap['image'].isNotEmpty
                                  ? NetworkImage(userMap['image'])
                                  : null,
                              child: userMap['image'] == null ||
                                      userMap['image'].isEmpty
                                  ? const Icon(Icons.person, color: Colors.black)
                                  : null,
                            ),
                            title: Text(
                              userMap['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: const Text(
                              'Tap to chat',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.chat_bubble_outline,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "No notifications available",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
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
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.white,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.notifications,
                                        color: Colors.black),
                                  ),
                                  title: Text(
                                    notificationData['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    notificationData['body'] ??
                                        'No content available',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
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
        backgroundColor: Colors.black, // Black button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white, // White text
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}