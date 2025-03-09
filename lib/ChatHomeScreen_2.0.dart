import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'chat.dart';

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

  // New state variable to toggle search bar visibility
  bool isSearchMode = false;

  @override
  void initState() {
  super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });
  
  

  

  

  

  
  

  
}



  
  

  

  String chatId(String user1, String user2) {
    return user1.compareTo(user2) > 0 ? "$user1$user2" : "$user2$user1";
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: _search.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userMap = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          userMap = {};
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: isSearchMode
              ? TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: 'Search by email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: onSearch,
                    ),
                  ),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(isSearchMode ? Icons.close : Icons.search),
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
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFilterButton("All"),
                        const SizedBox(width: 10),
                        _buildFilterButton("Unread"),
                        const SizedBox(width: 10),
                        _buildFilterButton("Favourites"),
                      ],
                    ),
                    if (userMap.isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
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
                          tileColor: Colors.black,
                          leading: userMap['image'] != null &&
                                  userMap['image'].isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userMap['image']),
                                )
                              : const Icon(Icons.person, color: Colors.white),
                          title: Text(
                            userMap['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          trailing: const Icon(Icons.chat, color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            _firestore.collection("notifications").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text("No notifications available"),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.notifications,
                                      color: Colors.blue),
                                  title: Text(
                                    notificationData['title'] ?? 'No Title',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    notificationData['body'] ??
                                        'No content available',
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
}

Widget _buildFilterButton(String label) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 175, 108, 187),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
