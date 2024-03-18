// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../Category/CategoryModel.dart';
import '../color.dart';
import 'ModelSubCategory.dart';
import 'SubCategory-Fetch.dart';


class EditSubCategoryScreen extends StatefulWidget {
  final SubCategoryModel Subcategory;
  final String image;

  EditSubCategoryScreen({Key? key, required this.Subcategory, required this.image})
      : super(key: key);

  @override
  _EditSubCategoryScreenState createState() => _EditSubCategoryScreenState();
}

class _EditSubCategoryScreenState extends State<EditSubCategoryScreen> {
  File? selectedImage;
  TextEditingController SubcategoryController = TextEditingController();
  bool isLoading = false;

   // Track loading state

  @override
  void initState() {
    super.initState();
    SubcategoryController.text = widget.Subcategory.subcategory;
  }

  Future<void> _updateCategory() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    // Firestore reference to the category document
    DocumentReference categoryRef = FirebaseFirestore.instance
        .collection('SubCategories')
        .doc(widget.Subcategory.id);


    Map<String, dynamic> updatedData = {
      'subCategory': SubcategoryController.text,
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

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('SubCategory_images/${widget.Subcategory.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }
  String? selectedSubCategory;
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
                  controller: SubcategoryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'SubCategory Name',
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
