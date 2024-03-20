import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../color.dart';

class CreateBanner extends StatefulWidget {
  const CreateBanner({Key? key}) : super(key: key);

  @override
  _CreateBannerState createState() => _CreateBannerState();
}

class _CreateBannerState extends State<CreateBanner> {
  TextEditingController Add_Banner = TextEditingController();
  String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedimage;
  bool isLoading = false;

  Future<void> Category() async {
    final Tvalue = Add_Banner.text.trim();
    if (Tvalue.isEmpty || selectedimage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the banner name and select an image')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('Banner_Images');
    Reference referenceImageToUpload = referenceDirImage.child(uniquefilename);

    try {
      await referenceImageToUpload.putFile(selectedimage!);
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print("Image URL: $imageUrl");

      FirebaseFirestore.instance.collection("Banner").add({
        'Banner name': Add_Banner.text,
        'image': imageUrl,
      }).then((value) {
        Add_Banner.clear();
        selectedimage = null;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Banner Added Successfully")),
        );
      });
    } catch (error) {
      print('error in uploading image :$error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
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
        title: Text('Add Banner', style: TextStyle(color: CupertinoColors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: TextFormField(
                  controller: Add_Banner,
                  decoration: InputDecoration(
                    hintText: "Banner Name",
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
              SizedBox(height: 30),
              selectedimage != null
                  ? Image.file(selectedimage!, height: 200, width: 200)
                  : Image.asset('assets/images/noimage.jpg', width: 200, height: 200),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.zero),
                child: ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagepicker = ImagePicker();
                    XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);
                    if (file == null) return;
                    selectedimage = File(file.path);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.zero),
                child: ElevatedButton(
                  onPressed: () async {
                    Category(); // Show the progress indicator
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white) // Show the progress indicator
                      : Text(
                    "Add Banner",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
