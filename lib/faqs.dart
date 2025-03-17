import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is BizMart?",
      "answer":
          "BizMart is an e-commerce platform designed to help small businesses to create an online presence."
    },
    {
      "question": "How secure is my payment information?",
      "answer":
          "BizMart uses encrypted payment gateways and follows industry standards to ensure your payment information remains secure."
    },
    {
      "question": "Are there any subscription fees for using BizMart?",
      "answer":
          "No, BizMart does not require any subscription fees. However, a small transaction fee may apply for certain sales."
    },
    {
      "question": "Can I sell both physical and digital products?",
      "answer":
          "Yes, BizMart allows you to sell both physical goods and digital products such as e-books, templates, and software."
    },
    {
      "question": "Is there a mobile app available?",
      "answer":
          "Yes, BizMart is currently available as a mobile app for Android only."
    }
  ];

  FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(0); // Go back to Home
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 1,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, // Hides divider line
                  //
                ),
                child: ExpansionTile(
                  iconColor: Colors.deepPurpleAccent,
                  collapsedIconColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    faqs[index]["question"]!,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        //color: const Color.fromARGB(255, 160, 125, 255),
                        color: Colors.black,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        faqs[index]["answer"]!,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
