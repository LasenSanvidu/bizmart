import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/shop/store_page.dart';
import 'package:provider/provider.dart';

class MyStoreUi extends StatefulWidget {
  MyStoreUi({super.key});

  @override
  State<MyStoreUi> createState() => _MyStoreUiState();
}

class _MyStoreUiState extends State<MyStoreUi> {
  final TextEditingController _storeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<StoreProvider>(context, listen: false).fetchStores();
    });
  }

  void _showRenameDialog(
      BuildContext context, StoreProvider storeProvider, Store store) {
    TextEditingController _renameController =
        TextEditingController(text: store.storeName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Store"),
          content: TextField(
            controller: _renameController,
            decoration: InputDecoration(labelText: "New Store Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_renameController.text.isNotEmpty) {
                  storeProvider.renameStore(store.id, _renameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Store",
          style: GoogleFonts.poppins(fontSize: 28),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.updateIndex(6); // Go back to Business Dashboard screen
          },
        ),
      ),
      body: Container(
        constraints: BoxConstraints(
          maxWidth: 400, // Maximum width
          minWidth: 300, // Minimum width
          maxHeight: 260, // Maximum height
          minHeight: 259, // Minimum height
        ),
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          border: Border.all(
              color: Colors.grey, width: 1.5), // Border color and width
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextField(
                controller: _storeNameController,
                decoration: InputDecoration(
                  hintText: "Enter Store Name",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.store, color: Colors.grey),
                ),
                style: GoogleFonts.poppins(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: const Color.fromARGB(255, 184, 161, 249),
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    if (_storeNameController.text.isNotEmpty) {
                      if (storeProvider.stores.isEmpty) {
                        storeProvider.addNewStore(_storeNameController.text);
                        _storeNameController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('You can only create one store.')),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Add Store',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: storeProvider.stores.length,
                itemBuilder: (context, index) {
                  final store = storeProvider.stores[index];
                  return ListTile(
                    title: Text(store.storeName),
                    subtitle: Text(
                      "${store.products.length} products",
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.store),
                          onPressed: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StorePage(storeId: store.id),
                              ),
                            );*/
                            CustomerFlowScreen.of(context)
                                ?.setNewScreen(StorePage(storeId: store.id));
                          },
                        ),
                        PopupMenuButton<String>(
                          //color: const Color.fromARGB(255, 233, 233, 233),
                          color: Colors.black,
                          icon: Icon(Icons.more_vert_rounded),
                          onSelected: (value) {
                            if (value == 'rename') {
                              _showRenameDialog(context, storeProvider, store);
                            } else {
                              storeProvider.clearWholeStore(store.id);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'rename',
                              child: Text(
                                'Rename Store',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Delete Store',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
