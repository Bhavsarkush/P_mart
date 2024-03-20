// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../category/categoryModel.dart';
import '../Subcategory-Model/ModelSubCategory.dart';
import '../color.dart';

class addProductScreen extends StatefulWidget {
  const addProductScreen({super.key});

  @override
  State<addProductScreen> createState() => _addProductScreenState();
}

class _addProductScreenState extends State<addProductScreen> {
  TextEditingController subcategory_name = TextEditingController();

  String? selectedSubCategory;
  String? selectedCategory;

  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  List<File> selectedImage = [];
  bool isLoading = false;

  TextEditingController product_name = TextEditingController();
  TextEditingController product_price = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController product_newprice = TextEditingController();
  TextEditingController product_color = TextEditingController();
  TextEditingController product_title1 = TextEditingController();
  TextEditingController product_detail1 = TextEditingController();
  TextEditingController product_title2 = TextEditingController();
  TextEditingController product_detail2 = TextEditingController();
  TextEditingController product_title3 = TextEditingController();
  TextEditingController product_detail3 = TextEditingController();
  TextEditingController product_title4 = TextEditingController();
  TextEditingController product_detail4 = TextEditingController();
  TextEditingController all_details = TextEditingController();
  TextEditingController product_Description = TextEditingController();

  // Generate a unique productId
  final productId = FirebaseFirestore.instance.collection("Products").doc().id;

