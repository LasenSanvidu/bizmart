import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error : $e');
      return null;
    }
  }

  // Register user with username
  Future<void> registerUser(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Save username to Firestore under user's UID
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the username from Firestore using the user's UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc['username'];
      }
    }
    return null;
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
