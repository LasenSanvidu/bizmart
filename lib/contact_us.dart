import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20), // Add this line to move "Contact Us" down
            Text(
              "Contact Us",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
                "We’re here to help! Whether you have a question, a suggestion, or need assistance, don’t hesitate to reach out. Our team is available Monday to Friday from 9 AM to 5 PM to answer your calls and emails. You can also connect with us on social media for updates and quick support. Your feedback is valuable to us, and we’re always happy to hear from you!"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(Icons.call, "Call us", _makePhoneCall),
                _buildButton(Icons.email, "Email us", _sendEmail),
              ],
            ),
            SizedBox(height: 20),
            _buildSocialButton(Icons.camera_alt, "Instagram", "Follow us", _openInstagram),
            _buildSocialButton(
                Icons.message, "Telegram", "", _openTelegram),
            _buildSocialButton(
                Icons.facebook, "Facebook", "Follow us", _openFacebook),
            _buildSocialButton(FontAwesomeIcons.whatsapp, "WhatsApp",
                "", _openWhatsApp),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }

  Widget _buildSocialButton(IconData icon, String platform, String followers,
      VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(platform),
      subtitle: Text(followers),
      trailing: Icon(Icons.share),
      onTap: onPressed,
    );
  }
}
