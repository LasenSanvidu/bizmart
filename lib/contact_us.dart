import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      print('Could not launch $url');
    }
  }

  void _sendEmail() {
    _launchURL('mailto:bizmart49@gmail.com'); // Replace with actual email
  }

  void _openInstagram() {
    _launchURL('https://www.instagram.com/biz_mart_');
  }

  void _openTelegram() {
    _launchURL('https://t.me/yourprofile');
  }

  void _openFacebook() {
    _launchURL('https://www.facebook.com/Biz Mart');
  }

  void _openWhatsApp() {
    _launchURL(
        'https://wa.me/94759923449'); // Replace with actual WhatsApp number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Contact Us",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(0); // Go back to Home
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap the content inside a SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "We’re here to help! Whether you have a question, a suggestion, or need assistance, don’t hesitate to reach out. Our team is always available for you. Connect with us on social media for updates and quick support. Your feedback is valuable to us, and we’re always happy to hear from you!",
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildSocialButton(
                  Icons.email, "Email us", "Reach us anytime", _sendEmail),
              SizedBox(height: 20),
              _buildSocialButton(
                  Icons.camera_alt, "Instagram", "", _openInstagram),
              _buildSocialButton(Icons.message, "Telegram", "", _openTelegram),
              _buildSocialButton(Icons.facebook, "Facebook", "", _openFacebook),
              _buildSocialButton(FontAwesomeIcons.whatsapp, "WhatsApp",
                  "Available 9-17", _openWhatsApp),
            ],
          ),
        ),
      ),
    );
  }

  // Modern social button with card-like appearance
  Widget _buildSocialButton(IconData icon, String platform, String followers,
      VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(
            icon,
            size: 35,
            color: Colors.deepPurpleAccent,
          ),
          title: Text(
            platform,
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          subtitle: Text(
            followers,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.deepPurpleAccent,
          ),
        ),
      ),
    );
  }
}
