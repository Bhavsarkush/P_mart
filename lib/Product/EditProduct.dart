import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'Model.dart';
import '../color.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;

  EditProduct({Key? key, required this.product, required String images}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File? selectedImage;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController(); // Added controller for category
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.productName;
    productPriceController.text = widget.product.productPrice.toString();
    categoryNameController.text = widget.product.categoryName ?? ''; // Initialize category name, handle null
  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.product.id);

      Map<String, dynamic> updatedData = {
        'productName': productNameController.text,
        'productPrice': double.parse(productPriceController.text),
        'categoryName': categoryNameController.text, // Update category name
      };

      if (selectedImage != null) {
        String imageUrl = await uploadImageToStorage(selectedImage!);
        updatedData['images'] = [imageUrl];
      }

      await productRef.update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update product: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('Product_images/${widget.product.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: Text(
          'Edit Product',
          style: TextStyle(color: CupertinoColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Product Name',
                    hintStyle: TextStyle(color: valo),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: TextFormField(
                  controller: productPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Product Price',
                    hintStyle: TextStyle(color: valo),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: TextFormField(
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Category Name',
                    hintStyle: TextStyle(color: valo),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.network(
                widget.product.images!.isNotEmpty
                    ? widget.product.images![0]
                    : '', // Display the current image
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null) {
                    selectedImage = File(file.path);
                    setState(() {});
                  }
                },
                child: Text('Select Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _updateProduct,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}