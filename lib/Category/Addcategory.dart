// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../color.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController Add_Category = TextEditingController();
  String CategoryImage = DateTime.now().millisecondsSinceEpoch.toString();
  String Imageurl = "";
  File? selectedImage;
  bool isLoading = false;

  Future<void> Category() async {
    final user = Add_Category.text.trim();
    if (user.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a category name")));
      // return;
    }
    if (selectedImage != null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Category_images');
      Reference referenceImageToUpload =
          referenceDirImages.child(CategoryImage);

      try {
        await referenceImageToUpload.putFile(selectedImage!);
        Imageurl = await referenceImageToUpload.getDownloadURL();
        print("Image URL: $Imageurl");

        FirebaseFirestore.instance.collection("Categories").add({
          'category': Add_Category.text,
          'image': Imageurl,
        }).then((value) {
          Add_Category.clear();
          selectedImage = null;
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Category Added Successfully")));
        });
      } catch (error) {
        print("Error uploading image: $error");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Center(
              child: Text(
            "Add Category",
            style: TextStyle(color: CupertinoColors.white),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: TextFormField(
                      controller: Add_Category,
                      decoration: InputDecoration(
                        hintText: "Category Name",
                        hintStyle: TextStyle(color: valo),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: valo),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ),
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.asset("assets/images/noimage.jpg",
                      width: 200, height: 200),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (file == null) return;
                          selectedImage = File(file.path);
                          setState(() {});
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder()),
                            backgroundColor: MaterialStateProperty.all(
                                CupertinoColors.white)),
                        child: Text(
                          "Select Image",
                          style: TextStyle(color: valo),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Category();

                        setState(() {
                          isLoading = false;
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder()),
                        backgroundColor: MaterialStateProperty.all(valo),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Add Category",
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                    )),
              )
            ])),
      ),
    );
  }
}
