import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../color.dart';

class EditBanner extends StatefulWidget {
  final String bannerId;
  final String bannerName;
  final String imageUrl;

  const EditBanner({
    required this.bannerId,
    required this.bannerName,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  _EditBannerState createState() => _EditBannerState();
}

class _EditBannerState extends State<EditBanner> {
  late TextEditingController _bannerController;
  String _imageUrl = '';
  File? _selectedImage;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bannerController = TextEditingController(text: widget.bannerName);
    _imageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _updateBanner() async {
    final bannerName = _bannerController.text.trim();

    if (bannerName.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the banner name or select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedImage != null) {
        final Reference referenceRoot = FirebaseStorage.instance.ref();
        final Reference referenceDirImage =
        referenceRoot.child('Banner_Images');
        final Reference referenceImageToUpload =
        referenceDirImage.child(DateTime.now().microsecondsSinceEpoch.toString());

        await referenceImageToUpload.putFile(_selectedImage!);
        _imageUrl = await referenceImageToUpload.getDownloadURL();
      }

      if (bannerName.isNotEmpty || _selectedImage != null) {
        await FirebaseFirestore.instance
            .collection("Banner")
            .doc(widget.bannerId)
            .update({
          if (bannerName.isNotEmpty) 'Banner name': bannerName,
          if (_selectedImage != null) 'image': _imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Banner Updated Successfully")),
        );

        Navigator.pop(context); // Navigate back after update
      }
    } catch (error) {
      print('Error updating banner: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: const Text(
          'Edit Banner',
          style: TextStyle(color: CupertinoColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _bannerController,
              decoration: InputDecoration(
                hintText: 'Banner Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200, width: 200)
                : _imageUrl.isNotEmpty
                ? Image.network(_imageUrl, height: 200, width: 200)
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker imagePicker = ImagePicker();
                final XFile? file = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file == null) return;
                setState(() {
                  _selectedImage = File(file.path);
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                backgroundColor: valo,
              ),
              child: const Text('Select Image', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateBanner,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                backgroundColor: valo,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Banner', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
