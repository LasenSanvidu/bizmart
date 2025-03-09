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

  void _makePhoneCall() {
    _launchURL('tel:+94759923449'); // Replace with actual phone number
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "We’re here to help! Whether you have a question, a suggestion, or need assistance, don’t hesitate to reach out. Our team is always available for you. also connect with us on social media for updates and quick support. Your feedback is valuable to us, and we’re always happy to hear from you!",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  Icons.call,
                  "Call us",
                  _makePhoneCall,
                ),
                _buildButton(Icons.email, "Email us", _sendEmail),
              ],
            ),
            SizedBox(height: 20),
            _buildSocialButton(Icons.camera_alt, "Instagram", "4.6K Followers",
                _openInstagram),
            _buildSocialButton(
                Icons.message, "Telegram", "1.3K Followers", _openTelegram),
            _buildSocialButton(
                Icons.facebook, "Facebook", "3.8K Followers", _openFacebook),
            _buildSocialButton(FontAwesomeIcons.whatsapp, "WhatsApp",
                "Available 9-17", _openWhatsApp),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 24,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String platform, String followers,
      VoidCallback onPressed) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Colors.black,
      ),
      title: Text(platform),
      subtitle: Text(followers),
      onTap: onPressed,
    );
  }
}
