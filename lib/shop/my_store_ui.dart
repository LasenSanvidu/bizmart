/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/business_dashboard.dart';
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
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            /*CustomerFlowScreen.of(context)
                ?.updateIndex(6); // Go back to Business Dashboard screen*/
            CustomerFlowScreen.of(context)
                ?.setNewScreen(BusinessDashboardScreen());
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
}*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/business_dashboard.dart';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Rename Store",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _renameController,
            decoration: InputDecoration(
              labelText: "New Store Name",
              labelStyle: GoogleFonts.poppins(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                if (_renameController.text.isNotEmpty) {
                  storeProvider.renameStore(store.id, _renameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Rename",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
        elevation: 0,
        title: Text(
          "My Store",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.setNewScreen(BusinessDashboardScreen());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Your Store",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Create or modify your existing store",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Store Name",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _storeNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Store Name",
                      hintStyle:
                          GoogleFonts.poppins(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.storefront_rounded,
                          color: Colors.black.withOpacity(0.6)),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_storeNameController.text.isNotEmpty) {
                          if (storeProvider.stores.isEmpty) {
                            storeProvider
                                .addNewStore(_storeNameController.text);
                            _storeNameController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'You can only create one store.',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Create Store',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            if (storeProvider.stores.isNotEmpty)
              Text(
                "Your Stores",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            SizedBox(height: 16),
            Expanded(
              child: storeProvider.stores.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store_outlined,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No stores yet",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Create a store to get started",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: storeProvider.stores.length,
                      itemBuilder: (context, index) {
                        final store = storeProvider.stores[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.storefront_rounded,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              store.storeName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "${store.products.length} products",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    CustomerFlowScreen.of(context)
                                        ?.setNewScreen(
                                            StorePage(storeId: store.id));
                                  },
                                ),
                                PopupMenuButton<String>(
                                  color: Colors.black,
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (value) {
                                    if (value == 'rename') {
                                      _showRenameDialog(
                                          context, storeProvider, store);
                                    } else {
                                      // Show confirmation dialog before deleting
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: Text(
                                            "Delete Store",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          content: Text(
                                            "Are you sure you want to delete this store? This action cannot be undone.",
                                            style: GoogleFonts.poppins(),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                "Cancel",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade600,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                storeProvider
                                                    .clearWholeStore(store.id);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Delete",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'rename',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined,
                                              color: Colors.white, size: 18),
                                          SizedBox(width: 12),
                                          Text(
                                            'Rename Store',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              color: Colors.white, size: 18),
                                          SizedBox(width: 12),
                                          Text(
                                            'Delete Store',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
