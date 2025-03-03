import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/store_page.dart';
import 'package:provider/provider.dart';

class StoreUi extends StatelessWidget {
  StoreUi({super.key});

  final TextEditingController _storeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Store",
          style: GoogleFonts.poppins(fontSize: 28),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: _storeNameController,
            decoration: InputDecoration(hintText: "Store Name"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_storeNameController.text.isNotEmpty) {
                storeProvider.addNewStore(_storeNameController.text, context);
                _storeNameController.clear();
              }
            },
            child: const Text('Add Store'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: storeProvider.stores.length,
              itemBuilder: (context, index) {
                final store = storeProvider.stores[index];
                return ListTile(
                  title: Text(store.storeName),
                  subtitle: Text("${store.products.length} products"),
                  trailing: IconButton(
                    icon: Icon(Icons.store),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StorePage(storeId: store.id)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
