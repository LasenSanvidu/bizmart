import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/shop/store_page.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  final String storeId;

  const AddProductPage({super.key, required this.storeId});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescripController =
      TextEditingController();

  File? _selectedImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Reduce image size
        maxHeight: 800,
        imageQuality: 70, // Reduce quality to make base64 string smaller
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
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

  Future<void> _addProduct() async {
    if (_productNameController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please fill all required fields and select an image')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Convert image to base64 string
      final String base64Image = await _imageToBase64(_selectedImage!);

      final product = Product(
        id: Uuid().v4(),
        prodname: _productNameController.text,
        prodprice: double.parse(_productPriceController.text),
        image: base64Image, // Store as base64 string
        description: _productDescripController.text.isNotEmpty
            ? _productDescripController.text
            : "No Description",
      );

      await Provider.of<StoreProvider>(context, listen: false)
          .addProductToStore(widget.storeId, product);

      CustomerFlowScreen.of(context)
          ?.setNewScreen(StorePage(storeId: widget.storeId));
    } catch (e) {
      print("Error adding product: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding product: $e')));
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
        title: Text(
          "Add Product",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.setNewScreen(StorePage(storeId: widget.storeId));
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_productNameController, "Product Name"),
              _buildTextField(_productPriceController, "Price", isNumber: true),
              _buildImagePicker(),
              _buildTextField(_productDescripController, "Description",
                  lines: 3),
              SizedBox(height: 60),
              _buildAddProductButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int lines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))]
            : [],
        minLines: lines,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16.5,
            color: Colors.grey[500],
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!,
                      height: 150, width: double.infinity, fit: BoxFit.cover),
                )
              : Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Center(
                    child: Icon(Icons.image, color: Colors.grey[600], size: 50),
                  ),
                ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image, color: Colors.white),
              label: Text("Pick Image", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _addProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? CircularProgressIndicator(color: Colors.white)
            : Text("Add Product",
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