  Future<bool> doesProductExist(String productName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Products")
        .where("productName", isEqualTo: productName)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addProductsToFireStore() async {
    final category = selectedCategory;
    final subcategory = selectedSubCategory;
    final productName = product_name.text.trim();
    final productPrice = product_price.text.trim();
    final productDiscount = discount.text.trim();
    final productNewPrice = product_newprice.text.trim();
    final color = product_color.text.trim();
    final productTitle1 = product_title1.text.trim();
    final productTitle2 = product_title2.text.trim();
    final productTitle3 = product_title3.text.trim();
    final productTitle4 = product_title4.text.trim();
    final productDetail1 = product_detail1.text.trim();
    final productDetail2 = product_detail2.text.trim();
    final productDetail3 = product_detail3.text.trim();
    final productDetail4 = product_detail4.text.trim();
    final allProduct = all_details.text.trim();
    final description = product_Description.text.trim();

    if (category == null || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select Category")),
      );
      return;
    }
    if (subcategory == null || subcategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select SubCategory")),
      );
      return;
    }
    if (productName.isEmpty ||
        productPrice.isEmpty ||
        productDiscount.isEmpty ||
        productNewPrice.isEmpty ||
        color.isEmpty ||
        productTitle1.isEmpty ||
        productTitle2.isEmpty ||
        productTitle3.isEmpty ||
        productTitle4.isEmpty ||
        productDetail1.isEmpty ||
        productDetail2.isEmpty ||
        productDetail3.isEmpty ||
        productDetail4.isEmpty ||
        allProduct.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Enter Field")),
      );
      return;
    }
    final doesExsit = doesProductExist(productName);

    if (await doesExsit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Enter Product Name")),
      );
    } else {
      setState(() {
        isLoading = true;
      });
      if (selectedImage.isNotEmpty) {
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('Product_Images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniquefilename);
        try {
          final List<String> imageUrls = [];
          for (var i = 0; i < selectedImage.length; i++) {
            Reference referenceImageToUpload =
                referenceDirImages.child('$uniquefilename-$i');

            await referenceImageToUpload.putFile(selectedImage[i]);

            // Get the download URL for each image
            String imageUrl = await referenceImageToUpload.getDownloadURL();
            imageUrls.add(imageUrl);
          }
          // Print URLs to the debug console
          print('Image URLs:');
          for (var url in imageUrls) {
            print(url);
          }
          FirebaseFirestore.instance.collection("Products").add({
            'productId': productId, // Add productId to the document
            'category': category,
            'subCategory': subcategory,
            'productName': productName,
            'productPrice': productPrice,
            'productColor': color,
            'productDescription': description,
            'productTitle1': productTitle1,
            'productTitle2': productTitle2,
            'productTitle3': productTitle3,
            'productTitle4': productTitle4,
            'productDetail1': productDetail1,
            'productDetail2': productDetail2,
            'productDetail3': productDetail3,
            'productDetail4': productDetail4,
            'ProductDiscount': productDiscount,
            'productNewPrice': productNewPrice,
            'allProduct': allProduct,
            'images': imageUrls,
          }).then((value) {
            selectedImage.clear();
            setState(() {
              isLoading = false;
            });

            product_name.clear();
            product_price.clear();
            discount.clear();
            product_newprice.clear();
            product_color.clear();
            product_title1.clear();
            product_title2.clear();
            product_title3.clear();
            product_title4.clear();
            product_detail1.clear();
            product_detail2.clear();
            product_detail3.clear();
            product_detail4.clear();
            all_details.clear();
            product_Description.clear();
            selectedCategory = null;
            selectedSubCategory = null;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product Added Successfully")),
            );
          });
        } catch (error) {
          print("Error Uploading Image $error");
        }
        ;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Select Images")),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: valo,
        title: const Text(
          "Add Products",
          style: TextStyle(color:CupertinoColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                width: 300,
                child: selectedImage.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImage.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              selectedImage[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/noimage.jpg",
                        width: 130,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              // Image.asset(img,height: 200,width: 200,),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      List<XFile>? files = await imagePicker.pickMultiImage();
                      if (files == null) return;

                      selectedImage =
                          files.map((file) => File(file.path)).toList();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: valo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    child: const Text(
                      "Select Image",
                      style: TextStyle(color: CupertinoColors.white),
                    )),
              ),

              const SizedBox(
                height: 20,
              ),

              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedSubCategory =
                        null; // Reset subcategory when category changes
                  });
                },
              ),
              const SizedBox(height: 20),
              SubCategoryDropdown(
                selectedCategory: selectedCategory ?? "",
                selectedSubCategory: selectedSubCategory,
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_price,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Price",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: discount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Discount",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_newprice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product New Price",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_color,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Color",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_title1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Title 1",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_detail1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Detail",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_title2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Title 2",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_detail2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Detail",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_title3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Title 3",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_detail3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Detail",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_title4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Title 4",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_detail4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Product Detail",
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: product_Description,
                // controller: productDescriptionController,
                maxLines:
                    3, // Adjust the number of lines according to your design
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  hintText: "Product Description",
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: all_details,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "All Detail",
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      addProductsToFireStore();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: valo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Add Product",
                            style: TextStyle(color: Colors.white),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown(
      {required this.selectedCategory, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final categoryDocs = snapshot.data!.docs;
          List<CategoryModel> categories = [];

          for (var doc in categoryDocs) {
            final category = CategoryModel.fromSnapshot(doc);
            categories.add(category);
          }

          return DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: onChanged,
            decoration: const InputDecoration(
                labelText: 'Select Category',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: valo))),
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
                return 'Please select a Product';
              }
              return null;
            },
          );
        });
  }
}

class SubCategoryDropdown extends StatelessWidget {
  final String selectedCategory;
  final String? selectedSubCategory;
  final ValueChanged<String?> onChanged;

  const SubCategoryDropdown({
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('SubCategories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final subCategoryDocs = snapshot.data!.docs;
        List<SubCategoryModel> subCategories = [];

        for (var doc in subCategoryDocs) {
          final subCategory = SubCategoryModel.fromSnapshot(doc);

          if (subCategory.category == selectedCategory) {
            subCategories.add(subCategory);
          }
        }

        return DropdownButtonFormField<String>(
          value: selectedSubCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: "SubCategory",
            labelStyle: const TextStyle(color: Colors.black), // Updated here
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: valo), // Updated here
                borderRadius: BorderRadius.circular(10)),
          ),
          items: subCategories.map((SubCategoryModel subCategory) {
            return DropdownMenuItem<String>(
              value: subCategory.subcategory,
              child: Text(
                subCategory.subcategory,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a SubCategory';
            }
            return null;
          },
        );
      },
    );
  }
}
