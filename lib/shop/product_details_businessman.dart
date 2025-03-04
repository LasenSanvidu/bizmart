import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/shop/shop.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  //late int _quantity;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.prodname);
    _priceController =
        TextEditingController(text: widget.product.prodprice.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _imagePath = widget.product.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _updateProduct() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    storeProvider.updateProduct(
      widget.product.id,
      _nameController.text,
      double.tryParse(_priceController.text) ?? widget.product.prodprice,
      _imagePath,
      _descriptionController.text,
      //_quantity,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product.prodname),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              /*child: Image.network(
                product.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),*/
              child: GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: widget.product.image.startsWith('http')
                      ? Image.network(
                          _imagePath,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : Image.file(
                          File(_imagePath), // Use local file path
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Editable Product Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "Product Name",
                  labelStyle: GoogleFonts.poppins(fontSize: 20)),
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Editable Product Price
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Price",
                labelStyle: GoogleFonts.poppins(fontSize: 20),
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),

            // Editable Product Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: GoogleFonts.poppins(fontSize: 20),
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Quantity Selector
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 28),
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                      : null, // Disable if quantity is 1
                ),
                Text(
                  '$_quantity',
                  style: GoogleFonts.poppins(fontSize: 22),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),*/

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 172, 144, 251),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  _updateProduct();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product Updated!')),
                  );
                  Navigator.pop(context);
                },
                child: Text("Update",
                    style:
                        GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
