import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/provider/inquiry_provider.dart';
import 'package:provider/provider.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
// In the InquiryPage class, update the build method to include initState
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<InquiryProvider>(context, listen: false).fetchMyInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<InquiryProvider>(context);
    final inquiryList = inquiryProvider.inquiryList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Inquiries",
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (inquiryList.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Clear all Inquiries?',
                      style: GoogleFonts.poppins(fontSize: 23),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'No',
                            style: TextStyle(fontSize: 16),
                          )),

                      //yes button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          inquiryProvider.clearAllInquiry();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: inquiryProvider.inquiryList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Inquiry_0.jpg',
                  width: 300,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'No Inquiries Available',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                )
              ],
            ))
          : ListView.builder(
              itemCount: inquiryProvider.inquiryList.length,
              itemBuilder: (context, index) {
                final inquiry = inquiryList[index];

                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 100,
                            height:
                                100, // You can make this taller without being cut off
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: inquiry.image.isNotEmpty
                                  ? inquiry.image.startsWith("http")
                                      ? Image.network(
                                          inquiry.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey);
                                          },
                                        )
                                      : Image.file(
                                          File(inquiry.image),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey);
                                          },
                                        )
                                  : Icon(Icons.image_not_supported,
                                      size: 50, color: Colors.grey),
                            )),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                inquiry.prodname,
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "\$${inquiry.prodprice}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            inquiryProvider.removeFromInquiry(inquiry);
                          },
                        ),
                      ],
                    ));
              },
            ),
    );
  }
}
