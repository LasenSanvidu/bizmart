// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:myapp/services/auth_service.dart'; 
// import '../mocks/mock_firebase.mocks.dart'; 

// void main() {
//   late MockFirebaseAuth mockAuth;
//   late MockFirebaseFirestore mockFirestore;
//   late MockCollectionReference mockCollectionRef;
//   late MockDocumentReference mockDocRef;
//   late MockDocumentSnapshot mockDocSnapshot;
//   late MockUser mockUser;
//   late AuthService authService;

//   setUp(() {
//     mockAuth = MockFirebaseAuth();
//     mockFirestore = MockFirebaseFirestore();
//     mockCollectionRef = MockCollectionReference();
//     mockDocRef = MockDocumentReference();
//     mockDocSnapshot = MockDocumentSnapshot();
//     mockUser = MockUser();

//     authService = AuthService(firebaseAuth: mockAuth, firestore: mockFirestore);
//   });

//   group('AuthService - Authentication Tests', () {
//     test('signIn should return a User when login is successful', () async {
//       final mockUserCredential = MockUserCredential();

//       when(mockAuth.signInWithEmailAndPassword(
//         email: "test@bizmart.com",
//         password: "password123",
//       )).thenAnswer((_) async => mockUserCredential);

//       when(mockUserCredential.user).thenReturn(mockUser);
//       when(mockUser.uid).thenReturn("test_uid");

//       final user = await authService.signIn("test@bizmart.com", "password123");

//       expect(user, isNotNull);
//       expect(user?.uid, equals("test_uid"));
//     });

//     test('signIn should return null when login fails', () async {
//       when(mockAuth.signInWithEmailAndPassword(
//         email: "wrong@bizmart.com",
//         password: "wrongpassword",
//       )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

//       final user = await authService.signIn("wrong@bizmart.com", "wrongpassword");

//       expect(user, isNull);
//     });

//     test('registerUser should create a new user and store username in Firestore', () async {
//       final mockUserCredential = MockUserCredential();

//       when(mockAuth.createUserWithEmailAndPassword(
//         email: "newuser@bizmart.com",
//         password: "password123",
//       )).thenAnswer((_) async => mockUserCredential);

//       when(mockUserCredential.user).thenReturn(mockUser);
//       when(mockUser.uid).thenReturn("new_user_uid");

//       when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
//       when(mockCollectionRef.doc("new_user_uid")).thenReturn(mockDocRef);
//       when(mockDocRef.set(any)).thenAnswer((_) async {});

//       await authService.registerUser("newuser@bizmart.com", "password123", "NewUser");

//       verify(mockDocRef.set({
//         'username': "NewUser",
//         'email': "newuser@bizmart.com",
//       })).called(1);
//     });

//     test('getUsername should return the correct username', () async {
//       when(mockAuth.currentUser).thenReturn(mockUser);
//       when(mockUser.uid).thenReturn("test_uid");

//       when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
//       when(mockCollectionRef.doc("test_uid")).thenReturn(mockDocRef);
//       when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

//       when(mockDocSnapshot.exists).thenReturn(true);
//       // Fix: Mock the bracket access method instead of data()
//       when(mockDocSnapshot['username']).thenReturn("TestUser");

//       final username = await authService.getUsername();

//       expect(username, equals("TestUser"));
//     });

//     test('getUsername should return null if user does not exist', () async {
//       when(mockAuth.currentUser).thenReturn(null);

//       final username = await authService.getUsername();

//       expect(username, isNull);
//     });

//     test('signOut should call FirebaseAuth.signOut()', () async {
//       when(mockAuth.signOut()).thenAnswer((_) async {});

//       await authService.signOut();

//       verify(mockAuth.signOut()).called(1);
//     });
//   });
// }