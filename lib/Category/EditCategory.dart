// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'CategoryModel.dart';
import '../color.dart';

class EditCategoryScreen extends StatefulWidget {
  final CategoryModel category;
  final String image;

  EditCategoryScreen({Key? key, required this.category, required this.image})
      : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  File? selectedImage;
  TextEditingController categoryController = TextEditingController();
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.category.category;
  }

  Future<void> _updateCategory() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    // Firestore reference to the category document
    DocumentReference categoryRef = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.category.id);

    // Prepare the updated data
    Map<String, dynamic> updatedData = {
      'category': categoryController.text,
    };

    // Check if a new image has been selected
    if (selectedImage != null) {
      // Upload the new image to Firebase Storage
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updatedData['image'] = imageUrl;
      // Update the image URL in Firestore
    }

    try {
      // Update the category document in Firestore
      await categoryRef.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update category'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  // Function to upload an image to Firebase Storage
  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('Category_images/${widget.category.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: Text(
          'Edit Category',
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
                  controller: categoryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Category Name',
                    hintStyle: TextStyle(color: valo),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.network(
                      widget.image, // Display the current image
                      width: 200,
                      height: 200,
                    ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading // Disable button if loading
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
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text(
                    'Select Image',
                    style: TextStyle(color: valo),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading // Disable button if loading
                      ? null
                      : () async {
                          await _updateCategory();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) // Show the progress indicator
                      : const Text(
                          "Update Category",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
