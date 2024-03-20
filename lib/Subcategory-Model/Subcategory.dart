// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_mart/Subcategory-Model/ModelSubCategory.dart';
import 'package:p_mart/Subcategory-Model/SubCategory-Fetch.dart';
import '../Category/CategoryModel.dart';
import '../color.dart';

class AddSubCategory extends StatefulWidget {
  const AddSubCategory({Key? key}) : super(key: key);

  @override
  State<AddSubCategory> createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  TextEditingController Sub_Category = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String Imageurl = "";
  File? selectedImage;
  bool isLoading = false;

  Future<void> AddSubCategory() async {
    final user = Sub_Category.text.trim();

    if (user.isEmpty || Sub_Category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a Subcategory name  ")),
      );
      return;
    }
    if (user.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a category name  ")),
      );
      return;
    }
    if (user.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a Image name  ")),
      );
      return;
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('SubCategory_images');
    Reference referenceImageToUpload =
    referenceDirImages.child(uniquefilename);

    try {
      await referenceImageToUpload.putFile(selectedImage!);
      Imageurl = await referenceImageToUpload.getDownloadURL();
      print("Image URL: $Imageurl");

      await FirebaseFirestore.instance.collection("SubCategories").add({
        'category': selectedCategory,
        'subCategory': Sub_Category.text.trim(),
        'image': Imageurl,
      });

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category Added Successfully")));
    } catch (error) {
      print("Error uploading image: $error");
    }
  }

  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: const Text(
          'SubCategory',
          style: TextStyle(color: CupertinoColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productdropdown(
              selectedCategory: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextFormField(
                controller: Sub_Category,
                decoration: InputDecoration(
                  hintText: "SubCategory Name",
                  hintStyle: TextStyle(color: valo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: valo),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            selectedImage != null
                ? Image.file(selectedImage!, width: 200, height: 200)
                : Image.asset(
              "assets/images/noimage.jpg",
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file == null) return;
                    selectedImage = File(file.path);
                    setState(() {});
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    backgroundColor: MaterialStateProperty.all(CupertinoColors.white),
                  ),
                  child: Text(
                    "Select Image",
                    style: TextStyle(color: valo),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await AddSubCategory();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    backgroundColor: MaterialStateProperty.all(valo),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    "Add SubCategory",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class productdropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  const productdropdown({Key? key, this.selectedCategory, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final categoryDocs = snapshot.data!.docs;
          List<CategoryModel> categories = [];
          for (var doc in categoryDocs) {
            final category = CategoryModel.fromSnapshot(doc);
            categories.add(category);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Select Category',
                hintStyle: TextStyle(color: valo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
              items: categories.map((CategoryModel category) {
                return DropdownMenuItem<String>(
                  value: category.category,
                  child: Text(
                    category.category,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Category';
                }
                return null;
              },
            ),
          );
        });
  }
}
