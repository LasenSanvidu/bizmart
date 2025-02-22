import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CompaniesScreen extends StatelessWidget {
  final String defaultImage = 'assets/default.png';

  const CompaniesScreen({super.key}); // Ensure you have this in your assets folder

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('companies').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Companies Available"));
        }

        var companies = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: companies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              var company = companies[index];
              String name = company['name'];
              String? imageUrl = company['imageUrl'];

              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Image.asset(defaultImage, fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset(defaultImage, fit: BoxFit.cover),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
