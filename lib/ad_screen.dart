/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // For base64 encoding/decoding
import 'package:go_router/go_router.dart';

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  File? _image;
  String? _fetchedImage; // Store the fetched image
  bool _isLoading = false; // Track loading state
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchAdImage();
  }

  Future<void> _fetchAdImage() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      var storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        String base64Image = storeSnapshot.docs.first['bannerImage'];
        setState(() {
          _fetchedImage = base64Image;
        });
      }
    } catch (e) {
      print("Error fetching image: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitAd() async {
    if (_image != null) {
      try {
        List<int> imageBytes = await _image!.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        var storeSnapshot = await FirebaseFirestore.instance
            .collection('stores')
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .get();

        if (storeSnapshot.docs.isNotEmpty) {
          String docId = storeSnapshot.docs.first.id;

          await FirebaseFirestore.instance.collection('stores').doc(docId).update({
            'bannerImage': 'data:image/jpeg;base64,$base64Image',
            'bannerImageUpdatedAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ad submitted successfully!')),
          );

          // Refresh the displayed image
          _fetchAdImage();
          context.pop();
        }
      } catch (e) {
        print("Error submitting ad: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image for the ad.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Boost "sells', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          )
                        : _fetchedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(_fetchedImage!.split(',')[1]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Tap to upload an image',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                              ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              ),
              child: Text(
                'Submit Ad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // For base64 encoding/decoding
import 'package:go_router/go_router.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/component/customer_flow_screen.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  File? _image;
  String? _fetchedImage; // Store the fetched image
  bool _isLoading = false; // Track loading state
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchAdImage();
  }

  Future<void> _fetchAdImage() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      var adSnapshot = await FirebaseFirestore.instance
          .collection('ads')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();

      if (adSnapshot.docs.isNotEmpty) {
        String base64Image = adSnapshot.docs.first['imageUrl'];
        setState(() {
          _fetchedImage = base64Image;
        });
      }
    } catch (e) {
      print("Error fetching AdImage: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitAd() async {
    if (_image != null) {
      try {
        setState(() {
          _isLoading = true;
        });
        List<int> imageBytes = await _image!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        String base64WithPrefix = 'data:image/jpeg;base64,$base64Image';

        // Query to check if user already has an ad
        var adSnapshot = await FirebaseFirestore.instance
            .collection('ads')
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .get();

        // If ad exists, update it; otherwise, create a new one
        if (adSnapshot.docs.isNotEmpty) {
          String adId = adSnapshot.docs.first.id;

          await FirebaseFirestore.instance.collection('ads').doc(adId).update({
            'imageUrl': base64WithPrefix,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Generate a new unique ID for the ad
          String adId = FirebaseFirestore.instance.collection('ads').doc().id;

          await FirebaseFirestore.instance.collection('ads').doc(adId).set({
            'adId': adId,
            'userId': _auth.currentUser!.uid,
            'imageUrl': base64WithPrefix,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ad submitted successfully!')),
            );
          }

          // Refresh the displayed image
          _fetchAdImage();
          setState(() {
            //_fetchAdImage();
            _isLoading = false;
          });
          context.pop();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error submitting ad: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting ad: $e')),
          );
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image for the ad.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Boost Sells',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            /*CustomerFlowScreen.of(context)
                ?.updateIndex(6); // Go back to dashboard*/
            CustomerFlowScreen.of(context)
                ?.setNewScreen(BusinessDashboardScreen());
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          )
                        : _fetchedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(_fetchedImage!.split(',')[1]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Tap to upload an image',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your ad is just one click away from reaching thousands!',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submitAd,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                child: Text(
                  'Submit Ad',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
