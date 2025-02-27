import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class ProductShowcaseScreen extends StatefulWidget {
  @override
  _ProductShowcaseScreenState createState() => _ProductShowcaseScreenState();
}

class _ProductShowcaseScreenState extends State<ProductShowcaseScreen> {
  String brand = "Product Showcase";
  String description = "No description available";
  String bannerImage = "";
  List<Map<String, dynamic>> categories = []; // ✅ Fixed Type

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    FirebaseFirestore.instance.collection('shoeBrand').doc('BrandID').get().then((doc) {
      if (doc.exists) {
        setState(() {
          brand = doc['name'] ?? "Product Showcase";
          description = doc['description'] ?? "No description available";
          bannerImage = doc['banner'] ?? "";

          categories = (doc['categories'] as List<dynamic>?)?.map((category) {
                return {
                  "image": (category as Map<String, dynamic>)["image"] ?? "",
                  "name": category["name"] ?? "Unnamed Category",
                };
              }).toList() ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brand, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          /// **Main Content**
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **Banner Image**
                  bannerImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            bannerImage,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text("No Banner Available")),
                        ),
                  SizedBox(height: 15),

                  /// **Shop Description**
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 25),

                  /// **Category Title**
                  Text(
                    "Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  /// **Category List (1 Row Per Category)**
                  categories.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 1), // ✅ Outline Added
                              ),
                              child: Row(
                                children: [
                                  /// **Category Image**
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      categories[index]["image"],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  /// **Category Name**
                                  Text(
                                    categories[index]["name"],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("No categories available", style: TextStyle(color: Colors.black54)),
                          ),
                        ),
                ],
              ),
            ),
          ),

          /// **Bottom "Contact Us" Button**
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.go("/contact_us"); // ✅ Navigate to Contact Us Page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Contact Us", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
