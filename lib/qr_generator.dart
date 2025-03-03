import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late String referralCode;
  final String baseUrl = "https://solecrafter.com/refer?code=";
  bool isLoading = true;
  int referralCount = 0;

  @override
  void initState() {
    super.initState();
    _loadOrGenerateReferralCode();
  }

  Future<void> _loadOrGenerateReferralCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? storedCode = prefs.getString('referralCode');
      referralCount = prefs.getInt('referralCount') ?? 0;

      if (storedCode == null) {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        final random = Random();
        String code = '';

        for (int i = 0; i < 6; i++) {
          code += chars[random.nextInt(chars.length)];
        }

        storedCode = code;
        await prefs.setString('referralCode', storedCode);
        await prefs.setInt('referralCount', 0);
      }

      setState(() {
        referralCode = storedCode!;
        isLoading = false;
      });
    } catch (e) {
      print("Error generating referral code: $e");
      setState(() {
        referralCode =
            "SC${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 13)}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1C4E9),
        title: const Text(
          'SoleCraft',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your Referral Code",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: "$baseUrl$referralCode",
                    size: 200.0,
                  ),
                  const SizedBox(height: 20),
                  SelectableText(
                    "Code: $referralCode",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$referralCount ${referralCount == 1 ? 'person has' : 'people have'} used your code",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
