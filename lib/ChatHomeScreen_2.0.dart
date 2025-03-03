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
      //Online
      setStatus("Online");
    } else {
      //Offline
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
          .orderBy("name", descending: false) // Sorting alphabetically
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Align(
          alignment: Alignment.center,
          child: Text('Chat',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        ),
        actions: [
          IconButton(
            onPressed: () => logOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(height: size.height / 20),
                SizedBox(
                  height: size.height / 14,
                  width: size.width / 1.2,
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height / 30),
                ElevatedButton(
                    onPressed: onSearch, child: const Text('Search')),
                SizedBox(height: size.height / 30),
                userMap.isNotEmpty
                    ? ListTile(
                        onTap: () {
                          String roomId = chatId(
                            _auth.currentUser?.displayName ?? 'Unknown',
                            userMap['name'] ??
                                'Unknown', // Handle null values here
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                chatId: roomId,
                                userMap: userMap,
                              ),
                            ),
                          );
                        },
                        leading: userMap['image'] != null &&
                                userMap['image'].isNotEmpty
                            ? Image.network(userMap['image'])
                            : const Icon(Icons.person, color: Colors.black),
                        title: Text(
                          userMap['name'] ?? 'No Name', // Default to 'No Name'
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap['email'] ??
                            'No Email'), // Default to 'No Email'
                        trailing: const Icon(Icons.chat, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
