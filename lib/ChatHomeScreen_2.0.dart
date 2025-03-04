import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'chat.dart';

class ChatHomeScreen2 extends StatefulWidget {
  const ChatHomeScreen2({super.key});

  @override
  State<ChatHomeScreen2> createState() => _ChatHomeScreen2State();
}

class _ChatHomeScreen2State extends State<ChatHomeScreen2> with WidgetsBindingObserver {
  Map<String, dynamic> userMap = {};
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // New state variable to toggle search bar visibility
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async{
    await _firestore.collection("users").doc(_auth.currentUser?.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  String chatId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: _search.text)
          .orderBy("name", descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userMap = querySnapshot.docs[0].data() as Map<String, dynamic>;
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

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
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
              : Align(
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
                  // Reset the search text if the user toggles off the search bar
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
                      ListTile(
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
                        leading:
                            userMap['image'] != null && userMap['image'].isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(userMap['image']),
                                  )
                                : const Icon(Icons.person, color: Colors.black),
                        title: Text(
                          userMap['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap['email'] ?? 'No Email'),
                        trailing: const Icon(Icons.chat, color: Colors.black),
                      ),
                    const SizedBox(height: 20),
                    Expanded(
                    child: Center(
                        child: Text('Your chat list will be displayed here.')),
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
      backgroundColor: Colors.blueAccent,
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