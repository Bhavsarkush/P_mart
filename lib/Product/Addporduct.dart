import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Category/categorymodel.dart';
import '../Subcategory-Model/ModelSubCategory.dart';
import '../color.dart';

class addProductsScreen extends StatefulWidget {
  const addProductsScreen({Key? key}) : super(key: key);

  @override
  State<addProductsScreen> createState() => _addProductsScreenState();
}

class _addProductsScreenState extends State<addProductsScreen> {
  String? selectedCategory;
  String? selectedSubCategory;
  bool isLoading = false;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  List<File> selectedImages = [];

  final TextEditingController productController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController newpriceController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController title1Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  final TextEditingController title2Controller = TextEditingController();
  final TextEditingController product3Controller = TextEditingController();
  final TextEditingController title3Controller = TextEditingController();
  final TextEditingController product4Controller = TextEditingController();
  final TextEditingController title4Controller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<bool> doesProductExist(String productName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('productName', isEqualTo: productName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addProductToFirestore() async {
    final category = selectedCategory;
    final subCategory = selectedSubCategory;
    final productName = productController.text.trim();
    final productPrice = priceController.text.trim();
    final productDiscount = discountController.text.trim();
    final productNewPrice = newpriceController.text.trim();
    final productColor = colorController.text.trim();
    final productTitle1 = title1Controller.text.trim();
    final productTitleDetail1 = title1Controller.text.trim();
    final productTitle2 =title2Controller.text.trim();
    final productTitleDetail2 = title2Controller.text.trim();
    final productTitle3 = title3Controller.text.trim();
    final productTitleDetail3 = title3Controller.text.trim();
    final productTitle4 = title4Controller.text.trim();
    final productTitleDetail4 = title4Controller.text.trim();
    final productDescription = descriptionController.text.trim();


    if (category == null || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (subCategory == null || subCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a SubCategory")),
      );
      return;
    }

    if (productName.isEmpty ||
        productPrice.isEmpty ||
        productDiscount.isEmpty ||
        productNewPrice.isEmpty ||
        productColor.isEmpty ||
        productTitle1.isEmpty ||
        productTitleDetail1.isEmpty ||
        productTitle2.isEmpty ||
        productTitleDetail2.isEmpty ||
        productTitle3.isEmpty ||
        productTitleDetail3.isEmpty ||
        productTitle4.isEmpty ||
        productTitleDetail4.isEmpty ||
        productDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in all fields"),
      ));

      return;
    }

    final doesExist = await doesProductExist(productName);

    if (doesExist) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Already exist')));
    } else {
      setState(() {
        isLoading = true;
      });
      if (selectedImages.isNotEmpty) {
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('Product_Images');
        Reference referenceImageToUpload =
        referenceDirImages.child(uniqueFileName);

        try {
          for (var image in selectedImages) {
            await referenceImageToUpload.putFile(image);
          }
          final List<String> imageUrls = await Future.wait(selectedImages.map(
                  (image) async => await referenceImageToUpload.getDownloadURL()));

          print('Image Urls:');
          for (var url in imageUrls) {
            print(url);
          }

          FirebaseFirestore.instance.collection("Products").add({
            'category': category,
            'subcategory': subCategory,
            'productName': productName,
            'productPrice': productPrice,
            'productColor': productColor,
            'productDescription': productDescription,
            'productTitle1': productTitle1,
            'productTitle2': productTitle2,
            'productTitle3': productTitle3,
            'productTitle4': productTitle4,
            'productTitleDetail1': productTitleDetail1,
            'productTitleDetail2': productTitleDetail2,
            'productTitleDetail3': productTitleDetail3,
            'productTitleDetail4': productTitleDetail4,
            'productDiscount': productDiscount,
            'productNewPrice': productNewPrice,
            'images': imageUrls,
          }).then((value) {
            selectedImages.clear();


            productController.clear();
            priceController.clear();
            colorController.clear();
            descriptionController.clear();
            product1Controller.clear();
            title1Controller.clear();
            product2Controller.clear();
            title2Controller.clear();
            product3Controller.clear();
            title3Controller.clear();
            product4Controller.clear();
            title4Controller.clear();
            descriptionController.clear();
            newpriceController.clear();

            selectedCategory = null;
            selectedSubCategory = null;

            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product Added Successfully')));
          });
        } catch (error) {
          print("Error uploading images: $error");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select images")));
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
        title: const Text(
          'Add Products',
          style: TextStyle(color: CupertinoColors.white),
        ),
        backgroundColor: valo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              SizedBox(
                  height: 180,
                  width: 200,
                  child: selectedImages.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                selectedImages[index],
                                width: 200,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/noimage.jpg",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    List<XFile>? files = await imagePicker.pickMultiImage();

                    selectedImages =
                        files.map((file) => File(file.path)).toList();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valo,
                  ),
                  child: const Text(
                    'Select Images',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
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
              const SizedBox(
                height: 25,
              ),
              SubCategoryDropdown(
                selectedCategory: selectedCategory ?? "",
                selectedSubCategory: selectedSubCategory,
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                  });
                },
              ),
              // Other form fields
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: productController,
                decoration: InputDecoration(
                  hintText: 'Product Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Product Price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: discountController,
                decoration: InputDecoration(
                  hintText: 'Discount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: newpriceController,
                decoration: InputDecoration(
                  hintText: 'Product New Price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: colorController,
                decoration: InputDecoration(
                  hintText: 'Product Color',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: product1Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: title1Controller,
                decoration: InputDecoration(
                  hintText: 'Title 1 detail',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: product2Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: title2Controller,
                decoration: InputDecoration(
                  hintText: 'Title 2 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: product3Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 3',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: title3Controller,
                decoration: InputDecoration(
                  hintText: 'Title 3 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: product4Controller,
                decoration: InputDecoration(
                  hintText: 'Product Title 4',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: title4Controller,
                decoration: InputDecoration(
                  hintText: 'Title 4 detail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                maxLines: 6,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Product Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    addProductToFirestore();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: valo),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Add Product',
                          style: TextStyle(
                              fontSize: 20, color: CupertinoColors.white),
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
            labelStyle: TextStyle(color: Colors.black), // Updated here
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: valo), // Updated here
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
