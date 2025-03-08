import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late String _imagePath;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

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

  // Helper method to display the image correctly based on its format
  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('data:image')) {
      // This is a base64 image
      return Image.memory(
        base64Decode(imagePath.split(',')[1]),
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    } else if (imagePath.startsWith('http')) {
      // This is a network image
      return Image.network(
        imagePath,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    } else {
      // This is a local file path
      return Image.file(
        File(imagePath),
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Reduce image size
        maxHeight: 800,
        imageQuality: 70, // Reduce quality to make base64 string smaller
      );

      if (pickedFile != null) {
        // Convert image to base64 immediately after picking
        final String base64Image = await _imageToBase64(File(pickedFile.path));
        setState(() {
          _imagePath = base64Image;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return 'data:image/jpeg;base64,${base64Encode(imageBytes)}';
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);

      // If the image path is a local file path (not base64 or http URL), convert it to base64
      String imageToSave = _imagePath;
      if (!_imagePath.startsWith('data:image') &&
          !_imagePath.startsWith('http')) {
        imageToSave = await _imageToBase64(File(_imagePath));
      }

      await storeProvider.updateProduct(
        widget.product.id,
        _nameController.text,
        double.tryParse(_priceController.text) ?? widget.product.prodprice,
        imageToSave, // Use the base64 string or existing image path
        _descriptionController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Updated!')),
      );
    } catch (e) {
      print("Error updating product: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating product: $e')));
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.updateIndex(5); // Go back to MyStoreUi
          },
        ),
        title: Text(widget.product.prodname),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _buildProductImage(_imagePath),
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

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: _isProcessing ? null : _updateProduct,
                child: _isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Update",
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
